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

type IRequestAdConstructionMaterial interface {
	Get(ctx context.Context, f model.FilterRequestAdConstructionMaterial) ([]model.RequestAdConstructionMaterial, int, error)
	GetByID(ctx context.Context, id int) (model.RequestAdConstructionMaterial, error)
	GetHistoryByID(ctx context.Context, f model.FilterRequestAdConstructionMaterial) ([]model.RequestAdConstructionMaterial, int, error)
	Create(ctx context.Context, r model.RequestAdConstructionMaterial) error
	ApproveByID(ctx context.Context, id int, executorID *int) error
	CanceledByID(ctx context.Context, id int) error
	UpdateExecutorID(ctx context.Context, r model.RequestAdConstructionMaterial) error
}

type requestAdConstructionMaterial struct {
	requestAdConstructionMaterialRepo repository.IRequestAdConstructionMaterial
	remotes                           client.DocumentsRemote
	requestExecutionService           IRequestExecution
	adConstructionMaterialService     IAdConstructionMaterial
	notification                      repository.INotification
	messageClient                     client.NotificationClient
	userRepo                          repository.IUser
}

func NewRequestAdConstructionMaterial(
	requestAdConstructionMaterialRepo repository.IRequestAdConstructionMaterial,
	remotes client.DocumentsRemote,
	requestExecutionService IRequestExecution,
	adConstructionMaterialService IAdConstructionMaterial,
	notification repository.INotification,
	messageClient client.NotificationClient,
	userRepo repository.IUser,
) IRequestAdConstructionMaterial {
	return &requestAdConstructionMaterial{
		requestAdConstructionMaterialRepo: requestAdConstructionMaterialRepo,
		remotes:                           remotes,
		requestExecutionService:           requestExecutionService,
		adConstructionMaterialService:     adConstructionMaterialService,
		notification:                      notification,
		messageClient:                     messageClient,
		userRepo:                          userRepo,
	}
}

func (service *requestAdConstructionMaterial) Get(ctx context.Context, f model.FilterRequestAdConstructionMaterial) ([]model.RequestAdConstructionMaterial, int, error) {
	res, total, err := service.requestAdConstructionMaterialRepo.Get(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service requestAdConstructionMaterial: Get: %w", err)
	}

	for i, v := range res {
		res[i].UrlDocument = make([]string, 0, len(v.Document))
		for _, d := range v.Document {
			d, err = service.remotes.Share(ctx, d, time.Hour*1)
			if err != nil {
				return res, 0, fmt.Errorf("service requestAdConstructionMaterial: GetBy: get document: id_doc: %d: %w", v.ID, err)
			}
			res[i].UrlDocument = append(res[i].UrlDocument, d.ShareLink)
		}
	}

	return res, total, nil
}

func (service *requestAdConstructionMaterial) GetByID(ctx context.Context, id int) (model.RequestAdConstructionMaterial, error) {
	res, err := service.requestAdConstructionMaterialRepo.GetByID(ctx, id)
	if err != nil {
		return res, fmt.Errorf("service requestAdConstructionMaterial: GetByID: %w", err)
	}

	res.AdConstructionMaterial.UrlDocument = make([]string, 0, len(res.AdConstructionMaterial.Documents))
	for _, d := range res.AdConstructionMaterial.Documents {
		d, err = service.remotes.Share(ctx, d, time.Hour*1)
		if err != nil {
			return res, fmt.Errorf("service requestAdConstructionMaterial: GetBy: get document AdConstructionMaterial: id_doc: %d: %w", res.ID, err)
		}
		res.AdConstructionMaterial.UrlDocument = append(res.AdConstructionMaterial.UrlDocument, d.ShareLink)
	}

	res.UrlDocument = make([]string, 0, len(res.Document))
	for _, d := range res.Document {
		d, err = service.remotes.Share(ctx, d, time.Hour*1)
		if err != nil {
			return res, fmt.Errorf("service requestAdConstructionMaterial: GetBy: get document: id_doc: %d: %w", res.ID, err)
		}
		res.UrlDocument = append(res.UrlDocument, d.ShareLink)
	}

	return res, nil
}

func (service *requestAdConstructionMaterial) Create(ctx context.Context, r model.RequestAdConstructionMaterial) error {
	r.Status = model.STATUS_CREATED

	ad, err := service.adConstructionMaterialService.GetByID(ctx, r.AdConstructionMaterialID)
	if err != nil {
		return fmt.Errorf("service requestAdConstructionMaterial: GetByID Ad: %w", err)
	}

	if r.ExecutorID == nil {
		r.ExecutorID = &ad.UserID
	}

	id, err := service.requestAdConstructionMaterialRepo.Create(ctx, r)
	if err != nil {
		return fmt.Errorf("service requestAdConstructionMaterial: Create: %w", err)
	}

	for i, d := range r.Document {
		_, err := service.remotes.Upload(ctx, r.Document[i])
		if err != nil {
			return fmt.Errorf("service requestAdConstructionMaterial: Create: Upload Document: documne title \"%v\": %v", d.Title, err.Error())
		}
	}

	go func() {
		tokens, err := service.notification.GetDeviceToken(model.DeviceToken{
			UserID: ad.UserID,
		})
		if err != nil {
			logrus.Errorf("service requestAdConstructionMaterial: Create: Get Token: err: %v", err.Error())
			return
		}

		//user, err := service.userRepo.GetByID(ad.UserID)
		//if err != nil {
		//	logrus.Errorf("service requestAdConstructionMaterial: Create: Get User Info: err: %v", err.Error())
		//	return
		//}

		r, _ = service.requestAdConstructionMaterialRepo.GetByID(ctx, r.ID)

		err = service.messageClient.Send(context.Background(), model.Notification{
			DeviceTokens: tokens,
			Message:      fmt.Sprintf("%s %s отправил заявку %s", r.User.FirstName, r.User.LastName, ad.Title),
			Tittle:       "Вам пришла заявка",
			Data: map[string]string{
				"date": time.Now().String(),
				"type": model.NotificationTypeCM,
				"id":   strconv.Itoa(id),
			},
		})
		if err != nil {
			logrus.Errorf("service requestAdConstructionMaterial: Create: Send Not: err: %v", err.Error())
			return
		}
	}()

	return nil
}

func (service *requestAdConstructionMaterial) ApproveByID(ctx context.Context, id int, executorID *int) error {
	r, err := service.requestAdConstructionMaterialRepo.GetByID(ctx, id)
	if err != nil {
		return fmt.Errorf("service requestAdConstructionMaterial: ApproveByID: GetByID: %w", err)
	}

	if r.Status != model.STATUS_CREATED {
		return fmt.Errorf("service requestAdConstructionMaterial: ApproveByID: check status request: %w", model.ErrInvalidStatus)
	} else {
		r.Status = model.STATUS_APPROVED
	}

	err = service.requestAdConstructionMaterialRepo.Update(ctx, r)
	if err != nil {
		return fmt.Errorf("service requestAdConstructionMaterial: ApproveByID: UpdateStatus: %w", err)
	}

	_, err = service.requestExecutionService.Create(ctx, model.RequestExecution{
		Src:                             model.TypeRequestCM,
		AssignTo:                        executorID,
		RequestAdConstructionMaterialID: &r.ID,
		ClinetID:                        &r.UserID,
		DriverID:                        &r.AdConstructionMaterial.UserID,
		Documents:                       r.Document,
		Title:                           r.Description,
		FinishAddress:                   &r.Address,
		FinishLatitude:                  r.Latitude,
		FinishLongitude:                 r.Longitude,
		StartLeaseAt:                    r.StartLeaseAt,
		EndLeaseAt:                      r.EndLeaseAt,
	})
	if err != nil {
		return fmt.Errorf("service requestAdConstructionMaterial: ApproveByID: Create Execution: %w", err)
	}

	go func() {
		tokens, err := service.notification.GetDeviceToken(model.DeviceToken{
			UserID: r.UserID,
		})
		if err != nil {
			logrus.Errorf("service requestAdConstructionMaterial: ApproveByID: Get Token: err: %v", err.Error())
			return
		}

		executor, err := service.userRepo.GetByID(*executorID)
		if err != nil {
			logrus.Errorf("service requestAdConstructionMaterial: ApproveByID: Get User Info: err: %v", err.Error())
			return
		}

		err = service.messageClient.Send(context.Background(), model.Notification{
			DeviceTokens: tokens,
			Message:      fmt.Sprintf("%s %s подтвердил заявку %s", executor.FirstName, executor.LastName, r.AdConstructionMaterial.Title),
			Tittle:       "Вам пришла заявка",
			Data: map[string]string{
				"date":       time.Now().String(),
				"type":       model.NotificationTypeCM,
				"id":         strconv.Itoa(r.ID),
				"wasApprove": "true",
			},
		})
		if err != nil {
			logrus.Errorf("service requestAdConstructionMaterial: ApproveByID: Send Not: err: %v", err.Error())
			return
		}
	}()

	return nil
}

func (service *requestAdConstructionMaterial) CanceledByID(ctx context.Context, id int) error {
	r, err := service.requestAdConstructionMaterialRepo.GetByID(ctx, id)
	if err != nil {
		return fmt.Errorf("service requestAdConstructionMaterial: CanceledByID: GetByID: %w", err)
	}

	if r.Status != model.STATUS_CREATED {
		return fmt.Errorf("service requestAdConstructionMaterial: CanceledByID: check status request: %w", model.ErrInvalidStatus)
	}

	r.Status = model.STATUS_CANCELED

	err = service.requestAdConstructionMaterialRepo.Update(ctx, r)
	if err != nil {
		return fmt.Errorf("service requestAdConstructionMaterial: CanceledByID: UpdateStatus: %w", err)
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
			Message:      fmt.Sprintf("%s %s отменил заявку %s", r.Executor.FirstName, r.Executor.LastName, r.AdConstructionMaterial.Title),
			Tittle:       "Вам пришла заявка",
			Data: map[string]string{
				"date": time.Now().String(),
				"type": model.NotificationTypeCM,
				"id":   strconv.Itoa(r.ID),
			},
		})
		if err != nil {
			logrus.Errorf("service requestAdConstructionMaterial: ApproveByID: Send Not: err: %v", err.Error())
			return
		}
	}()

	return nil
}

func (service *requestAdConstructionMaterial) GetHistoryByID(ctx context.Context, f model.FilterRequestAdConstructionMaterial) ([]model.RequestAdConstructionMaterial, int, error) {
	res, total, err := service.requestAdConstructionMaterialRepo.GetHistoryByID(ctx, f)
	if err != nil {
		return nil, 0, fmt.Errorf("service requestAdConstructionMaterial: GetHistoryByID: %w", err)
	}

	return res, total, nil
}

func (service *requestAdConstructionMaterial) UpdateExecutorID(ctx context.Context, r model.RequestAdConstructionMaterial) error {
	rDB, err := service.requestAdConstructionMaterialRepo.GetByID(ctx, r.ID)
	if err != nil {
		return fmt.Errorf("service requestAdConstructionMaterial: CanceledByID: GetByID: %w", err)
	}

	if r.Status != model.STATUS_CREATED {
		return fmt.Errorf("service requestAdConstructionMaterial: CanceledByID: check status request: %w", model.ErrInvalidStatus)
	} else {
		rDB.ExecutorID = r.ExecutorID
	}

	err = service.requestAdConstructionMaterialRepo.Update(ctx, rDB)
	if err != nil {
		return fmt.Errorf("service requestAdConstructionMaterial: UpdateExecutorID: %w", err)
	}

	return nil
}
