package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IRequestAdConstructionMaterial interface {
	Get(ctx context.Context, f model.FilterRequestAdConstructionMaterial) ([]model.RequestAdConstructionMaterial, int, error)
	GetByID(ctx context.Context, id int) (model.RequestAdConstructionMaterial, error)
	GetHistoryByID(ctx context.Context, f model.FilterRequestAdConstructionMaterial) ([]model.RequestAdConstructionMaterial, int, error)
	Create(ctx context.Context, r model.RequestAdConstructionMaterial) (int, error)
	Update(ctx context.Context, r model.RequestAdConstructionMaterial) error
	Delete(ctx context.Context, id int) error
}

type requestAdConstructionMaterial struct {
	db *gorm.DB
}

func NewRequestAdConstructionMaterial(db *gorm.DB) IRequestAdConstructionMaterial {
	return &requestAdConstructionMaterial{db: db}
}

func (repo *requestAdConstructionMaterial) Get(ctx context.Context, f model.FilterRequestAdConstructionMaterial) ([]model.RequestAdConstructionMaterial, int, error) {
	res := make([]model.RequestAdConstructionMaterial, 0)

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
	if f.AdConstructionMaterialDetail != nil && *f.AdConstructionMaterialDetail {
		stmt = stmt.Preload("AdConstructionMaterial").
			Preload("AdConstructionMaterial.ConstructionMaterialBrand").
			Preload("AdConstructionMaterial.ConstructionMaterialSubCategory")
	}
	if f.DocumentDetail != nil && *f.DocumentDetail {
		stmt = stmt.Preload("Document")
	}

	if len(f.IDs) != 0 {
		stmt = stmt.Where("id IN (?)", f.IDs)
	}

	if len(f.AdConstructionMaterialIDs) != 0 {
		stmt = stmt.Where("ad_construction_material_id IN (?)", f.AdConstructionMaterialIDs)
	}

	if len(f.AdConstructionMaterialUserIDs) != 0 {
		stmt = stmt.Where("ad_construction_material_id in (select id from ad_construction_materials where user_id = ?)", f.AdConstructionMaterialUserIDs)
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
		return nil, 0, fmt.Errorf("repository requestAdConstructionMaterial `Get` `Find`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository requestAdConstructionMaterial `Get` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}

func (repo *requestAdConstructionMaterial) GetByID(ctx context.Context, id int) (model.RequestAdConstructionMaterial, error) {
	res := model.RequestAdConstructionMaterial{}

	err := repo.db.
		WithContext(ctx).
		Unscoped().
		Preload("User").
		Preload("Executor").
		Preload("AdConstructionMaterial").
		Preload("AdConstructionMaterial.ConstructionMaterialBrand").
		Preload("AdConstructionMaterial.ConstructionMaterialSubCategory").
		Preload("AdConstructionMaterial.Documents").
		Preload("Document").
		Find(&res, id).Error
	if err != nil {
		return res, fmt.Errorf("repository requestAdConstructionMaterial `GetByID` `Find`: %w", err)
	}

	return res, nil
}

func (repo *requestAdConstructionMaterial) Create(ctx context.Context, r model.RequestAdConstructionMaterial) (int, error) {
	err := repo.db.WithContext(ctx).Create(&r).Error
	if err != nil {
		return 0, fmt.Errorf("repository requestAdConstructionMaterial `Create` `Create`: %w", err)
	}

	return r.ID, nil
}

func (repo *requestAdConstructionMaterial) UpdateStatus(ctx context.Context, r model.RequestAdConstructionMaterial) error {
	value := map[string]interface{}{
		"status": r.Status,
	}

	err := repo.db.WithContext(ctx).Model(&model.RequestAdConstructionMaterial{}).Where("id = ?", r.ID).Updates(value).Error
	if err != nil {
		return fmt.Errorf("repository requestAdConstructionMaterial `Update` `Updates`: %w", err)
	}

	return nil
}

func (repo *requestAdConstructionMaterial) Delete(ctx context.Context, id int) error {
	err := repo.db.WithContext(ctx).Delete(&model.RequestAdConstructionMaterial{}, id).Error
	if err != nil {
		return fmt.Errorf("repository requestAdConstructionMaterial `Delete` `Delete`: %w", err)
	}

	return nil
}

func (repo *requestAdConstructionMaterial) GetHistoryByID(ctx context.Context, f model.FilterRequestAdConstructionMaterial) ([]model.RequestAdConstructionMaterial, int, error) {
	if len(f.IDs) == 0 {
		return nil, 0, nil
	}

	res := make([]model.RequestAdConstructionMaterial, 0)

	stmt := repo.db.WithContext(ctx).Unscoped().Table("request_ad_construction_materials_histories")

	if f.UserDetail != nil && *f.UserDetail {
		stmt = stmt.Preload("User")
	}
	if f.ExecutorDetail != nil && *f.ExecutorDetail {
		stmt = stmt.Preload("Executor")
	}
	if f.AdConstructionMaterialDetail != nil && *f.AdConstructionMaterialDetail {
		stmt = stmt.Preload("AdConstructionMaterial")
	}

	if len(f.IDs) != 0 {
		stmt = stmt.Where("id IN (?)", f.IDs)
	}

	if len(f.AdConstructionMaterialIDs) != 0 {
		stmt = stmt.Where("ad_construction_material_id IN (?)", f.AdConstructionMaterialIDs)
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
		return nil, 0, fmt.Errorf("repository requestAdConstructionMaterial `GetHistoryByID` `Find`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository requestAdConstructionMaterial `GetHistoryByID` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}

func (repo *requestAdConstructionMaterial) UpdateExecutorID(ctx context.Context, r model.RequestAdConstructionMaterial) error {
	value := map[string]interface{}{
		"executor_id": &r.ExecutorID,
	}

	err := repo.db.WithContext(ctx).Model(&model.RequestAdConstructionMaterial{}).Where("id = ?", r.ID).Updates(value).Error
	if err != nil {
		return fmt.Errorf("repository requestAdConstructionMaterial `UpdateExecutorID` `Updates`: %w", err)
	}

	return nil
}

func (repo *requestAdConstructionMaterial) Update(ctx context.Context, r model.RequestAdConstructionMaterial) error {
	value := map[string]interface{}{
		"status":      r.Status,
		"executor_id": &r.ExecutorID,
	}

	err := repo.db.WithContext(ctx).Model(&model.RequestAdConstructionMaterial{}).Where("id = ?", r.ID).Updates(value).Error
	if err != nil {
		return fmt.Errorf("repository requestAdConstructionMaterial `Update` `Updates`: %w", err)
	}

	return nil
}
