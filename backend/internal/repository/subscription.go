package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type subscription struct {
	db *gorm.DB
}

type ISubscription interface {
	Create(ctx context.Context, sub []model.AdClientCreationSubscription) error
	Delete(ctx context.Context, userID int, src string, equipmentSubCategoryID []int, typeID []int) error
	GetDeviceTokenBySrc(ctx context.Context, sub model.AdClientCreationSubscription) ([]model.DeviceToken, error)
	GetToCreateAdClient(ctx context.Context, src string, userID int) ([]model.AdClientCreationSubscription, error)
}

func NewSubscription(db *gorm.DB) ISubscription {
	return &subscription{
		db: db,
	}
}

func (repo *subscription) GetToCreateAdClient(ctx context.Context, src string, userID int) ([]model.AdClientCreationSubscription, error) {
	res := make([]model.AdClientCreationSubscription, 0)

	stmt := repo.db.WithContext(ctx)

	if src != "" {
		stmt = stmt.Where("src = ?", src)
	}

	stmt = stmt.Where("user_id = ?", userID).Find(&res)

	if err := stmt.Error; err != nil {
		return nil, err
	}

	return res, nil
}

func (repo *subscription) Create(ctx context.Context, sub []model.AdClientCreationSubscription) error {
	if len(sub) == 0 {
		return nil
	}

	// костыль.... ну незнаю что мне делать... я 2 сутки не спал уже
	var onConflict clause.OnConflict

	if sub[0].SubCategoryID != nil {
		onConflict = clause.OnConflict{
			Columns:   []clause.Column{{Name: "user_id"}, {Name: "src"}, {Name: "sub_category_id"}, {Name: "city_id"}},
			DoNothing: true,
		}
	} else {
		onConflict = clause.OnConflict{
			Columns:   []clause.Column{{Name: "user_id"}, {Name: "src"}, {Name: "type_id"}, {Name: "city_id"}},
			DoNothing: true,
		}
	}

	stmt := repo.db.WithContext(ctx).Clauses(onConflict).Create(&sub)
	if err := stmt.Error; err != nil {
		return fmt.Errorf("repository subscription: Create: err: %w", err)
	}
	return nil
}

func (repo *subscription) Delete(ctx context.Context, UserID int, Src string, EquipmentSubCategoryID []int, TypeID []int) error {
	stmt := repo.db.WithContext(ctx).Where("user_id = ?", UserID).Where("src = ?", Src)

	if len(EquipmentSubCategoryID) != 0 {
		stmt = stmt.Where("equipment_sub_category_id in (?)", EquipmentSubCategoryID)
	}

	if len(TypeID) != 0 {
		stmt = stmt.Where("type_id in (?)", TypeID)
	}

	stmt = stmt.Delete(&model.AdClientCreationSubscription{})
	if err := stmt.Error; err != nil {
		return fmt.Errorf("repository subscription: Delete: err: %w", err)
	}
	return nil
}

func (repo *subscription) GetDeviceTokenBySrc(ctx context.Context, sub model.AdClientCreationSubscription) ([]model.DeviceToken, error) {
	dv := make([]model.DeviceToken, 0)
	stmt := repo.db.WithContext(ctx).
		Where("user_id in (?)",
			repo.db.
				Where("src = ?", sub.Src).
				Where("sub_category_id = ? OR type_id = ?", *sub.SubCategoryID, sub.TypeID).
				Where("city_id = ? OR city_id = ?", sub.CityID, 0).
				Select("user_id").
				Table("ad_client_creation_subscriptions"),
		).
		Find(&dv)
	if err := stmt.Error; err != nil {
		return nil, fmt.Errorf("repository subscription: GetDeviceToken: err: %w", err)
	}

	return dv, nil
}
