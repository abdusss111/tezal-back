package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IServiceCategory interface {
	Get(ctx context.Context, f model.FilterServiceCategory) ([]model.ServiceCategory, error)
	GetByID(ctx context.Context, id int) (model.ServiceCategory, error)
	Create(ctx context.Context, ec model.ServiceCategory) (int, error)
	Update(ctx context.Context, ec model.ServiceCategory) error
	Delete(ctx context.Context, id int) error
}

type serviceCategory struct {
	db *gorm.DB
}

func NewServiceCategory(db *gorm.DB) IServiceCategory {
	return &serviceCategory{db: db}
}

func (repo *serviceCategory) Get(ctx context.Context, f model.FilterServiceCategory) ([]model.ServiceCategory, error) {
	res := make([]model.ServiceCategory, 0)

	stmt := repo.db.WithContext(ctx).Model(&model.ServiceCategory{})

	if f.Unscoped != nil && *f.Unscoped {
		stmt = stmt.Unscoped()
	}

	if f.DocumentsDetail != nil && *f.DocumentsDetail {
		stmt = stmt.Preload("Documents")
	}

	if f.SubCategoriesDatail != nil && *f.SubCategoriesDatail {
		stmt = stmt.Preload("ServiceSubCategories").Preload("ServiceSubCategories.Params")
	}

	if f.SubCategoriesDocumentsDetail != nil && *f.SubCategoriesDocumentsDetail {
		stmt = stmt.Preload("ServiceSubCategories.Documents")
	}

	if len(f.IDs) != 0 {
		stmt = stmt.Where("id in (?)", f.IDs)
	}

	if f.Name != nil {
		stmt = stmt.Where("name ILIKE '%' || ? || '%' ", f.Name)
	}

	err := stmt.Find(&res).Error
	if err != nil {
		return nil, fmt.Errorf("repository serviceCategory `Get` `Find`: %w", err)
	}

	return res, nil
}

func (repo *serviceCategory) GetByID(ctx context.Context, id int) (model.ServiceCategory, error) {
	res := model.ServiceCategory{}

	err := repo.db.WithContext(ctx).
		Preload("ServiceSubCategories").
		Preload("ServiceSubCategories.Params").
		Preload("ServiceSubCategories.Documents").
		Preload("Documents").
		Find(&res, id).Error
	if err != nil {
		return res, fmt.Errorf("repository serviceCategory `GetByID` `Find`: %w", err)
	}

	return res, nil
}

func (repo *serviceCategory) Create(ctx context.Context, ec model.ServiceCategory) (int, error) {
	err := repo.db.WithContext(ctx).Create(&ec).Error
	if err != nil {
		return 0, fmt.Errorf("repository serviceCategory `Create` `Create`: %w", err)
	}

	return ec.ID, nil
}

func (repo *serviceCategory) Update(ctx context.Context, ec model.ServiceCategory) error {
	// // value := make(map[string]any, 0)

	// // if ec.Name != "" {
	// // 	value["name"] = ec.Name
	// // }

	// stmt := repo.db.WithContext(ctx).Save(&ec)
	// if stmt.Error != nil {
	// 	return fmt.Errorf("repository serviceCategory `Update` `Updates`: %w", stmt.Error)
	// }

	// // err := repo.db.WithContext(ctx).Model(&model.ServiceCategory{}).Where("id = ?", ec.ID).Updates(value).Error
	// // if err != nil {
	// // 	return fmt.Errorf("repository serviceCategory `Update` `Updates`: %w", err)
	// // }

	// return nil
	tx := repo.db.Begin()
	defer tx.Rollback()

	oldEc := ec

	if len(oldEc.Documents) != 0 {
		if err := tx.Model(&ec).Association("Documents").Clear(); err != nil {
			return fmt.Errorf("repository serviceCategory: Clear Association: %w", err)
		}

		var ids []int
		for i := range oldEc.Documents {
			ids = append(ids, oldEc.Documents[i].ID)
		}

		if err := tx.Delete(&oldEc.Documents, "id in ?", ids).Error; err != nil {
			return fmt.Errorf("repository serviceCategory Delet old Documents : %w", err)
		}

		if err := tx.Create(&oldEc.Documents).Error; err != nil {
			return fmt.Errorf("repository serviceCategory Creat new Document: %w", err)
		}

		for i := range oldEc.Documents {
			categoryDocs := model.ServiceCategoriyDocuments{
				ServiceCategoryID: oldEc.ID,
				DocumentID:        oldEc.Documents[i].ID,
			}

			if err := tx.Create(&categoryDocs).Error; err != nil {
				return fmt.Errorf("repository serviceCategory Create Association Document: %w", err)
			}
		}
	}

	stmt := repo.db.
		WithContext(ctx).
		Where("id = ?", ec.ID).
		Save(&ec)
	if stmt.Error != nil {
		return fmt.Errorf("repository serviceCategory `Update` `Updates`: %w", stmt.Error)
	}

	tx.Commit()
	return nil
}

func (repo *serviceCategory) Delete(ctx context.Context, id int) error {
	err := repo.db.WithContext(ctx).Delete(&model.ServiceCategory{}, id).Error
	if err != nil {
		return fmt.Errorf("repository serviceCategory `Delete` `Delete`: %w", err)
	}

	return nil
}
