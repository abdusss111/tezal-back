package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IEquipmentCategory interface {
	Get(ctx context.Context, f model.FilterEquipmentCategory) ([]model.EquipmentCategory, error)
	GetByID(ctx context.Context, id int) (model.EquipmentCategory, error)
	Create(ctx context.Context, ec model.EquipmentCategory) (int, error)
	Update(ctx context.Context, ec model.EquipmentCategory) error
	Delete(ctx context.Context, id int) error
}

type equipmentCategory struct {
	db *gorm.DB
}

func NewEquipmentCategory(db *gorm.DB) IEquipmentCategory {
	return &equipmentCategory{db: db}
}

func (repo *equipmentCategory) Get(ctx context.Context, f model.FilterEquipmentCategory) ([]model.EquipmentCategory, error) {
	res := make([]model.EquipmentCategory, 0)

	stmt := repo.db.WithContext(ctx).Model(&model.EquipmentCategory{})

	if f.Unscoped != nil && *f.Unscoped {
		stmt = stmt.Unscoped()
	}

	if f.DocumentsDetail != nil && *f.DocumentsDetail {
		stmt = stmt.Preload("Documents")
	}

	if f.SubCategoriesDatail != nil && *f.SubCategoriesDatail {
		stmt = stmt.Preload("EquipmentSubCategories").Preload("EquipmentSubCategories.Params")
	}

	if f.SubCategoriesDocumentsDetail != nil && *f.SubCategoriesDocumentsDetail {
		stmt = stmt.Preload("EquipmentSubCategories.Documents")
	}

	if len(f.IDs) != 0 {
		stmt = stmt.Where("id in (?)", f.IDs)
	}

	if f.Name != nil {
		stmt = stmt.Where("name ILIKE '%' || ? || '%' ", f.Name)
	}

	err := stmt.Find(&res).Error
	if err != nil {
		return nil, fmt.Errorf("repository equipmentCategory `Get` `Find`: %w", err)
	}

	return res, nil
}

func (repo *equipmentCategory) GetByID(ctx context.Context, id int) (model.EquipmentCategory, error) {
	res := model.EquipmentCategory{}

	err := repo.db.WithContext(ctx).
		Preload("EquipmentSubCategories").
		Preload("EquipmentSubCategories.Params").
		Preload("EquipmentSubCategories.Documents").
		Preload("Documents").
		Find(&res, id).Error
	if err != nil {
		return res, fmt.Errorf("repository equipmentCategory `GetByID` `Find`: %w", err)
	}

	return res, nil
}

func (repo *equipmentCategory) Create(ctx context.Context, ec model.EquipmentCategory) (int, error) {
	err := repo.db.WithContext(ctx).Create(&ec).Error
	if err != nil {
		return 0, fmt.Errorf("repository equipmentCategory `Create` `Create`: %w", err)
	}

	return ec.ID, nil
}

func (repo *equipmentCategory) Update(ctx context.Context, ec model.EquipmentCategory) error {
	// // value := make(map[string]any, 0)

	// // if ec.Name != "" {
	// // 	value["name"] = ec.Name
	// // }

	// stmt := repo.db.WithContext(ctx).Save(&ec)
	// if stmt.Error != nil {
	// 	return fmt.Errorf("repository equipmentCategory `Update` `Updates`: %w", stmt.Error)
	// }

	// // err := repo.db.WithContext(ctx).Model(&model.EquipmentCategory{}).Where("id = ?", ec.ID).Updates(value).Error
	// // if err != nil {
	// // 	return fmt.Errorf("repository equipmentCategory `Update` `Updates`: %w", err)
	// // }

	// return nil
	tx := repo.db.Begin()
	defer tx.Rollback()

	oldEc := ec

	if len(oldEc.Documents) != 0 {
		if err := tx.Model(&ec).Association("Documents").Clear(); err != nil {
			return fmt.Errorf("repository equipmentCategory: Clear Association: %w", err)
		}

		var ids []int
		for i := range oldEc.Documents {
			ids = append(ids, oldEc.Documents[i].ID)
		}

		if err := tx.Delete(&oldEc.Documents, "id in ?", ids).Error; err != nil {
			return fmt.Errorf("repository equipmentCategory Delet old Documents : %w", err)
		}

		if err := tx.Create(&oldEc.Documents).Error; err != nil {
			return fmt.Errorf("repository equipmentCategory Creat new Document: %w", err)
		}

		for i := range oldEc.Documents {
			categoryDocs := model.EquipmentCategoriyDocuments{
				EquipmentCategoryID: oldEc.ID,
				DocumentID:          oldEc.Documents[i].ID,
			}

			if err := tx.Create(&categoryDocs).Error; err != nil {
				return fmt.Errorf("repository equipmentCategory Create Association Document: %w", err)
			}
		}
	}

	stmt := repo.db.
		WithContext(ctx).
		Where("id = ?", ec.ID).
		Save(&ec)
	if stmt.Error != nil {
		return fmt.Errorf("repository equipmentCategory `Update` `Updates`: %w", stmt.Error)
	}

	tx.Commit()
	return nil
}

func (repo *equipmentCategory) Delete(ctx context.Context, id int) error {
	err := repo.db.WithContext(ctx).Delete(&model.EquipmentCategory{}, id).Error
	if err != nil {
		return fmt.Errorf("repository equipmentCategory `Delete` `Delete`: %w", err)
	}

	return nil
}
