package service

import (
	"context"
	"errors"
	"fmt"
	"github.com/sirupsen/logrus"
	client2 "gitlab.com/eqshare/eqshare-back/internal/client"
	"strconv"
	"sync"
	"time"

	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IOwner interface {
	Get(f model.FilterOwner) ([]model.Owner, error)
	GetByID(id int) (model.Owner, error)
	BeOwner(userID int) error
	AddWorker(ownerID, workerID int) error
	DeleteWorker(ownerID, workerID int) error
	DeleteOWner(ownerID int) error
	SendAddWorkerRequest(ownerID, driverID int, firstname, lastname string) error
}

type owner struct {
	repo          repository.IOwner
	userRepo      repository.IUser
	messageClient client2.NotificationClient
	notification  repository.INotification
}

func NewOwner(repo repository.IOwner, userRepo repository.IUser, messageClient client2.NotificationClient, notification repository.INotification) *owner {
	return &owner{repo: repo, userRepo: userRepo, messageClient: messageClient, notification: notification}
}

func (o *owner) Get(f model.FilterOwner) ([]model.Owner, error) {
	return o.repo.Get(f)
}

func (o *owner) GetByID(id int) (model.Owner, error) {
	return o.repo.GetByID(id)
}

func (o *owner) BeOwner(userID int) error {
	user, err := o.userRepo.GetByID(userID)
	if err != nil {
		return err
	}

	if !user.CanDriver {
		return model.ErrAccessDenied
	}

	err = o.repo.Create(model.Owner{
		UserID: userID,
	})
	if err != nil {
		return err
	}

	return o.userRepo.UpdateCanOwner(userID, false)
}

func (o *owner) SendAddWorkerRequest(ownerID, driverID int, firstname, lastname string) error {
	driver, err := o.userRepo.GetByID(driverID)

	if err != nil {
		return err
	}

	if !driver.CanDriver {
		return model.ErrAccessDenied
	}

	// надо чекнуть потом
	existingRequest, err := o.repo.GetOwnerDriverRequest(ownerID, driverID)

	if err == nil && existingRequest.Status == "PENDING" {
		return errors.New("driver request is pending")
	} else if err == nil && existingRequest.Status == "ACCEPTED" {
		return errors.New("you already owned this driver")
	} else {
		err := o.repo.DeleteOwnerDriverRequest(ownerID, driverID)
		if err != nil {
			return err
		}
	}

	request := model.OwnerDriverRequests{
		OwnerID:  ownerID,
		DriverID: driverID,
		FullName: firstname + " " + lastname,
		Status:   "PENDING",
	}

	err = o.repo.CreateOwnerDriverRequest(request)
	if err != nil {
		return err
	}

	tokens, err := o.notification.GetDeviceToken(model.DeviceToken{
		UserID: driverID,
	})
	if err != nil {
		return err
	}

	user, err := o.userRepo.GetByID(ownerID)
	if err != nil {
		return err
	}

	go func() {
		err := o.messageClient.Send(context.Background(), model.Notification{
			DeviceTokens: tokens,
			Tittle:       "Владелец хочет добавить вас в список своих водителей",
			Message:      fmt.Sprintf("%s %s хочет добавить вас в список своих водителей", user.FirstName, user.LastName),
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
	}()

	return nil
}

func (o *owner) AddWorker(ownerID, workerID int) error {
	worker, err := o.userRepo.GetByID(workerID)
	if err != nil {
		return err
	}

	// if worker.OwnerID != nil {
	// 	return model.ErrHaveOwner
	// }

	if !worker.CanDriver {
		return model.ErrAccessDenied
	}
	worker.OwnerID = &ownerID

	wg := sync.WaitGroup{}
	chErr := make(chan error, 2)

	wg.Add(2)

	go func() {
		defer wg.Done()
		err := o.repo.AddWorker(ownerID, workerID)
		if err != nil {
			chErr <- err
			return
		}
	}()

	go func() {
		defer wg.Done()
		err := o.userRepo.UpdateOwnerID(worker)
		if err != nil {
			chErr <- err
			return
		}
	}()

	wg.Wait()

	close(chErr)

	for err2 := range chErr {
		return err2
	}

	return nil
}

func (o *owner) DeleteWorker(ownerID, workerID int) error {
	wg := sync.WaitGroup{}
	chErr := make(chan error, 4)

	wg.Add(4)

	go func() {
		defer wg.Done()
		err := o.repo.DeleteWorker(ownerID, workerID)
		if err != nil {
			chErr <- err
			return
		}
	}()

	go func() {
		defer wg.Done()
		err := o.userRepo.UpdateOwnerID(model.User{
			ID:      workerID,
			OwnerID: nil,
		})
		if err != nil {
			chErr <- err
			return
		}
	}()

	go func() {
		defer wg.Done()
		err := o.userRepo.ResetNickName(workerID)
		if err != nil {
			chErr <- err
			return
		}
	}()

	go func() {
		defer wg.Done()
		err := o.repo.DeleteOwnerDriverRequest(ownerID, workerID)
		if err != nil {
			chErr <- err
			return
		}
	}()

	wg.Wait()

	close(chErr)

	for err := range chErr {
		return err
	}

	return nil
}

func (o *owner) DeleteOWner(ownerID int) error {
	return o.repo.Deleted(ownerID)
}
