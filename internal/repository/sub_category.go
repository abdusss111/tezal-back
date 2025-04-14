package repository

import (
	"context"
	"fmt"
	"time"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type sbRepo struct {
	db *gorm.DB
}

type ISubCategory interface {
	Create(sb model.SubCategory) (int, error)
	Get(sb model.SubCategory) (model.SubCategory, error)
	GetList() ([]model.SubCategory, error)
	GetByID(ctx context.Context, id int) (model.SubCategory, error)
	Update(sb model.SubCategory) (model.SubCategory, error)
	Delete(sb model.SubCategory) error
	BindAlias(sb model.SubCategory) error
	UpdateAlias(sb model.SubCategory) error
}

func NewSubCategoryRepository(db *gorm.DB) *sbRepo {
	return &sbRepo{
		db: db,
	}
}

func (r *sbRepo) Create(sb model.SubCategory) (int, error) {
	if err := r.db.Model(&model.SubCategory{}).Create(&sb).Error; err != nil {
		return 0, err
	}

	return sb.ID, nil
}

func (r *sbRepo) GetByID(ctx context.Context, id int) (model.SubCategory, error) {
	res := model.SubCategory{}

	err := r.db.WithContext(ctx).
		Preload("Documents").
		Preload("Alias").
		Preload("Types").
		Preload("Types.Documents").
		Preload("Types.Params").
		Preload("Types.Alias").
		Find(&res, id).Error
	if err != nil {
		return res, fmt.Errorf("repository sbRepo `GetByID` `Find`: %w", err)
	}

	return res, nil
}

func (r *sbRepo) Get(sb model.SubCategory) (model.SubCategory, error) {
	res := r.db.Model(&model.SubCategory{}).Preload("Documents").Preload("Alias").Find(&sb)
	if res.Error != nil {
		return sb, res.Error
	}

	if res.RowsAffected == 0 {
		return sb, gorm.ErrRecordNotFound
	}

	return sb, nil
}

func (r *sbRepo) Update(sb model.SubCategory) (model.SubCategory, error) {
	oldSb := sb
	if len(oldSb.Documents) != 0 {
		if err := r.db.Model(&sb).Association("Documents").Clear(); err != nil {
			return sb, err
		}

		var ids []int
		for i := range oldSb.Documents {
			ids = append(ids, oldSb.Documents[i].ID)
		}

		if err := r.db.Delete(&oldSb.Documents, "id in ?", ids).Error; err != nil {
			return sb, err
		}

		if err := r.db.Create(&oldSb.Documents).Error; err != nil {
			return sb, err
		}

		for i := range oldSb.Documents {
			subCategoryDocs := model.SubCategoryDocuments{
				SubCategoryID: oldSb.ID,
				DocumentID:    oldSb.Documents[i].ID,
			}

			if err := r.db.Create(&subCategoryDocs).Error; err != nil {
				return sb, err
			}
		}
	}

	return oldSb, r.db.Model(&oldSb).Model(&model.SubCategory{}).
		Where("id = ?", oldSb.ID).
		Update("name", oldSb.Name).
		Update("updated_at", time.Now()).Error
}

func (r *sbRepo) Delete(sb model.SubCategory) error {
	return r.db.Delete(&sb).Error
}

func (r *sbRepo) GetList() (sbs []model.SubCategory, err error) {
	res := r.db.Model(&model.SubCategory{}).Preload("Documents").Preload("Alias").Find(&sbs)

	if err = res.Where("deleted_at is NULL").Find(&sbs).Error; err != nil {
		return sbs, err
	}

	return sbs, nil
}

func (r *sbRepo) BindAlias(sb model.SubCategory) error {
	tx := r.db.Begin()

	defer tx.Rollback()
	if err := tx.Create(&sb.Alias).Error; err != nil {
		return err
	}

	type subCategoryAlias struct {
		SubCategoryID int
		AliasID       int
	}

	for i := range sb.Alias {
		if err := tx.Create(&subCategoryAlias{
			SubCategoryID: sb.ID,
			AliasID:       sb.Alias[i].ID,
		}).Error; err != nil {
			return err
		}
	}

	return tx.Commit().Error
}

func (r *sbRepo) UpdateAlias(sb model.SubCategory) error {
	return r.db.Updates(sb).Error
}
