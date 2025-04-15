package repository

import (
	"context"
	"database/sql"
	"errors"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IAdConstructionMaterialClient interface {
	Get(ctx context.Context, f model.FilterAdConstructionMaterialClients) ([]model.AdConstructionMaterialClient, int, error)
	GetByID(ctx context.Context, id int) (model.AdConstructionMaterialClient, error)
	Create(ctx context.Context, ad model.AdConstructionMaterialClient) (int, error)
	Update(ctx context.Context, ad model.AdConstructionMaterialClient) error
	UpdateStatus(ctx context.Context, ad model.AdConstructionMaterialClient) error
	Delete(ctx context.Context, id int) error
	GetByIDSeen(ctx context.Context, id int) (int, error)
	CreateSeen(ctx context.Context, id int) error
	IncrementSeen(ctx context.Context, id int) error
}

type adConstructionMaterialClient struct {
	db *gorm.DB
}

func NewAdConstructionMaterialClient(db *gorm.DB) IAdConstructionMaterialClient {
	return &adConstructionMaterialClient{db: db}
}

func (repo *adConstructionMaterialClient) Get(ctx context.Context, f model.FilterAdConstructionMaterialClients) ([]model.AdConstructionMaterialClient, int, error) {
	res := make([]model.AdConstructionMaterialClient, 0)

	stmt := repo.db.WithContext(ctx)

	if f.UserDetail != nil && *f.UserDetail {
		stmt = stmt.Preload("User")
	}
	if f.CityDetail != nil && *f.CityDetail {
		stmt = stmt.Preload("City")
	}
	if f.ConstructionMaterialSubСategoryDetail != nil && *f.ConstructionMaterialSubСategoryDetail {
		stmt = stmt.Preload("ConstructionMaterialSubCategory")
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

	if len(f.ConstructionMaterialSubСategoryIDs) != 0 {
		stmt = stmt.Where("construction_material_sub_category_id in (?)", f.ConstructionMaterialSubСategoryIDs)
	}

	if len(f.ConstructionMaterialСategoryIDs) != 0 {
		stmt = stmt.Where(`construction_material_sub_category_id in (SELECT id
			FROM construction_material_sub_categories
			WHERE construction_material_categories_id = ?)`, f.ConstructionMaterialСategoryIDs)
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
		return nil, 0, fmt.Errorf("repository adConstructionMaterialClient `Get` `Find`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository adConstructionMaterialClient `Get` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}

func (repo *adConstructionMaterialClient) GetByID(ctx context.Context, id int) (model.AdConstructionMaterialClient, error) {
	res := model.AdConstructionMaterialClient{}

	err := repo.db.WithContext(ctx).
		Unscoped().
		Preload("User").
		Preload("City").
		Preload("ConstructionMaterialSubCategory").
		Preload("Documents").
		Find(&res, id).Error
	if err != nil {
		return res, fmt.Errorf("repository adConstructionMaterialClient `GetByID` `Find`: %w", err)
	}

	return res, nil
}

func (repo *adConstructionMaterialClient) Create(ctx context.Context, ad model.AdConstructionMaterialClient) (int, error) {
	err := repo.db.WithContext(ctx).Create(&ad).Error
	if err != nil {
		return 0, fmt.Errorf("repository adConstructionMaterialClient `Create` `Create`: %w", err)
	}

	return ad.ID, nil
}

func (repo *adConstructionMaterialClient) Update(ctx context.Context, ad model.AdConstructionMaterialClient) error {
	value := map[string]interface{}{
		"user_id":                               ad.UserID,
		"city_id":                               ad.CityID,
		"construction_material_sub_category_id": ad.ConstructionMaterialSubCategoryID,
		"status":                                ad.Status,
		"title":                                 ad.Title,
		"description":                           ad.Description,
		"price":                                 ad.Price,
		"start_lease_date":                      ad.StartLeaseAt,
		"end_lease_date":                        ad.EndLeaseAt,
		"address":                               ad.Address,
		"latitude":                              ad.Latitude,
		"longitude":                             ad.Longitude,
	}

	err := repo.db.WithContext(ctx).Model(&model.AdConstructionMaterialClient{}).Where("id = ?", ad.ID).Updates(value).Error
	if err != nil {
		return fmt.Errorf("repository adConstructionMaterialClient `Update` `Updates`: %w", err)
	}

	return nil
}

func (repo *adConstructionMaterialClient) UpdateStatus(ctx context.Context, ad model.AdConstructionMaterialClient) error {
	value := map[string]interface{}{
		"status": ad.Status,
	}

	err := repo.db.WithContext(ctx).Model(&model.AdConstructionMaterialClient{}).Where("id = ?", ad.ID).Updates(value).Error
	if err != nil {
		return fmt.Errorf("repository adConstructionMaterialClient `Update` `Updates`: %w", err)
	}

	return nil
}

func (repo *adConstructionMaterialClient) Delete(ctx context.Context, id int) error {
	err := repo.db.WithContext(ctx).Delete(&model.AdConstructionMaterialClient{}, id).Error
	if err != nil {
		return fmt.Errorf("repository adConstructionMaterialClient `Delete` `Delete`: %w", err)
	}

	return nil
}

func (repo *adConstructionMaterialClient) GetByIDSeen(ctx context.Context, id int) (int, error) {
	stmt := repo.db.WithContext(ctx).Table("ad_construction_material_client_seen")

	rows := stmt.Where("ad_construction_material_client_id = ?", id).Select("count").Row()
	if rows.Err() != nil {
		return 0, fmt.Errorf("repository adConstructionMaterialClient `GetByIDSeen`: %w", rows.Err())
	}

	count := 0

	err := rows.Scan(&count)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return 0, fmt.Errorf("repository adConstructionMaterialClient `GetByIDSeen`: %w", model.ErrNotFound)
		}
		return 0, fmt.Errorf("repository adConstructionMaterialClient `GetByIDSeen`: %w", err)
	}

	return count, nil
}

func (repo *adConstructionMaterialClient) CreateSeen(ctx context.Context, id int) error {
	stmt := repo.db.WithContext(ctx).Table("ad_construction_material_client_seen")

	stmt = stmt.Exec(`INSERT INTO ad_construction_material_client_seen (ad_construction_material_client_id)
	VALUES (?)`, id)
	if stmt.Error != nil {
		return fmt.Errorf("repository adConstructionMaterialClient `CreateSeen`: %w", stmt.Error)
	}

	return nil
}

func (repo *adConstructionMaterialClient) IncrementSeen(ctx context.Context, id int) error {
	stmt := repo.db.WithContext(ctx).Table("ad_construction_material_client_seen")

	stmt = stmt.Exec(`UPDATE ad_construction_material_client_seen
	SET count = count + 1
	WHERE ad_construction_material_client_id = ?`, id)
	if stmt.Error != nil {
		if errors.Is(stmt.Error, gorm.ErrRecordNotFound) {
			return fmt.Errorf("repository adConstructionMaterialClient `IncrementSeen`: %w", model.ErrNotFound)
		}
		return fmt.Errorf("repository adConstructionMaterialClient `IncrementSeen`: %w", stmt.Error)
	}

	return nil
}
