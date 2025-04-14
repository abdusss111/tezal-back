package service

import (
	client2 "gitlab.com/eqshare/eqshare-back/internal/client"
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IRequestNotification interface {
	GetOwnerDriverRequests(driverID int) ([]*model.OwnerDriverRequests, error)
}

type requestNotification struct {
	repo          repository.IOwner
	userRepo      repository.IUser
	messageClient client2.NotificationClient
	notification  repository.INotification
}

func NewRequestNotification(repo repository.IOwner, userRepo repository.IUser, messageClient client2.NotificationClient, notification repository.INotification) IRequestNotification {
	return &requestNotification{repo: repo, userRepo: userRepo, messageClient: messageClient, notification: notification}
}

func (r *requestNotification) GetOwnerDriverRequests(driverID int) ([]*model.OwnerDriverRequests, error) {
	requests, err := r.repo.GetOwnerDriverRequests(driverID)
	if err != nil {
		return nil, err
	}

	return requests, err
}
