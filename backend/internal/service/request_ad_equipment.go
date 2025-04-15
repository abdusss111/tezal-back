package service

import (
	"context"
	"fmt"
	"strconv"
	"time"

	"github.com/sirupsen/logrus"
	"gitlab.com/eqshare/eqshare-back/internal/client"
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IRequestAdEquipment interface {
	Get(ctx context.Context, f model.FilterRequestAdEquipment) ([]model.RequestAdEquipment, int, error)
	GetByID(ctx context.Context, id int) (model.RequestAdEquipment, error)
	GetHistoryByID(ctx context.Context, f model.FilterRequestAdEquipment) ([]model.RequestAdEquipment, int, error)
	Create(ctx context.Context, r model.RequestAdEquipment) error
	ApproveByID(ctx context.Context, id int, executorID *int) error
	CanceledByID(ctx context.Context, id int) error
	UpdateExecutorID(ctx context.Context, r model.RequestAdEquipment) error
}

type requestAdEquipment struct {
	requestAdEquipmentRepo  repository.IRequestAdEquipment
	remotes                 client.DocumentsRemote
	requestExecutionService IRequestExecution
	adEquipmentService      IAdEquipment
	notification            repository.INotification
	messageClient           client.NotificationClient
	userRepo                repository.IUser
}

func NewRequestAdEquipment(
	requestAdEquipmentRepo repository.IRequestAdEquipment,
	remotes client.DocumentsRemote,
	requestExecutionService IRequestExecution,
	adEquipmentService IAdEquipment,
	notification repository.INotification,
	messageClient client.NotificationClient,
	userRepo repository.IUser,
) IRequestAdEquipment {
	return &requestAdEquipment{
		requestAdEquipmentRepo:  requestAdEquipmentRepo,
		remotes:                 remotes,
		requestExecutionService: requestExecutionService,
		adEquipmentService:      adEquipmentService,
		notification:            notification,
		messageClient:           messageClient,
		userRepo:                userRepo,
	}
}

func (service *requestAdEquipment) Get(ctx context.Context, f model.FilterRequestAdEquipment) ([]model.RequestAdEquipment, int, error) {
	res, total, err := service.requestAdEquipmentRepo.Get(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service requestAdEquipment: Get: %w", err)
	}

	for i, v := range res {
		res[i].UrlDocument = make([]string, 0, len(v.Document))
		for _, d := range v.Document {
			d, err = service.remotes.Share(ctx, d, time.Hour*1)
			if err != nil {
				return res, 0, fmt.Errorf("service requestAdEquipment: GetBy: get document: id_doc: %d: %w", v.ID, err)
			}
			res[i].UrlDocument = append(res[i].UrlDocument, d.ShareLink)
		}
	}

	return res, total, nil
}

func (service *requestAdEquipment) GetByID(ctx context.Context, id int) (model.RequestAdEquipment, error) {
	res, err := service.requestAdEquipmentRepo.GetByID(ctx, id)
	if err != nil {
		return res, fmt.Errorf("service requestAdEquipment: GetByID: %w", err)
	}

	res.AdEquipment.UrlDocument = make([]string, 0, len(res.AdEquipment.Documents))
	for _, d := range res.AdEquipment.Documents {
		d, err = service.remotes.Share(ctx, d, time.Hour*1)
		if err != nil {
			return res, fmt.Errorf("service requestAdEquipment: GetBy: get document AdEquipment: id_doc: %d: %w", res.ID, err)
		}
		res.AdEquipment.UrlDocument = append(res.AdEquipment.UrlDocument, d.ShareLink)
	}

	res.UrlDocument = make([]string, 0, len(res.Document))
	for _, d := range res.Document {
		d, err = service.remotes.Share(ctx, d, time.Hour*1)
		if err != nil {
			return res, fmt.Errorf("service requestAdEquipment: GetBy: get document: id_doc: %d: %w", res.ID, err)
		}
		res.UrlDocument = append(res.UrlDocument, d.ShareLink)
	}

	return res, nil
}

func (service *requestAdEquipment) Create(ctx context.Context, r model.RequestAdEquipment) error {
	r.Status = model.STATUS_CREATED

	ad, err := service.adEquipmentService.GetByID(ctx, r.AdEquipmentID)
	if err != nil {
		return fmt.Errorf("service requestAdEquipment: GetByID Ad: %w", err)
	}

	if r.ExecutorID == nil {
		r.ExecutorID = &ad.UserID
	}

	id, err := service.requestAdEquipmentRepo.Create(ctx, r)
	if err != nil {
		return fmt.Errorf("service requestAdEquipment: Create: %w", err)
	}

	for i, d := range r.Document {
		_, err := service.remotes.Upload(ctx, r.Document[i])
		if err != nil {
			return fmt.Errorf("service requestAdEquipment: Create: Upload Document: documne title \"%v\": %v", d.Title, err.Error())
		}
	}

	go func() {
		tokens, err := service.notification.GetDeviceToken(model.DeviceToken{
			UserID: ad.UserID,
		})
		if err != nil {
			logrus.Errorf("service requestAdEquipment: Create: Get Token: err: %v", err.Error())
			return
		}

		//user, err := service.userRepo.GetByID(ad.UserID)
		//if err != nil {
		//	logrus.Errorf("service requestAdEquipment: Create: Get User Info: err: %v", err.Error())
		//	return
		//}

		r, _ = service.requestAdEquipmentRepo.GetByID(ctx, r.ID)

		err = service.messageClient.Send(context.Background(), model.Notification{
			DeviceTokens: tokens,
			Message:      fmt.Sprintf("%s %s отправил заявку %s", r.User.FirstName, r.User.LastName, ad.Title),
			Tittle:       "Вам пришла заявка",
			Data: map[string]string{
				"date": time.Now().String(),
				"type": model.NotificationTypeEQ,
				"id":   strconv.Itoa(id),
			},
		})
		if err != nil {
			logrus.Errorf("service requestAdEquipment: Create: Send Not: err: %v", err.Error())
			return
		}
	}()

	return nil
}

func (service *requestAdEquipment) ApproveByID(ctx context.Context, id int, executorID *int) error {
	r, err := service.requestAdEquipmentRepo.GetByID(ctx, id)
	if err != nil {
		return fmt.Errorf("service requestAdEquipment: ApproveByID: GetByID: %w", err)
	}

	if r.Status != model.STATUS_CREATED {
		return fmt.Errorf("service requestAdEquipment: ApproveByID: check status request: %w", model.ErrInvalidStatus)
	} else {
		r.Status = model.STATUS_APPROVED
	}

	err = service.requestAdEquipmentRepo.Update(ctx, r)
	if err != nil {
		return fmt.Errorf("service requestAdEquipment: ApproveByID: UpdateStatus: %w", err)
	}

	_, err = service.requestExecutionService.Create(ctx, model.RequestExecution{
		Src:                  model.TypeRequestEq,
		AssignTo:             executorID,
		RequestAdEquipmentID: &r.ID,
		ClinetID:             &r.UserID,
		DriverID:             &r.AdEquipment.UserID,
		Documents:            r.Document,
		Title:                r.Description,
		FinishAddress:        &r.Address,
		FinishLatitude:       r.Latitude,
		FinishLongitude:      r.Longitude,
		StartLeaseAt:         r.StartLeaseAt,
		EndLeaseAt:           r.EndLeaseAt,
	})
	if err != nil {
		return fmt.Errorf("service requestAdEquipment: ApproveByID: Create Execution: %w", err)
	}

	go func() {
		tokens, err := service.notification.GetDeviceToken(model.DeviceToken{
			UserID: r.UserID,
		})
		if err != nil {
			logrus.Errorf("service requestAdEquipment: ApproveByID: Get Token: err: %v", err.Error())
			return
		}

		user, err := service.userRepo.GetByID(*executorID)
		if err != nil {
			logrus.Errorf("service requestAdEquipment: ApproveByID: Get User Info: err: %v", err.Error())
			return
		}

		err = service.messageClient.Send(context.Background(), model.Notification{
			DeviceTokens: tokens,
			Message:      fmt.Sprintf("%s %s подтвердил заявку %s", user.FirstName, user.LastName, r.AdEquipment.Title),
			Tittle:       "Вам пришла заявка",
			Data: map[string]string{
				"date":       time.Now().String(),
				"type":       model.NotificationTypeEQ,
				"id":         strconv.Itoa(r.ID),
				"wasApprove": "true",
			},
		})
		if err != nil {
			logrus.Errorf("service requestAdEquipment: ApproveByID: Send Not: err: %v", err.Error())
			return
		}
	}()

	return nil
}

func (service *requestAdEquipment) CanceledByID(ctx context.Context, id int) error {
	r, err := service.requestAdEquipmentRepo.GetByID(ctx, id)
	if err != nil {
		return fmt.Errorf("service requestAdEquipment: CanceledByID: GetByID: %w", err)
	}

	if r.Status != model.STATUS_CREATED {
		return fmt.Errorf("service requestAdEquipment: CanceledByID: check status request: %w", model.ErrInvalidStatus)
	}

	r.Status = model.STATUS_CANCELED

	err = service.requestAdEquipmentRepo.Update(ctx, r)
	if err != nil {
		return fmt.Errorf("service requestAdEquipment: CanceledByID: UpdateStatus: %w", err)
	}

	go func() {
		tokens, err := service.notification.GetDeviceToken(model.DeviceToken{
			UserID: r.UserID,
		})
		//if r.ExecutorID != nil && *r.ExecutorID != 0 {
		//	tokens2, _ := service.notification.GetDeviceToken(model.DeviceToken{
		//		UserID: *r.ExecutorID,
		//	})
		//	tokens = append(tokens2)
		//}

		err = service.messageClient.Send(context.Background(), model.Notification{
			DeviceTokens: tokens,
			Message:      fmt.Sprintf("%s %s отменил заявку %s", r.Executor.FirstName, r.Executor.LastName, r.AdEquipment.Title),
			Tittle:       "Вам пришла заявка",
			Data: map[string]string{
				"date": time.Now().String(),
				"type": model.NotificationTypeEQ,
				"id":   strconv.Itoa(r.ID),
			},
		})
		if err != nil {
			logrus.Errorf("service requestAdEquipment: ApproveByID: Send Not: err: %v", err.Error())
			return
		}
	}()

	return nil
}

func (service *requestAdEquipment) GetHistoryByID(ctx context.Context, f model.FilterRequestAdEquipment) ([]model.RequestAdEquipment, int, error) {
	res, total, err := service.requestAdEquipmentRepo.GetHistoryByID(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service requestAdEquipment: GetHistoryByID: %w", err)
	}

	return res, total, nil
}

func (service *requestAdEquipment) UpdateExecutorID(ctx context.Context, r model.RequestAdEquipment) error {
	rDB, err := service.requestAdEquipmentRepo.GetByID(ctx, r.ID)
	if err != nil {
		return fmt.Errorf("service requestAdEquipment: CanceledByID: GetByID: %w", err)
	}

	if r.Status != model.STATUS_CREATED {
		return fmt.Errorf("service requestAdEquipment: CanceledByID: check status request: %w", model.ErrInvalidStatus)
	} else {
		rDB.ExecutorID = r.ExecutorID
	}

	err = service.requestAdEquipmentRepo.Update(ctx, rDB)
	if err != nil {
		return fmt.Errorf("service requestAdEquipment: UpdateExecutorID: %w", err)
	}

	return nil
}
