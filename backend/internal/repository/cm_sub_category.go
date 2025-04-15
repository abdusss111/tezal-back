package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IConstructionMaterialSubCategory interface {
	Get(ctx context.Context, f model.FilterConstructionMaterialSubCategory) ([]model.ConstructionMaterialSubCategory, error)
	GetByID(ctx context.Context, id int) (model.ConstructionMaterialSubCategory, error)
	Create(ctx context.Context, ec model.ConstructionMaterialSubCategory) error
	Update(ctx context.Context, ec model.ConstructionMaterialSubCategory) error
	Delete(ctx context.Context, id int) error
}

type constructionMaterialSubCategory struct {
	db *gorm.DB
}

func NewConstructionMaterialSubCategory(db *gorm.DB) IConstructionMaterialSubCategory {
	return &constructionMaterialSubCategory{db: db}
}

func (repo *constructionMaterialSubCategory) Get(ctx context.Context, f model.FilterConstructionMaterialSubCategory) ([]model.ConstructionMaterialSubCategory, error) {
	res := make([]model.ConstructionMaterialSubCategory, 0)

	stmt := repo.db.WithContext(ctx).Model(&model.ConstructionMaterialSubCategory{})

	if f.Unscoped != nil && *f.Unscoped {
		stmt = stmt.Unscoped()
	}

	if f.DocumentsDetail != nil && *f.DocumentsDetail {
		stmt = stmt.Preload("Documents")
	}

	if f.DocumentsDetail != nil && *f.DocumentsDetail {
		stmt = stmt.Preload("Params")
	}

	if len(f.IDs) != 0 {
		stmt = stmt.Where("id IN (?)", f.IDs)
	}

	if len(f.ConstructionMaterialCategoryIDs) != 0 {
		stmt = stmt.Where("construction_material_categories_id IN (?)", f.ConstructionMaterialCategoryIDs)
	}

	if f.Name != nil {
		stmt = stmt.Where("name ILIKE '%' || ? || '%' ", f.Name)
	}

	err := stmt.Find(&res).Error
	if err != nil {
		return nil, fmt.Errorf("repository constructionMaterialSubCategory `Get` `Find`: %w", err)
	}

	return res, nil
}

func (repo *constructionMaterialSubCategory) GetByID(ctx context.Context, id int) (model.ConstructionMaterialSubCategory, error) {
	res := model.ConstructionMaterialSubCategory{}

	stmt := repo.db.WithContext(ctx).Unscoped()

	stmt = stmt.Preload("Alias").Preload("Documents").Preload("Params")

	err := stmt.Find(&res, id).Error
	if err != nil {
		return res, fmt.Errorf("repository constructionMaterialSubCategory `GetByID` `Find`: %w", err)
	}

	return res, nil
}

func (repo *constructionMaterialSubCategory) Create(ctx context.Context, ec model.ConstructionMaterialSubCategory) error {
	err := repo.db.WithContext(ctx).Create(&ec).Error
	if err != nil {
		return fmt.Errorf("repository constructionMaterialSubCategory `Create` `Create`: %w", err)
	}

	return nil
}

func (repo *constructionMaterialSubCategory) Update(ctx context.Context, ec model.ConstructionMaterialSubCategory) error {
	tx := repo.db.Begin()
	defer tx.Rollback()

	oldEc := ec

	if len(oldEc.Documents) != 0 {
		if err := tx.Model(&ec).Association("Documents").Clear(); err != nil {
			return fmt.Errorf("repository constructionMaterialSubCategory: Clear Association: %w", err)
		}

		var ids []int
		for i := range oldEc.Documents {
			ids = append(ids, oldEc.Documents[i].ID)
		}

		if err := tx.Delete(&oldEc.Documents, "id in ?", ids).Error; err != nil {
			return fmt.Errorf("repository constructionMaterialSubCategory Delet old Documents : %w", err)
		}

		if err := tx.Create(&oldEc.Documents).Error; err != nil {
			return fmt.Errorf("repository constructionMaterialSubCategory Creat new Document: %w", err)
		}

		for i := range oldEc.Documents {
			subCategoryDocs := model.ConstructionMaterialSubCategoriesDocuments{
				ConstructionMaterialSubCategoryID: oldEc.ID,
				DocumentID:                        oldEc.Documents[i].ID,
			}

			if err := tx.Create(&subCategoryDocs).Error; err != nil {
				return fmt.Errorf("repository constructionMaterialSubCategory Create Association Document: %w", err)
			}
		}
	}

	stmt := repo.db.
		WithContext(ctx).
		Where("id = ?", ec.ID).
		Where("construction_material_categories_id = ?", ec.ConstructionMaterialCategoriesID).
		Save(&ec)
	if stmt.Error != nil {
		return fmt.Errorf("repository constructionMaterialSubCategory `Update` `Updates`: %w", stmt.Error)
	}

	tx.Commit()
	return nil
}

func (repo *constructionMaterialSubCategory) Delete(ctx context.Context, id int) error {
	err := repo.db.WithContext(ctx).Delete(&model.ConstructionMaterialSubCategory{}, id).Error
	if err != nil {
		return fmt.Errorf("repository constructionMaterialSubCategory `Delete` `Delete`: %w", err)
	}

	return nil
}
