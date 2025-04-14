package service

import (
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type INotification interface {
	SaveDeviceToken(token model.DeviceToken) error
	GetUserDeviceTokens(token model.DeviceToken) ([]string, error)
	ExistDeviceToken(token model.DeviceToken) (bool, error)
}

type notification struct {
	repo repository.INotification
}

func NewNotificationService(repo repository.INotification) *notification {
	return &notification{
		repo: repo,
	}
}

func (a *notification) SaveDeviceToken(token model.DeviceToken) error {
	return a.repo.SaveDeviceToken(token)
}

func (a *notification) ExistDeviceToken(token model.DeviceToken) (bool, error) {
	return a.repo.ExistDeviceToken(token)
}

func (a *notification) GetUserDeviceTokens(token model.DeviceToken) ([]string, error) {
	tokens, err := a.repo.GetDeviceToken(token)
	if err != nil {
		return nil, err
	}

	return tokens, nil
}
