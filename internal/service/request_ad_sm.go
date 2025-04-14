package service

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"log"
	"math"
	"strconv"
	"sync"
	"time"

	"github.com/sirupsen/logrus"
	client2 "gitlab.com/eqshare/eqshare-back/internal/client"
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type ISpecializedMachineryRequest interface {
	Create(ctx context.Context, smr model.SpecializedMachineryRequest) (int, error)
	Get(f model.FilterSpecializedMachineryRequest) ([]model.SpecializedMachineryRequest, int, error)
	GetByID(id int) (model.SpecializedMachineryRequest, error)
	GetHistoryByID(id int) ([]model.SpecializedMachineryRequest, error)
	DriverApproveByID(ctx context.Context, id int) error
	DriverRevisedByID(smr model.SpecializedMachineryRequest) error
	DriverCanceledByID(id int, canceledBy int) error
	ClientCanceledByID(id int, canceledBy int) error
	ClientRevisedByID(smr model.SpecializedMachineryRequest) error
	AssignTo(id int, workerID int) error
	ForceApprove(smr model.SpecializedMachineryRequest) error
	// ClientRevisedApproveByID(id int) error
}

type specializedMachineryRequest struct {
	repo          repository.ISpecializedMachineryRequest
	repoAdSM      repository.IAdSpecializedMachinery
	userRepo      repository.IUser
	serviceRE     IRequestExecution
	remotes       client2.DocumentsRemote
	messageClient client2.NotificationClient
	notification  repository.INotification
}

func NewSpecializedMachineryRequest(
	repo repository.ISpecializedMachineryRequest,
	repoAdSM repository.IAdSpecializedMachinery,
	serviceRE IRequestExecution,
	remotes client2.DocumentsRemote,
	messageClient client2.NotificationClient,
	notification repository.INotification,
	userRepo repository.IUser,
) *specializedMachineryRequest {
	return &specializedMachineryRequest{
		repo:          repo,
		repoAdSM:      repoAdSM,
		serviceRE:     serviceRE,
		remotes:       remotes,
		messageClient: messageClient,
		notification:  notification,
		userRepo:      userRepo,
	}
}

// Может создавать только клиент.
// Должен быть мидлвар для проверки клиента и передачи идентификатора юзер.
func (s *specializedMachineryRequest) Create(ctx context.Context, smr model.SpecializedMachineryRequest) (int, error) {
	ad, err := s.repoAdSM.GetByID(smr.AdSpecializedMachineryID)
	if err != nil {
		return 0, fmt.Errorf("create smr: %w", err)
	}

	//валидация заявка на объявлеия самого автора
	// if ad.UserID == uint(smr.UserID) {
	// 	return 0, model.ErrCreatingYourAd
	// }

	if smr.EndLeaseAt.Valid {
		if smr.EndLeaseAt.Time.Before(smr.StartLeaseAt) {
			return 0, model.ErrInvalidTimeRange
		}

		differenceTime := smr.EndLeaseAt.Time.Sub(smr.StartLeaseAt)
		if differenceTime <= 0 {
			return 0, model.ErrInvalidTimeRange
		}

		c := int(math.Round(differenceTime.Hours()))

		smr.CountHour = &c

		diff := smr.EndLeaseAt.Time.Sub(smr.StartLeaseAt)

		dayWork := int(diff.Hours()/24) + 1

		hourWorkDay := smr.EndLeaseAt.Time.Hour() - smr.StartLeaseAt.Hour()

		if hourWorkDay == 0 && diff.Hours() > 0 {
			hourWorkDay = 1
		}

		oa := ad.Price * float64(dayWork*hourWorkDay)

		smr.OrderAmount = &oa
	}

	smr.Status = model.STATUS_CREATED

	id, err := s.repo.Create(smr)
	if err != nil {
		return 0, err
	}

	wg := sync.WaitGroup{}

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	chErr := make(chan error, len(smr.Document))

	for _, d := range smr.Document {
		doc := d
		wg.Add(1)
		go func() {
			defer wg.Done()
			_, err = s.remotes.Upload(ctx, doc)
			if err != nil {
				chErr <- err
				return
			}
		}()
	}

	wg.Wait()

	close(chErr)

	var errDoc error

	for err2 := range chErr {
		errDoc = errors.Join(errDoc, err2)
	}

	if errDoc != nil {
		return id, nil
	}

	tokens, err := s.notification.GetDeviceToken(model.DeviceToken{
		UserID: int(ad.UserID),
	})
	if err != nil {
		return id, err
	}

	//user, err := s.userRepo.GetByID(int(ad.UserID))
	//if err != nil {
	//	return id, err
	//}

	if len(tokens) != 0 {

		go func() {

			usr, _ := s.userRepo.GetByID(smr.UserID)

			s.messageClient.Send(context.Background(), model.Notification{
				DeviceTokens: tokens,
				Message:      fmt.Sprintf("%s %s отправил заявку %s", usr.FirstName, usr.LastName, ad.Name),
				Tittle:       "Вам пришла заявка",
				Data: map[string]string{
					"date": time.Now().String(),
					"type": model.NotificationTypeSM,
					"id":   strconv.Itoa(id),
				},
			})
			log.Println(tokens)
			log.Println("Notification Sent")
		}()
	}

	return id, nil
}

// Получение заявок
// В зависимости от роли посик происходит по разному
func (s *specializedMachineryRequest) Get(f model.FilterSpecializedMachineryRequest) ([]model.SpecializedMachineryRequest, int, error) {
	// var (
	// 	err error
	// 	res []model.SpecializedMachineryRequest
	// )

	// switch role {
	// case model.ROLE_CLIENT:
	// 	res, err = s.repo.Get(model.FilterSpecializedMachineryRequest{
	// 		UserID: user.ID,
	// 	})
	// case model.ROLE_OWNER:
	// 	fallthrough
	// case model.ROLE_DRIVER:
	// 	res, err = s.repo.Get(model.FilterSpecializedMachineryRequest{
	// 		AdSpecializedMachineryUserID: user.ID,
	// 	})
	// default:
	// 	return nil, model.ErrAccessDenied
	// }

	res, count, err := s.repo.Get(f)

	if err != nil {
		return nil, 0, err
	}

	for i := range res {
		res[i].UrlDocument = make([]string, 0, len(res[i].Document))
		for _, d := range res[i].Document {
			d, err = s.remotes.Share(context.Background(), d, time.Duration(time.Hour))
			if err != nil {
				return nil, 0, err
			}
			res[i].UrlDocument = append(res[i].UrlDocument, d.ShareLink)
		}
	}

	return res, count, nil
}

// Получение истории по идентификатору
func (s *specializedMachineryRequest) GetByID(id int) (model.SpecializedMachineryRequest, error) {
	smr, err := s.repo.GetByID(id)
	if err != nil {
		return model.SpecializedMachineryRequest{}, err
	}

	smr.UrlDocument = make([]string, 0, len(smr.Document))

	for _, d := range smr.Document {
		d, err = s.remotes.Share(context.Background(), d, time.Duration(time.Hour))
		if err != nil {
			return model.SpecializedMachineryRequest{}, err
		}
		smr.UrlDocument = append(smr.UrlDocument, d.ShareLink)
	}

	smr.AdSpecializedMachinery.UrlDocument = make([]string, 0, len(smr.AdSpecializedMachinery.Document))

	for _, d := range smr.AdSpecializedMachinery.Document {
		d, err = s.remotes.Share(context.Background(), d, time.Duration(time.Hour))
		if err != nil {
			return model.SpecializedMachineryRequest{}, err
		}

		smr.AdSpecializedMachinery.UrlDocument = append(smr.AdSpecializedMachinery.UrlDocument, d.ShareLink)
	}

	return smr, nil
}

// Получение истории заявки
// Должен быть тригер для сохранения в таблице specialized_machinery_requests_histories (сделано)
// TODO specialized_machinery_requests_histories нужно создать (сделано)
func (s *specializedMachineryRequest) GetHistoryByID(id int) ([]model.SpecializedMachineryRequest, error) {
	smrs, err := s.repo.GetHistoryByID(id)
	if err != nil {
		return nil, err
	}

	for i := range smrs {
		smrs[i].UrlDocument = make([]string, 0, len(smrs[i].Document))
		for _, d := range smrs[i].Document {
			d, err = s.remotes.Share(context.Background(), d, time.Duration(time.Hour))
			if err != nil {
				return nil, err
			}
			smrs[i].UrlDocument = append(smrs[i].UrlDocument, d.ShareLink)
		}
	}

	return smrs, nil
}

// Должен иметь доступ только водителю
// Водитель утверждает заявку и создается работа на выполнение
func (s *specializedMachineryRequest) DriverApproveByID(ctx context.Context, id int) error {
	smrOld, err := s.repo.GetByID(id)
	if err != nil {
		return fmt.Errorf("driver approve error: %w", err)
	}

	if smrOld.Status == model.STATUS_CANCELED || smrOld.Status == model.STATUS_APPROVED {
		return model.ErrInvalidStatus
	}

	smrOld.Status = model.STATUS_APPROVED

	if err := s.repo.Update(smrOld); err != nil {
		return err
	}

	_, err = s.serviceRE.Create(context.TODO(), model.RequestExecution{
		Src:                           model.TypeRequestSM,
		SpecializedMachineryRequestID: &smrOld.ID,
		ClinetID:                      &smrOld.UserID,
		DriverID:                      &smrOld.AdSpecializedMachinery.UserID,
		Documents:                     smrOld.Document,
		Title:                         smrOld.Description,
		FinishAddress:                 &smrOld.Address,
		FinishLatitude:                smrOld.Latitude,
		FinishLongitude:               smrOld.Longitude,
		StartLeaseAt:                  model.Time{NullTime: sql.NullTime{Time: smrOld.StartLeaseAt, Valid: true}},
		EndLeaseAt:                    smrOld.EndLeaseAt,
	})
	if err != nil {
		return err
	}

	// if err := s.repo.Delete(id); err != nil {
	// 	return err
	// }

	tokens, err := s.notification.GetDeviceToken(model.DeviceToken{
		UserID: smrOld.UserID,
	})
	if err != nil {
		return err
	}

	user, err := s.userRepo.GetByID(smrOld.UserID)
	if err != nil {
		return err
	}

	ad, err := s.repoAdSM.GetByID(smrOld.AdSpecializedMachineryID)
	if err != nil {
		return fmt.Errorf("create smr: %w", err)
	}

	go func() {
		err := s.messageClient.Send(context.Background(), model.Notification{
			DeviceTokens: tokens,
			Tittle:       "Водитель подтвердил вашу заявку",
			Message:      fmt.Sprintf("%s %s подтвердил заявку %s", user.FirstName, user.LastName, ad.Name),
			Data: map[string]string{
				"date":       time.Now().String(),
				"type":       model.NotificationTypeSM,
				"id":         strconv.Itoa(smrOld.ID),
				"wasApprove": "true",
			},
		})
		if err != nil {
			logrus.Error(err)
		}

	}()

	return nil
}

// Должен иметь доступ только водителю
// Водитель отправляет на доработку и клиент должен подвердить или отменить
func (s *specializedMachineryRequest) DriverRevisedByID(smr model.SpecializedMachineryRequest) error {
	smrOld, err := s.repo.GetByID(smr.ID)
	if err != nil {
		return fmt.Errorf("driver revised error: %w", err)
	}

	if smrOld.Status == model.STATUS_CANCELED || smrOld.Status == model.STATUS_APPROVED {
		return model.ErrInvalidStatus
	}

	smr.Status = model.STATUS_REVISED_DRIVER

	err = s.repo.Update(smr)
	if err != nil {
		return fmt.Errorf("service specializedMachineryRequest error: %w", err)
	}

	go func(smr model.SpecializedMachineryRequest) {
		tokens, err := s.notification.GetDeviceToken(model.DeviceToken{
			UserID: smr.AdSpecializedMachinery.UserID,
		})
		if err != nil {
			logrus.Error(err)
			return
		}

		err = s.messageClient.Send(context.Background(), model.Notification{
			Tittle: "Водитель отклонил вашу заявку",
			Message: fmt.Sprintf("%s %s отклонил заявку %s",
				smr.AdSpecializedMachinery.User.FirstName,
				smr.AdSpecializedMachinery.User.LastName,
				smr.Description),
			DeviceTokens: tokens,
		})
		if err != nil {
			logrus.Error(err)
		}

	}(smrOld)

	return nil
}

// Должен иметь доступ только водителю
// Водитель отменяет заявку, клиент не имеет право что либо делать
func (s *specializedMachineryRequest) DriverCanceledByID(id int, canceledBy int) error {
	smrOld, err := s.repo.GetByID(id)
	if err != nil {
		return fmt.Errorf("driver revised error: %w", err)
	}

	if smrOld.Status == model.STATUS_CANCELED || smrOld.Status == model.STATUS_APPROVED {
		return model.ErrInvalidStatus
	}

	smrOld.Status = model.STATUS_CANCELED

	err = s.repo.Update(smrOld)
	if err != nil {
		return fmt.Errorf("update status error: %w", err)
	}

	go func() {
		tokens, err := s.notification.GetDeviceToken(model.DeviceToken{
			UserID: smrOld.UserID,
		})
		if smrOld.AdSpecializedMachinery.UserID != 0 {
			tokens2, _ := s.notification.GetDeviceToken(model.DeviceToken{
				UserID: smrOld.AdSpecializedMachinery.UserID,
			})
			tokens = append(tokens2)
		}

		canceledByUser, err := s.userRepo.GetByID(canceledBy)
		if err != nil {
			logrus.Errorf("service requestAdEquipment: ApproveByID: Get User Info: err: %v", err.Error())
			return
		}

		err = s.messageClient.Send(context.Background(), model.Notification{
			DeviceTokens: tokens,
			Message: fmt.Sprintf("%s %s отменил заявку %s", canceledByUser.FirstName,
				canceledByUser.LastName, smrOld.AdSpecializedMachinery.Name),
			Tittle: "Вам пришла заявка",
			Data: map[string]string{
				"date": time.Now().String(),
				"type": model.NotificationTypeSM,
				"id":   strconv.Itoa(smrOld.ID),
			},
		})
		if err != nil {
			logrus.Errorf("service requestAdEquipment: ApproveByID: Send Not: err: %v", err.Error())
			return
		}
	}()

	return nil
}

// Должен иметь достпу тольок клиент
// Клиент отменяет заявку которая пришла на доработку
func (s *specializedMachineryRequest) ClientCanceledByID(id int, canceledBy int) error {
	smrOld, err := s.repo.GetByID(id)
	if err != nil {
		return fmt.Errorf("driver revised error: %w", err)
	}

	if smrOld.Status != model.STATUS_REVISED_DRIVER {
		return model.ErrInvalidStatus
	}

	smrOld.Status = model.STATUS_CANCELED

	err = s.repo.Update(smrOld)
	if err != nil {
		return fmt.Errorf("update status error: %w", err)
	}

	go func() {
		tokens, err := s.notification.GetDeviceToken(model.DeviceToken{
			UserID: smrOld.UserID,
		})
		if smrOld.AdSpecializedMachinery.UserID != 0 {
			tokens2, _ := s.notification.GetDeviceToken(model.DeviceToken{
				UserID: smrOld.AdSpecializedMachinery.UserID,
			})
			tokens = append(tokens2)
		}

		canceledByUser, err := s.userRepo.GetByID(canceledBy)
		if err != nil {
			logrus.Errorf("service requestAdEquipment: ApproveByID: Get User Info: err: %v", err.Error())
			return
		}

		err = s.messageClient.Send(context.Background(), model.Notification{
			DeviceTokens: tokens,
			Message: fmt.Sprintf("%s %s отменил заявку %s", canceledByUser.FirstName,
				canceledByUser.LastName, smrOld.AdSpecializedMachinery.Name),
			Tittle: "Вам пришла заявка",
			Data: map[string]string{
				"date": time.Now().String(),
				"type": model.NotificationTypeSM,
				"id":   strconv.Itoa(smrOld.ID),
			},
		})

		if err != nil {
			logrus.Errorf("service requestAdEquipment: ApproveByID: Send Not: err: %v", err.Error())
			return
		}
		log.Println(tokens)
		log.Println("Notification Sent")
	}()

	return nil
}

// Должен иметь достпу тольок клиент
// Клиент доробатывает изменение и возвращает обратно водителю на утверждения
func (s *specializedMachineryRequest) ClientRevisedByID(smr model.SpecializedMachineryRequest) error {
	smrOld, err := s.repo.GetByID(smr.ID)
	if err != nil {
		return fmt.Errorf("driver revised error: %w", err)
	}

	if smrOld.Status != model.STATUS_REVISED_DRIVER {
		return model.ErrInvalidStatus
	}

	smrOld.Status = model.STATUS_REVISED_CLIENT

	return s.repo.Update(smr)
}

// // Должен иметь достпу тольок клиент
// // Клиент доробатывает изменение от водителя соглашается
// // TODO `Спросить у Сабины` Возможно клиент не должен сразу делать approve
// func (s *specializedMachineryRequest) ClientRevisedApproveByID(id int) error {
// 	smrOld, err := s.repo.GetByID(id)
// 	if err != nil {
// 		return fmt.Errorf("driver revised error: %w", err)
// 	}

// 	if smrOld.Status != model.STATUS_REVISED_DRIVER {
// 		return model.ErrInvalidStatus
// 	}

// 	smrOld.Status = model.STATUS_APPROVED

// 	return s.repo.Update(smrOld)
// }

func (s *specializedMachineryRequest) AssignTo(id int, workerID int) error {
	smrOld, err := s.repo.GetByID(id)
	if err != nil {
		return fmt.Errorf("owner approve and assign to error: %w", err)
	}

	if smrOld.Status == model.STATUS_CANCELED || smrOld.Status == model.STATUS_APPROVED {
		return model.ErrInvalidStatus
	}

	smrOld.Status = model.STATUS_APPROVED

	if err := s.repo.Update(smrOld); err != nil {
		return err
	}

	_, err = s.serviceRE.Create(context.TODO(), model.RequestExecution{
		Src:                           model.TypeRequestSM,
		SpecializedMachineryRequestID: &smrOld.ID,
		AssignTo:                      &workerID,
		ClinetID:                      &smrOld.UserID,
		DriverID:                      &smrOld.AdSpecializedMachinery.UserID,
		Documents:                     smrOld.Document,
		Title:                         smrOld.Description,
		FinishAddress:                 &smrOld.Address,
		FinishLatitude:                smrOld.Latitude,
		FinishLongitude:               smrOld.Longitude,
		StartLeaseAt:                  model.Time{NullTime: sql.NullTime{Time: smrOld.StartLeaseAt, Valid: true}},
		EndLeaseAt:                    smrOld.EndLeaseAt,
	})
	if err != nil {
		return err
	}

	if err := s.repo.Delete(id); err != nil {
		return err
	}

	return nil
}

func (s *specializedMachineryRequest) ForceApprove(smr model.SpecializedMachineryRequest) error {
	ad, err := s.repoAdSM.GetByID(smr.AdSpecializedMachineryID)
	if err != nil {
		return fmt.Errorf("create smr: %w", err)
	}

	if smr.EndLeaseAt.Valid {
		if smr.EndLeaseAt.Time.Before(smr.StartLeaseAt) {
			return model.ErrInvalidTimeRange
		}

		differenceTime := smr.EndLeaseAt.Time.Sub(smr.StartLeaseAt)
		if differenceTime <= 0 {
			return model.ErrInvalidTimeRange
		}

		c := int(math.Round(differenceTime.Hours()))

		smr.CountHour = &c

		diff := smr.EndLeaseAt.Time.Sub(smr.StartLeaseAt)

		dayWork := int(diff.Hours()/24) + 1

		hourWorkDay := smr.EndLeaseAt.Time.Hour() - smr.StartLeaseAt.Hour()

		if hourWorkDay == 0 && diff.Hours() > 0 {
			hourWorkDay = 1
		}

		oa := ad.Price * float64(dayWork*hourWorkDay)

		smr.OrderAmount = &oa
	}

	smr.Status = model.STATUS_APPROVED

	id, err := s.repo.Create(smr)
	if err != nil {
		return err
	}

	wg := sync.WaitGroup{}

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	chErr := make(chan error, len(smr.Document))

	for _, d := range smr.Document {
		wg.Add(1)
		doc := d
		go func() {
			defer wg.Done()
			_, err = s.remotes.Upload(ctx, doc)
			if err != nil {
				chErr <- err
				return
			}
		}()
	}

	wg.Wait()
	close(chErr)

	var errDoc error

	for err2 := range chErr {
		errDoc = errors.Join(errDoc, err2)
	}

	if errDoc != nil {
		return err
	}

	_, err = s.serviceRE.Create(context.TODO(), model.RequestExecution{
		Src:                           model.TypeRequestSM,
		SpecializedMachineryRequestID: &id,
		ClinetID:                      &smr.UserID,
		DriverID:                      &ad.UserID,
		AssignTo:                      &ad.UserID,
		Documents:                     smr.Document,
		Title:                         smr.Description,
		FinishAddress:                 &smr.Address,
		FinishLatitude:                smr.Latitude,
		FinishLongitude:               smr.Longitude,
		StartLeaseAt:                  model.Time{NullTime: sql.NullTime{Time: smr.StartLeaseAt, Valid: true}},
		EndLeaseAt:                    smr.EndLeaseAt,
	})
	if err != nil {
		return err
	}

	if err := s.repo.Delete(id); err != nil {
		return err
	}

	return nil
}
