package service

import (
	"context"
	"fmt"
	"log"
	"strconv"
	"time"

	"github.com/sirupsen/logrus"
	"gitlab.com/eqshare/eqshare-back/internal/client"
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IRequestAdConstructionMaterialClient interface {
	Get(ctx context.Context, f model.FilterRequestAdConstructionMaterialClient) ([]model.RequestAdConstructionMaterialClient, int, error)
	GetByID(ctx context.Context, id int) (model.RequestAdConstructionMaterialClient, error)
	GetHistoryByID(ctx context.Context, f model.FilterRequestAdConstructionMaterialClient) ([]model.RequestAdConstructionMaterialClient, int, error)
	Create(ctx context.Context, r model.RequestAdConstructionMaterialClient) error
	ApproveByID(ctx context.Context, id int, approvedBy model.User) error
	CanceledByID(ctx context.Context, id int) error
	UpdateExecutorID(ctx context.Context, r model.RequestAdConstructionMaterialClient) error
}

type requestAdConstructionMaterialClient struct {
	requestAdConstructionMaterialClientRepo repository.IRequestAdConstructionMaterialClient
	adConstructionMaterialClientService     IAdConstructionMaterialClient
	remotes                                 client.DocumentsRemote
	requestExecutionService                 IRequestExecution
	notification                            repository.INotification
	messageClient                           client.NotificationClient
	userRepo                                repository.IUser
}

func NewRequestAdConstructionMaterialClient(
	requestAdConstructionMaterialClientRepo repository.IRequestAdConstructionMaterialClient,
	remotes client.DocumentsRemote,
	requestExecutionService IRequestExecution,
	adConstructionMaterialClientService IAdConstructionMaterialClient,
	notification repository.INotification,
	messageClient client.NotificationClient,
	userRepo repository.IUser,
) IRequestAdConstructionMaterialClient {
	return &requestAdConstructionMaterialClient{
		requestAdConstructionMaterialClientRepo: requestAdConstructionMaterialClientRepo,
		remotes:                                 remotes,
		requestExecutionService:                 requestExecutionService,
		adConstructionMaterialClientService:     adConstructionMaterialClientService,
		notification:                            notification,
		messageClient:                           messageClient,
		userRepo:                                userRepo,
	}
}

func (service *requestAdConstructionMaterialClient) Get(ctx context.Context, f model.FilterRequestAdConstructionMaterialClient) ([]model.RequestAdConstructionMaterialClient, int, error) {
	res, total, err := service.requestAdConstructionMaterialClientRepo.Get(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service requestAdConstructionMaterialClient: Get: %w", err)
	}

	for i, v := range res {
		res[i].AdConstructionMaterialClient.UrlDocument = make([]string, 0, len(res[i].AdConstructionMaterialClient.UrlDocument))
		for _, d := range v.AdConstructionMaterialClient.Documents {
			d, err = service.remotes.Share(ctx, d, time.Hour*1)
			if err != nil {
				return res, 0, fmt.Errorf("service requestAdConstructionMaterialClient: GetBy: get document: id_doc: %d: %w", v.ID, err)
			}
			res[i].AdConstructionMaterialClient.UrlDocument = append(res[i].AdConstructionMaterialClient.UrlDocument, d.ShareLink)
		}
	}

	return res, total, nil
}

func (service *requestAdConstructionMaterialClient) GetByID(ctx context.Context, id int) (model.RequestAdConstructionMaterialClient, error) {
	res, err := service.requestAdConstructionMaterialClientRepo.GetByID(ctx, id)
	if err != nil {
		return res, fmt.Errorf("service requestAdConstructionMaterialClient: GetByID: %w", err)
	}

	res.AdConstructionMaterialClient.UrlDocument = make([]string, 0, len(res.AdConstructionMaterialClient.Documents))
	for _, d := range res.AdConstructionMaterialClient.Documents {
		d, err = service.remotes.Share(ctx, d, time.Hour*1)
		if err != nil {
			return res, fmt.Errorf("service requestAdConstructionMaterial: GetBy: get document: id_doc: %d: %w", res.AdConstructionMaterialClient.ID, err)
		}
		res.AdConstructionMaterialClient.UrlDocument = append(res.AdConstructionMaterialClient.UrlDocument, d.ShareLink)
	}

	return res, nil
}

func (service *requestAdConstructionMaterialClient) Create(ctx context.Context, r model.RequestAdConstructionMaterialClient) error {
	r.Status = model.STATUS_CREATED

	id, err := service.requestAdConstructionMaterialClientRepo.Create(ctx, r)
	if err != nil {
		return fmt.Errorf("service requestAdConstructionMaterialClient: Create: %w", err)
	}

	go func() {
		ad, err := service.adConstructionMaterialClientService.GetByID(context.Background(), r.AdConstructionMaterialClientID)
		if err != nil {
			logrus.Errorf("service requestAdConstructionMaterialClient: Create: GetAdById: err: %v", err.Error())
			return
		}

		tokens, err := service.notification.GetDeviceToken(model.DeviceToken{
			UserID: ad.UserID,
		})
		if err != nil {
			logrus.Errorf("service requestAdConstructionMaterialClient: Create: Get Token: err: %v", err.Error())
			return
		}

		executor, err := service.userRepo.GetByID(*r.ExecutorID)
		if err != nil {
			logrus.Errorf("service requestAdConstructionMaterialClient: Create: Get Executor Info: err: %v", err.Error())
			return
		}

		err = service.messageClient.Send(context.Background(), model.Notification{
			DeviceTokens: tokens,
			Message:      fmt.Sprintf("%s %s отправил заявку %s", executor.FirstName, executor.LastName, ad.Title),
			Tittle:       "Вам пришла заявка",
			Data: map[string]string{
				"date": time.Now().String(),
				"type": model.NotificationTypeCMClient,
				"id":   strconv.Itoa(id),
			},
		})
		if err != nil {
			logrus.Errorf("service requestAdConstructionMaterialClient: Create: Send Not: err: %v", err.Error())
			return
		}
		log.Println(tokens)
		log.Println("Notification Sent")
	}()

	return nil
}

func (service *requestAdConstructionMaterialClient) ApproveByID(ctx context.Context, id int, approvedBy model.User) error {
	r, err := service.requestAdConstructionMaterialClientRepo.GetByID(ctx, id)
	if err != nil {
		return fmt.Errorf("service requestAdConstructionMaterialClient: ApproveByID: GetByID: %w", err)
	}

	if r.Status != model.STATUS_CREATED {
		return fmt.Errorf("service requestAdConstructionMaterialClient: ApproveByID: check status request: %w", model.ErrInvalidStatus)
	} else {
		r.Status = model.STATUS_APPROVED
	}

	err = service.requestAdConstructionMaterialClientRepo.Update(ctx, r)
	if err != nil {
		return fmt.Errorf("service requestAdConstructionMaterialClient: ApproveByID: Update: %w", err)
	}

	_, err = service.requestExecutionService.Create(ctx, model.RequestExecution{
		Src:                                   model.TypeRequestCMClient,
		AssignTo:                              r.ExecutorID,
		RequestAdConstructionMaterialClientID: &r.ID,
		DriverID:                              &r.UserID,
		ClinetID:                              &r.AdConstructionMaterialClient.UserID,
		Documents:                             r.AdConstructionMaterialClient.Documents,
		Title:                                 r.AdConstructionMaterialClient.Title,
		FinishAddress:                         &r.AdConstructionMaterialClient.Address,
		FinishLatitude:                        r.AdConstructionMaterialClient.Latitude,
		FinishLongitude:                       r.AdConstructionMaterialClient.Longitude,
		StartLeaseAt:                          r.AdConstructionMaterialClient.StartLeaseAt,
		EndLeaseAt:                            r.AdConstructionMaterialClient.EndLeaseAt,
	})
	if err != nil {
		return err
	}

	go func() {
		tokens, err := service.notification.GetDeviceToken(model.DeviceToken{
			UserID: r.UserID,
		})
		if err != nil {
			logrus.Errorf("service requestAdConstructionMaterialClient: ApproveByID: Get Token: err: %v", err.Error())
			return
		}

		err = service.messageClient.Send(context.Background(), model.Notification{
			DeviceTokens: tokens,
			Message:      fmt.Sprintf("%s %s подтвердил заявку %s", approvedBy.FirstName, approvedBy.LastName, r.AdConstructionMaterialClient.Title),
			Tittle:       "Вам пришла заявка",
			Data: map[string]string{
				"date":       time.Now().String(),
				"type":       model.NotificationTypeCMClient,
				"id":         strconv.Itoa(r.ID),
				"wasApprove": "true",
			},
		})
		if err != nil {
			logrus.Errorf("service requestAdConstructionMaterialClient: ApproveByID: Send Not: err: %v", err.Error())
			return
		}
	}()

	go func() {
		r.AdConstructionMaterialClient.Status = model.STATUS_FINISHED
		if err = service.adConstructionMaterialClientService.UpdateStatus(ctx, r.AdConstructionMaterialClient); err != nil {
			logrus.Errorf("requestAdServiceClient - ApproveByID - error updating ad service client status - %v", err)
			return
		}
	}()

	return nil
}

func (service *requestAdConstructionMaterialClient) CanceledByID(ctx context.Context, id int) error {
	r, err := service.requestAdConstructionMaterialClientRepo.GetByID(ctx, id)
	if err != nil {
		return fmt.Errorf("service requestAdConstructionMaterialClient: CanceledByID: GetByID: %w", err)
	}

	if r.Status != model.STATUS_CREATED {
		return fmt.Errorf("service requestAdConstructionMaterialClient: CanceledByID: check status request: %w", model.ErrInvalidStatus)
	}

	r.Status = model.STATUS_CANCELED

	err = service.requestAdConstructionMaterialClientRepo.Update(ctx, r)
	if err != nil {
		return fmt.Errorf("service requestAdConstructionMaterialClient: CanceledByID: Update: %w", err)
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

		user, err := service.userRepo.GetByID(r.AdConstructionMaterialClient.UserID)
		if err != nil {
			logrus.Errorf("service requestAdConstructionMaterialClient: ApproveByID: Get User Info: err: %v", err.Error())
			return
		}

		err = service.messageClient.Send(context.Background(), model.Notification{
			DeviceTokens: tokens,
			Message:      fmt.Sprintf("%s %s отменил заявку %s", user.FirstName, user.LastName, r.AdConstructionMaterialClient.Title),
			Tittle:       "Вам пришла заявка",
			Data: map[string]string{
				"date": time.Now().String(),
				"type": model.NotificationTypeCMClient,
				"id":   strconv.Itoa(r.ID),
			},
		})
		if err != nil {
			logrus.Errorf("service requestAdConstructionMaterialClient: ApproveByID: Send Not: err: %v", err.Error())
			return
		}
	}()

	return nil
}

func (service *requestAdConstructionMaterialClient) GetHistoryByID(ctx context.Context, f model.FilterRequestAdConstructionMaterialClient) ([]model.RequestAdConstructionMaterialClient, int, error) {
	res, total, err := service.requestAdConstructionMaterialClientRepo.GetHistoryByID(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service requestAdConstructionMaterialClient: GetHistoryByID: %w", err)
	}

	return res, total, nil
}

func (service *requestAdConstructionMaterialClient) UpdateExecutorID(ctx context.Context, r model.RequestAdConstructionMaterialClient) error {
	rDB, err := service.requestAdConstructionMaterialClientRepo.GetByID(ctx, r.ID)
	if err != nil {
		return fmt.Errorf("service requestAdConstructionMaterialClient: CanceledByID: GetByID: %w", err)
	}

	if r.Status != model.STATUS_CREATED {
		return fmt.Errorf("service requestAdConstructionMaterialClient: CanceledByID: check status request: %w", model.ErrInvalidStatus)
	} else {
		rDB.ExecutorID = r.ExecutorID
	}

	err = service.requestAdConstructionMaterialClientRepo.Update(ctx, rDB)
	if err != nil {
		return fmt.Errorf("service requestAdConstructionMaterialClient: UpdateExecutorID: %w", err)
	}

	return nil
}
