package repository

import (
	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type adminLogs struct {
	db *gorm.DB
}

type IAdminLogsRepository interface {
	GetLogs(event model.Logs) ([]model.Logs, error)
	CreateLogs(event model.Logs) error
}

func NewAdminLogsRepository(db *gorm.DB) *adminLogs {
	return &adminLogs{
		db: db,
	}
}

func (r *adminLogs) GetLogs(event model.Logs) (logs []model.Logs, err error) {
	if err = r.db.Find(&logs).Error; err != nil {
		return logs, err
	}

	return logs, nil
}

func (r *adminLogs) CreateLogs(event model.Logs) error {
	return r.db.Create(&event).Error
}
