package repository

import (
	"context"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type ITypeParams interface {
	Set(ctx context.Context, tps []model.TypesParams) error
	Delete(ctx context.Context, tps model.TypesParams) error
}

type typeParams struct {
	db *gorm.DB
}

func NewTypeParams(db *gorm.DB) *typeParams {
	return &typeParams{db: db}
}

func (tp *typeParams) Set(ctx context.Context, tps []model.TypesParams) error {
	return tp.db.WithContext(ctx).Clauses(clause.OnConflict{DoNothing: true}).Create(&tps).Error
}

func (tp *typeParams) Delete(ctx context.Context, tps model.TypesParams) error {
	return tp.db.WithContext(ctx).Model(&model.TypesParams{}).Where("type_id = ?", tps.TypeID).Where("param_id = ?", tps.ParamID).Delete(&tps).Error
}
