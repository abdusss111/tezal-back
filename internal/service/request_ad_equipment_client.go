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

type IRequestAdEquipmentClient interface {
	Get(ctx context.Context, f model.FilterRequestAdEquipmentClient) ([]model.RequestAdEquipmentClient, int, error)
	GetByID(ctx context.Context, id int) (model.RequestAdEquipmentClient, error)
	GetHistoryByID(ctx context.Context, f model.FilterRequestAdEquipmentClient) ([]model.RequestAdEquipmentClient, int, error)
	Create(ctx context.Context, r model.RequestAdEquipmentClient) error
	ApproveByID(ctx context.Context, id int, approvedBy model.User) error
	CanceledByID(ctx context.Context, id int) error
	UpdateExecutorID(ctx context.Context, r model.RequestAdEquipmentClient) error
}

type requestAdEquipmentClient struct {
	requestAdEquipmentClientRepo repository.IRequestAdEquipmentClient
	adEquipmentClientService     IAdEquipmentClient
	remotes                      client.DocumentsRemote
	requestExecutionService      IRequestExecution
	notification                 repository.INotification
	messageClient                client.NotificationClient
	userRepo                     repository.IUser
}

func NewRequestAdEquipmentClient(
	requestAdEquipmentClientRepo repository.IRequestAdEquipmentClient,
	remotes client.DocumentsRemote,
	requestExecutionService IRequestExecution,
	adEquipmentClientService IAdEquipmentClient,
	notification repository.INotification,
	messageClient client.NotificationClient,
	userRepo repository.IUser,
) IRequestAdEquipmentClient {
	return &requestAdEquipmentClient{
		requestAdEquipmentClientRepo: requestAdEquipmentClientRepo,
		remotes:                      remotes,
		requestExecutionService:      requestExecutionService,
		adEquipmentClientService:     adEquipmentClientService,
		notification:                 notification,
		messageClient:                messageClient,
		userRepo:                     userRepo,
	}
}

func (service *requestAdEquipmentClient) Get(ctx context.Context, f model.FilterRequestAdEquipmentClient) ([]model.RequestAdEquipmentClient, int, error) {
	res, total, err := service.requestAdEquipmentClientRepo.Get(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service requestAdEquipmentClient: Get: %w", err)
	}

	for i, v := range res {
		res[i].AdEquipmentClient.UrlDocument = make([]string, 0, len(res[i].AdEquipmentClient.UrlDocument))
		for _, d := range v.AdEquipmentClient.Documents {
			d, err = service.remotes.Share(ctx, d, time.Hour*1)
			if err != nil {
				return res, 0, fmt.Errorf("service requestAdEquipmentClient: GetBy: get document: id_doc: %d: %w", v.ID, err)
			}
			res[i].AdEquipmentClient.UrlDocument = append(res[i].AdEquipmentClient.UrlDocument, d.ShareLink)
		}
	}

	return res, total, nil
}

func (service *requestAdEquipmentClient) GetByID(ctx context.Context, id int) (model.RequestAdEquipmentClient, error) {
	res, err := service.requestAdEquipmentClientRepo.GetByID(ctx, id)
	if err != nil {
		return res, fmt.Errorf("service requestAdEquipmentClient: GetByID: %w", err)
	}

	res.AdEquipmentClient.UrlDocument = make([]string, 0, len(res.AdEquipmentClient.Documents))
	for _, d := range res.AdEquipmentClient.Documents {
		d, err = service.remotes.Share(ctx, d, time.Hour*1)
		if err != nil {
			return res, fmt.Errorf("service requestAdEquipment: GetBy: get document: id_doc: %d: %w", res.AdEquipmentClient.ID, err)
		}
		res.AdEquipmentClient.UrlDocument = append(res.AdEquipmentClient.UrlDocument, d.ShareLink)
	}

	return res, nil
}

func (service *requestAdEquipmentClient) Create(ctx context.Context, r model.RequestAdEquipmentClient) error {
	r.Status = model.STATUS_CREATED

	id, err := service.requestAdEquipmentClientRepo.Create(ctx, r)
	if err != nil {
		return fmt.Errorf("service requestAdEquipmentClient: Create: %w", err)
	}

	go func() {
		ad, err := service.adEquipmentClientService.GetByID(context.Background(), r.AdEquipmentClientID)
		if err != nil {
			logrus.Errorf("service requestAdEquipmentClient: Create: GetAdById: err: %v", err.Error())
			return
		}

		tokens, err := service.notification.GetDeviceToken(model.DeviceToken{
			UserID: ad.UserID,
		})
		if err != nil {
			logrus.Errorf("service requestAdEquipmentClient: Create: Get Token: err: %v", err.Error())
			return
		}

		executor, err := service.userRepo.GetByID(*r.ExecutorID)
		if err != nil {
			logrus.Errorf("service requestAdEquipmentClient: Create: Get Executor Info: err: %v", err.Error())
			return
		}

		err = service.messageClient.Send(context.Background(), model.Notification{
			DeviceTokens: tokens,
			Message:      fmt.Sprintf("%s %s отправил заявку %s", executor.FirstName, executor.LastName, ad.Title),
			Tittle:       "Вам пришла заявка",
			Data: map[string]string{
				"date": time.Now().String(),
				"type": model.NotificationTypeEQClient,
				"id":   strconv.Itoa(id),
			},
		})
		if err != nil {
			logrus.Errorf("service requestAdEquipmentClient: Create: Send Not: err: %v", err.Error())
			return
		}
	}()

	return nil
}

func (service *requestAdEquipmentClient) ApproveByID(ctx context.Context, id int, approvedBy model.User) error {
	r, err := service.requestAdEquipmentClientRepo.GetByID(ctx, id)
	if err != nil {
		return fmt.Errorf("service requestAdEquipmentClient: ApproveByID: GetByID: %w", err)
	}

	if r.Status != model.STATUS_CREATED {
		return fmt.Errorf("service requestAdEquipmentClient: ApproveByID: check status request: %w", model.ErrInvalidStatus)
	} else {
		r.Status = model.STATUS_APPROVED
	}

	err = service.requestAdEquipmentClientRepo.Update(ctx, r)
	if err != nil {
		return fmt.Errorf("service requestAdEquipmentClient: ApproveByID: Update: %w", err)
	}

	service.requestExecutionService.Create(ctx, model.RequestExecution{
		Src:                        model.TypeRequestEqClient,
		AssignTo:                   r.ExecutorID,
		RequestAdEquipmentClientID: &r.ID,
		DriverID:                   &r.UserID,
		ClinetID:                   &r.AdEquipmentClient.UserID,
		Documents:                  r.AdEquipmentClient.Documents,
		Title:                      r.AdEquipmentClient.Title,
		FinishAddress:              &r.AdEquipmentClient.Address,
		FinishLatitude:             r.AdEquipmentClient.Latitude,
		FinishLongitude:            r.AdEquipmentClient.Longitude,
		StartLeaseAt:               r.AdEquipmentClient.StartLeaseAt,
		EndLeaseAt:                 r.AdEquipmentClient.EndLeaseAt,
	})

	go func() {
		tokens, err := service.notification.GetDeviceToken(model.DeviceToken{
			UserID: r.UserID,
		})
		if err != nil {
			logrus.Errorf("service requestAdEquipmentClient: ApproveByID: Get Token: err: %v", err.Error())
			return
		}

		err = service.messageClient.Send(context.Background(), model.Notification{
			DeviceTokens: tokens,
			Message:      fmt.Sprintf("%s %s подтвердил заявку %s", approvedBy.FirstName, approvedBy.LastName, r.AdEquipmentClient.Title),
			Tittle:       "Вам пришла заявка",
			Data: map[string]string{
				"date":       time.Now().String(),
				"type":       model.NotificationTypeEQClient,
				"id":         strconv.Itoa(r.ID),
				"wasApprove": "true",
			},
		})
		if err != nil {
			logrus.Errorf("service requestAdEquipmentClient: ApproveByID: Send Not: err: %v", err.Error())
			return
		}
	}()

	go func() {
		r.AdEquipmentClient.Status = model.STATUS_FINISHED
		if err = service.adEquipmentClientService.UpdateStatus(ctx, r.AdEquipmentClient); err != nil {
			logrus.Errorf("requestAdServiceClient - ApproveByID - error updating ad service client status - %v", err)
			return
		}
	}()

	return nil
}

func (service *requestAdEquipmentClient) CanceledByID(ctx context.Context, id int) error {
	r, err := service.requestAdEquipmentClientRepo.GetByID(ctx, id)
	if err != nil {
		return fmt.Errorf("service requestAdEquipmentClient: CanceledByID: GetByID: %w", err)
	}

	if r.Status != model.STATUS_CREATED {
		return fmt.Errorf("service requestAdEquipmentClient: CanceledByID: check status request: %w", model.ErrInvalidStatus)
	}

	r.Status = model.STATUS_CANCELED

	err = service.requestAdEquipmentClientRepo.Update(ctx, r)
	if err != nil {
		return fmt.Errorf("service requestAdEquipmentClient: CanceledByID: Update: %w", err)
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

		user, err := service.userRepo.GetByID(r.AdEquipmentClient.UserID)
		if err != nil {
			logrus.Errorf("service requestAdEquipmentClient: ApproveByID: Get User Info: err: %v", err.Error())
			return
		}

		err = service.messageClient.Send(context.Background(), model.Notification{
			DeviceTokens: tokens,
			Message:      fmt.Sprintf("%s %s отменил заявку %s", user.FirstName, user.LastName, r.AdEquipmentClient.Title),
			Tittle:       "Вам пришла заявка",
			Data: map[string]string{
				"date": time.Now().String(),
				"type": model.NotificationTypeEQClient,
				"id":   strconv.Itoa(r.ID),
			},
		})
		if err != nil {
			logrus.Errorf("service requestAdEquipmentClient: ApproveByID: Send Not: err: %v", err.Error())
			return
		}
	}()

	return nil
}

func (service *requestAdEquipmentClient) GetHistoryByID(ctx context.Context, f model.FilterRequestAdEquipmentClient) ([]model.RequestAdEquipmentClient, int, error) {
	res, total, err := service.requestAdEquipmentClientRepo.GetHistoryByID(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service requestAdEquipmentClient: GetHistoryByID: %w", err)
	}

	return res, total, nil
}

func (service *requestAdEquipmentClient) UpdateExecutorID(ctx context.Context, r model.RequestAdEquipmentClient) error {
	rDB, err := service.requestAdEquipmentClientRepo.GetByID(ctx, r.ID)
	if err != nil {
		return fmt.Errorf("service requestAdEquipmentClient: CanceledByID: GetByID: %w", err)
	}

	if r.Status != model.STATUS_CREATED {
		return fmt.Errorf("service requestAdEquipmentClient: CanceledByID: check status request: %w", model.ErrInvalidStatus)
	} else {
		rDB.ExecutorID = r.ExecutorID
	}

	err = service.requestAdEquipmentClientRepo.Update(ctx, rDB)
	if err != nil {
		return fmt.Errorf("service requestAdEquipmentClient: UpdateExecutorID: %w", err)
	}

	return nil
}
