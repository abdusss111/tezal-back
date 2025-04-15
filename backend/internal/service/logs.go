package service

import (
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type adminLogs struct {
	repo repository.IAdminLogsRepository
}

type IAdminLogsService interface {
	GetLogs(event model.Logs) ([]model.Logs, error)
	CreateLogs(event model.Logs) error
}

func NewAdminLogs(repo repository.IAdminLogsRepository) *adminLogs {
	return &adminLogs{
		repo: repo,
	}
}

func (s *adminLogs) GetLogs(event model.Logs) (logs []model.Logs, err error) {
	return s.repo.GetLogs(event)
}

func (s *adminLogs) CreateLogs(event model.Logs) error {
	return s.repo.CreateLogs(event)
}
