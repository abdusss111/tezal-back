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

type IRequestAdServiceClient interface {
	Get(ctx context.Context, f model.FilterRequestAdServiceClient) ([]model.RequestAdServiceClient, int, error)
	GetByID(ctx context.Context, id int) (model.RequestAdServiceClient, error)
	GetHistoryByID(ctx context.Context, f model.FilterRequestAdServiceClient) ([]model.RequestAdServiceClient, int, error)
	Create(ctx context.Context, r model.RequestAdServiceClient) error
	ApproveByID(ctx context.Context, id int, approvedBy model.User) error
	CanceledByID(ctx context.Context, id int) error
	UpdateExecutorID(ctx context.Context, r model.RequestAdServiceClient) error
}

type requestAdServiceClient struct {
	requestAdServiceClientRepo repository.IRequestAdServiceClient
	adServiceClientService     IAdServiceClient
	remotes                    client.DocumentsRemote
	requestExecutionService    IRequestExecution
	notification               repository.INotification
	messageClient              client.NotificationClient
	userRepo                   repository.IUser
}

func NewRequestAdServiceClient(
	requestAdServiceClientRepo repository.IRequestAdServiceClient,
	remotes client.DocumentsRemote,
	requestExecutionService IRequestExecution,
	adServiceClientService IAdServiceClient,
	notification repository.INotification,
	messageClient client.NotificationClient,
	userRepo repository.IUser,
) IRequestAdServiceClient {
	return &requestAdServiceClient{
		requestAdServiceClientRepo: requestAdServiceClientRepo,
		remotes:                    remotes,
		requestExecutionService:    requestExecutionService,
		adServiceClientService:     adServiceClientService,
		notification:               notification,
		messageClient:              messageClient,
		userRepo:                   userRepo,
	}
}

func (service *requestAdServiceClient) Get(ctx context.Context, f model.FilterRequestAdServiceClient) ([]model.RequestAdServiceClient, int, error) {
	res, total, err := service.requestAdServiceClientRepo.Get(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service requestAdServiceClient: Get: %w", err)
	}

	for i, v := range res {
		res[i].AdServiceClient.UrlDocument = make([]string, 0, len(res[i].AdServiceClient.UrlDocument))
		for _, d := range v.AdServiceClient.Documents {
			d, err = service.remotes.Share(ctx, d, time.Hour*1)
			if err != nil {
				return res, 0, fmt.Errorf("service requestAdServiceClient: GetBy: get document: id_doc: %d: %w", v.ID, err)
			}
			res[i].AdServiceClient.UrlDocument = append(res[i].AdServiceClient.UrlDocument, d.ShareLink)
		}
	}

	return res, total, nil
}

func (service *requestAdServiceClient) GetByID(ctx context.Context, id int) (model.RequestAdServiceClient, error) {
	res, err := service.requestAdServiceClientRepo.GetByID(ctx, id)
	if err != nil {
		return res, fmt.Errorf("service requestAdServiceClient: GetByID: %w", err)
	}

	res.AdServiceClient.UrlDocument = make([]string, 0, len(res.AdServiceClient.Documents))
	for _, d := range res.AdServiceClient.Documents {
		d, err = service.remotes.Share(ctx, d, time.Hour*1)
		if err != nil {
			return res, fmt.Errorf("service requestAdService: GetBy: get document: id_doc: %d: %w", res.AdServiceClient.ID, err)
		}
		res.AdServiceClient.UrlDocument = append(res.AdServiceClient.UrlDocument, d.ShareLink)
	}

	return res, nil
}

func (service *requestAdServiceClient) Create(ctx context.Context, r model.RequestAdServiceClient) error {
	r.Status = model.STATUS_CREATED

	id, err := service.requestAdServiceClientRepo.Create(ctx, r)
	if err != nil {
		return fmt.Errorf("service requestAdServiceClient: Create: %w", err)
	}

	go func() {
		ad, err := service.adServiceClientService.GetByID(context.Background(), r.AdServiceClientID)
		if err != nil {
			logrus.Errorf("service requestAdServiceClient: Create: GetAdById: err: %v", err.Error())
			return
		}

		tokens, err := service.notification.GetDeviceToken(model.DeviceToken{
			UserID: ad.UserID,
		})
		if err != nil {
			logrus.Errorf("service requestAdServiceClient: Create: Get Token: err: %v", err.Error())
			return
		}

		executor, err := service.userRepo.GetByID(*r.ExecutorID)
		if err != nil {
			logrus.Errorf("service requestAdServiceClient: Create: Get Executor Info: err: %v", err.Error())
			return
		}

		err = service.messageClient.Send(context.Background(), model.Notification{
			DeviceTokens: tokens,
			Message:      fmt.Sprintf("%s %s отправил заявку %s", executor.FirstName, executor.LastName, ad.Title),
			Tittle:       "Вам пришла заявка",
			Data: map[string]string{
				"date": time.Now().String(),
				"type": model.NotificationTypeSVCClient,
				"id":   strconv.Itoa(id),
			},
		})
		if err != nil {
			logrus.Errorf("service requestAdServiceClient: Create: Send Not: err: %v", err.Error())
			return
		}
	}()

	return nil
}

func (service *requestAdServiceClient) ApproveByID(ctx context.Context, id int, approvedBy model.User) error {
	r, err := service.requestAdServiceClientRepo.GetByID(ctx, id)
	if err != nil {
		return fmt.Errorf("service requestAdServiceClient: ApproveByID: GetByID: %w", err)
	}

	if r.Status != model.STATUS_CREATED {
		return fmt.Errorf("service requestAdServiceClient: ApproveByID: check status request: %w", model.ErrInvalidStatus)
	} else {
		r.Status = model.STATUS_APPROVED
	}

	err = service.requestAdServiceClientRepo.Update(ctx, r)
	if err != nil {
		return fmt.Errorf("service requestAdServiceClient: ApproveByID: Update: %w", err)
	}

	service.requestExecutionService.Create(ctx, model.RequestExecution{
		Src:                      model.TypeRequestSVCClient,
		AssignTo:                 r.ExecutorID,
		RequestAdServiceClientID: &r.ID,
		DriverID:                 &r.UserID,
		ClinetID:                 &r.AdServiceClient.UserID,
		Documents:                r.AdServiceClient.Documents,
		Title:                    r.AdServiceClient.Title,
		FinishAddress:            &r.AdServiceClient.Address,
		FinishLatitude:           r.AdServiceClient.Latitude,
		FinishLongitude:          r.AdServiceClient.Longitude,
		StartLeaseAt:             r.AdServiceClient.StartLeaseAt,
		EndLeaseAt:               r.AdServiceClient.EndLeaseAt,
	})

	go func() {
		tokens, err := service.notification.GetDeviceToken(model.DeviceToken{
			UserID: r.UserID,
		})
		if err != nil {
			logrus.Errorf("service requestAdServiceClient: ApproveByID: Get Token: err: %v", err.Error())
			return
		}

		err = service.messageClient.Send(context.Background(), model.Notification{
			DeviceTokens: tokens,
			Message:      fmt.Sprintf("%s %s подтвердил заявку %s", approvedBy.FirstName, approvedBy.LastName, r.AdServiceClient.Title),
			Tittle:       "Вам пришла заявка",
			Data: map[string]string{
				"date":       time.Now().String(),
				"type":       model.NotificationTypeSVCClient,
				"id":         strconv.Itoa(r.ID),
				"wasApprove": "true",
			},
		})
		if err != nil {
			logrus.Errorf("service requestAdServiceClient: ApproveByID: Send Not: err: %v", err.Error())
			return
		}
	}()

	go func() {
		r.AdServiceClient.Status = model.STATUS_FINISHED
		if err = service.adServiceClientService.UpdateStatus(ctx, r.AdServiceClient); err != nil {
			logrus.Errorf("requestAdServiceClient - ApproveByID - error updating ad service client status - %v", err)
			return
		}
	}()

	return nil
}

func (service *requestAdServiceClient) CanceledByID(ctx context.Context, id int) error {
	r, err := service.requestAdServiceClientRepo.GetByID(ctx, id)
	if err != nil {
		return fmt.Errorf("service requestAdServiceClient: CanceledByID: GetByID: %w", err)
	}

	if r.Status != model.STATUS_CREATED {
		return fmt.Errorf("service requestAdServiceClient: CanceledByID: check status request: %w", model.ErrInvalidStatus)
	}

	r.Status = model.STATUS_CANCELED

	err = service.requestAdServiceClientRepo.Update(ctx, r)
	if err != nil {
		return fmt.Errorf("service requestAdServiceClient: CanceledByID: Update: %w", err)
	}

	go func() {
		tokens, err := service.notification.GetDeviceToken(model.DeviceToken{
			UserID: r.UserID,
		})
		if r.ExecutorID != nil && *r.ExecutorID != 0 {
			tokens2, _ := service.notification.GetDeviceToken(model.DeviceToken{
				UserID: *r.ExecutorID,
			})
			tokens = append(tokens2)
		}

		user, err := service.userRepo.GetByID(r.AdServiceClient.UserID)
		if err != nil {
			logrus.Errorf("service requestAdServiceClient: ApproveByID: Get User Info: err: %v", err.Error())
			return
		}

		err = service.messageClient.Send(context.Background(), model.Notification{
			DeviceTokens: tokens,
			Message:      fmt.Sprintf("%s %s отменил заявку %s", user.FirstName, user.LastName, r.AdServiceClient.Title),
			Tittle:       "Вам пришла заявка",
			Data: map[string]string{
				"date": time.Now().String(),
				"type": model.NotificationTypeSVCClient,
				"id":   strconv.Itoa(r.ID),
			},
		})
		if err != nil {
			logrus.Errorf("service requestAdServiceClient: ApproveByID: Send Not: err: %v", err.Error())
			return
		}
	}()

	return nil
}

func (service *requestAdServiceClient) GetHistoryByID(ctx context.Context, f model.FilterRequestAdServiceClient) ([]model.RequestAdServiceClient, int, error) {
	res, total, err := service.requestAdServiceClientRepo.GetHistoryByID(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service requestAdServiceClient: GetHistoryByID: %w", err)
	}

	return res, total, nil
}

func (service *requestAdServiceClient) UpdateExecutorID(ctx context.Context, r model.RequestAdServiceClient) error {
	rDB, err := service.requestAdServiceClientRepo.GetByID(ctx, r.ID)
	if err != nil {
		return fmt.Errorf("service requestAdServiceClient: CanceledByID: GetByID: %w", err)
	}

	if r.Status != model.STATUS_CREATED {
		return fmt.Errorf("service requestAdServiceClient: CanceledByID: check status request: %w", model.ErrInvalidStatus)
	} else {
		rDB.ExecutorID = r.ExecutorID
	}

	err = service.requestAdServiceClientRepo.Update(ctx, rDB)
	if err != nil {
		return fmt.Errorf("service requestAdServiceClient: UpdateExecutorID: %w", err)
	}

	return nil
}
