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

type IRequestAdService interface {
	Get(ctx context.Context, f model.FilterRequestAdService) ([]model.RequestAdService, int, error)
	GetByID(ctx context.Context, id int) (model.RequestAdService, error)
	GetHistoryByID(ctx context.Context, f model.FilterRequestAdService) ([]model.RequestAdService, int, error)
	Create(ctx context.Context, r model.RequestAdService) error
	ApproveByID(ctx context.Context, id int, executorID *int) error
	CanceledByID(ctx context.Context, id int) error
	UpdateExecutorID(ctx context.Context, r model.RequestAdService) error
}

type requestAdService struct {
	requestAdServiceRepo    repository.IRequestAdService
	remotes                 client.DocumentsRemote
	requestExecutionService IRequestExecution
	adServiceService        IAdService
	notification            repository.INotification
	messageClient           client.NotificationClient
	userRepo                repository.IUser
}

func NewRequestAdService(
	requestAdServiceRepo repository.IRequestAdService,
	remotes client.DocumentsRemote,
	requestExecutionService IRequestExecution,
	adServiceService IAdService,
	notification repository.INotification,
	messageClient client.NotificationClient,
	userRepo repository.IUser,
) IRequestAdService {
	return &requestAdService{
		requestAdServiceRepo:    requestAdServiceRepo,
		remotes:                 remotes,
		requestExecutionService: requestExecutionService,
		adServiceService:        adServiceService,
		notification:            notification,
		messageClient:           messageClient,
		userRepo:                userRepo,
	}
}

func (service *requestAdService) Get(ctx context.Context, f model.FilterRequestAdService) ([]model.RequestAdService, int, error) {
	res, total, err := service.requestAdServiceRepo.Get(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service requestAdService: Get: %w", err)
	}

	for i, v := range res {
		res[i].UrlDocument = make([]string, 0, len(v.Document))
		for _, d := range v.Document {
			d, err = service.remotes.Share(ctx, d, time.Hour*1)
			if err != nil {
				return res, 0, fmt.Errorf("service requestAdService: GetBy: get document: id_doc: %d: %w", v.ID, err)
			}
			res[i].UrlDocument = append(res[i].UrlDocument, d.ShareLink)
		}
	}

	return res, total, nil
}

func (service *requestAdService) GetByID(ctx context.Context, id int) (model.RequestAdService, error) {
	res, err := service.requestAdServiceRepo.GetByID(ctx, id)
	if err != nil {
		return res, fmt.Errorf("service requestAdService: GetByID: %w", err)
	}

	res.AdService.UrlDocument = make([]string, 0, len(res.AdService.Documents))
	for _, d := range res.AdService.Documents {
		d, err = service.remotes.Share(ctx, d, time.Hour*1)
		if err != nil {
			return res, fmt.Errorf("service requestAdService: GetBy: get document AdService: id_doc: %d: %w", res.ID, err)
		}
		res.AdService.UrlDocument = append(res.AdService.UrlDocument, d.ShareLink)
	}

	res.UrlDocument = make([]string, 0, len(res.Document))
	for _, d := range res.Document {
		d, err = service.remotes.Share(ctx, d, time.Hour*1)
		if err != nil {
			return res, fmt.Errorf("service requestAdService: GetBy: get document: id_doc: %d: %w", res.ID, err)
		}
		res.UrlDocument = append(res.UrlDocument, d.ShareLink)
	}

	return res, nil
}

func (service *requestAdService) Create(ctx context.Context, r model.RequestAdService) error {
	r.Status = model.STATUS_CREATED

	ad, err := service.adServiceService.GetByID(ctx, r.AdServiceID)
	if err != nil {
		return fmt.Errorf("service requestAdService: GetByID Ad: %w", err)
	}

	if r.ExecutorID == nil {
		r.ExecutorID = &ad.UserID
	}

	id, err := service.requestAdServiceRepo.Create(ctx, r)
	if err != nil {
		return fmt.Errorf("service requestAdService: Create: %w", err)
	}

	for i, d := range r.Document {
		_, err := service.remotes.Upload(ctx, r.Document[i])
		if err != nil {
			return fmt.Errorf("service requestAdService: Create: Upload Document: documne title \"%v\": %v", d.Title, err.Error())
		}
	}

	go func() {
		tokens, err := service.notification.GetDeviceToken(model.DeviceToken{
			UserID: ad.UserID,
		})
		if err != nil {
			logrus.Errorf("service requestAdService: Create: Get Token: err: %v", err.Error())
			return
		}

		//user, err := service.userRepo.GetByID(ad.UserID)
		//if err != nil {
		//	logrus.Errorf("service requestAdService: Create: Get User Info: err: %v", err.Error())
		//	return
		//}

		r, _ = service.requestAdServiceRepo.GetByID(ctx, r.ID)

		err = service.messageClient.Send(context.Background(), model.Notification{
			DeviceTokens: tokens,
			Message:      fmt.Sprintf("%s %s отправил заявку %s", r.User.FirstName, r.User.LastName, ad.Title),
			Tittle:       "Вам пришла заявка",
			Data: map[string]string{
				"date": time.Now().String(),
				"type": model.NotificationTypeSVC,
				"id":   strconv.Itoa(id),
			},
		})
		if err != nil {
			logrus.Errorf("service requestAdService: Create: Send Not: err: %v", err.Error())
			return
		}
	}()

	return nil
}

func (service *requestAdService) ApproveByID(ctx context.Context, id int, executorID *int) error {
	r, err := service.requestAdServiceRepo.GetByID(ctx, id)
	if err != nil {
		return fmt.Errorf("service requestAdService: ApproveByID: GetByID: %w", err)
	}

	if r.Status != model.STATUS_CREATED {
		return fmt.Errorf("service requestAdService: ApproveByID: check status request: %w", model.ErrInvalidStatus)
	} else {
		r.Status = model.STATUS_APPROVED
	}

	err = service.requestAdServiceRepo.Update(ctx, r)
	if err != nil {
		return fmt.Errorf("service requestAdService: ApproveByID: UpdateStatus: %w", err)
	}

	_, err = service.requestExecutionService.Create(ctx, model.RequestExecution{
		Src:                model.TypeRequestSVC,
		AssignTo:           executorID,
		RequestAdServiceID: &r.ID,
		ClinetID:           &r.UserID,
		DriverID:           &r.AdService.UserID,
		Documents:          r.Document,
		Title:              r.Description,
		FinishAddress:      &r.Address,
		FinishLatitude:     r.Latitude,
		FinishLongitude:    r.Longitude,
		StartLeaseAt:       r.StartLeaseAt,
		EndLeaseAt:         r.EndLeaseAt,
	})
	if err != nil {
		return fmt.Errorf("service requestAdService: ApproveByID: Create Execution: %w", err)
	}

	go func() {
		tokens, err := service.notification.GetDeviceToken(model.DeviceToken{
			UserID: r.UserID,
		})
		if err != nil {
			logrus.Errorf("service requestAdService: ApproveByID: Get Token: err: %v", err.Error())
			return
		}

		executor, err := service.userRepo.GetByID(*executorID)
		if err != nil {
			logrus.Errorf("service requestAdService: ApproveByID: Get User Info: err: %v", err.Error())
			return
		}

		err = service.messageClient.Send(context.Background(), model.Notification{
			DeviceTokens: tokens,
			Message:      fmt.Sprintf("%s %s подтвердил заявку %s", executor.FirstName, executor.LastName, r.AdService.Title),
			Tittle:       "Вам пришла заявка",
			Data: map[string]string{
				"date":       time.Now().String(),
				"type":       model.NotificationTypeSVC,
				"id":         strconv.Itoa(r.ID),
				"wasApprove": "true",
			},
		})
		if err != nil {
			logrus.Errorf("service requestAdService: ApproveByID: Send Not: err: %v", err.Error())
			return
		}
	}()

	return nil
}

func (service *requestAdService) CanceledByID(ctx context.Context, id int) error {
	r, err := service.requestAdServiceRepo.GetByID(ctx, id)
	if err != nil {
		return fmt.Errorf("service requestAdService: CanceledByID: GetByID: %w", err)
	}

	if r.Status != model.STATUS_CREATED {
		return fmt.Errorf("service requestAdService: CanceledByID: check status request: %w", model.ErrInvalidStatus)
	}

	r.Status = model.STATUS_CANCELED

	err = service.requestAdServiceRepo.Update(ctx, r)
	if err != nil {
		return fmt.Errorf("service requestAdService: CanceledByID: UpdateStatus: %w", err)
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
			Message:      fmt.Sprintf("%s %s отменил заявку %s", r.Executor.FirstName, r.Executor.LastName, r.AdService.Title),
			Tittle:       "Вам пришла заявка",
			Data: map[string]string{
				"date": time.Now().String(),
				"type": model.NotificationTypeSVC,
				"id":   strconv.Itoa(r.ID),
			},
		})
		if err != nil {
			logrus.Errorf("service requestAdService: ApproveByID: Send Not: err: %v", err.Error())
			return
		}
	}()

	return nil
}

func (service *requestAdService) GetHistoryByID(ctx context.Context, f model.FilterRequestAdService) ([]model.RequestAdService, int, error) {
	res, total, err := service.requestAdServiceRepo.GetHistoryByID(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service requestAdService: GetHistoryByID: %w", err)
	}

	return res, total, nil
}

func (service *requestAdService) UpdateExecutorID(ctx context.Context, r model.RequestAdService) error {
	rDB, err := service.requestAdServiceRepo.GetByID(ctx, r.ID)
	if err != nil {
		return fmt.Errorf("service requestAdService: CanceledByID: GetByID: %w", err)
	}

	if r.Status != model.STATUS_CREATED {
		return fmt.Errorf("service requestAdService: CanceledByID: check status request: %w", model.ErrInvalidStatus)
	} else {
		rDB.ExecutorID = r.ExecutorID
	}

	err = service.requestAdServiceRepo.Update(ctx, rDB)
	if err != nil {
		return fmt.Errorf("service requestAdService: UpdateExecutorID: %w", err)
	}

	return nil
}
