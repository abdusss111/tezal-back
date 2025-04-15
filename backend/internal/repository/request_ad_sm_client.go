package repository

import (
	"context"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IRequest interface {
	Create(rc model.Request) (int, error)
	Get(f model.FilterRequest) ([]model.Request, int, error)
	GetByID(id int) (model.Request, error)
	Update(ctx context.Context, rc model.Request) error
	Delete(rc model.Request) error
	DeleteByAdClientID(adClinetID int) error
	GetHistoryByID(id int) ([]model.Request, error)
}

type request struct {
	db *gorm.DB
}

func NewRequestRepository(db *gorm.DB) *request {
	return &request{db: db}
}

func (r *request) Create(rc model.Request) (int, error) {
	if err := r.db.Create(&rc).Error; err != nil {
		return 0, err
	}

	return rc.ID, nil
}

func (r *request) Get(f model.FilterRequest) ([]model.Request, int, error) {
	rcs := make([]model.Request, 0)

	stmt := r.db.Model(&model.Request{}).Preload("AdClient")

	if f.UserDetail != nil && *f.UserDetail {
		stmt = stmt.Preload("User")
	}

	if f.UserAssigned != nil && *f.UserAssigned {
		stmt = stmt.Preload("UserAssigned")
	}

	if len(f.AdClient) != 0 {
		stmt = stmt.Where("ad_client in (?)", f.AdClient)
	}

	if f.AdClientUserID != nil {
		stmt = stmt.Where("ad_client_id in (SELECT id FROM ad_clients WHERE user_id = ?)", f.AdClientUserID)
	}

	if f.UserID != nil {
		stmt = stmt.Where("user_id = ?", f.UserID)
	}

	if f.Status != nil {
		stmt = stmt.Where("status = ?", f.Status)
	}

	if f.Limit != nil {
		stmt = stmt.Limit(*f.Limit)
	}

	if f.Offset != nil {
		stmt = stmt.Offset(*f.Offset)
	}

	stmt = stmt.Order("created_at DESC")

	stmt = stmt.Find(&rcs)
	if stmt.Error != nil {
		return nil, 0, stmt.Error
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, stmt.Error
	}

	return rcs, int(n), nil
}

func (r *request) GetByID(id int) (model.Request, error) {
	rc := model.Request{}
	return rc, r.db.Model(&model.Request{}).Unscoped().
		Preload("AdClient.User").
		Preload("User").
		Preload("AdClient.Type").
		// Preload("AdClient.Type.SubCategory").
		Preload("AdClient.City").
		Preload("AdClient.Documents").
		Where("id = ?", id).Find(&rc).Error
}

func (r *request) Update(ctx context.Context, rc model.Request) error {
	return r.db.WithContext(ctx).Model(&model.Request{}).Where("id = ?", rc.ID).Updates(&rc).Error
}

func (r *request) Delete(rc model.Request) error {
	return r.db.Model(&model.Request{}).Where("id = ?", rc.ID).Delete(&rc).Error
}

func (r *request) DeleteByAdClientID(adClinetID int) error {
	return r.db.Model(&model.Request{}).Where("ad_client_id = ? AND status != 'APPROVED'", adClinetID).Delete(&model.Request{}).Error
}

func (r *request) GetHistoryByID(id int) ([]model.Request, error) {
	rcs := make([]model.Request, 0)

	err := r.db.Unscoped().
		Table("requests_histories").
		Order("updated_at DESC").
		Order("deleted_at DESC").
		Where("id = ?", id).
		Find(&rcs).Error
	if err != nil {
		return nil, err
	}

	return rcs, nil
}
