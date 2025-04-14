package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IConstructionMaterialCategory interface {
	Get(ctx context.Context, f model.FilterConstructionMaterialCategory) ([]model.ConstructionMaterialCategory, error)
	GetByID(ctx context.Context, id int) (model.ConstructionMaterialCategory, error)
	Create(ctx context.Context, ec model.ConstructionMaterialCategory) (int, error)
	Update(ctx context.Context, ec model.ConstructionMaterialCategory) error
	Delete(ctx context.Context, id int) error
}

type constructionMaterialCategory struct {
	db *gorm.DB
}

func NewConstructionMaterialCategory(db *gorm.DB) IConstructionMaterialCategory {
	return &constructionMaterialCategory{db: db}
}

func (repo *constructionMaterialCategory) Get(ctx context.Context, f model.FilterConstructionMaterialCategory) ([]model.ConstructionMaterialCategory, error) {
	res := make([]model.ConstructionMaterialCategory, 0)

	stmt := repo.db.WithContext(ctx).Model(&model.ConstructionMaterialCategory{})

	if f.Unscoped != nil && *f.Unscoped {
		stmt = stmt.Unscoped()
	}

	if f.DocumentsDetail != nil && *f.DocumentsDetail {
		stmt = stmt.Preload("Documents")
	}

	if f.SubCategoriesCountAdDetail != nil && *f.SubCategoriesCountAdDetail {
		stmt = stmt.Preload("ConstructionMaterialSubCategories").Preload("ConstructionMaterialSubCategories.Params")
	}

	if f.SubCategoriesDocumentsDetail != nil && *f.SubCategoriesDocumentsDetail {
		stmt = stmt.Preload("ConstructionMaterialSubCategories.Documents")
	}

	if len(f.IDs) != 0 {
		stmt = stmt.Where("id in (?)", f.IDs)
	}

	if f.Name != nil {
		stmt = stmt.Where("name ILIKE '%' || ? || '%' ", f.Name)
	}

	err := stmt.Find(&res).Error
	if err != nil {
		return nil, fmt.Errorf("repository constructionMaterialCategory `Get` `Find`: %w", err)
	}

	return res, nil
}

func (repo *constructionMaterialCategory) GetByID(ctx context.Context, id int) (model.ConstructionMaterialCategory, error) {
	res := model.ConstructionMaterialCategory{}

	err := repo.db.WithContext(ctx).
		Preload("ConstructionMaterialSubCategories").
		Preload("ConstructionMaterialSubCategories.Params").
		Preload("ConstructionMaterialSubCategories.Documents").
		Preload("Documents").
		Find(&res, id).Error
	if err != nil {
		return res, fmt.Errorf("repository constructionMaterialCategory `GetByID` `Find`: %w", err)
	}

	return res, nil
}

func (repo *constructionMaterialCategory) Create(ctx context.Context, ec model.ConstructionMaterialCategory) (int, error) {
	err := repo.db.WithContext(ctx).Create(&ec).Error
	if err != nil {
		return 0, fmt.Errorf("repository constructionMaterialCategory `Create` `Create`: %w", err)
	}

	return ec.ID, nil
}

func (repo *constructionMaterialCategory) Update(ctx context.Context, ec model.ConstructionMaterialCategory) error {
	// // value := make(map[string]any, 0)

	// // if ec.Name != "" {
	// // 	value["name"] = ec.Name
	// // }

	// stmt := repo.db.WithContext(ctx).Save(&ec)
	// if stmt.Error != nil {
	// 	return fmt.Errorf("repository constructionMaterialCategory `Update` `Updates`: %w", stmt.Error)
	// }

	// // err := repo.db.WithContext(ctx).Model(&model.ConstructionMaterialCategory{}).Where("id = ?", ec.ID).Updates(value).Error
	// // if err != nil {
	// // 	return fmt.Errorf("repository constructionMaterialCategory `Update` `Updates`: %w", err)
	// // }

	// return nil
	tx := repo.db.Begin()
	defer tx.Rollback()

	oldEc := ec

	if len(oldEc.Documents) != 0 {
		if err := tx.Model(&ec).Association("Documents").Clear(); err != nil {
			return fmt.Errorf("repository constructionMaterialCategory: Clear Association: %w", err)
		}

		var ids []int
		for i := range oldEc.Documents {
			ids = append(ids, oldEc.Documents[i].ID)
		}

		if err := tx.Delete(&oldEc.Documents, "id in ?", ids).Error; err != nil {
			return fmt.Errorf("repository constructionMaterialCategory Delet old Documents : %w", err)
		}

		if err := tx.Create(&oldEc.Documents).Error; err != nil {
			return fmt.Errorf("repository constructionMaterialCategory Creat new Document: %w", err)
		}

		for i := range oldEc.Documents {
			categoryDocs := model.ConstructionMaterialCategoryDocuments{
				ConstructionMaterialCategoryID: oldEc.ID,
				DocumentID:                     oldEc.Documents[i].ID,
			}

			if err := tx.Create(&categoryDocs).Error; err != nil {
				return fmt.Errorf("repository constructionMaterialCategory Create Association Document: %w", err)
			}
		}
	}

	stmt := repo.db.
		WithContext(ctx).
		Where("id = ?", ec.ID).
		Save(&ec)
	if stmt.Error != nil {
		return fmt.Errorf("repository constructionMaterialCategory `Update` `Updates`: %w", stmt.Error)
	}

	tx.Commit()
	return nil
}

func (repo *constructionMaterialCategory) Delete(ctx context.Context, id int) error {
	err := repo.db.WithContext(ctx).Delete(&model.ConstructionMaterialCategory{}, id).Error
	if err != nil {
		return fmt.Errorf("repository constructionMaterialCategory `Delete` `Delete`: %w", err)
	}

	return nil
}
