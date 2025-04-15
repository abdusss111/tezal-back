package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IServiceSubCategory interface {
	Get(ctx context.Context, f model.FilterServiceSubCategory) ([]model.ServiceSubCategory, error)
	GetByID(ctx context.Context, id int) (model.ServiceSubCategory, error)
	Create(ctx context.Context, ec model.ServiceSubCategory) error
	Update(ctx context.Context, ec model.ServiceSubCategory) error
	Delete(ctx context.Context, id int) error
}

type serviceSubCategory struct {
	db *gorm.DB
}

func NewServiceSubCategory(db *gorm.DB) IServiceSubCategory {
	return &serviceSubCategory{db: db}
}

func (repo *serviceSubCategory) Get(ctx context.Context, f model.FilterServiceSubCategory) ([]model.ServiceSubCategory, error) {
	res := make([]model.ServiceSubCategory, 0)

	stmt := repo.db.WithContext(ctx).Model(&model.ServiceSubCategory{})

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

	if len(f.ServiceCategoryIDs) != 0 {
		stmt = stmt.Where("service_categories_id IN (?)", f.ServiceCategoryIDs)
	}

	if f.Name != nil {
		stmt = stmt.Where("name ILIKE '%' || ? || '%' ", f.Name)
	}

	err := stmt.Find(&res).Error
	if err != nil {
		return nil, fmt.Errorf("repository serviceSubCategory `Get` `Find`: %w", err)
	}

	return res, nil
}

func (repo *serviceSubCategory) GetByID(ctx context.Context, id int) (model.ServiceSubCategory, error) {
	res := model.ServiceSubCategory{}

	stmt := repo.db.WithContext(ctx).Unscoped()

	stmt = stmt.Preload("Alias").Preload("Documents").Preload("Params")

	err := stmt.Find(&res, id).Error
	if err != nil {
		return res, fmt.Errorf("repository serviceSubCategory `GetByID` `Find`: %w", err)
	}

	return res, nil
}

func (repo *serviceSubCategory) Create(ctx context.Context, ec model.ServiceSubCategory) error {
	err := repo.db.WithContext(ctx).Create(&ec).Error
	if err != nil {
		return fmt.Errorf("repository serviceSubCategory `Create` `Create`: %w", err)
	}

	return nil
}

func (repo *serviceSubCategory) Update(ctx context.Context, ec model.ServiceSubCategory) error {
	tx := repo.db.Begin()
	defer tx.Rollback()

	oldEc := ec

	if len(oldEc.Documents) != 0 {
		if err := tx.Model(&ec).Association("Documents").Clear(); err != nil {
			return fmt.Errorf("repository serviceSubCategory: Clear Association: %w", err)
		}

		var ids []int
		for i := range oldEc.Documents {
			ids = append(ids, oldEc.Documents[i].ID)
		}

		if err := tx.Delete(&oldEc.Documents, "id in ?", ids).Error; err != nil {
			return fmt.Errorf("repository serviceSubCategory Delet old Documents : %w", err)
		}

		if err := tx.Create(&oldEc.Documents).Error; err != nil {
			return fmt.Errorf("repository serviceSubCategory Creat new Document: %w", err)
		}

		for i := range oldEc.Documents {
			subCategoryDocs := model.ServiceSubCategoriesDocuments{
				ServiceSubCategoryID: oldEc.ID,
				DocumentID:           oldEc.Documents[i].ID,
			}

			if err := tx.Create(&subCategoryDocs).Error; err != nil {
				return fmt.Errorf("repository serviceSubCategory Create Association Document: %w", err)
			}
		}
	}

	stmt := repo.db.
		WithContext(ctx).
		Where("id = ?", ec.ID).
		Where("service_categories_id = ?", ec.ServiceCategoriesID).
		Save(&ec)
	if stmt.Error != nil {
		return fmt.Errorf("repository serviceSubCategory `Update` `Updates`: %w", stmt.Error)
	}

	tx.Commit()
	return nil
}

func (repo *serviceSubCategory) Delete(ctx context.Context, id int) error {
	err := repo.db.WithContext(ctx).Delete(&model.ServiceSubCategory{}, id).Error
	if err != nil {
		return fmt.Errorf("repository serviceSubCategory `Delete` `Delete`: %w", err)
	}

	return nil
}
