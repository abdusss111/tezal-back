package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IEquipmentSubCategory interface {
	GetList(ctx context.Context) ([]model.EquipmentSubCategory, error)
	Get(ctx context.Context, f model.FilterEquipmentSubCategory) ([]model.EquipmentSubCategory, error)
	GetByID(ctx context.Context, id int) (model.EquipmentSubCategory, error)
	Create(ctx context.Context, ec model.EquipmentSubCategory) error
	Update(ctx context.Context, ec model.EquipmentSubCategory) error
	Delete(ctx context.Context, id int) error
}

type equipmentSubCategory struct {
	db *gorm.DB
}

func NewEquipmentSubCategory(db *gorm.DB) IEquipmentSubCategory {
	return &equipmentSubCategory{db: db}
}

func (repo *equipmentSubCategory) GetList(ctx context.Context) ([]model.EquipmentSubCategory, error) {
	res := make([]model.EquipmentSubCategory, 0)
	err := repo.db.Model(&model.EquipmentSubCategory{}).Find(&res).Error

	if err != nil {
		return nil, fmt.Errorf("repository equipmentSubCategory `Get` `Find`: %w", err)
	}

	return res, nil
}

func (repo *equipmentSubCategory) Get(ctx context.Context, f model.FilterEquipmentSubCategory) ([]model.EquipmentSubCategory, error) {
	res := make([]model.EquipmentSubCategory, 0)

	stmt := repo.db.WithContext(ctx).Model(&model.EquipmentSubCategory{})

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

	if len(f.EquipmentCategoryIDs) != 0 {
		stmt = stmt.Where("equipment_categories_id IN (?)", f.EquipmentCategoryIDs)
	}

	if f.Name != nil {
		stmt = stmt.Where("name ILIKE '%' || ? || '%' ", f.Name)
	}

	err := stmt.Find(&res).Error
	if err != nil {
		return nil, fmt.Errorf("repository equipmentSubCategory `Get` `Find`: %w", err)
	}

	return res, nil
}

func (repo *equipmentSubCategory) GetByID(ctx context.Context, id int) (model.EquipmentSubCategory, error) {
	res := model.EquipmentSubCategory{}

	stmt := repo.db.WithContext(ctx).Unscoped()

	stmt = stmt.Preload("Alias").Preload("Documents").Preload("Params")

	err := stmt.Find(&res, id).Error
	if err != nil {
		return res, fmt.Errorf("repository equipmentSubCategory `GetByID` `Find`: %w", err)
	}

	return res, nil
}

func (repo *equipmentSubCategory) Create(ctx context.Context, ec model.EquipmentSubCategory) error {
	err := repo.db.WithContext(ctx).Create(&ec).Error
	if err != nil {
		return fmt.Errorf("repository equipmentSubCategory `Create` `Create`: %w", err)
	}

	return nil
}

func (repo *equipmentSubCategory) Update(ctx context.Context, ec model.EquipmentSubCategory) error {
	tx := repo.db.Begin()
	defer tx.Rollback()

	oldEc := ec

	if len(oldEc.Documents) != 0 {
		if err := tx.Model(&ec).Association("Documents").Clear(); err != nil {
			return fmt.Errorf("repository equipmentSubCategory: Clear Association: %w", err)
		}

		var ids []int
		for i := range oldEc.Documents {
			ids = append(ids, oldEc.Documents[i].ID)
		}

		if err := tx.Delete(&oldEc.Documents, "id in ?", ids).Error; err != nil {
			return fmt.Errorf("repository equipmentSubCategory Delet old Documents : %w", err)
		}

		if err := tx.Create(&oldEc.Documents).Error; err != nil {
			return fmt.Errorf("repository equipmentSubCategory Creat new Document: %w", err)
		}

		for i := range oldEc.Documents {
			subCategoryDocs := model.EquipmentSubCategoriesDocuments{
				EquipmentSubCategoryID: oldEc.ID,
				DocumentID:             oldEc.Documents[i].ID,
			}

			if err := tx.Create(&subCategoryDocs).Error; err != nil {
				return fmt.Errorf("repository equipmentSubCategory Create Association Document: %w", err)
			}
		}
	}

	stmt := repo.db.
		WithContext(ctx).
		Where("id = ?", ec.ID).
		Where("equipment_categories_id = ?", ec.EquipmentCategoriesID).
		Save(&ec)
	if stmt.Error != nil {
		return fmt.Errorf("repository equipmentSubCategory `Update` `Updates`: %w", stmt.Error)
	}

	tx.Commit()
	return nil
}

func (repo *equipmentSubCategory) Delete(ctx context.Context, id int) error {
	err := repo.db.WithContext(ctx).Delete(&model.EquipmentSubCategory{}, id).Error
	if err != nil {
		return fmt.Errorf("repository equipmentSubCategory `Delete` `Delete`: %w", err)
	}

	return nil
}
