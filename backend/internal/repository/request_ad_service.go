package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IRequestAdService interface {
	Get(ctx context.Context, f model.FilterRequestAdService) ([]model.RequestAdService, int, error)
	GetByID(ctx context.Context, id int) (model.RequestAdService, error)
	GetHistoryByID(ctx context.Context, f model.FilterRequestAdService) ([]model.RequestAdService, int, error)
	Create(ctx context.Context, r model.RequestAdService) (int, error)
	Update(ctx context.Context, r model.RequestAdService) error
	Delete(ctx context.Context, id int) error
}

type requestAdService struct {
	db *gorm.DB
}

func NewRequestAdService(db *gorm.DB) IRequestAdService {
	return &requestAdService{db: db}
}

func (repo *requestAdService) Get(ctx context.Context, f model.FilterRequestAdService) ([]model.RequestAdService, int, error) {
	res := make([]model.RequestAdService, 0)

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
	if f.AdServiceDetail != nil && *f.AdServiceDetail {
		stmt = stmt.Preload("AdService").
			Preload("AdService.ServiceSubCategory").
			Preload("AdService.ServiceBrand")
	}
	if f.DocumentDetail != nil && *f.DocumentDetail {
		stmt = stmt.Preload("Document")
	}

	if len(f.IDs) != 0 {
		stmt = stmt.Where("id IN (?)", f.IDs)
	}

	if len(f.AdServiceIDs) != 0 {
		stmt = stmt.Where("ad_service_id IN (?)", f.AdServiceIDs)
	}

	if len(f.AdServiceUserIDs) != 0 {
		stmt = stmt.Where("ad_service_id in (select id from ad_services where user_id = ?)", f.AdServiceUserIDs)
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

	stmt = stmt.Order("id DESC")

	stmt = stmt.Find(&res)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository requestAdService `Get` `Find`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository requestAdService `Get` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}

func (repo *requestAdService) GetByID(ctx context.Context, id int) (model.RequestAdService, error) {
	res := model.RequestAdService{}

	err := repo.db.
		WithContext(ctx).
		Unscoped().
		Preload("User").
		Preload("Executor").
		Preload("AdService").
		Preload("AdService.ServiceBrand").
		Preload("AdService.ServiceSubCategory").
		Preload("AdService.Documents").
		Preload("AdService.User").
		Preload("Document").
		Find(&res, id).Error
	if err != nil {
		return res, fmt.Errorf("repository requestAdService `GetByID` `Find`: %w", err)
	}

	return res, nil
}

func (repo *requestAdService) Create(ctx context.Context, r model.RequestAdService) (int, error) {
	err := repo.db.WithContext(ctx).Create(&r).Error
	if err != nil {
		return 0, fmt.Errorf("repository requestAdService `Create` `Create`: %w", err)
	}

	return r.ID, nil
}

func (repo *requestAdService) UpdateStatus(ctx context.Context, r model.RequestAdService) error {
	value := map[string]interface{}{
		"status": r.Status,
	}

	err := repo.db.WithContext(ctx).Model(&model.RequestAdService{}).Where("id = ?", r.ID).Updates(value).Error
	if err != nil {
		return fmt.Errorf("repository requestAdService `Update` `Updates`: %w", err)
	}

	return nil
}

func (repo *requestAdService) Delete(ctx context.Context, id int) error {
	err := repo.db.WithContext(ctx).Delete(&model.RequestAdService{}, id).Error
	if err != nil {
		return fmt.Errorf("repository requestAdService `Delete` `Delete`: %w", err)
	}

	return nil
}

func (repo *requestAdService) GetHistoryByID(ctx context.Context, f model.FilterRequestAdService) ([]model.RequestAdService, int, error) {
	if len(f.IDs) == 0 {
		return nil, 0, nil
	}

	res := make([]model.RequestAdService, 0)

	stmt := repo.db.WithContext(ctx).Unscoped().Table("request_ad_services_histories")

	if f.UserDetail != nil && *f.UserDetail {
		stmt = stmt.Preload("User")
	}
	if f.ExecutorDetail != nil && *f.ExecutorDetail {
		stmt = stmt.Preload("Executor")
	}
	if f.AdServiceDetail != nil && *f.AdServiceDetail {
		stmt = stmt.Preload("AdService")
	}

	if len(f.IDs) != 0 {
		stmt = stmt.Where("id IN (?)", f.IDs)
	}

	if len(f.AdServiceIDs) != 0 {
		stmt = stmt.Where("ad_service_id IN (?)", f.AdServiceIDs)
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
		return nil, 0, fmt.Errorf("repository requestAdService `GetHistoryByID` `Find`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository requestAdService `GetHistoryByID` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}

func (repo *requestAdService) UpdateExecutorID(ctx context.Context, r model.RequestAdService) error {
	value := map[string]interface{}{
		"executor_id": &r.ExecutorID,
	}

	err := repo.db.WithContext(ctx).Model(&model.RequestAdService{}).Where("id = ?", r.ID).Updates(value).Error
	if err != nil {
		return fmt.Errorf("repository requestAdService `UpdateExecutorID` `Updates`: %w", err)
	}

	return nil
}

func (repo *requestAdService) Update(ctx context.Context, r model.RequestAdService) error {
	value := map[string]interface{}{
		"status":      r.Status,
		"executor_id": &r.ExecutorID,
	}

	err := repo.db.WithContext(ctx).Model(&model.RequestAdService{}).Where("id = ?", r.ID).Updates(value).Error
	if err != nil {
		return fmt.Errorf("repository requestAdService `Update` `Updates`: %w", err)
	}

	return nil
}
