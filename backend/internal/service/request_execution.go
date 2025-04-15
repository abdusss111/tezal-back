package service

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"log"
	"strconv"
	"strings"
	"time"

	"github.com/sirupsen/logrus"
	client2 "gitlab.com/eqshare/eqshare-back/internal/client"
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IRequestExecution interface {
	Create(ctx context.Context, req model.RequestExecution) (int, error)
	Get(f model.FilterRequestExecution) ([]model.RequestExecution, int, error)
	GetDTO(f model.FilterRequestExecution) ([]model.RequestExecutionDTO, int, error)
	GetByID(id int) (model.RequestExecution, error)
	DriverStremCoordinatesByID(ctx context.Context, cord model.RequestExecutionMove) error
	ClientGetStremCoordinatesByID(ctx context.Context, id int) (<-chan model.RequestExecutionMove, error)
	DriverConfirmStartWork(ctx context.Context, id int) error
	ClientConfirmStartWork(ctx context.Context, id int) error
	DriverPauseWork(ctx context.Context, id int) error
	ClientPauseWork(ctx context.Context, id int) error
	DriverFinishWork(ctx context.Context, id int, paymentAmount int) error
	ClientFinishWork(ctx context.Context, id int, paymentAmount int) error
	DriverSetOnRoad(ctx context.Context, id int) error
	Reassign(id int, workerID *int) error
	DriverRate(req model.RequestExecution, rate int) error
	RequestRate(req model.RequestExecution, rate int, comment string) error
	SendMessageToClient(ctx context.Context, re model.RequestExecution, notification2 model.Notification) error
	GetHistoryByID(id int) ([]model.RequestExecution, error)
	HistoryTraveledWay(ctx context.Context, id int) ([]model.Coordinates, error)
	UpdatePostNotificationOnTrue(ctx context.Context, id ...int) error
	Update(ctx context.Context, re model.RequestExecution) error
	UpdateEndLeaseAt(ctx context.Context, id int, EndLeaseAt model.Time) error
	CreateRequestExecutionAssignmentWithoutClinet(ctx context.Context, re model.RequestExecution) error
}

type requestExecution struct {
	repo               repository.IRequestExecution
	smReqRepo          repository.ISpecializedMachineryRequest
	adClientRepo       repository.IAdClient
	userRepo           repository.IUser
	remotes            client2.DocumentsRemote
	repoLogs           repository.IAdminLogsRepository
	messageClient      client2.NotificationClient
	notification       repository.INotification
	repoAdSM           repository.IAdSpecializedMachinery
	requestAdEquipment repository.IRequestAdEquipment
}

func NewRequestExecution(repo repository.IRequestExecution,
	remotes client2.DocumentsRemote,
	messageClient client2.NotificationClient,
	notification repository.INotification,
	driverRepo repository.ISpecializedMachineryRequest,
	repoLogs repository.IAdminLogsRepository,
	repoAdSM repository.IAdSpecializedMachinery,
	adClientRepo repository.IAdClient,
	requestAdEquipment repository.IRequestAdEquipment,
	userRepo repository.IUser) *requestExecution {
	return &requestExecution{
		repo:               repo,
		remotes:            remotes,
		messageClient:      messageClient,
		notification:       notification,
		smReqRepo:          driverRepo,
		repoLogs:           repoLogs,
		repoAdSM:           repoAdSM,
		adClientRepo:       adClientRepo,
		requestAdEquipment: requestAdEquipment,
		userRepo:           userRepo,
	}
}

// (specialized_machinery_request_id IS NOT NULL) OR (request_id IS NOT NULL) OR (request_ad_equipment_client_id IS NOT NULL) OR (request_ad_equipment_id IS NOT NULL)
func (r *requestExecution) Create(ctx context.Context, req model.RequestExecution) (int, error) {
	if req.AssignTo != nil && *req.DriverID == *req.AssignTo {
		req.AssignTo = nil
	}

	req.Status = model.STATUS_AWAITS_START

	logrus.Info(req.Src)

	if req.Src == "MACHINARY" {
		req.Src = "SM"
	}

	logrus.Info(req.Src)

	f := func(s string) bool {
		for _, v := range []string{
			model.TypeRequestSM,
			model.TypeRequestSMClient,
			model.TypeRequestEq,
			model.TypeRequestEqClient,
			model.TypeRequestCM,
			model.TypeRequestCMClient,
			model.TypeRequestSVC,
			model.TypeRequestSVCClient,
		} {
			if v == s {
				return true
			}
		}

		return false
	}

	if !f(req.Src) {
		return 0, fmt.Errorf("service requestExecution: check src: %w", model.ErrInvalidStatus)
	}

	//author, err := r.repoUsers.GetByID(req.UserID)
	//if err != nil {
	//	return 0, err
	//}
	//
	//logs := model.Logs{
	//	Text:        "создание запроса клиента о работе на статус APPROVE...",
	//	Author:      fmt.Sprintf("%v %v %v", author.FirstName, author.LastName, author.PhoneNumber),
	//	Description: fmt.Sprintf("%v", rc),
	//}

	id, err := r.repo.Create(ctx, req)
	if err != nil {
		return 0, fmt.Errorf("service requestExecution: Create: %w", err)
	}

	return id, nil
}

func (r *requestExecution) Get(f model.FilterRequestExecution) ([]model.RequestExecution, int, error) {
	re, count, err := r.repo.Get(f)
	if err != nil {
		return nil, 0, err
	}

	// for i, re2 := range re {
	// 	if re2.RequestID != nil {
	// 		if len(re2.Request.AdClient.Documents) != 0 {
	// 			doc, err := r.remotes.Share(context.TODO(), re2.Request.AdClient.Documents[0], time.Hour)
	// 			if err != nil {
	// 				return nil, 0, err
	// 			}
	// 			re[i].Request.AdClient.Documents[0] = doc
	// 		}
	// 	}

	// 	if re2.SpecializedMachineryRequestID != nil {
	// 		re[i].SpecializedMachineryRequest.UrlDocument = make([]string, 0, len(re[i].SpecializedMachineryRequest.Document))
	// 		for _, d := range re2.SpecializedMachineryRequest.Document {
	// 			t, err := r.remotes.Share(context.TODO(), d, time.Hour)
	// 			if err != nil {
	// 				return nil, 0, err
	// 			}
	// 			re[i].SpecializedMachineryRequest.UrlDocument = append(re[i].SpecializedMachineryRequest.UrlDocument, t.ShareLink)
	// 		}
	// 	}
	// }

	for i, rere := range re {
		re[i].UrlDocument = make([]string, 0, len(rere.Documents))
		for _, d := range rere.Documents {
			d, err := r.remotes.Share(context.TODO(), d, time.Hour*1)
			if err != nil {
				return nil, 0, err
			}
			re[i].UrlDocument = append(re[i].UrlDocument, d.ShareLink)
		}
	}

	return re, count, nil
}

func (r *requestExecution) GetDTO(f model.FilterRequestExecution) ([]model.RequestExecutionDTO, int, error) {
	re, count, err := r.repo.Get(f)
	if err != nil {
		return nil, 0, err
	}

	// for i, re2 := range re {
	// 	if re2.RequestID != nil {
	// 		if len(re2.Request.AdClient.Documents) != 0 {
	// 			doc, err := r.remotes.Share(context.TODO(), re2.Request.AdClient.Documents[0], time.Hour)
	// 			if err != nil {
	// 				return nil, 0, err
	// 			}
	// 			re[i].Request.AdClient.Documents[0] = doc
	// 		}
	// 	}

	// 	if re2.SpecializedMachineryRequestID != nil {
	// 		re[i].SpecializedMachineryRequest.UrlDocument = make([]string, 0, len(re[i].SpecializedMachineryRequest.Document))
	// 		for _, d := range re2.SpecializedMachineryRequest.Document {
	// 			t, err := r.remotes.Share(context.TODO(), d, time.Hour)
	// 			if err != nil {
	// 				return nil, 0, err
	// 			}
	// 			re[i].SpecializedMachineryRequest.UrlDocument = append(re[i].SpecializedMachineryRequest.UrlDocument, t.ShareLink)
	// 		}
	// 	}
	// }

	for i, rere := range re {
		re[i].UrlDocument = make([]string, 0, len(rere.Documents))
		for _, d := range rere.Documents {
			d, err := r.remotes.Share(context.TODO(), d, time.Hour*1)
			if err != nil {
				return nil, 0, err
			}
			re[i].UrlDocument = append(re[i].UrlDocument, d.ShareLink)
		}
	}

	resDTO := make([]model.RequestExecutionDTO, 0, len(re))
	for _, toDto := range re {
		if toDto.Src == model.TypeRequestCM {
			resDTO = append(resDTO, model.RequestExecutionDTO{
				RequestExecution: toDto,
				SubCategoryName:  toDto.RequestAdConstructionMaterial.AdConstructionMaterial.ConstructionMaterialSubCategory.Name,
				Price:            &toDto.RequestAdConstructionMaterial.AdConstructionMaterial.Price,
			})
		} else if toDto.Src == model.TypeRequestCMClient {
			resDTO = append(resDTO, model.RequestExecutionDTO{
				RequestExecution: toDto,
				SubCategoryName:  toDto.RequestAdConstructionMaterialClient.AdConstructionMaterialClient.ConstructionMaterialSubCategory.Name,
				Price:            toDto.RequestAdConstructionMaterialClient.AdConstructionMaterialClient.Price,
			})
		} else if toDto.Src == model.TypeRequestEq {
			resDTO = append(resDTO, model.RequestExecutionDTO{
				RequestExecution: toDto,
				SubCategoryName:  toDto.RequestAdEquipment.AdEquipment.EquipmentSubCategory.Name,
				Price:            &toDto.RequestAdEquipment.AdEquipment.Price,
			})
		} else if toDto.Src == model.TypeRequestEqClient {
			resDTO = append(resDTO, model.RequestExecutionDTO{
				RequestExecution: toDto,
				SubCategoryName:  toDto.RequestAdEquipmentClient.AdEquipmentClient.EquipmentSubCategory.Name,
				Price:            toDto.RequestAdEquipmentClient.AdEquipmentClient.Price,
			})
		} else if toDto.Src == model.TypeRequestSM {
			resDTO = append(resDTO, model.RequestExecutionDTO{
				RequestExecution: toDto,
				SubCategoryName:  toDto.SpecializedMachineryRequest.AdSpecializedMachinery.Type.Name,
				Price:            &toDto.SpecializedMachineryRequest.AdSpecializedMachinery.Price,
			})
		} else if toDto.Src == model.TypeRequestSMClient {
			resDTO = append(resDTO, model.RequestExecutionDTO{
				RequestExecution: toDto,
				SubCategoryName:  toDto.Request.AdClient.Type.Name, //TODO somnitelno, no ok
				Price:            &toDto.Request.AdClient.Price,
			})
		} else if toDto.Src == model.TypeRequestSVC {
			resDTO = append(resDTO, model.RequestExecutionDTO{
				RequestExecution: toDto,
				SubCategoryName:  toDto.RequestAdService.AdService.ServiceSubCategory.Name,
				Price:            &toDto.RequestAdService.AdService.Price,
			})
		} else if toDto.Src == model.TypeRequestSVCClient {
			resDTO = append(resDTO, model.RequestExecutionDTO{
				RequestExecution: toDto,
				SubCategoryName:  toDto.RequestAdServiceClient.AdServiceClient.ServiceSubCategory.Name,
				Price:            toDto.RequestAdServiceClient.AdServiceClient.Price,
			})
		}

	}

	return resDTO, count, nil
}

func (r *requestExecution) GetByID(id int) (model.RequestExecution, error) {
	res, err := r.repo.GetByID(id)
	if err != nil {
		return model.RequestExecution{}, fmt.Errorf("service requestExecution: GetByID: err: %w", err)
	}

	f := func(dosc []model.Document) ([]string, error) {
		if len(dosc) == 0 {
			return nil, nil
		}
		res := make([]string, 0, len(dosc))
		for _, d := range dosc {
			d, err := r.remotes.Share(context.Background(), d, time.Hour*1)
			if err != nil {
				return nil, err
			}
			res = append(res, d.ShareLink)
		}
		return res, nil
	}

	res.SpecializedMachineryRequest.UrlDocument, err = f(res.SpecializedMachineryRequest.Document)
	if err != nil {
		return model.RequestExecution{}, err
	}

	res.SpecializedMachineryRequest.AdSpecializedMachinery.UrlDocument, err = f(res.SpecializedMachineryRequest.AdSpecializedMachinery.Document)
	if err != nil {
		return model.RequestExecution{}, err
	}

	res.Request.AdClient.UrlDocuments, err = f(res.Request.AdClient.Documents)
	if err != nil {
		return model.RequestExecution{}, err
	}

	res.RequestAdEquipment.UrlDocument, err = f(res.RequestAdEquipment.Document)
	if err != nil {
		return model.RequestExecution{}, err
	}

	res.RequestAdEquipment.AdEquipment.UrlDocument, err = f(res.RequestAdEquipment.AdEquipment.Documents)
	if err != nil {
		return model.RequestExecution{}, err
	}

	res.RequestAdEquipmentClient.AdEquipmentClient.UrlDocument, err = f(res.RequestAdEquipmentClient.AdEquipmentClient.Documents)
	if err != nil {
		return model.RequestExecution{}, err
	}

	res.UrlDocument, err = f(res.Documents)
	if err != nil {
		return model.RequestExecution{}, err
	}

	return res, nil
}

func (r *requestExecution) DriverStremCoordinatesByID(ctx context.Context, c model.RequestExecutionMove) error {
	return r.repo.CreateCordinate(ctx, c)
}

func (r *requestExecution) ClientGetStremCoordinatesByID(ctx context.Context, id int) (<-chan model.RequestExecutionMove, error) {
	// возврашает канал (chan) который транслирует кординаты человека
	// // может вызывать только работу которую началось
	c := make(chan model.RequestExecutionMove)
	limitCord := 1
	desc := true

	go func() {
		for {
			coor, err := r.repo.GetCordinateByID(ctx, id, model.FilterRequestExecutionMove{
				DescCreatedAt: &desc,
				Limit:         &limitCord,
			})
			// GetCoordinateByID(ctx, id)
			if err != nil {
				close(c)
				return
			}
			if len(coor) == 0 {
				time.Sleep(time.Second * 3)
				continue
			}

			select {
			case <-ctx.Done():
				close(c)
				logrus.Error(ctx.Err())
				return
			case c <- coor[0]:
			}
		}
	}()

	return c, nil
}

func (r *requestExecution) DriverConfirmStartWork(ctx context.Context, id int) error {
	re, err := r.repo.GetByID(id)
	if err != nil {
		return err
	}

	if !(re.Status == model.STATUS_AWAITS_START || re.Status == model.STATUS_PAUSE || re.Status == model.STATUS_ON_ROAD) {
		return model.ErrInvalidStatus
	}

	re.WorkStartedDriver = true
	re.WorkStartedClinet = true
	re.ForgotToStart = true

	if re.WorkStartedClinet && re.WorkStartedDriver {
		if re.Status != model.STATUS_PAUSE {
			re.WorkStartedAt = model.Time{NullTime: sql.NullTime{Time: time.Now(), Valid: true}}
		}
		re.Status = model.STATUS_WORKING
	}

	if err := r.repo.Update(re); err != nil {
		return err
	}

	go func() {
		err := r.driverConfirmStartWork(context.Background(), id)
		if err != nil {
			logrus.Errorf("service requestExecution: driverConfirmStartWork: %v", err.Error())
		}
	}()

	return nil
}

func (r *requestExecution) driverConfirmStartWork(ctx context.Context, id int) error {
	re, err := r.repo.GetByID(id)
	if err != nil {
		return fmt.Errorf("notification: GetByID: err: %w", err)
	}

	nameDriver := ""
	sendToUserID := make([]int, 0, 3)

	if re.AssignTo != nil {
		nameDriver = fmt.Sprintf("%s %s", re.UserAssignTo.LastName, re.UserAssignTo.FirstName)
		if re.DriverID != nil && re.ClinetID != nil {
			sendToUserID = append(sendToUserID, *re.DriverID, *re.ClinetID)
			// log.Println("DriverID:", *re.DriverID)
			// log.Println("ClinetID:", *re.ClinetID)
		} else {
			log.Println("Either DriverID or ClinetID is nil in the AssignTo branch")
		}
	} else if re.DriverID != nil {
		nameDriver = fmt.Sprintf("%s %s", re.Driver.FirstName, re.Driver.LastName)
		if re.ClinetID != nil {
			sendToUserID = append(sendToUserID, *re.DriverID, *re.ClinetID)
			// log.Println("DriverID:", *re.DriverID)
			// log.Println("ClinetID:", *re.ClinetID)
		} else {
			sendToUserID = append(sendToUserID, *re.DriverID)
			// log.Println("DriverID:", *re.DriverID)
		}
	} else {
		return errors.New("vse ploha logica slomalas")
	}

	// Retrieve device tokens for each user ID.
	tokens := make([]string, 0, len(sendToUserID))
	for _, uid := range sendToUserID {
		res, err := r.notification.GetDeviceToken(model.DeviceToken{UserID: uid})
		if err != nil {
			return fmt.Errorf("notification: GetDeviceToken: userID = %v: err: %w", uid, err)
		}
		tokens = append(tokens, res...)
	}

	// Filter tokens: trim spaces and record if any empty tokens were found.
	filteredTokens := make([]string, 0, len(tokens))
	emptyFound := false
	for _, t := range tokens {
		trimmed := strings.TrimSpace(t)
		if trimmed == "" {
			emptyFound = true
		} else {
			filteredTokens = append(filteredTokens, trimmed)
		}
	}
	if emptyFound {
		logrus.Error("Some device tokens were empty and have been filtered out")
	}
	if len(filteredTokens) == 0 {
		return errors.New("notification: no valid device tokens retrieved")
	}

	// log.Println("User IDs to notify:", sendToUserID)
	// log.Println("Retrieved tokens:", filteredTokens)

	// Send the notification.
	err = r.messageClient.Send(ctx, model.Notification{
		Data: map[string]string{
			"date":   time.Now().String(),
			"src":    re.Src,
			"status": re.Status,
			"id":     strconv.Itoa(re.ID),
			"screen": "driver_on_road",
		},
		DeviceTokens: filteredTokens,
		Message:      fmt.Sprintf("Водитель %s начал работу", nameDriver),
		Tittle:       fmt.Sprintf("Водитель %s начал работу", nameDriver),
	})
	if err != nil {
		return fmt.Errorf("notification: Send: err: %w", err)
	}

	log.Println("Notification Sent")
	return nil
}

func (r *requestExecution) ClientConfirmStartWork(ctx context.Context, id int) error {
	// только клиент
	// работа должна быть в паузе или только созданна

	re, err := r.repo.GetByID(id)
	if err != nil {
		return err
	}

	if !(re.Status == model.STATUS_AWAITS_START || re.Status == model.STATUS_PAUSE || re.Status == model.STATUS_ON_ROAD) {
		return model.ErrInvalidStatus
	}

	re.WorkStartedClinet = true

	if re.WorkStartedClinet && re.WorkStartedDriver {
		if re.Status != model.STATUS_PAUSE {
			re.WorkStartedAt = model.Time{NullTime: sql.NullTime{Time: time.Now(), Valid: true}}
		}
		re.Status = model.STATUS_WORKING
	}

	if err = r.repo.Update(re); err != nil {
		return err
	}

	//user, err := r.userRepo.GetByID(re.)
	//r.SendMessageToClient(ctx, re, model.Notification{Message: "Клиент подтвердил работу"})

	return nil
}

func (r *requestExecution) DriverPauseWork(ctx context.Context, id int) error {
	// только водитель
	// работа должна было начаться

	re, err := r.repo.GetByID(id)
	if err != nil {
		return err
	}

	if re.Status != model.STATUS_WORKING && re.Status != model.STATUS_ON_ROAD {
		return model.ErrInvalidStatus
	}

	re.WorkStartedDriver = false

	if !(re.WorkStartedClinet && re.WorkStartedDriver) {
		re.Status = model.STATUS_PAUSE
	}

	if err := r.repo.Update(re); err != nil {
		return err
	}

	// if err = r.ClientPauseWork(ctx, id); err != nil {
	// 	return err
	// }

	go func() {
		err := r.driverPauseWork(context.Background(), id)
		if err != nil {
			logrus.Errorf("service requestExecution: driverPauseWork: %v", err.Error())
		}
	}()

	return nil
}

func (r *requestExecution) driverPauseWork(ctx context.Context, id int) error {
	re, err := r.repo.GetByID(id)
	if err != nil {
		return fmt.Errorf("notification: GetByID: err: %w", err)
	}

	nameDriver := ""
	sendToUserID := make([]int, 0, 3)

	if re.AssignTo != nil {
		nameDriver = fmt.Sprintf("%s %s", re.UserAssignTo.LastName, re.UserAssignTo.FirstName)
		if re.DriverID != nil && re.ClinetID != nil {
			sendToUserID = append(sendToUserID, *re.DriverID, *re.ClinetID)
		}
	} else if re.DriverID != nil {
		nameDriver = fmt.Sprintf("%s %s", re.Driver.FirstName, re.Driver.LastName)
		if re.ClinetID != nil {
			sendToUserID = append(sendToUserID, *re.ClinetID)
		}
	} else {
		return errors.New("vse ploha logica slomalas")
	}

	tokens := make([]string, 0, len(sendToUserID))

	for _, id := range sendToUserID {
		res, err := r.notification.GetDeviceToken(model.DeviceToken{UserID: id})
		if err != nil {
			return fmt.Errorf("notification: GetDeviceToken: userID = %v: err: %w", id, err)
		}
		tokens = append(tokens, res...)
	}

	err = r.messageClient.Send(ctx, model.Notification{
		Data:         map[string]string{"screen": "driver_on_road"},
		DeviceTokens: tokens,
		Message:      fmt.Sprintf("Водитель %s остановил работу", nameDriver),
		Tittle:       fmt.Sprintf("Водитель %s остановил работу", nameDriver),
	})
	if err != nil {
		return fmt.Errorf("notification: Send: err: %w", err)
	}

	return nil
}

func (r *requestExecution) ClientPauseWork(ctx context.Context, id int) error {
	// только клиент
	// работа должна было начаться

	re, err := r.repo.GetByID(id)
	if err != nil {
		return err
	}

	if re.Status != model.STATUS_WORKING && re.Status != model.STATUS_ON_ROAD {
		return model.ErrInvalidStatus
	}

	re.WorkStartedClinet = false

	if !(re.WorkStartedClinet && re.WorkStartedDriver) {
		re.Status = model.STATUS_PAUSE
	}

	if err = r.repo.Update(re); err != nil {
		return err
	}

	//r.SendMessageToClient(ctx, re, model.Notification{Message: "Клиент остановил работу"})
	return nil
}

func (r *requestExecution) DriverFinishWork(ctx context.Context, id int, paymentAmount int) error {
	// только водитель
	// работа должна быть в активном статусе

	re, err := r.repo.GetByID(id)
	if err != nil {
		return err
	}

	if re.Status != model.STATUS_WORKING {
		return model.ErrInvalidStatus
	}

	re.WorkStartedDriver = false
	re.WorkStartedClinet = false

	if !re.WorkStartedDriver && !re.WorkStartedClinet {
		re.WorkEndAt = model.Time{NullTime: sql.NullTime{Time: time.Now(), Valid: true}}
		re.Status = model.STATUS_FINISHED
	}

	re.DriverPaymentAmount = &paymentAmount

	if err := r.repo.Update(re); err != nil {
		return err
	}

	// if err := r.ClientFinishWork(ctx, id); err != nil {
	// 	return err
	// }

	go func() {
		err := r.driverFinishWork(context.Background(), id)
		if err != nil {
			logrus.Errorf("service requestExecution: driverFinishWork: %v", err.Error())
		}
	}()

	return nil
}

func (r *requestExecution) driverFinishWork(ctx context.Context, id int) error {
	re, err := r.repo.GetByID(id)
	if err != nil {
		return fmt.Errorf("notification: GetByID: err: %w", err)
	}

	nameDriver := ""
	sendToUserID := make([]int, 0, 3)

	if re.AssignTo != nil {
		nameDriver = fmt.Sprintf("%s %s", re.UserAssignTo.LastName, re.UserAssignTo.FirstName)
		if re.DriverID != nil && re.ClinetID != nil {
			sendToUserID = append(sendToUserID, *re.DriverID, *re.ClinetID)
		}
	} else if re.DriverID != nil {
		nameDriver = fmt.Sprintf("%s %s", re.Driver.FirstName, re.Driver.LastName)
		if re.ClinetID != nil {
			sendToUserID = append(sendToUserID, *re.ClinetID)
		}
	} else {
		return errors.New("vse ploha logica slomalas")
	}

	tokens := make([]string, 0, len(sendToUserID))

	for _, id := range sendToUserID {
		res, err := r.notification.GetDeviceToken(model.DeviceToken{UserID: id})
		if err != nil {
			return fmt.Errorf("notification: GetDeviceToken: userID = %v: err: %w", id, err)
		}
		tokens = append(tokens, res...)
	}

	err = r.messageClient.Send(ctx, model.Notification{
		Data:         map[string]string{"screen": "rating"},
		DeviceTokens: tokens,
		Message:      fmt.Sprintf("Водитель %s завершил работу", nameDriver),
		Tittle:       fmt.Sprintf("Водитель %s завершил работу", nameDriver),
	})
	if err != nil {
		return fmt.Errorf("notification: Send: err: %w", err)
	}

	return nil
}

func (r *requestExecution) ClientFinishWork(ctx context.Context, id int, paymentAmount int) error {
	// только клиент
	// работа должна быть в активном статусе

	re, err := r.repo.GetByID(id)
	if err != nil {
		return err
	}

	if re.Status != model.STATUS_WORKING {
		return model.ErrInvalidStatus
	}

	re.WorkStartedClinet = false

	if !re.WorkStartedDriver && !re.WorkStartedClinet {
		re.Status = model.STATUS_FINISHED
	}

	re.ClinetPaymentAmount = &paymentAmount

	if err = r.repo.Update(re); err != nil {
		return err
	}

	//r.SendMessageToClient(ctx, re, model.Notification{Message: "Клиент завершил работу"})
	return nil
}

func (r *requestExecution) DriverSetOnRoad(ctx context.Context, id int) error {
	if err := r.repo.Update(model.RequestExecution{
		ID:     id,
		Status: model.STATUS_ON_ROAD,
	}); err != nil {
		return err
	}

	go func() {
		err := r.driverSetOnRoad(context.Background(), id)
		if err != nil {
			logrus.Errorf("service requestExecution: driverSetOnRoad: err: %v", err.Error())
		}
	}()

	return nil
}

func (r *requestExecution) driverSetOnRoad(ctx context.Context, id int) error {
	re, err := r.repo.GetByID(id)
	if err != nil {
		return fmt.Errorf("notification: GetByID: err: %w", err)
	}

	nameDriver := ""
	sendToUserID := make([]int, 0, 3)

	if re.AssignTo != nil {
		nameDriver = fmt.Sprintf("%s %s", re.UserAssignTo.LastName, re.UserAssignTo.FirstName)
		if re.ClinetID != nil && re.DriverID != nil {
			sendToUserID = append(sendToUserID, *re.DriverID, *re.ClinetID)
		}
	} else if re.DriverID != nil {
		nameDriver = fmt.Sprintf("%s %s", re.Driver.FirstName, re.Driver.LastName)
		if re.ClinetID != nil {
			sendToUserID = append(sendToUserID, *re.ClinetID)
		}
	} else {
		return errors.New("vse ploha logica slomalas")
	}

	tokens := make([]string, 0, len(sendToUserID))

	for _, id := range sendToUserID {
		res, err := r.notification.GetDeviceToken(model.DeviceToken{UserID: id})
		if err != nil {
			return fmt.Errorf("notification: GetDeviceToken: userID = %v: err: %w", id, err)
		}
		tokens = append(tokens, res...)
	}

	err = r.messageClient.Send(ctx, model.Notification{
		Data:         map[string]string{"screen": "driver_on_road"},
		DeviceTokens: tokens,
		Message:      fmt.Sprintf("Водитель %s в пути", nameDriver),
		Tittle:       fmt.Sprintf("Водитель %s в пути", nameDriver),
	})
	if err != nil {
		return fmt.Errorf("notification: Send: err: %w", err)
	}

	return nil
}

func (r *requestExecution) Reassign(id int, workerID *int) error {
	return r.repo.UpdateAssignTo(id, workerID)
}

func (r *requestExecution) DriverRate(req model.RequestExecution, rate int) (err error) {
	var userID int

	switch {
	case req.SpecializedMachineryRequestID != nil:
		driverReq, err := r.smReqRepo.GetByID(*req.SpecializedMachineryRequestID)
		if err != nil {
			return err
		}
		userID = driverReq.AdSpecializedMachinery.UserID
	case req.RequestAdEquipmentID != nil:
		req, err := r.requestAdEquipment.GetByID(context.Background(), *req.RequestAdEquipmentID)
		if err != nil {
			return err
		}
		userID = req.AdEquipment.UserID
	default:
		return nil
	}

	user, err := r.userRepo.GetByID(userID)
	if err != nil {
		return err
	}

	user.CountRate++
	user.Rating = (user.Rating + float64(rate)) / float64(user.CountRate)

	return r.userRepo.Update(user)
}

func (r *requestExecution) RequestRate(req model.RequestExecution, rate int, comment string) (err error) {
	req, err = r.repo.GetRequestID(req)
	if err != nil {
		return err
	}

	if err = r.DriverRate(req, rate); err != nil {
		return err
	}

	req.Rate = &rate
	req.RateComment = &comment

	return r.repo.Update(req)
}

func (r *requestExecution) SendMessageToClient(ctx context.Context, re model.RequestExecution, notification model.Notification) error {
	re, err := r.repo.GetByID(re.ID)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil
		}
		return err
	}

	if re.Status == "WORKING" && re.WorkStartedClinet && !re.WorkStartedDriver {
		if notification.Data == nil {
			notification.Data = map[string]string{"screen": "finished"}
		}
	}

	if re.SpecializedMachineryRequestID != nil {
		tokens, err := r.notification.GetDeviceToken(model.DeviceToken{
			UserID: re.SpecializedMachineryRequest.UserID,
		})
		if err != nil {
			if errors.Is(err, gorm.ErrRecordNotFound) {
				return nil
			}
			return err
		}

		if len(tokens) == 0 {
			return nil
		}

		go func() {
			r.messageClient.Send(ctx, model.Notification{
				Data:         notification.Data,
				DeviceTokens: tokens,
				Message:      notification.Message,
				Tittle:       notification.Tittle,
			})
		}()

		return nil
	}

	adClient, err := r.smReqRepo.GetByID(re.Request.AdClientID)
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil
		}
		return err
	}

	adClientUser, err := r.adClientRepo.GetByID(model.AdClient{ID: adClient.ID})
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

	if len(tokens) == 0 {
		return nil
	}

	go func() {
		r.messageClient.Send(ctx, model.Notification{
			Data:         notification.Data,
			DeviceTokens: tokens,
			Message:      notification.Message,
			Tittle:       notification.Tittle,
		})
	}()

	return nil
}

func (r *requestExecution) GetHistoryByID(id int) ([]model.RequestExecution, error) {
	return r.repo.GetHistoryByID(id)
}

func (r *requestExecution) HistoryTraveledWay(ctx context.Context, id int) ([]model.Coordinates, error) {
	res, err := r.repo.HistoryTraveledWay(ctx, id)
	if err != nil {
		return nil, fmt.Errorf("service requestExecution: %w", err)
	}
	return res, nil
}

func (r *requestExecution) UpdatePostNotificationOnTrue(ctx context.Context, id ...int) error {
	err := r.repo.UpdatePostNotification(ctx, id...)
	if err != nil {
		return fmt.Errorf("service requestExecution: UpdatePostNotificationOnTrue: err: %w", err)
	}

	return nil
}

func (r *requestExecution) Update(ctx context.Context, re model.RequestExecution) error {
	err := r.repo.Update(re)
	if err != nil {
		return fmt.Errorf("service requestExecution: Update: err: %w", err)
	}

	return nil
}

func (r *requestExecution) UpdateEndLeaseAt(ctx context.Context, id int, endLeaseAt model.Time) error {
	err := r.repo.UpdateEndLeaseAt(ctx, id, endLeaseAt)
	if err != nil {
		return fmt.Errorf("service requestExecution: UpdateEndLeaseAt: err: %w", err)
	}

	return nil
}

func (r *requestExecution) CreateRequestExecutionAssignmentWithoutClinet(ctx context.Context, re model.RequestExecution) error {
	if re.AssignTo == nil {
		if re.DriverID == nil {
			return errors.New("fatal painc error assign_to and driver_id null")
		}

		driver, err := r.userRepo.GetByID(*re.DriverID)
		if err != nil {
			return fmt.Errorf("service requestExecution: CreateRequestExecutionAssignmentWithoutClinet: GetDriver: err %w", err)
		}

		if driver.OwnerID == nil {
			return errors.New("driver who doesn't have owner")
		}

		temp := *re.DriverID

		re.AssignTo = &temp
		re.DriverID = driver.OwnerID

		if re.AssignTo != nil && re.DriverID != nil && *re.AssignTo == *re.DriverID {
			re.AssignTo = nil
		}
	}

	_, err := r.Create(ctx, re)
	if err != nil {
		return fmt.Errorf("service requestExecution: CreateRequestExecutionAssignmentWithoutClinet: Create: err %w", err)
	}

	for _, d := range re.Documents {
		_, err := r.remotes.Upload(ctx, d)
		if err != nil {
			return fmt.Errorf("service requestExecution:: Upload Foto: err %w", err)
		}
	}

	return nil
}
