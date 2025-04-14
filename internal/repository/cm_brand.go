package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IConstructionMaterialBrand interface {
	Get(ctx context.Context, f model.FilterConstructionMaterialBrand) ([]model.ConstructionMaterialBrand, error)
	GetByID(ctx context.Context, id int) (model.ConstructionMaterialBrand, error)
	Create(ctx context.Context, b model.ConstructionMaterialBrand) error
	Update(ctx context.Context, b model.ConstructionMaterialBrand) error
	Delete(ctx context.Context, id int) error
}

type constructionMaterialBrand struct {
	db *gorm.DB
}

func NewConstructionMaterialBrand(db *gorm.DB) IConstructionMaterialBrand {
	return &constructionMaterialBrand{db: db}
}

func (repo *constructionMaterialBrand) Get(ctx context.Context, f model.FilterConstructionMaterialBrand) ([]model.ConstructionMaterialBrand, error) {
	res := make([]model.ConstructionMaterialBrand, 0)

	stmt := repo.db.WithContext(ctx).Model(&model.ConstructionMaterialBrand{})

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
		return nil, fmt.Errorf("repository constructionMaterialBrand `Get` `Find`: %w", stmt.Error)
	}

	return res, nil
}

func (repo *constructionMaterialBrand) GetByID(ctx context.Context, id int) (model.ConstructionMaterialBrand, error) {
	res := model.ConstructionMaterialBrand{}

	err := repo.db.WithContext(ctx).Unscoped().Find(&res, id).Error
	if err != nil {
		return res, fmt.Errorf("repository constructionMaterialBrand `GetByID` `Find`: %w", err)
	}

	return res, nil
}

func (repo *constructionMaterialBrand) Create(ctx context.Context, b model.ConstructionMaterialBrand) error {
	err := repo.db.WithContext(ctx).Create(&b).Error
	if err != nil {
		return fmt.Errorf("repository constructionMaterialBrand `Create` `Create`: %w", err)
	}

	return nil
}

func (repo *constructionMaterialBrand) Update(ctx context.Context, b model.ConstructionMaterialBrand) error {
	value := map[string]interface{}{
		"name": b.Name,
	}

	err := repo.db.WithContext(ctx).Model(&model.ConstructionMaterialBrand{}).Where("id = ?", b.ID).Updates(value).Error
	if err != nil {
		return fmt.Errorf("repository constructionMaterialBrand `Update` `Updates`: %w", err)
	}

	return nil
}

func (repo *constructionMaterialBrand) Delete(ctx context.Context, id int) error {
	err := repo.db.WithContext(ctx).Delete(&model.ConstructionMaterialBrand{}, id).Error
	if err != nil {
		return fmt.Errorf("repository constructionMaterialBrand `Delete` `Delete`: %w", err)
	}

	return nil
}
