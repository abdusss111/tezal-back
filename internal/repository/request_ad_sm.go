package repository

import (
	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type ISpecializedMachineryRequest interface {
	Get(f model.FilterSpecializedMachineryRequest) ([]model.SpecializedMachineryRequest, int, error)
	GetByID(id int) (model.SpecializedMachineryRequest, error)
	GetHistoryByID(id int) ([]model.SpecializedMachineryRequest, error)
	Create(smr model.SpecializedMachineryRequest) (int, error)
	Update(smr model.SpecializedMachineryRequest) error
	Delete(id int) error
	//GetByUserID(smr model.SpecializedMachineryRequest) (model.SpecializedMachineryRequest, error)
}

type specializedMachineryRequest struct {
	db *gorm.DB
}

func NewSpecializedMachineryRequest(db *gorm.DB) *specializedMachineryRequest {
	return &specializedMachineryRequest{db: db}
}

func (s *specializedMachineryRequest) Get(f model.FilterSpecializedMachineryRequest) ([]model.SpecializedMachineryRequest, int, error) {
	smrs := make([]model.SpecializedMachineryRequest, 0)

	query := s.db.Model(&model.SpecializedMachineryRequest{}).
		Preload("Document").
		Preload("AdSpecializedMachinery")

	if f.UserDetail != nil && *f.UserDetail {
		query = query.Preload("User")
	}

	if f.AdSpecializedMachineryUserID != nil {
		query = query.Where(`ad_specialized_machinery_id IN
			(SELECT a.id FROM ad_specialized_machineries a WHERE a.user_id = ? AND a.deleted_at IS NULL)`, f.AdSpecializedMachineryUserID,
		)
	}

	if len(f.AdSpecializedMachineryID) != 0 {
		query = query.Where("ad_specialized_machinery_id = ANY(?)", f.AdSpecializedMachineryID)
	}

	if f.UserID != nil {
		query = query.Where("user_id = ?", f.UserID)
	}

	if f.CityID != nil {
		query = query.Where("ad_specialized_machinery_id = ?", f.CityID)
	}

	if f.Status != nil {
		query = query.Where("status = ?", f.Status)
	}

	if f.Limit != nil {
		query = query.Limit(*f.Limit)
	}

	if f.Offset != nil {
		query = query.Offset(*f.Offset)
	}

	// TODO еще фильтры

	query = query.Order("created_at DESC")

	res := query.Find(&smrs)
	if res.Error != nil {
		return nil, 0, res.Error
	}

	var n int64
	res = res.Limit(-1).Offset(-1)
	res = res.Count(&n)
	if res.Error != nil {
		return nil, 0, res.Error
	}

	return smrs, int(n), nil
}

func (s *specializedMachineryRequest) GetByID(id int) (model.SpecializedMachineryRequest, error) {
	smr := model.SpecializedMachineryRequest{}

	res := s.db.Preload("Document").
		Preload("User").
		Preload("AdSpecializedMachinery").
		Preload("AdSpecializedMachinery.User").
		Preload("AdSpecializedMachinery.Brand").
		Preload("AdSpecializedMachinery.Type").
		Preload("AdSpecializedMachinery.City").
		Preload("AdSpecializedMachinery.Document")
	res = res.Unscoped()

	res = res.First(&smr, id)
	if res.Error != nil {
		return smr, res.Error
	}

	return smr, nil
}

func (s *specializedMachineryRequest) GetHistoryByID(id int) ([]model.SpecializedMachineryRequest, error) {
	smrs := make([]model.SpecializedMachineryRequest, 0)

	err := s.db.
		Unscoped().
		Table("specialized_machinery_requests_histories").
		Order("updated_at DESC").
		Order("deleted_at DESC").
		Where("id = ?", id).
		Find(&smrs).Error
	if err != nil {
		return nil, err
	}

	return smrs, nil
}

func (s *specializedMachineryRequest) Create(smr model.SpecializedMachineryRequest) (int, error) {
	res := s.db.Create(&smr)
	if res.Error != nil {
		return 0, res.Error
	}

	return smr.ID, nil
}

func (s *specializedMachineryRequest) Update(smr model.SpecializedMachineryRequest) error {
	return s.db.Model(&model.SpecializedMachineryRequest{}).Where("id = ?", smr.ID).Updates(smr).Error
}

func (s *specializedMachineryRequest) Delete(id int) error {
	return s.db.Where("id = ?", id).Delete(&model.SpecializedMachineryRequest{}).Error
}

//func (s *specializedMachineryRequest) GetByUserID(smr model.SpecializedMachineryRequest) (model.SpecializedMachineryRequest, error) {
//	return s.db.Model(&model.SpecializedMachineryRequest{}).Where("")
//}
