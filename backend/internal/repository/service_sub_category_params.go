package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type IServiceSubCategoryParams interface {
	Set(ctx context.Context, tps []model.ServiceSubCategoriesParams) error
	Delete(ctx context.Context, tps model.ServiceSubCategoriesParams) error
}

type serviceSubCategoryParams struct {
	db *gorm.DB
}

func NewServiceSubCategoryParams(db *gorm.DB) IServiceSubCategoryParams {
	return &serviceSubCategoryParams{db: db}
}

func (tp *serviceSubCategoryParams) Set(ctx context.Context, tps []model.ServiceSubCategoriesParams) error {
	stmt := tp.db.WithContext(ctx).Clauses(clause.OnConflict{DoNothing: true}).Create(&tps)

	if stmt.Error != nil {
		return fmt.Errorf("repository serviceSubCategoryParams: Set: err: %w", stmt.Error)
	}

	return nil
}

func (tp *serviceSubCategoryParams) Delete(ctx context.Context, tps model.ServiceSubCategoriesParams) error {
	stmt := tp.db.WithContext(ctx).Model(&model.ServiceSubCategoriesParams{})

	stmt = stmt.Where("sub_category_id = ?", tps.ServiceSubCategoryID).Where("param_id = ?", tps.ParamID)

	stmt = stmt.Delete(&tps)

	if stmt.Error != nil {
		return fmt.Errorf("repository serviceSubCategoryParams: Delete: err: %w", stmt.Error)
	}

	return nil
}
