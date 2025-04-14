package repository

import (
	"errors"
	"time"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IType interface {
	Get(f model.FilterType) ([]model.Type, error)
	GetByID(ct model.Type) (model.Type, error)
	Update(ct model.Type) (model.Type, error)
	Create(ct model.Type) (model.Type, error)
	Delete(ct model.Type) error
	GetList(ct model.Type) ([]model.Type, error)
	BindAlias(ct model.Type) error
	UpdateAlias(ct model.Type) error
}

type typeSM struct {
	db *gorm.DB
}

func NewType(db *gorm.DB) *typeSM {
	return &typeSM{db: db}
}

func (t *typeSM) Get(f model.FilterType) ([]model.Type, error) {
	tSMs := make([]model.Type, 0)

	result := t.db.Preload("Documents").Preload("Alias").Preload("Params").Find(&tSMs)
	if err := result.Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}

	return tSMs, nil
}

func (t *typeSM) Create(ct model.Type) (model.Type, error) {
	if err := t.db.Model(model.Type{}).Omit("id").Create(&ct).Error; err != nil {
		return ct, err
	}

	return ct, nil
}

func (t *typeSM) GetByID(ct model.Type) (model.Type, error) {
	if err := t.db.Model(model.Type{}).Preload("Documents").Preload("Params").Find(&ct).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return ct, model.ErrNotFound
		}

		return ct, err
	}

	return ct, nil
}

func (t *typeSM) GetList(ct model.Type) (cts []model.Type, err error) {
	if err = t.db.Model(model.Type{}).
		Where("sub_category_id = ?", ct.SubCategoryID).
		Preload("Documents").
		Preload("Params").
		Preload("Alias").
		Find(&cts).
		Error; err != nil {
		return cts, err
	}

	// for i := range cts {
	// 	if err = t.db.Raw(`
	// 		SELECT * FROM documents
	// 			right join type_documents on document_id = id
	// 		where type_id = ?
	// 	`, cts[i].ID).Scan(&cts[i].Documents).Error; err != nil {
	// 		return cts, err
	// 	}
	// }

	return cts, nil
}

func (t *typeSM) Delete(ct model.Type) error {
	if err := t.db.Model(&ct).Association("Documents").Clear(); err != nil {
		return err
	}

	return t.db.Delete(&ct).Error
}

func (t *typeSM) Update(ct model.Type) (model.Type, error) {
	oldCt := ct
	if len(oldCt.Documents) != 0 {
		if err := t.db.Model(&ct).Association("Documents").Clear(); err != nil {
			return ct, err
		}

		var ids []int
		for i := range oldCt.Documents {
			ids = append(ids, oldCt.Documents[i].ID)
		}

		if err := t.db.Delete(&oldCt.Documents, "id in ?", ids).Error; err != nil {
			return ct, err
		}

		if err := t.db.Create(&oldCt.Documents).Error; err != nil {
			return ct, err
		}

		for i := range oldCt.Documents {
			subCategoryDocs := model.TypeDocuments{
				TypeID:     oldCt.ID,
				DocumentID: oldCt.Documents[i].ID,
			}

			if err := t.db.Create(&subCategoryDocs).Error; err != nil {
				return ct, err
			}
		}
	}

	return oldCt, t.db.Model(&model.Type{}).
		Where("id = ?", oldCt.ID).
		Update("name", oldCt.Name).
		Update("updated_at", time.Now()).Error
}

func (t *typeSM) BindAlias(ct model.Type) error {
	tx := t.db.Begin()
	defer tx.Rollback()

	if err := t.db.Create(&ct.Alias).Error; err != nil {
		return err
	}

	type typeAliases struct {
		TypeID  int
		AliasID int
	}

	for i := range ct.Alias {
		if err := tx.Create(&typeAliases{
			TypeID:  ct.ID,
			AliasID: ct.Alias[i].ID,
		}).Error; err != nil {
			return err
		}
	}

	return tx.Commit().Error
}

func (t *typeSM) UpdateAlias(cr model.Type) error {
	return t.db.Updates(cr).Error
}
