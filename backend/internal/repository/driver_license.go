package repository

import (
	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type dlRepo struct {
	db *gorm.DB
}

type IDriverLicense interface {
	CreateDriverLicense(dl model.DriverLicense) error
	GetDriverByUserID(dl model.DriverLicense) (model.DriverLicense, error)
}

func NewDriverLicenseRepository(db *gorm.DB) *dlRepo {
	return &dlRepo{
		db: db,
	}
}

func (r *dlRepo) CreateDriverLicense(dl model.DriverLicense) error {
	if err := r.db.Create(&dl).Error; err != nil {
		return err
	}

	var dd []model.DriverDocuments
	for i := range dl.Documents {
		dd = append(dd, model.DriverDocuments{
			DriverLicenseID: dl.ID,
			DocID:           dl.Documents[i].ID,
		})
	}

	if err := r.db.Create(dd).Error; err != nil {
		return err
	}

	return nil
}

func (r *dlRepo) GetDriverByUserID(dl model.DriverLicense) (model.DriverLicense, error) {
	res := r.db.Model(model.DriverLicense{}).Where("user_id = ?", dl.UserID).Scan(&dl)
	if res.RowsAffected == 0 {
		return dl, gorm.ErrRecordNotFound
	}

	return dl, res.Error
}
