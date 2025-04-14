package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IRequestAdEquipmentClient interface {
	Get(ctx context.Context, f model.FilterRequestAdEquipmentClient) ([]model.RequestAdEquipmentClient, int, error)
	GetByID(ctx context.Context, id int) (model.RequestAdEquipmentClient, error)
	GetHistoryByID(ctx context.Context, f model.FilterRequestAdEquipmentClient) ([]model.RequestAdEquipmentClient, int, error)
	Create(ctx context.Context, r model.RequestAdEquipmentClient) (int, error)
	Update(ctx context.Context, r model.RequestAdEquipmentClient) error
	Delete(ctx context.Context, id int) error
}

type requestAdEquipmentClient struct {
	db *gorm.DB
}

func NewRequestAdEquipmentClient(db *gorm.DB) IRequestAdEquipmentClient {
	return &requestAdEquipmentClient{db: db}
}

func (repo *requestAdEquipmentClient) Get(ctx context.Context, f model.FilterRequestAdEquipmentClient) ([]model.RequestAdEquipmentClient, int, error) {
	res := make([]model.RequestAdEquipmentClient, 0)

	stmt := repo.db.WithContext(ctx)

	if f.Unscoped != nil && *f.Unscoped {
		stmt = stmt.Unscoped()
	}

	if f.AdEquipmentClientDetail != nil {
		stmt = stmt.Preload("AdEquipmentClient")
	}
	if f.UserDetail != nil {
		stmt = stmt.Preload("User")
	}
	if f.ExecutorDetail != nil {
		stmt = stmt.Preload("Executor")
	}
	if f.AdEquipmentClientDocumentDetail != nil {
		stmt = stmt.Preload("AdEquipmentClient.Documents")
	}

	if len(f.IDs) != 0 {
		stmt = stmt.Where("id IN (?)", f.IDs)
	}

	if len(f.AdEquipmentClientIDs) != 0 {
		stmt = stmt.Where("ad_equipment_client_id IN (?)", f.AdEquipmentClientIDs)
	}

	if len(f.ExecutorIDs) != 0 {
		stmt = stmt.Where("executor_id IN (?)", f.ExecutorIDs)
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
		return nil, 0, fmt.Errorf("repository requestAdEquipmentClient `Get` `Find`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository requestAdEquipment `Get` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}

func (repo *requestAdEquipmentClient) GetByID(ctx context.Context, id int) (model.RequestAdEquipmentClient, error) {
	res := model.RequestAdEquipmentClient{}

	err := repo.db.
		WithContext(ctx).
		Unscoped().
		Preload("AdEquipmentClient").
		Preload("User").
		Preload("Executor").
		Preload("AdEquipmentClient.Documents").
		Find(&res, id).Error
	if err != nil {
		return res, fmt.Errorf("repository requestAdEquipmentClient `GetByID` `Find`: %w", err)
	}

	return res, nil
}

func (repo *requestAdEquipmentClient) Create(ctx context.Context, r model.RequestAdEquipmentClient) (int, error) {
	err := repo.db.WithContext(ctx).Create(&r).Error
	if err != nil {
		return 0, fmt.Errorf("repository requestAdEquipmentClient `Create` `Create`: %w", err)
	}

	return r.ID, nil
}

func (repo *requestAdEquipmentClient) Update(ctx context.Context, r model.RequestAdEquipmentClient) error {
	value := map[string]interface{}{
		"executor_id": r.ExecutorID,
		"status":      r.Status,
	}

	err := repo.db.WithContext(ctx).Model(&model.RequestAdEquipmentClient{}).Where("id = ?", r.ID).Updates(value).Error
	if err != nil {
		return fmt.Errorf("repository requestAdEquipmentClient `Update` `Updates`: %w", err)
	}

	return nil
}

func (repo *requestAdEquipmentClient) Delete(ctx context.Context, id int) error {
	err := repo.db.WithContext(ctx).Delete(&model.RequestAdEquipmentClient{}, id).Error
	if err != nil {
		return fmt.Errorf("repository requestAdEquipmentClient `Delete` `Delete`: %w", err)
	}

	return nil
}

func (repo *requestAdEquipmentClient) GetHistoryByID(ctx context.Context, f model.FilterRequestAdEquipmentClient) ([]model.RequestAdEquipmentClient, int, error) {
	if len(f.IDs) == 0 {
		return nil, 0, nil
	}

	res := make([]model.RequestAdEquipmentClient, 0)

	stmt := repo.db.WithContext(ctx).Unscoped().Table("request_ad_equipment_clients_histories")

	if f.AdEquipmentClientDetail != nil {
		stmt = stmt.Preload("AdEquipmentClient")
	}
	if f.UserDetail != nil {
		stmt = stmt.Preload("User")
	}
	if f.ExecutorDetail != nil {
		stmt = stmt.Preload("Executor")
	}

	if len(f.AdEquipmentClientIDs) != 0 {
		stmt = stmt.Where("ad_equipment_client_id IN (?)", f.AdEquipmentClientIDs)
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
		return nil, 0, fmt.Errorf("repository requestAdEquipmentClient `GetHistoryByID` `Find`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository requestAdEquipmentClient `GetHistoryByID` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}
