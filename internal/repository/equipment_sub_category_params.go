package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type IEquipmentSubCategoryParams interface {
	Set(ctx context.Context, tps []model.EquipmentSubCategoriesParams) error
	Delete(ctx context.Context, tps model.EquipmentSubCategoriesParams) error
}

type equipmentSubCategoryParams struct {
	db *gorm.DB
}

func NewEquipmentSubCategoryParams(db *gorm.DB) IEquipmentSubCategoryParams {
	return &equipmentSubCategoryParams{db: db}
}

func (tp *equipmentSubCategoryParams) Set(ctx context.Context, tps []model.EquipmentSubCategoriesParams) error {
	stmt := tp.db.WithContext(ctx).Clauses(clause.OnConflict{DoNothing: true}).Create(&tps)

	if stmt.Error != nil {
		return fmt.Errorf("repository equipmentSubCategoryParams: Set: err: %w", stmt.Error)
	}

	return nil
}

func (tp *equipmentSubCategoryParams) Delete(ctx context.Context, tps model.EquipmentSubCategoriesParams) error {
	stmt := tp.db.WithContext(ctx).Model(&model.EquipmentSubCategoriesParams{})

	stmt = stmt.Where("sub_category_id = ?", tps.EquipmentSubCategoryID).Where("param_id = ?", tps.ParamID)

	stmt = stmt.Delete(&tps)

	if stmt.Error != nil {
		return fmt.Errorf("repository equipmentSubCategoryParams: Delete: err: %w", stmt.Error)
	}

	return nil
}
