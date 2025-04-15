package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IRequestAdConstructionMaterialClient interface {
	Get(ctx context.Context, f model.FilterRequestAdConstructionMaterialClient) ([]model.RequestAdConstructionMaterialClient, int, error)
	GetByID(ctx context.Context, id int) (model.RequestAdConstructionMaterialClient, error)
	GetHistoryByID(ctx context.Context, f model.FilterRequestAdConstructionMaterialClient) ([]model.RequestAdConstructionMaterialClient, int, error)
	Create(ctx context.Context, r model.RequestAdConstructionMaterialClient) (int, error)
	Update(ctx context.Context, r model.RequestAdConstructionMaterialClient) error
	Delete(ctx context.Context, id int) error
}

type requestAdConstructionMaterialClient struct {
	db *gorm.DB
}

func NewRequestAdConstructionMaterialClient(db *gorm.DB) IRequestAdConstructionMaterialClient {
	return &requestAdConstructionMaterialClient{db: db}
}

func (repo *requestAdConstructionMaterialClient) Get(ctx context.Context, f model.FilterRequestAdConstructionMaterialClient) ([]model.RequestAdConstructionMaterialClient, int, error) {
	res := make([]model.RequestAdConstructionMaterialClient, 0)

	stmt := repo.db.WithContext(ctx)

	if f.Unscoped != nil && *f.Unscoped {
		stmt = stmt.Unscoped()
	}

	if f.AdConstructionMaterialClientDetail != nil {
		stmt = stmt.Preload("AdConstructionMaterialClient").
			Preload("AdConstructionMaterialClient.ConstructionMaterialSubCategory").
			Preload("AdConstructionMaterialClient.City")
	}
	if f.UserDetail != nil {
		stmt = stmt.Preload("User")
	}
	if f.ExecutorDetail != nil {
		stmt = stmt.Preload("Executor")
	}
	if f.AdConstructionMaterialClientDocumentDetail != nil {
		stmt = stmt.Preload("AdConstructionMaterialClient.Documents")
	}

	if len(f.IDs) != 0 {
		stmt = stmt.Where("id IN (?)", f.IDs)
	}

	if len(f.AdConstructionMaterialClientIDs) != 0 {
		stmt = stmt.Where("ad_construction_material_client_id IN (?)", f.AdConstructionMaterialClientIDs)
	}

	if len(f.UserIDs) != 0 {
		stmt = stmt.Where("user_id IN (?)", f.UserIDs)
	}

	if len(f.ExecutorIDs) != 0 {
		stmt = stmt.Where("executor_id IN (?)", f.ExecutorIDs)
	}

	if f.Status != nil {
		stmt = stmt.Where("status = ?", f.Status)
	}

	if f.Description != nil {
		stmt = stmt.Where("description ILIKE '%' || ? || '%'", f.Description)
	}

	if f.Limit != nil {
		stmt = stmt.Limit(*f.Limit)
	}
	if f.Offset != nil {
		stmt = stmt.Offset(*f.Offset)
	}

	stmt = stmt.Order("id DESC")

	stmt = stmt.Find(&res)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository requestAdConstructionMaterialClient `Get` `Find`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository requestAdConstructionMaterial `Get` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}

func (repo *requestAdConstructionMaterialClient) GetByID(ctx context.Context, id int) (model.RequestAdConstructionMaterialClient, error) {
	res := model.RequestAdConstructionMaterialClient{}

	err := repo.db.
		WithContext(ctx).
		Unscoped().
		Preload("AdConstructionMaterialClient.User").
		Preload("User").
		Preload("Executor").
		Preload("AdConstructionMaterialClient.Documents").
		Find(&res, id).Error
	if err != nil {
		return res, fmt.Errorf("repository requestAdConstructionMaterialClient `GetByID` `Find`: %w", err)
	}

	return res, nil
}

func (repo *requestAdConstructionMaterialClient) Create(ctx context.Context, r model.RequestAdConstructionMaterialClient) (int, error) {
	err := repo.db.WithContext(ctx).Create(&r).Error
	if err != nil {
		return 0, fmt.Errorf("repository requestAdConstructionMaterialClient `Create` `Create`: %w", err)
	}

	return r.ID, nil
}

func (repo *requestAdConstructionMaterialClient) Update(ctx context.Context, r model.RequestAdConstructionMaterialClient) error {
	value := map[string]interface{}{
		"executor_id": r.ExecutorID,
		"status":      r.Status,
	}

	err := repo.db.WithContext(ctx).Model(&model.RequestAdConstructionMaterialClient{}).Where("id = ?", r.ID).Updates(value).Error
	if err != nil {
		return fmt.Errorf("repository requestAdConstructionMaterialClient `Update` `Updates`: %w", err)
	}

	return nil
}

func (repo *requestAdConstructionMaterialClient) Delete(ctx context.Context, id int) error {
	err := repo.db.WithContext(ctx).Delete(&model.RequestAdConstructionMaterialClient{}, id).Error
	if err != nil {
		return fmt.Errorf("repository requestAdConstructionMaterialClient `Delete` `Delete`: %w", err)
	}

	return nil
}

func (repo *requestAdConstructionMaterialClient) GetHistoryByID(ctx context.Context, f model.FilterRequestAdConstructionMaterialClient) ([]model.RequestAdConstructionMaterialClient, int, error) {
	if len(f.IDs) == 0 {
		return nil, 0, nil
	}

	res := make([]model.RequestAdConstructionMaterialClient, 0)

	stmt := repo.db.WithContext(ctx).Unscoped().Table("request_ad_construction_material_clients_histories")

	if f.AdConstructionMaterialClientDetail != nil {
		stmt = stmt.Preload("AdConstructionMaterialClient")
	}
	if f.UserDetail != nil {
		stmt = stmt.Preload("User")
	}
	if f.ExecutorDetail != nil {
		stmt = stmt.Preload("Executor")
	}

	if len(f.AdConstructionMaterialClientIDs) != 0 {
		stmt = stmt.Where("ad_construction_material_client_id IN (?)", f.AdConstructionMaterialClientIDs)
	}

	if len(f.UserIDs) != 0 {
		stmt = stmt.Where("user_id IN (?)", f.UserIDs)
	}

	if len(f.ExecutorIDs) != 0 {
		stmt = stmt.Where("executor_id IN (?)", f.ExecutorIDs)
	}

	if f.Status != nil {
		stmt = stmt.Where("status = ?", f.Status)
	}

	if f.Description != nil {
		stmt = stmt.Where("description ILIKE '%' || ? || '%'", f.Description)
	}

	if f.Limit != nil {
		stmt = stmt.Limit(*f.Limit)
	}
	if f.Offset != nil {
		stmt = stmt.Offset(*f.Offset)
	}

	stmt = stmt.Find(&res)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository requestAdConstructionMaterialClient `GetHistoryByID` `Find`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository requestAdConstructionMaterialClient `GetHistoryByID` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}
