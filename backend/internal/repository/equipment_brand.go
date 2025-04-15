package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IEquipmentBrand interface {
	Get(ctx context.Context, f model.FilterEquipmentBrand) ([]model.EquipmentBrand, error)
	GetByID(ctx context.Context, id int) (model.EquipmentBrand, error)
	Create(ctx context.Context, b model.EquipmentBrand) error
	Update(ctx context.Context, b model.EquipmentBrand) error
	Delete(ctx context.Context, id int) error
}

type equipmentBrand struct {
	db *gorm.DB
}

func NewEquipmentBrand(db *gorm.DB) IEquipmentBrand {
	return &equipmentBrand{db: db}
}

func (repo *equipmentBrand) Get(ctx context.Context, f model.FilterEquipmentBrand) ([]model.EquipmentBrand, error) {
	res := make([]model.EquipmentBrand, 0)

	stmt := repo.db.WithContext(ctx).Model(&model.EquipmentBrand{})

	if f.Unscoped != nil && *f.Unscoped {
		stmt = stmt.Unscoped()
	}

	if len(f.IDs) != 0 {
		stmt = stmt.Where("id IN (?)", f.IDs)
	}

	if f.Name != nil {
		stmt = stmt.Where("name ILIKE '%' || ? || '%' ", f.Name)
	}

	stmt = stmt.Find(&res)
	if stmt.Error != nil {
		return nil, fmt.Errorf("repository equipmentBrand `Get` `Find`: %w", stmt.Error)
	}

	return res, nil
}

func (repo *equipmentBrand) GetByID(ctx context.Context, id int) (model.EquipmentBrand, error) {
	res := model.EquipmentBrand{}

	err := repo.db.WithContext(ctx).Unscoped().Find(&res, id).Error
	if err != nil {
		return res, fmt.Errorf("repository equipmentBrand `GetByID` `Find`: %w", err)
	}

	return res, nil
}

func (repo *equipmentBrand) Create(ctx context.Context, b model.EquipmentBrand) error {
	err := repo.db.WithContext(ctx).Create(&b).Error
	if err != nil {
		return fmt.Errorf("repository equipmentBrand `Create` `Create`: %w", err)
	}

	return nil
}

func (repo *equipmentBrand) Update(ctx context.Context, b model.EquipmentBrand) error {
	value := map[string]interface{}{
		"name": b.Name,
	}

	err := repo.db.WithContext(ctx).Model(&model.EquipmentBrand{}).Where("id = ?", b.ID).Updates(value).Error
	if err != nil {
		return fmt.Errorf("repository equipmentBrand `Update` `Updates`: %w", err)
	}

	return nil
}

func (repo *equipmentBrand) Delete(ctx context.Context, id int) error {
	err := repo.db.WithContext(ctx).Delete(&model.EquipmentBrand{}, id).Error
	if err != nil {
		return fmt.Errorf("repository equipmentBrand `Delete` `Delete`: %w", err)
	}

	return nil
}
