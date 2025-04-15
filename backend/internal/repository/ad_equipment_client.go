package repository

import (
	"context"
	"database/sql"
	"errors"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IAdEquipmentClient interface {
	Get(ctx context.Context, f model.FilterAdEquipmentClients) ([]model.AdEquipmentClient, int, error)
	GetByID(ctx context.Context, id int) (model.AdEquipmentClient, error)
	Create(ctx context.Context, ad model.AdEquipmentClient) (int, error)
	Update(ctx context.Context, ad model.AdEquipmentClient) error
	UpdateStatus(ctx context.Context, ad model.AdEquipmentClient) error
	Delete(ctx context.Context, id int) error
	GetByIDSeen(ctx context.Context, id int) (int, error)
	CreateSeen(ctx context.Context, id int) error
	IncrementSeen(ctx context.Context, id int) error
}

type adEquipmentClient struct {
	db *gorm.DB
}

func NewAdEquipmentClient(db *gorm.DB) IAdEquipmentClient {
	return &adEquipmentClient{db: db}
}

func (repo *adEquipmentClient) Get(ctx context.Context, f model.FilterAdEquipmentClients) ([]model.AdEquipmentClient, int, error) {
	res := make([]model.AdEquipmentClient, 0)

	stmt := repo.db.WithContext(ctx)

	if f.UserDetail != nil && *f.UserDetail {
		stmt = stmt.Preload("User")
	}
	if f.CityDetail != nil && *f.CityDetail {
		stmt = stmt.Preload("City")
	}
	if f.EquipmentSubСategoryDetail != nil && *f.EquipmentSubСategoryDetail {
		stmt = stmt.Preload("EquipmentSubCategory")
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

	if len(f.EquipmentSubСategoryIDs) != 0 {
		stmt = stmt.Where("equipment_sub_category_id in (?)", f.EquipmentSubСategoryIDs)
	}

	if len(f.EquipmentСategoryIDs) != 0 {
		stmt = stmt.Where(`equipment_sub_category_id in (SELECT id
			FROM equipment_sub_categories
			WHERE equipment_categories_id = ?)`, f.EquipmentСategoryIDs)
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
		return nil, 0, fmt.Errorf("repository adEquipmentClient `Get` `Find`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository adEquipmentClient `Get` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}

func (repo *adEquipmentClient) GetByID(ctx context.Context, id int) (model.AdEquipmentClient, error) {
	res := model.AdEquipmentClient{}

	err := repo.db.WithContext(ctx).
		Unscoped().
		Preload("User").
		Preload("City").
		Preload("EquipmentSubCategory").
		Preload("Documents").
		Find(&res, id).Error
	if err != nil {
		return res, fmt.Errorf("repository adEquipmentClient `GetByID` `Find`: %w", err)
	}

	return res, nil
}

func (repo *adEquipmentClient) Create(ctx context.Context, ad model.AdEquipmentClient) (int, error) {
	err := repo.db.WithContext(ctx).Create(&ad).Error
	if err != nil {
		return 0, fmt.Errorf("repository adEquipmentClient `Create` `Create`: %w", err)
	}

	return ad.ID, nil
}

func (repo *adEquipmentClient) Update(ctx context.Context, ad model.AdEquipmentClient) error {
	value := map[string]interface{}{
		"user_id":                   ad.UserID,
		"city_id":                   ad.CityID,
		"equipment_sub_category_id": ad.EquipmentSubCategoryID,
		"status":                    ad.Status,
		"title":                     ad.Title,
		"description":               ad.Description,
		"price":                     ad.Price,
		"start_lease_date":          ad.StartLeaseAt,
		"end_lease_date":            ad.EndLeaseAt,
		"address":                   ad.Address,
		"latitude":                  ad.Latitude,
		"longitude":                 ad.Longitude,
	}

	err := repo.db.WithContext(ctx).Model(&model.AdEquipmentClient{}).Where("id = ?", ad.ID).Updates(value).Error
	if err != nil {
		return fmt.Errorf("repository adEquipmentClient `Update` `Updates`: %w", err)
	}

	return nil
}

func (repo *adEquipmentClient) UpdateStatus(ctx context.Context, ad model.AdEquipmentClient) error {
	value := map[string]interface{}{
		"status": ad.Status,
	}

	err := repo.db.WithContext(ctx).Model(&model.AdEquipmentClient{}).Where("id = ?", ad.ID).Updates(value).Error
	if err != nil {
		return fmt.Errorf("repository adEquipmentClient `Update` `Updates`: %w", err)
	}

	return nil
}

func (repo *adEquipmentClient) Delete(ctx context.Context, id int) error {
	err := repo.db.WithContext(ctx).Delete(&model.AdEquipmentClient{}, id).Error
	if err != nil {
		return fmt.Errorf("repository adEquipmentClient `Delete` `Delete`: %w", err)
	}

	return nil
}

func (repo *adEquipmentClient) GetByIDSeen(ctx context.Context, id int) (int, error) {
	stmt := repo.db.WithContext(ctx).Table("ad_equipment_client_seen")

	rows := stmt.Where("ad_equipment_client_id = ?", id).Select("count").Row()
	if rows.Err() != nil {
		return 0, fmt.Errorf("repository adEquipmentClient `GetByIDSeen`: %w", rows.Err())
	}

	count := 0

	err := rows.Scan(&count)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return 0, fmt.Errorf("repository adEquipmentClient `GetByIDSeen`: %w", model.ErrNotFound)
		}
		return 0, fmt.Errorf("repository adEquipmentClient `GetByIDSeen`: %w", err)
	}

	return count, nil
}

func (repo *adEquipmentClient) CreateSeen(ctx context.Context, id int) error {
	stmt := repo.db.WithContext(ctx).Table("ad_equipment_client_seen")

	stmt = stmt.Exec(`INSERT INTO ad_equipment_client_seen (ad_equipment_client_id)
	VALUES (?)`, id)
	if stmt.Error != nil {
		return fmt.Errorf("repository adEquipmentClient `CreateSeen`: %w", stmt.Error)
	}

	return nil
}

func (repo *adEquipmentClient) IncrementSeen(ctx context.Context, id int) error {
	stmt := repo.db.WithContext(ctx).Table("ad_equipment_client_seen")

	stmt = stmt.Exec(`UPDATE ad_equipment_client_seen
	SET count = count + 1
	WHERE ad_equipment_client_id = ?`, id)
	if stmt.Error != nil {
		if errors.Is(stmt.Error, gorm.ErrRecordNotFound) {
			return fmt.Errorf("repository adEquipmentClient `IncrementSeen`: %w", model.ErrNotFound)
		}
		return fmt.Errorf("repository adEquipmentClient `IncrementSeen`: %w", stmt.Error)
	}

	return nil
}
