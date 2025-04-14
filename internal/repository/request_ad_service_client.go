package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IRequestAdServiceClient interface {
	Get(ctx context.Context, f model.FilterRequestAdServiceClient) ([]model.RequestAdServiceClient, int, error)
	GetByID(ctx context.Context, id int) (model.RequestAdServiceClient, error)
	GetHistoryByID(ctx context.Context, f model.FilterRequestAdServiceClient) ([]model.RequestAdServiceClient, int, error)
	Create(ctx context.Context, r model.RequestAdServiceClient) (int, error)
	Update(ctx context.Context, r model.RequestAdServiceClient) error
	Delete(ctx context.Context, id int) error
}

type requestAdServiceClient struct {
	db *gorm.DB
}

func NewRequestAdServiceClient(db *gorm.DB) IRequestAdServiceClient {
	return &requestAdServiceClient{db: db}
}

func (repo *requestAdServiceClient) Get(ctx context.Context, f model.FilterRequestAdServiceClient) ([]model.RequestAdServiceClient, int, error) {
	res := make([]model.RequestAdServiceClient, 0)

	stmt := repo.db.WithContext(ctx)

	if f.Unscoped != nil && *f.Unscoped {
		stmt = stmt.Unscoped()
	}

	if f.AdServiceClientDetail != nil {
		stmt = stmt.Preload("AdServiceClient").
			Preload("AdServiceClient.ServiceSubCategory")
	}
	if f.UserDetail != nil {
		stmt = stmt.Preload("User")
	}
	if f.ExecutorDetail != nil {
		stmt = stmt.Preload("Executor")
	}
	if f.AdServiceClientDocumentDetail != nil {
		stmt = stmt.Preload("AdServiceClient.Documents")
	}

	if len(f.IDs) != 0 {
		stmt = stmt.Where("id IN (?)", f.IDs)
	}

	if len(f.AdServiceClientIDs) != 0 {
		stmt = stmt.Where("ad_service_client_id IN (?)", f.AdServiceClientIDs)
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
		return nil, 0, fmt.Errorf("repository requestAdServiceClient `Get` `Find`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository requestAdService `Get` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}

func (repo *requestAdServiceClient) GetByID(ctx context.Context, id int) (model.RequestAdServiceClient, error) {
	res := model.RequestAdServiceClient{}

	err := repo.db.
		WithContext(ctx).
		Unscoped().
		Preload("AdServiceClient.User").
		Preload("User").
		Preload("Executor").
		Preload("AdServiceClient.Documents").
		Find(&res, id).Error
	if err != nil {
		return res, fmt.Errorf("repository requestAdServiceClient `GetByID` `Find`: %w", err)
	}

	return res, nil
}

func (repo *requestAdServiceClient) Create(ctx context.Context, r model.RequestAdServiceClient) (int, error) {
	err := repo.db.WithContext(ctx).Create(&r).Error
	if err != nil {
		return 0, fmt.Errorf("repository requestAdServiceClient `Create` `Create`: %w", err)
	}

	return r.ID, nil
}

func (repo *requestAdServiceClient) Update(ctx context.Context, r model.RequestAdServiceClient) error {
	value := map[string]interface{}{
		"executor_id": r.ExecutorID,
		"status":      r.Status,
	}

	err := repo.db.WithContext(ctx).Model(&model.RequestAdServiceClient{}).Where("id = ?", r.ID).Updates(value).Error
	if err != nil {
		return fmt.Errorf("repository requestAdServiceClient `Update` `Updates`: %w", err)
	}

	return nil
}

func (repo *requestAdServiceClient) Delete(ctx context.Context, id int) error {
	err := repo.db.WithContext(ctx).Delete(&model.RequestAdServiceClient{}, id).Error
	if err != nil {
		return fmt.Errorf("repository requestAdServiceClient `Delete` `Delete`: %w", err)
	}

	return nil
}

func (repo *requestAdServiceClient) GetHistoryByID(ctx context.Context, f model.FilterRequestAdServiceClient) ([]model.RequestAdServiceClient, int, error) {
	if len(f.IDs) == 0 {
		return nil, 0, nil
	}

	res := make([]model.RequestAdServiceClient, 0)

	stmt := repo.db.WithContext(ctx).Unscoped().Table("request_ad_service_clients_histories")

	if f.AdServiceClientDetail != nil {
		stmt = stmt.Preload("AdServiceClient")
	}
	if f.UserDetail != nil {
		stmt = stmt.Preload("User")
	}
	if f.ExecutorDetail != nil {
		stmt = stmt.Preload("Executor")
	}

	if len(f.AdServiceClientIDs) != 0 {
		stmt = stmt.Where("ad_service_client_id IN (?)", f.AdServiceClientIDs)
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
		return nil, 0, fmt.Errorf("repository requestAdServiceClient `GetHistoryByID` `Find`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository requestAdServiceClient `GetHistoryByID` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}
