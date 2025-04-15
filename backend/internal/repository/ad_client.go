package repository

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"time"

	"github.com/jackc/pgx/v5/pgconn"
	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IAdClient interface {
	Create(ad model.AdClient) (model.AdClient, error)
	Update(ad model.AdClient) error
	GetByID(ad model.AdClient) (model.AdClient, error)
	GetOwnerList(ad model.AdClient) ([]model.AdClient, error)
	GetList(filter model.FilterAdClient) (ads []model.AdClient, total int, err error)
	Delete(ctx context.Context, ad model.AdClient) error
	UpdateAdClientDocuments(ads []model.AdClientDocuments) error
	CreateInteracted(adClientID int, userID int) error
	GetInteracted(adClientID int) ([]model.AdClientInteracted, error)
	GetByIDSeen(ctx context.Context, id int) (int, error)
	CreateSeen(ctx context.Context, id int) error
	IncrementSeen(ctx context.Context, id int) error
}

type adClientRepo struct {
	db *gorm.DB
}

func NewAdClientRepository(db *gorm.DB) *adClientRepo {
	return &adClientRepo{
		db: db,
	}
}

func (r *adClientRepo) Create(ad model.AdClient) (model.AdClient, error) {
	if err := r.db.Model(model.AdClient{}).Create(&ad).Error; err != nil {
		return ad, err
	}

	return ad, nil
}

func (r *adClientRepo) Update(ad model.AdClient) error {
	return r.db.Model(model.AdClient{}).Unscoped().Where("id = ?", ad.ID).Preload("Documents").Updates(&ad).Error
}

func (r *adClientRepo) GetByID(ad model.AdClient) (model.AdClient, error) {
	res := r.db.Model(model.AdClient{}).Unscoped().Where("id = ?", ad.ID).Preload("User").Preload("City").Preload("Type").
		Preload("Documents").Find(&ad)
	if err := res.Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return ad, gorm.ErrRecordNotFound
		}

		return ad, err
	}

	if res.RowsAffected == 0 {
		return ad, gorm.ErrRecordNotFound
	}

	return ad, nil
}

func (r *adClientRepo) GetOwnerList(ad model.AdClient) (ads []model.AdClient, err error) {
	res := r.db.Model(model.AdClient{}).Where("user_id = ?", ad.UserID).
		Where("deleted_at is NULL").Preload("Documents").Preload("User").Preload("City").Preload("Type").Find(&ads)
	if err = res.Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return ads, model.ErrNotFound
		}

		return ads, err
	}

	if res.RowsAffected == 0 {
		return ads, model.ErrNotFound
	}

	return ads, nil
}

func (r *adClientRepo) GetList(f model.FilterAdClient) (ads []model.AdClient, total int, err error) {
	stmt := r.db.Model(&model.AdClient{}).
		Joins("JOIN types ON types.id = ad_clients.type_id").
		Preload("User").
		Preload("Documents").
		Preload("City").
		Preload("Type")

	if f.SubCategoryID != nil {
		stmt = stmt.Where("types.sub_category_id = ?", f.SubCategoryID)
	}

	if f.UserID != nil {
		stmt = stmt.Where("user_id = ?", f.UserID)
	}

	if f.TypeID != nil {
		stmt = stmt.Where("type_id = ?", f.TypeID)
	}

	if f.CityID != nil && *f.CityID != 92 {
		stmt = stmt.Where("city_id = ?", f.CityID)
	}

	if f.Unscoped != nil && *f.Unscoped {
		stmt = stmt.Unscoped()
	}

	if len(f.ID) != 0 {
		stmt = stmt.Where("ad_clients.id IN (?)", f.ID).Unscoped()
	}

	if f.Status != nil {
		stmt = stmt.Where("status = ?", f.Status)
	}

	if f.Deleted != nil {
		stmt = stmt.Unscoped()

		if *f.Deleted {
			stmt = stmt.Where("deleted_at IS NOT NULL")
		} else {
			stmt = stmt.Where("deleted_at IS NULL")
		}
	}

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

	res := stmt.Find(&ads)
	if res.Error != nil {
		return nil, 0, res.Error
	}

	var n int64

	if res.RowsAffected == 0 {
		return ads, 0, model.ErrNotFound
	}

	res = res.Limit(-1).Offset(-1)
	tx := res.Count(&n)

	if tx.Error != nil {
		return nil, 0, tx.Error
	}

	return ads, int(n), nil
}

func (r *adClientRepo) UpdateAdClientDocuments(ads []model.AdClientDocuments) error {
	return r.db.Model(model.AdClientDocuments{}).Updates(&ads).Error
}

func (r *adClientRepo) Delete(ctx context.Context, ad model.AdClient) error {
	return r.db.WithContext(ctx).Model(&ad).Update("deleted_at", time.Now()).Error
}

func (r *adClientRepo) CreateInteracted(adClientID int, userID int) error {
	err := r.db.Create(&model.AdClientInteracted{
		AdClientID: adClientID,
		UserID:     userID,
	}).Error

	if err != nil {
		if errPG, ok := err.(*pgconn.PgError); ok {
			if errPG.ConstraintName == "ad_clients_interacted_pk_2" {
				return nil
			}
		}
		return nil
	}

	return err
}

func (r *adClientRepo) GetInteracted(adClientID int) ([]model.AdClientInteracted, error) {
	adcis := make([]model.AdClientInteracted, 0)

	err := r.db.Model(&model.AdClientInteracted{}).Preload("User").
		Where("ad_client_id = ?", adClientID).
		Find(&adcis).Error
	if err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, model.ErrNotFound
		}
		return nil, err
	}

	return adcis, nil
}

func (repo *adClientRepo) GetByIDSeen(ctx context.Context, id int) (int, error) {
	stmt := repo.db.WithContext(ctx).Table("ad_client_seen")

	rows := stmt.Where("ad_client_id = ?", id).Select("count").Row()
	if rows.Err() != nil {
		return 0, fmt.Errorf("repository adClientRepo `GetByIDSeen`: %w", rows.Err())
	}

	count := 0

	err := rows.Scan(&count)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return 0, fmt.Errorf("repository adClientRepo `GetByIDSeen`: %w", model.ErrNotFound)
		}
		return 0, fmt.Errorf("repository adClientRepo `GetByIDSeen`: %w", err)
	}

	return count, nil
}

func (repo *adClientRepo) CreateSeen(ctx context.Context, id int) error {
	stmt := repo.db.WithContext(ctx).Table("ad_client_seen")

	stmt = stmt.Exec(`INSERT INTO ad_client_seen (ad_client_id)
	VALUES (?)`, id)
	if stmt.Error != nil {
		return fmt.Errorf("repository adClientRepo `CreateSeen`: %w", stmt.Error)
	}

	return nil
}

func (repo *adClientRepo) IncrementSeen(ctx context.Context, id int) error {
	stmt := repo.db.WithContext(ctx).Table("ad_client_seen")

	stmt = stmt.Exec(`UPDATE ad_client_seen
	SET count = count + 1
	WHERE ad_client_id = ?`, id)
	if stmt.Error != nil {
		if errors.Is(stmt.Error, gorm.ErrRecordNotFound) {
			return fmt.Errorf("repository adClientRepo `IncrementSeen`: %w", model.ErrNotFound)
		}
		return fmt.Errorf("repository adClientRepo `IncrementSeen`: %w", stmt.Error)
	}

	return nil
}
