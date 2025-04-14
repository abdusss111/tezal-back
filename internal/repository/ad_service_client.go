package repository

import (
	"context"
	"database/sql"
	"errors"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IAdServiceClient interface {
	Get(ctx context.Context, f model.FilterAdServiceClients) ([]model.AdServiceClient, int, error)
	GetByID(ctx context.Context, id int) (model.AdServiceClient, error)
	Create(ctx context.Context, ad model.AdServiceClient) (int, error)
	Update(ctx context.Context, ad model.AdServiceClient) error
	UpdateStatus(ctx context.Context, ad model.AdServiceClient) error
	Delete(ctx context.Context, id int) error
	GetByIDSeen(ctx context.Context, id int) (int, error)
	CreateSeen(ctx context.Context, id int) error
	IncrementSeen(ctx context.Context, id int) error
}

type adServiceClient struct {
	db *gorm.DB
}

func NewAdServiceClient(db *gorm.DB) IAdServiceClient {
	return &adServiceClient{db: db}
}

func (repo *adServiceClient) Get(ctx context.Context, f model.FilterAdServiceClients) ([]model.AdServiceClient, int, error) {
	res := make([]model.AdServiceClient, 0)

	stmt := repo.db.WithContext(ctx)

	if f.UserDetail != nil && *f.UserDetail {
		stmt = stmt.Preload("User")
	}
	if f.CityDetail != nil && *f.CityDetail {
		stmt = stmt.Preload("City")
	}
	if f.ServiceSubСategoryDetail != nil && *f.ServiceSubСategoryDetail {
		stmt = stmt.Preload("ServiceSubCategory")
	}
	if f.DocumentsDetail != nil && *f.DocumentsDetail {
		stmt = stmt.Preload("Documents")
	}
	if f.Unscoped != nil && *f.Unscoped {
		stmt = stmt.Unscoped()
	}

	if len(f.IDs) != 0 {
		stmt = stmt.Where("id in (?)", f.IDs)
	}

	if len(f.UserIDs) != 0 {
		stmt = stmt.Where("user_id in (?)", f.UserIDs)
	}

	if len(f.CityIDs) != 0 {
		stmt = stmt.Where("city_id in (?)", f.CityIDs)
	}

	if len(f.ServiceSubСategoryIDs) != 0 {
		stmt = stmt.Where("service_sub_category_id in (?)", f.ServiceSubСategoryIDs)
	}

	if len(f.ServiceСategoryIDs) != 0 {
		stmt = stmt.Where(`service_sub_category_id in (SELECT id
			FROM service_sub_categories
			WHERE service_categories_id = ?)`, f.ServiceСategoryIDs)
	}

	if f.Status != nil {
		stmt = stmt.Where("status = ?", f.Status)
	}

	if f.Title != nil {
		stmt = stmt.Where("title ILIKE '%' || ? || '%'", f.Title)
	}

	if f.Description != nil {
		stmt = stmt.Where("description ILIKE '%' || ? || '%'", f.Description)
	}

	stmt = setFilterParamByStmt(stmt, "price", f.Price)

	if len(f.ASC) != 0 {
		for _, v := range f.ASC {
			stmt = stmt.Order(fmt.Sprintf("%s ASC", v))
		}
	}
	if len(f.DESC) != 0 {
		for _, v := range f.DESC {
			stmt = stmt.Order(fmt.Sprintf("%s DESC", v))
		}
	}
	if f.Limit != nil {
		stmt = stmt.Limit(*f.Limit)
	}
	if f.Offset != nil {
		stmt = stmt.Offset(*f.Offset)
	}

	stmt = stmt.Find(&res)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository adServiceClient `Get` `Find`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository adServiceClient `Get` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}

func (repo *adServiceClient) GetByID(ctx context.Context, id int) (model.AdServiceClient, error) {
	res := model.AdServiceClient{}

	err := repo.db.WithContext(ctx).
		Unscoped().
		Preload("User").
		Preload("City").
		Preload("ServiceSubCategory").
		Preload("Documents").
		Find(&res, id).Error
	if err != nil {
		return res, fmt.Errorf("repository adServiceClient `GetByID` `Find`: %w", err)
	}

	return res, nil
}

func (repo *adServiceClient) Create(ctx context.Context, ad model.AdServiceClient) (int, error) {
	err := repo.db.WithContext(ctx).Create(&ad).Error
	if err != nil {
		return 0, fmt.Errorf("repository adServiceClient `Create` `Create`: %w", err)
	}

	return ad.ID, nil
}

func (repo *adServiceClient) Update(ctx context.Context, ad model.AdServiceClient) error {
	value := map[string]interface{}{
		"user_id":                 ad.UserID,
		"city_id":                 ad.CityID,
		"service_sub_category_id": ad.ServiceSubCategoryID,
		"status":                  ad.Status,
		"title":                   ad.Title,
		"description":             ad.Description,
		"price":                   ad.Price,
		"start_lease_date":        ad.StartLeaseAt,
		"end_lease_date":          ad.EndLeaseAt,
		"address":                 ad.Address,
		"latitude":                ad.Latitude,
		"longitude":               ad.Longitude,
	}

	err := repo.db.WithContext(ctx).Model(&model.AdServiceClient{}).Where("id = ?", ad.ID).Updates(value).Error
	if err != nil {
		return fmt.Errorf("repository adServiceClient `Update` `Updates`: %w", err)
	}

	return nil
}

func (repo *adServiceClient) UpdateStatus(ctx context.Context, ad model.AdServiceClient) error {
	value := map[string]interface{}{
		"status": ad.Status,
	}

	err := repo.db.WithContext(ctx).Model(&model.AdServiceClient{}).Where("id = ?", ad.ID).Updates(value).Error
	if err != nil {
		return fmt.Errorf("repository adServiceClient `Update` `Updates`: %w", err)
	}

	return nil
}

func (repo *adServiceClient) Delete(ctx context.Context, id int) error {
	err := repo.db.WithContext(ctx).Delete(&model.AdServiceClient{}, id).Error
	if err != nil {
		return fmt.Errorf("repository adServiceClient `Delete` `Delete`: %w", err)
	}

	return nil
}

func (repo *adServiceClient) GetByIDSeen(ctx context.Context, id int) (int, error) {
	stmt := repo.db.WithContext(ctx).Table("ad_service_client_seen")

	rows := stmt.Where("ad_service_client_id = ?", id).Select("count").Row()
	if rows.Err() != nil {
		return 0, fmt.Errorf("repository adServiceClient `GetByIDSeen`: %w", rows.Err())
	}

	count := 0

	err := rows.Scan(&count)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return 0, fmt.Errorf("repository adServiceClient `GetByIDSeen`: %w", model.ErrNotFound)
		}
		return 0, fmt.Errorf("repository adServiceClient `GetByIDSeen`: %w", err)
	}

	return count, nil
}

func (repo *adServiceClient) CreateSeen(ctx context.Context, id int) error {
	stmt := repo.db.WithContext(ctx).Table("ad_service_client_seen")

	stmt = stmt.Exec(`INSERT INTO ad_service_client_seen (ad_service_client_id)
	VALUES (?)`, id)
	if stmt.Error != nil {
		return fmt.Errorf("repository adServiceClient `CreateSeen`: %w", stmt.Error)
	}

	return nil
}

func (repo *adServiceClient) IncrementSeen(ctx context.Context, id int) error {
	stmt := repo.db.WithContext(ctx).Table("ad_service_client_seen")

	stmt = stmt.Exec(`UPDATE ad_service_client_seen
	SET count = count + 1
	WHERE ad_service_client_id = ?`, id)
	if stmt.Error != nil {
		if errors.Is(stmt.Error, gorm.ErrRecordNotFound) {
			return fmt.Errorf("repository adServiceClient `IncrementSeen`: %w", model.ErrNotFound)
		}
		return fmt.Errorf("repository adServiceClient `IncrementSeen`: %w", stmt.Error)
	}

	return nil
}
