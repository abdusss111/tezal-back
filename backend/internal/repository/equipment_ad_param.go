package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IEquipmentAdParam interface {
	Get(ctx context.Context, f model.FilterEquipmentAdParam) ([]model.EquipmentAdParam, error)
	GetByID(ctx context.Context, id int) (model.EquipmentAdParam, error)
	Create(ctx context.Context, p model.EquipmentAdParam) error
	Update(ctx context.Context, p model.EquipmentAdParam) error
	Delete(ctx context.Context, id int) error
}

type equipmentAdParam struct {
	db *gorm.DB
}

func NewEquipmentAdParam(db *gorm.DB) IEquipmentAdParam {
	return &equipmentAdParam{db: db}
}

func (repo *equipmentAdParam) Get(ctx context.Context, f model.FilterEquipmentAdParam) ([]model.EquipmentAdParam, error) {
	res := make([]model.EquipmentAdParam, 0)

	stmt := repo.db.WithContext(ctx)

	// TODO фильтры для параметров

	err := stmt.Find(&res).Error
	if err != nil {
		return nil, fmt.Errorf("repository equipmentAdParam `Get` `Find`: %w", err)
	}

	return nil, nil
}

func (repo *equipmentAdParam) GetByID(ctx context.Context, id int) (model.EquipmentAdParam, error) {
	res := model.EquipmentAdParam{}

	err := repo.db.WithContext(ctx).Unscoped().Find(&res, id).Error
	if err != nil {
		return res, fmt.Errorf("repository equipmentAdParam `GetByID` `Find`: %w", err)
	}

	return res, nil
}

func (repo *equipmentAdParam) Create(ctx context.Context, p model.EquipmentAdParam) error {
	err := repo.db.WithContext(ctx).Create(&p).Error
	if err != nil {
		return fmt.Errorf("repository equipmentAdParam `Create` `Create`: %w", err)
	}

	return nil
}

func (repo *equipmentAdParam) Update(ctx context.Context, p model.EquipmentAdParam) error {
	value := map[string]interface{}{
		"name":     p.Name,
		"name_eng": p.NameEng,
	}

	err := repo.db.WithContext(ctx).Model(&model.EquipmentAdParam{}).Where("id = ?", p.ID).Updates(value).Error
	if err != nil {
		return fmt.Errorf("repository equipmentAdParam `Update` `Updates`: %w", err)
	}

	return nil
}

func (repo *equipmentAdParam) Delete(ctx context.Context, id int) error {
	err := repo.db.WithContext(ctx).Delete(&model.EquipmentAdParam{}, id).Error
	if err != nil {
		return fmt.Errorf("repository equipmentAdParam `Delete` `Delete`: %w", err)
	}

	return nil
}
