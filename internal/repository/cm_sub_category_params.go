package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type IConstructionMaterialSubCategoryParams interface {
	Set(ctx context.Context, tps []model.ConstructionMaterialSubCategoriesParams) error
	Delete(ctx context.Context, tps model.ConstructionMaterialSubCategoriesParams) error
}

type constructionMaterialSubCategoryParams struct {
	db *gorm.DB
}

func NewConstructionMaterialSubCategoryParams(db *gorm.DB) IConstructionMaterialSubCategoryParams {
	return &constructionMaterialSubCategoryParams{db: db}
}

func (tp *constructionMaterialSubCategoryParams) Set(ctx context.Context, tps []model.ConstructionMaterialSubCategoriesParams) error {
	stmt := tp.db.WithContext(ctx).Clauses(clause.OnConflict{DoNothing: true}).Create(&tps)

	if stmt.Error != nil {
		return fmt.Errorf("repository constructionMaterialSubCategoryParams: Set: err: %w", stmt.Error)
	}

	return nil
}

func (tp *constructionMaterialSubCategoryParams) Delete(ctx context.Context, tps model.ConstructionMaterialSubCategoriesParams) error {
	stmt := tp.db.WithContext(ctx).Model(&model.ConstructionMaterialSubCategoriesParams{})

	stmt = stmt.Where("sub_category_id = ?", tps.ConstructionMaterialSubCategoryID).Where("param_id = ?", tps.ParamID)

	stmt = stmt.Delete(&tps)

	if stmt.Error != nil {
		return fmt.Errorf("repository constructionMaterialSubCategoryParams: Delete: err: %w", stmt.Error)
	}

	return nil
}
