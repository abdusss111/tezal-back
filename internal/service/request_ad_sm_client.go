package service

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"strconv"
	"sync"
	"time"

	"github.com/sirupsen/logrus"
	"gitlab.com/eqshare/eqshare-back/internal/client"
	"gorm.io/gorm"

	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IRequest interface {
	Get(f model.FilterRequest) ([]model.Request, int, error)
	GetByID(id int) (model.Request, error)
	Create(ctx context.Context, rc model.Request) (model.Request, error)
	Approve(ctx context.Context, rc model.Request) error
	Canceled(ctx context.Context, id int) error
	ForceApprove(ctx context.Context, fr model.ForceRequest) error
	AssignTo(ctx context.Context, id int, workerID int) error
	GetHistoryByID(id int) ([]model.Request, error)
}

type request struct {
	repo          repository.IRequest
	reService     requestExecution
	adRepo        repository.IAdClient
	messageClient client.NotificationClient
	notification  repository.INotification
	repoUsers     repository.IUser
	repoLogs      repository.IAdminLogsRepository
	remote        client.DocumentsRemote
}

func NewRequestService(repo repository.IRequest,
	reService requestExecution,
	adRepo repository.IAdClient,
	messageClient client.NotificationClient,
	notification repository.INotification,
	repoUsers repository.IUser,
	repoLogs repository.IAdminLogsRepository,
	remote client.DocumentsRemote) *request {
	return &request{
		repo:          repo,
		reService:     reService,
		adRepo:        adRepo,
		messageClient: messageClient,
		notification:  notification,
		repoUsers:     repoUsers,
		repoLogs:      repoLogs,
		remote:        remote,
	}
}

func (r *request) Get(f model.FilterRequest) ([]model.Request, int, error) {
	rs, count, err := r.repo.Get(f)
	if err != nil {
		return nil, 0, err
	}

	uniq := make(map[int]model.AdClient)

	for _, r2 := range rs {
		uniq[r2.AdClientID] = model.AdClient{}
	}

	adIDs := make([]int, 0, len(uniq))

	for k := range uniq {
		adIDs = append(adIDs, k)
	}

	if len(adIDs) == 0 {
		return nil, 0, nil
	}

	ads, _, err := r.adRepo.GetList(model.FilterAdClient{
		ID: adIDs,
	})
	if err != nil {
		return nil, 0, err
	}

	for i, ac := range ads {
		if len(ac.Documents) != 0 {
			doc, err := r.remote.Share(context.TODO(), ac.Documents[0], time.Hour)
			if err != nil {
				return nil, 0, err
			}
			ads[i].Documents[0] = doc
		}
		uniq[ac.ID] = ads[i]
	}

	for i := range rs {
		rs[i].AdClient = uniq[rs[i].AdClientID]
	}

	return rs, count, nil
}

func (r *request) GetByID(id int) (model.Request, error) {
	re, err := r.repo.GetByID(id)
	if err != nil {
		return model.Request{}, err
	}

	for i, d := range re.AdClient.Documents {
		re.AdClient.Documents[i], err = r.remote.Share(context.TODO(), d, time.Hour)
		if err != nil {
			return model.Request{}, err
		}
	}

	return re, nil
}

func (r *request) Create(ctx context.Context, rc model.Request) (req model.Request, err error) {
	ad, err := r.adRepo.GetByID(model.AdClient{ID: rc.AdClientID})
	if err != nil {
		return req, err
	}

	rc.Status = model.STATUS_CREATED
	if req.ID, err = r.repo.Create(rc); err != nil {
		return req, err
	}

	tokens, err := r.notification.GetDeviceToken(model.DeviceToken{
		UserID: ad.UserID,
	})
	if err != nil {
		return req, err
	}

	user, err := r.repoUsers.GetByID(rc.UserID)
	if err != nil {
		return req, err
	}

	go func() {
		r.messageClient.Send(context.Background(), model.Notification{
			DeviceTokens: tokens,
			Message:      fmt.Sprintf("%s %s отправил заказ на объявление %s", user.FirstName, user.LastName, ad.Headline),
			Tittle:       "Водитель отправил вам заказ на объявление",
			Data: map[string]string{
				"date": time.Now().String(),
				"type": model.NotificationTypeSMClient,
				"id":   strconv.Itoa(req.ID),
			},
		})
	}()

	return req, nil
}

func (r *request) Approve(ctx context.Context, rc model.Request) error {
	usedID := rc.UserID
	rc, err := r.repo.GetByID(rc.ID)
	if err != nil {
		return err
	}

	if rc.Status != model.STATUS_CREATED {
		return model.ErrInvalidStatus
	}

	rc.Status = model.STATUS_APPROVED

	wg := sync.WaitGroup{}

	ctx, cancel := context.WithCancel(ctx)
	defer cancel()

	chErr := make(chan error, 3)

	wg.Add(4)

	go func() {
		defer wg.Done()
		if err := r.repo.Update(ctx, rc); err != nil {
			chErr <- err
			return
		}
	}()

	go func() {
		defer wg.Done()
		if _, err := r.reService.Create(context.Background(), model.RequestExecution{
			Src:             model.TypeRequestSMClient,
			RequestID:       &rc.ID,
			AssignTo:        rc.Assigned,
			DriverID:        &rc.UserID,
			ClinetID:        &rc.AdClient.UserID,
			Documents:       rc.AdClient.Documents,
			Title:           rc.AdClient.Headline,
			FinishAddress:   &rc.AdClient.Address,
			FinishLatitude:  rc.AdClient.Latitude,
			FinishLongitude: rc.AdClient.Longitude,
			StartLeaseAt:    model.Time{NullTime: sql.NullTime{Time: rc.AdClient.StartDate, Valid: true}},
			EndLeaseAt:      rc.AdClient.EndDate,
		}); err != nil {
			chErr <- err
			return
		}
	}()

	// go func() {
	// 	defer wg.Done()
	// 	if err := r.adRepo.Delete(ctx, model.AdClient{ID: rc.AdClientID}); err != nil {
	// 		chErr <- err
	// 		return
	// 	}
	// }()

	go func() {
		defer wg.Done()
		if err := r.adRepo.Update(model.AdClient{ID: rc.AdClientID, Status: model.STATUS_FINISHED}); err != nil {
			chErr <- err
			return
		}
	}()

	go func() {
		defer wg.Done()
		if err := r.repo.DeleteByAdClientID(rc.AdClientID); err != nil {
			chErr <- err
			return
		}
	}()

	wg.Wait()

	close(chErr)

	for err2 := range chErr {
		return err2
	}

	tokens, err := r.notification.GetDeviceToken(model.DeviceToken{
		UserID: rc.UserID,
	})
	if err != nil {
		return err
	}

	user, err := r.repoUsers.GetByID(usedID)
	if err != nil {
		return err
	}

	ad, err := r.adRepo.GetByID(model.AdClient{ID: rc.AdClientID})
	if err != nil {
		return err
	}

	go func() {
		r.messageClient.Send(context.Background(), model.Notification{
			DeviceTokens: tokens,
			Message:      fmt.Sprintf("%s %s принял заказ на объявление %v", user.FirstName, user.LastName, ad.Headline),
			Tittle:       "Клиент принял заказ на объявление",
			Data: map[string]string{
				"date":       time.Now().String(),
				"type":       model.NotificationTypeSMClient,
				"id":         strconv.Itoa(rc.ID),
				"wasApprove": "true",
			},
		})
	}()

	author, err := r.repoUsers.GetByID(rc.UserID)
	if err != nil {
		return err
	}

	logs := model.Logs{
		Text:        "создание запроса клиента о работе на статус APPROVE...",
		Author:      fmt.Sprintf("%v %v %v", author.FirstName, author.LastName, author.PhoneNumber),
		Description: fmt.Sprintf("%v", rc),
	}

	return r.repoLogs.CreateLogs(logs)
}

func (r *request) Canceled(ctx context.Context, id int) error {
	rc, err := r.repo.GetByID(id)
	if err != nil {
		return err
	}

	if rc.Status != model.STATUS_CREATED {
		return model.ErrInvalidStatus
	}

	rc.Status = model.STATUS_CANCELED

	author, err := r.repoUsers.GetByID(rc.UserID)
	if err != nil {
		return err
	}

	if err = r.repo.Update(ctx, rc); err != nil {
		return err
	}

	go func() {
		err := r.repoLogs.CreateLogs(model.Logs{
			Text:        "создание запроса клиента о работе на статус CANCELED...",
			Author:      fmt.Sprintf("%v %v %v", author.FirstName, author.LastName, author.PhoneNumber),
			Description: fmt.Sprintf("%v", rc),
		})
		if err != nil {
			logrus.Fatal(err)
		}
	}()

	go func(rc model.Request) {
		userIds := make([]int, 0, 2)
		if rc.UserID != 0 {
			userIds = append(userIds, rc.UserID)
		}
		if rc.Assigned != nil && *rc.Assigned != 0 {
			userIds = append(userIds, *rc.Assigned)
		}
		tokens, err := r.notification.GetDeviceToken(model.DeviceToken{
			UserID: rc.UserID,
		})
		if err != nil {
			logrus.Error(err)
			return
		}

		err = r.messageClient.Send(context.Background(), model.Notification{
			DeviceTokens: tokens,
			Tittle:       "Клиент отклонил заказ на объявление",
			Message:      fmt.Sprintf("%s %s отклонил заказ на объявление %v", rc.User.FirstName, rc.User.LastName, rc.AdClient.Headline),
			Data: map[string]string{
				"date": time.Now().String(),
				"type": model.NotificationTypeSMClient,
				"id":   strconv.Itoa(rc.ID),
			},
		})
		if err != nil {
			logrus.Error(err)
		}
	}(rc)

	return nil
}

func (r *request) ForceApprove(ctx context.Context, fr model.ForceRequest) error {
	id, err := r.repo.Create(model.Request{
		AdClientID: fr.AdClientID,
		UserID:     fr.UserID,
		Status:     model.STATUS_APPROVED,
	})
	if err != nil {
		return err
	}

	ad, err := r.adRepo.GetByID(model.AdClient{ID: fr.AdClientID})
	if err != nil {
		return fmt.Errorf("service request: ForceApprove: get ad: %w", err)
	}

	wg := sync.WaitGroup{}
	ctx, cancel := context.WithCancel(ctx)
	defer cancel()
	chErr := make(chan error, 2)

	wg.Add(2)

	go func() {
		defer wg.Done()
		if _, err := r.reService.Create(context.Background(), model.RequestExecution{
			Src:             model.TypeRequestSMClient,
			RequestID:       &id,
			AssignTo:        &fr.UserID,
			DriverID:        &fr.UserID,
			ClinetID:        &ad.UserID,
			Documents:       ad.Documents,
			Title:           ad.Headline,
			FinishAddress:   &ad.Address,
			FinishLatitude:  ad.Latitude,
			FinishLongitude: ad.Longitude,
			StartLeaseAt:    model.Time{NullTime: sql.NullTime{Time: ad.StartDate, Valid: true}},
			EndLeaseAt:      ad.EndDate,
		}); err != nil {
			chErr <- err
			return
		}
	}()

	go func() {
		defer wg.Done()
		if err := r.adRepo.Delete(ctx, model.AdClient{ID: fr.AdClientID}); err != nil {
			chErr <- err
			return
		}
	}()

	wg.Wait()

	close(chErr)

	for err2 := range chErr {
		return err2
	}

	author, err := r.repoUsers.GetByID(fr.UserID)
	if err != nil {
		return err
	}

	logs := model.Logs{
		Text:   "создание запроса клиента о работе на статус FORCE_APPROVE...",
		Author: fmt.Sprintf("%v %v %v", author.FirstName, author.LastName, author.PhoneNumber),
		Description: fmt.Sprintf("%v", model.Request{
			AdClientID: fr.AdClientID,
			UserID:     fr.UserID,
			Status:     model.STATUS_APPROVED,
		}),
	}

	go func() {
		r.SendClientMessage(ctx, model.Request{ID: id}, "Водитель подтвердил")
	}()

	return r.repoLogs.CreateLogs(logs)
}

func (r *request) AssignTo(ctx context.Context, id int, workerID int) error {
	clientReqOld, err := r.repo.GetByID(id)
	if err != nil {
		return fmt.Errorf("owner approve and assign to error: %w", err)
	}

	if clientReqOld.Status == model.STATUS_CANCELED || clientReqOld.Status == model.STATUS_APPROVED {
		return model.ErrInvalidStatus
	}

	clientReqOld.Status = model.STATUS_CREATED
	clientReqOld.Assigned = &workerID

	return r.repo.Update(ctx, clientReqOld)
}

func (r *request) SendClientMessage(ctx context.Context, cl model.Request, message string) error {
	adClientUser, err := r.adRepo.GetByID(model.AdClient{ID: cl.AdClientID})
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil
		}
		return err
	}

	tokens, err := r.notification.GetDeviceToken(model.DeviceToken{
		UserID: adClientUser.UserID,
	})
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil
		}
		return err
	}

	go func() {
		r.messageClient.Send(context.Background(), model.Notification{
			DeviceTokens: tokens,
			Message:      message,
			Tittle:       message,
		})
	}()

	return nil
}

func (r *request) GetHistoryByID(id int) ([]model.Request, error) {
	return r.repo.GetHistoryByID(id)
}
