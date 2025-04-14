package repository

import (
	"context"
	"database/sql"
	"errors"
	"fmt"

	"github.com/sirupsen/logrus"
	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IDocument interface {
	Create(ctx context.Context, document model.Document) (model.Document, error)
	CreateMany(ctx context.Context, doc ...*model.Document) error
	GetByUserID(ctx context.Context, document model.Document) (model.Document, error)
	GetByID(ctx context.Context, id int, model string) (model.Document, error)
	Update(ctx context.Context, document model.Document) error
	Delete(ctx context.Context, document []model.Document) error
	DeleteUnscoped(id ...int) error
	GetListDocuments(ctx context.Context) ([]model.Document, error)
}

type docRepo struct {
	db *gorm.DB
}

func NewDocumentRepository(db *gorm.DB) *docRepo {
	return &docRepo{
		db: db,
	}
}

func (r *docRepo) Create(ctx context.Context, doc model.Document) (model.Document, error) {
	// logrus.Debugf("[input]: %+v", doc)

	return doc, r.db.WithContext(ctx).
		Model(model.Document{}).
		Create(&doc).
		Error
}

func (r *docRepo) CreateMany(ctx context.Context, doc ...*model.Document) error {
	return r.db.WithContext(ctx).
		Model(model.Document{}).
		Create(doc).Error
}

func (r *docRepo) GetByUserID(ctx context.Context, doc model.Document) (model.Document, error) {
	// logrus.Debugf("[input]: %+v", doc)

	var documentCount int64
	if err := r.db.WithContext(ctx).
		Model(model.Document{}).
		Where("user_id = ?", doc.UserID).
		Find(&doc).Count(&documentCount).Error; err != nil {
		logrus.Errorf("[error]: %+v", err)
	}

	if documentCount == 0 {
		return doc, gorm.ErrRecordNotFound
	}

	return doc, nil
}

func (r *docRepo) Update(ctx context.Context, doc model.Document) error {
	// logrus.Debugf("[input]: %+v", doc)

	tx := r.db.WithContext(ctx).Model(model.Document{}).
		Where("id = ?", doc.ID).
		Where("user_id = ?", doc.UserID).Save(&doc)
	if tx.Error != nil {
		logrus.Errorf("[error]: %+v", tx.Error)
	}

	if tx.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}

	return nil
}

func (r *docRepo) Delete(ctx context.Context, doc []model.Document) error {
	// logrus.Debugf("[input]: %+v", doc)

	ids := make([]int, 0, len(doc))
	for i := range doc {
		ids = append(ids, doc[i].ID)
	}

	tx := r.db.WithContext(ctx).Delete(&doc, ids)
	if tx.Error != nil {
		logrus.Errorf("[error]: %+v", tx.Error)
	}

	if tx.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}

	return nil
}

func (r *docRepo) DeleteUnscoped(id ...int) error {
	if len(id) == 0 {
		return nil
	}

	tx := r.db.Begin(&sql.TxOptions{
		Isolation: sql.LevelSerializable,
	})
	defer tx.Rollback()
	if err := tx.Error; err != nil {
		return err
	}

	err := tx.Unscoped().
		Table("ad_specialized_machineries_documents").
		Where("document_id IN (?)", id).
		Delete(&model.AdSpecializedMachineriesDocuments{}).
		Error
	if err != nil {
		return err
	}

	err = tx.Unscoped().Delete(model.Document{}, id).
		Error
	if err != nil {

		return err
	}

	return tx.Commit().Error
}

func (r *docRepo) GetListDocuments(ctx context.Context) (docs []model.Document, err error) {
	tx := r.db.WithContext(ctx).Raw("select * from documents").Scan(&docs)
	if tx.Error != nil {
		logrus.Errorf("[error]: %+v", tx.Error)
		return docs, err
	}

	if tx.RowsAffected == 0 {
		return docs, gorm.ErrRecordNotFound
	}

	return docs, nil
}

func (r *docRepo) GetByID(ctx context.Context, modelID int, modelName string) (model.Document, error) {
	var document model.Document
	var documentID string

	var modelDB interface{}

	switch modelName {
	case "ad_specialized_machinery":
		documentID = "ad_specialized_machinery_id"
		modelDB = &model.AdSpecializedMachineriesDocuments{}
	case "ad_clients":
		documentID = "ad_client_id"
		modelDB = &model.AdClientDocuments{}
	case "ad_equipments":
		documentID = "ad_equipment_id"
		modelDB = &model.AdEquipmentDocuments{}
	case "ad_equipment_clients":
		documentID = "ad_equipment_client_id"
		modelDB = &model.AdEquipmentClientDocuments{}
	case "ad_construction_material":
		documentID = "ad_construction_material_id"
		modelDB = &model.AdConstructionMaterialDocuments{}
	case "ad_construction_material_clients":
		documentID = "ad_construction_material_client_id"
		modelDB = &model.AdConstructionMaterialClientDocuments{}
	case "ad_service":
		documentID = "ad_service_id"
		modelDB = &model.AdServiceDocuments{}
	default:
		return document, fmt.Errorf("unknown model name: %s", modelName)
	}

	var documentIDs []int

	if err := r.db.WithContext(ctx).
		Model(modelDB).
		Select("document_id").
		Where(documentID+" = ?", modelID).
		Find(&documentIDs).Error; err != nil {
		logrus.Errorf("Error fetching document IDs for adsMachineryId %d: %v", modelID, err)
		return document, err
	}

	if len(documentIDs) == 0 {
		logrus.Warnf("No documents found for adsMachineryId: %d", modelID)
		return document, nil // Возвращаем пустой объект, если документов нет
	}

	if err := r.db.WithContext(ctx).
		Model(&model.Document{}).
		Where("id IN ?", documentIDs).
		First(&document).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			logrus.Warnf("Document not found for adsMachineryId: %d", modelID)
			return document, fmt.Errorf("document not found for adsMachineryId %d: %w", modelID, gorm.ErrRecordNotFound)
		}
		logrus.Errorf("Error fetching document for adsMachineryId %d: %v", modelID, err)
		return document, err
	}

	//logrus.Infof("Document found: %+v", document)
	return document, nil
}
