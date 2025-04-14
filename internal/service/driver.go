package service

import (
	"context"
	"errors"
	"fmt"
	"log"
	"strconv"
	"time"

	"github.com/sirupsen/logrus"

	client2 "gitlab.com/eqshare/eqshare-back/internal/client"
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IDriver interface {
	DriverAuth(ctx context.Context, user model.User) error
	GetDriverDocument(ctx context.Context, doc model.Document, download bool) (model.Document, error)
	UpdateDriverDocument(ctx context.Context, doc model.Document) (model.Document, error)
	DeleteDriverDocument(ctx context.Context, doc model.Document) (model.Document, error)
	UpdateLocationStatus(id int, isEnabled bool) error
	RespondToAddWorkerRequest(driverID, ownerID int, accept bool) error
}

type dService struct {
	docRepo           repository.IDocument
	userRepo          repository.IUser
	driverLicenseRepo repository.IDriverLicense
	remotes           client2.DocumentsRemote
	driverRepo        repository.IDriverMove
	ownerRepo         repository.IOwner
	messageClient     client2.NotificationClient
	notification      repository.INotification
}

func NewDocumentService(docRepo repository.IDocument,
	remotes client2.DocumentsRemote,
	userRepo repository.IUser,
	driverLicense repository.IDriverLicense,
	driverRepo repository.IDriverMove,
	ownerRepo repository.IOwner,
	messageClient client2.NotificationClient,
	notification repository.INotification) *dService {

	return &dService{
		docRepo:           docRepo,
		remotes:           remotes,
		userRepo:          userRepo,
		driverLicenseRepo: driverLicense,
		driverRepo:        driverRepo,
		ownerRepo:         ownerRepo,
		messageClient:     messageClient,
		notification:      notification,
	}
}

func (s *dService) DriverAuth(ctx context.Context, driver model.User) error {
	user, err := s.userRepo.GetByID(driver.ID)
	if err != nil {
		return err
	}

	user.AccessRole = model.ROLE_DRIVER
	user.IIN = driver.IIN
	user.BirthDate = driver.BirthDate
	user.DriverLicense = driver.DriverLicense
	user.FirstName = driver.FirstName
	user.LastName = driver.LastName

	for i := range user.DriverLicense.Documents {
		user.DriverLicense.Documents[i].UserID = user.ID
		stored, err := s.docRepo.Create(ctx, user.DriverLicense.Documents[i])
		if err != nil {
			return err
		}

		if _, err = s.remotes.Upload(ctx, stored); err != nil {
			return err
		}
		user.DriverLicense.Documents[i] = stored
		user.DriverLicense.UserID = user.ID
	}

	if err = s.userRepo.UpdateAsDriver(user); err != nil {
		return err
	}

	if err := s.driverLicenseRepo.CreateDriverLicense(*user.DriverLicense); err != nil {
		return err
	}

	return s.userRepo.UpdateCanDriver(user.ID, true)
}

func (s *dService) GetDriverDocument(ctx context.Context, doc model.Document, download bool) (model.Document, error) {
	userId, ok := ctx.Value(model.UserID).(int)
	if !ok {
		return doc, fmt.Errorf("unauthorized action is prohibited")
	}

	doc.UserID = userId

	stored, err := s.docRepo.GetByUserID(ctx, doc)
	if err != nil {
		return stored, err
	}

	if !download {
		return stored, nil
	}

	return s.remotes.Get(ctx, stored)
}

func (s *dService) UpdateDriverDocument(ctx context.Context, doc model.Document) (model.Document, error) {
	userId, ok := ctx.Value(model.UserID).(int)
	if !ok {
		return doc, fmt.Errorf("unauthorized action is prohibited")
	}

	doc.UserID = userId

	return doc, s.docRepo.Update(ctx, doc)
}

func (s *dService) DeleteDriverDocument(ctx context.Context, doc model.Document) (model.Document, error) {
	userId, ok := ctx.Value(model.UserID).(int)
	if !ok {
		return doc, fmt.Errorf("unauthorized action is prohibited")
	}

	doc.UserID = userId

	document, err := s.docRepo.GetByUserID(ctx, doc)
	if err != nil {
		return document, err
	}

	document, err = s.remotes.Delete(ctx, document)
	if err != nil {
		return document, err
	}

	return doc, s.docRepo.Delete(ctx, []model.Document{doc})
}

func (s *dService) UpdateLocationStatus(id int, isEnabled bool) error {
	return s.driverRepo.UpdateLocationStatus(id, isEnabled)
}

func (d *dService) RespondToAddWorkerRequest(driverID, ownerID int, accept bool) error {
	request1, err := d.ownerRepo.GetOwnerDriverRequest(ownerID, driverID)

	if err != nil {
		return err
	} // error occurs here

	if request1.Status != "PENDING" {
		return errors.New("request is not pending")
	}

	if accept {
		request1.Status = "ACCEPTED"
		err = d.ownerRepo.UpdateOwnerDriverRequest(request1)
		if err != nil {
			return err
		}

		err = d.ownerRepo.AddDriverToOwner(ownerID, driverID)
		if err != nil {
			return err
		}

		tokens, err := d.notification.GetDeviceToken(model.DeviceToken{
			UserID: ownerID,
		})
		if err != nil {
			return err
		}

		user, err := d.userRepo.GetByID(driverID)
		if err != nil {
			return err
		}

		go func() {
			err := d.messageClient.Send(context.Background(), model.Notification{
				DeviceTokens: tokens,
				Tittle:       "Водитель принял вашу заявку",
				Message:      fmt.Sprintf("Водитель %s %s принял вашу заявку", user.FirstName, user.LastName),
				Data: map[string]string{
					"date":       time.Now().String(),
					"type":       model.NotificationTypeSM,
					"id":         strconv.Itoa(driverID),
					"wasApprove": "true",
				},
			})
			if err != nil {
				logrus.Error(err)
			}
			log.Println(tokens)
			log.Println("Notification Sent")
		}()

	} else {
		request1.Status = "REJECTED"
		err = d.ownerRepo.UpdateOwnerDriverRequest(request1)
		if err != nil {
			return err
		}

		tokens, err := d.notification.GetDeviceToken(model.DeviceToken{
			UserID: ownerID,
		})
		if err != nil {
			return err
		}

		user, err := d.userRepo.GetByID(driverID)
		if err != nil {
			return err
		}

		go func() {
			err := d.messageClient.Send(context.Background(), model.Notification{
				DeviceTokens: tokens,
				Tittle:       "Водитель отклонил вашу заявку",
				Message:      fmt.Sprintf("Водитель %s %s отклонил вашу заявку", user.FirstName, user.LastName),
				Data: map[string]string{
					"date":       time.Now().String(),
					"type":       model.NotificationTypeSM,
					"id":         strconv.Itoa(driverID),
					"wasApprove": "true",
				},
			})
			if err != nil {
				logrus.Error(err)
			}
			log.Println(tokens)
			log.Println("Notification Sent")
		}()
	}

	return nil
}
