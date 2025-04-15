package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IRequestAdEquipment interface {
	Get(ctx context.Context, f model.FilterRequestAdEquipment) ([]model.RequestAdEquipment, int, error)
	GetByID(ctx context.Context, id int) (model.RequestAdEquipment, error)
	GetHistoryByID(ctx context.Context, f model.FilterRequestAdEquipment) ([]model.RequestAdEquipment, int, error)
	Create(ctx context.Context, r model.RequestAdEquipment) (int, error)
	Update(ctx context.Context, r model.RequestAdEquipment) error
	Delete(ctx context.Context, id int) error
}

type requestAdEquipment struct {
	db *gorm.DB
}

func NewRequestAdEquipment(db *gorm.DB) IRequestAdEquipment {
	return &requestAdEquipment{db: db}
}

func (repo *requestAdEquipment) Get(ctx context.Context, f model.FilterRequestAdEquipment) ([]model.RequestAdEquipment, int, error) {
	res := make([]model.RequestAdEquipment, 0)

	stmt := repo.db.WithContext(ctx)

	if f.Unscoped != nil && *f.Unscoped {
		stmt = stmt.Unscoped()
	}

	if f.UserDetail != nil && *f.UserDetail {
		stmt = stmt.Preload("User")
	}
	if f.ExecutorDetail != nil && *f.ExecutorDetail {
		stmt = stmt.Preload("Executor")
	}
	if f.AdEquipmentDetail != nil && *f.AdEquipmentDetail {
		stmt = stmt.Preload("AdEquipment")
	}
	if f.DocumentDetail != nil && *f.DocumentDetail {
		stmt = stmt.Preload("Document")
	}

	if len(f.IDs) != 0 {
		stmt = stmt.Where("id IN (?)", f.IDs)
	}

	if len(f.AdEquipmentIDs) != 0 {
		stmt = stmt.Where("ad_equipment_id IN (?)", f.AdEquipmentIDs)
	}

	if len(f.AdEquipmentUserIDs) != 0 {
		stmt = stmt.Where("ad_equipment_id in (select id from ad_equipments where user_id = ?)", f.AdEquipmentUserIDs)
	}

	if len(f.UserIDs) != 0 {
		stmt = stmt.Where("user_id in (?)", f.UserIDs)
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

	stmt = stmt.Find(&res)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository requestAdEquipment `Get` `Find`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository requestAdEquipment `Get` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}

func (repo *requestAdEquipment) GetByID(ctx context.Context, id int) (model.RequestAdEquipment, error) {
	res := model.RequestAdEquipment{}

	err := repo.db.
		WithContext(ctx).
		Unscoped().
		Preload("User").
		Preload("Executor").
		Preload("AdEquipment").
		Preload("AdEquipment.EquipmentBrand").
		Preload("AdEquipment.EquipmentSubCategory").
		Preload("AdEquipment.Documents").
		Preload("Document").
		Find(&res, id).Error
	if err != nil {
		return res, fmt.Errorf("repository requestAdEquipment `GetByID` `Find`: %w", err)
	}

	return res, nil
}

func (repo *requestAdEquipment) Create(ctx context.Context, r model.RequestAdEquipment) (int, error) {
	err := repo.db.WithContext(ctx).Create(&r).Error
	if err != nil {
		return 0, fmt.Errorf("repository requestAdEquipment `Create` `Create`: %w", err)
	}

	return r.ID, nil
}

func (repo *requestAdEquipment) UpdateStatus(ctx context.Context, r model.RequestAdEquipment) error {
	value := map[string]interface{}{
		"status": r.Status,
	}

	err := repo.db.WithContext(ctx).Model(&model.RequestAdEquipment{}).Where("id = ?", r.ID).Updates(value).Error
	if err != nil {
		return fmt.Errorf("repository requestAdEquipment `Update` `Updates`: %w", err)
	}

	return nil
}

func (repo *requestAdEquipment) Delete(ctx context.Context, id int) error {
	err := repo.db.WithContext(ctx).Delete(&model.RequestAdEquipment{}, id).Error
	if err != nil {
		return fmt.Errorf("repository requestAdEquipment `Delete` `Delete`: %w", err)
	}

	return nil
}

func (repo *requestAdEquipment) GetHistoryByID(ctx context.Context, f model.FilterRequestAdEquipment) ([]model.RequestAdEquipment, int, error) {
	if len(f.IDs) == 0 {
		return nil, 0, nil
	}

	res := make([]model.RequestAdEquipment, 0)

	stmt := repo.db.WithContext(ctx).Unscoped().Table("request_ad_equipments_histories")

	if f.UserDetail != nil && *f.UserDetail {
		stmt = stmt.Preload("User")
	}
	if f.ExecutorDetail != nil && *f.ExecutorDetail {
		stmt = stmt.Preload("Executor")
	}
	if f.AdEquipmentDetail != nil && *f.AdEquipmentDetail {
		stmt = stmt.Preload("AdEquipment")
	}

	if len(f.IDs) != 0 {
		stmt = stmt.Where("id IN (?)", f.IDs)
	}

	if len(f.AdEquipmentIDs) != 0 {
		stmt = stmt.Where("ad_equipment_id IN (?)", f.AdEquipmentIDs)
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

	stmt = stmt.Find(&res)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository requestAdEquipment `GetHistoryByID` `Find`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository requestAdEquipment `GetHistoryByID` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}

func (repo *requestAdEquipment) UpdateExecutorID(ctx context.Context, r model.RequestAdEquipment) error {
	value := map[string]interface{}{
		"executor_id": &r.ExecutorID,
	}

	err := repo.db.WithContext(ctx).Model(&model.RequestAdEquipment{}).Where("id = ?", r.ID).Updates(value).Error
	if err != nil {
		return fmt.Errorf("repository requestAdEquipment `UpdateExecutorID` `Updates`: %w", err)
	}

	return nil
}

func (repo *requestAdEquipment) Update(ctx context.Context, r model.RequestAdEquipment) error {
	value := map[string]interface{}{
		"status":      r.Status,
		"executor_id": &r.ExecutorID,
	}

	err := repo.db.WithContext(ctx).Model(&model.RequestAdEquipment{}).Where("id = ?", r.ID).Updates(value).Error
	if err != nil {
		return fmt.Errorf("repository requestAdEquipment `Update` `Updates`: %w", err)
	}

	return nil
}
