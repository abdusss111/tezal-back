package repository

import (
	"context"
	"database/sql"
	"errors"
	"fmt"
	"log"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

// IAdSpecializedMachinery defines the interface for our repository.
type IAdSpecializedMachinery interface {
	Create(ad model.AdSpecializedMachinery) (int, error)
	CreateLinkDocument(links ...model.AdSpecializedMachineriesDocuments) error
	Get(ctx context.Context, f model.FilterAdSpecializedMachinery) ([]model.AdSpecializedMachinery, int, error)
	GetByID(id int) (model.AdSpecializedMachinery, error)
	GetDocumentByID(adID int) ([]model.Document, error)
	Update(ad model.AdSpecializedMachinery) error
	UpdateFoto(ad model.AdSpecializedMachinery) error
	Delete(id int) error
	Interacted(adID int, userID int) error
	GetInteracted(adID int) ([]model.AdSpecializedMachineryInteracted, error)
	GetByIDSeen(ctx context.Context, id int) (int, error)
	CreateSeen(ctx context.Context, id int) error
	IncrementSeen(ctx context.Context, id int) error
}

type adSpecializedMachinery struct {
	db *gorm.DB
}

// NewAdSpecializedMachinery returns a new repository instance.
func NewAdSpecializedMachinery(db *gorm.DB) IAdSpecializedMachinery {
	return &adSpecializedMachinery{db: db}
}

// Create creates a new ad in a transaction.
func (a *adSpecializedMachinery) Create(ad model.AdSpecializedMachinery) (int, error) {
	tx := a.db.Begin()
	defer tx.Rollback()

	if err := tx.Omit("Params", "count_rate", "rating").Create(&ad).Error; err != nil {
		return 0, fmt.Errorf("repository adSpecializedMachinery: Create base: %w", err)
	}

	// Set the foreign key in the Params
	ad.Params.AdSpecializedMachineryID = ad.ID

	if err := tx.Create(&ad.Params).Error; err != nil {
		return 0, fmt.Errorf("repository adSpecializedMachinery: Create params: %w", err)
	}

	tx.Commit()
	return ad.ID, nil
}

// CreateLinkDocument creates many-to-many link records.
func (a *adSpecializedMachinery) CreateLinkDocument(links ...model.AdSpecializedMachineriesDocuments) error {
	return a.db.Table("ad_specialized_machineries_documents").Create(links).Error
}

// GetDocumentByID returns documents for a given ad.
// Note: We assume that in the join table the column for the document is "document_id".
func (a *adSpecializedMachinery) GetDocumentByID(adID int) ([]model.Document, error) {
	docs := make([]model.Document, 0)
	query := `
		SELECT *
		FROM "documents"
		WHERE id = ANY(
			SELECT document_id
			FROM ad_specialized_machineries_documents
			WHERE ad_specialized_machinery_id = ?
		)
	`
	if err := a.db.Raw(query, adID).Scan(&docs).Error; err != nil {
		return nil, err
	}
	return docs, nil
}
func (r *adSpecializedMachinery) Get(ctx context.Context, f model.FilterAdSpecializedMachinery) ([]model.AdSpecializedMachinery, int, error) {
	log.Printf("Starting repository.Get with filters: %+v", f)
	ads := make([]model.AdSpecializedMachinery, 0)

	// 1) Build a filterStmt that applies all filters
	//    but DOES NOT add preloads, sorting, limit, offset.
	filterStmt := r.db.WithContext(ctx).Model(&model.AdSpecializedMachinery{})

	// Debug if you want to see generated queries
	// filterStmt = filterStmt.Debug()

	// --- Apply common filters (soft-delete handling) ---
	filterStmt = filterStmt.Where("deleted_at IS NULL")
	if f.Unscoped != nil && *f.Unscoped {
		filterStmt = filterStmt.Unscoped()
	}

	// --- Apply field-based filters ---
	if len(f.UserID) > 0 {
		filterStmt = filterStmt.Where("user_id IN ?", f.UserID)
	}
	if f.TypeID != nil {
		filterStmt = filterStmt.Where("type_id = ?", *f.TypeID)
	}
	if f.CityID != nil && *f.CityID != 92 {
		filterStmt = filterStmt.Where("city_id = ?", *f.CityID)
	}
	if f.SubCategoryID != nil {
		filterStmt = filterStmt.Where("type_id IN (SELECT id FROM types WHERE sub_category_id = ?)", *f.SubCategoryID)
	}
	if f.Name != nil {
		filterStmt = filterStmt.Where("name ILIKE ?", "%"+*f.Name+"%")
	}
	if f.Description != nil {
		filterStmt = filterStmt.Where("description ILIKE ?", "%"+*f.Description+"%")
	}

	// --- Numeric range filters ---
	filterStmt = setFilterParamByStmt(filterStmt, "price", f.Price)
	// (Apply other numeric filters similarly...)

	// 2) Count how many records match these filters
	//    (no preloads, limit, offset, or ordering for the count)
	var total int64
	if err := filterStmt.Count(&total).Error; err != nil {
		log.Printf("Error executing Count: %v", err)
		return nil, 0, err
	}
	log.Printf("Total records matching filters: %d", total)

	// 3) Now build a dataStmt that includes the same filters
	//    plus any preloads, sorting, limit, offset.
	dataStmt := r.db.WithContext(ctx).Model(&model.AdSpecializedMachinery{})

	// Re-apply the same filters
	dataStmt = dataStmt.Where("deleted_at IS NULL")
	if f.Unscoped != nil && *f.Unscoped {
		dataStmt = dataStmt.Unscoped()
	}
	if len(f.UserID) > 0 {
		dataStmt = dataStmt.Where("user_id IN ?", f.UserID)
	}
	if f.TypeID != nil {
		dataStmt = dataStmt.Where("type_id = ?", *f.TypeID)
	}
	if f.CityID != nil && *f.CityID != 92 {
		dataStmt = dataStmt.Where("city_id = ?", *f.CityID)
	}
	if f.SubCategoryID != nil {
		dataStmt = dataStmt.Where("type_id IN (SELECT id FROM types WHERE sub_category_id = ?)", *f.SubCategoryID)
	}
	if f.Name != nil {
		dataStmt = dataStmt.Where("name ILIKE ?", "%"+*f.Name+"%")
	}
	if f.Description != nil {
		dataStmt = dataStmt.Where("description ILIKE ?", "%"+*f.Description+"%")
	}
	dataStmt = setFilterParamByStmt(dataStmt, "price", f.Price)
	// ... Add the other numeric filters again ...

	// 4) Preload associations, if requested
	if f.UserDetail != nil && *f.UserDetail {
		dataStmt = dataStmt.Preload("User")
	}
	if f.BrandDetail != nil && *f.BrandDetail {
		dataStmt = dataStmt.Preload("Brand")
	}
	if f.TypeDetail != nil && *f.TypeDetail {
		dataStmt = dataStmt.Preload("Type")
	}
	if f.CityDetail != nil && *f.CityDetail {
		dataStmt = dataStmt.Preload("City")
	}
	if f.DocumentDetail != nil && *f.DocumentDetail {
		dataStmt = dataStmt.Preload("Document")
	}

	// 5) Sorting
	if len(f.ASC) > 0 {
		for _, col := range f.ASC {
			dataStmt = dataStmt.Order(fmt.Sprintf("%s ASC", col))
		}
	}
	if len(f.DESC) > 0 {
		for _, col := range f.DESC {
			dataStmt = dataStmt.Order(fmt.Sprintf("%s DESC", col))
		}
	}
	// If you have a default order:
	dataStmt = dataStmt.Order("updated_at DESC")

	// 6) Pagination
	if f.Limit != nil {
		dataStmt = dataStmt.Limit(*f.Limit)
	}
	if f.Offset != nil {
		dataStmt = dataStmt.Offset(*f.Offset)
	}

	// 7) Execute the final query for data
	if err := dataStmt.Find(&ads).Error; err != nil {
		log.Printf("Error executing Find: %v", err)
		return nil, 0, err
	}

	log.Printf("Repository.Get completed successfully. Total records: %d", total)
	return ads, int(total), nil
}

// GetByID returns one ad by its ID.
func (a *adSpecializedMachinery) GetByID(id int) (model.AdSpecializedMachinery, error) {
	var adsm model.AdSpecializedMachinery
	res := a.db.
		Preload("City").
		Preload("User").
		Preload("Brand").
		Preload("Type").
		Preload("Document").
		Preload("Params").
		First(&adsm, id)
	if res.Error != nil {
		return adsm, res.Error
	}
	return adsm, nil
}

// Update updates an ad.
func (a *adSpecializedMachinery) Update(ad model.AdSpecializedMachinery) error {
	return a.db.Model(&model.AdSpecializedMachinery{}).Where("id = ?", ad.ID).Save(ad).Error
}

// UpdateFoto updates only the photos of an ad in a transaction.
func (a *adSpecializedMachinery) UpdateFoto(ad model.AdSpecializedMachinery) error {
	return a.db.Transaction(func(tx *gorm.DB) error {
		// Use tx instead of a.db for the transaction.
		if err := tx.Create(&ad.Document).Error; err != nil {
			return err
		}

		links := make([]model.AdSpecializedMachineriesDocuments, 0, len(ad.Document))
		for _, d := range ad.Document {
			l := model.AdSpecializedMachineriesDocuments{
				AdSpecializedMachineryID: ad.ID,
				DocumentID:               d.ID,
			}
			links = append(links, l)
		}

		if err := tx.Create(&links).Error; err != nil {
			return err
		}

		return nil
	})
}

// Delete performs a soft delete on an ad.
func (a *adSpecializedMachinery) Delete(id int) error {
	return a.db.Where("id = ?", id).Delete(&model.AdSpecializedMachinery{}).Error
}

// Interacted creates a record of a user interacting with an ad.
func (a *adSpecializedMachinery) Interacted(adID int, userID int) error {
	return a.db.Create(&model.AdSpecializedMachineryInteracted{
		AdSpecializedMachineryID: adID,
		UserID:                   userID,
	}).Error
}

// GetInteracted returns all interactions for a given ad.
func (a *adSpecializedMachinery) GetInteracted(adID int) ([]model.AdSpecializedMachineryInteracted, error) {
	var adsmi []model.AdSpecializedMachineryInteracted
	return adsmi, a.db.Where("ad_specialized_machinery_id = ?", adID).Preload("User").Find(&adsmi).Error
}

// GetByIDSeen returns the view count for an ad.
func (repo *adSpecializedMachinery) GetByIDSeen(ctx context.Context, id int) (int, error) {
	stmt := repo.db.WithContext(ctx).Table("ad_specialized_machinery_seen")
	rows := stmt.Where("ad_specialized_machinery_id = ?", id).Select("count").Row()
	if rows.Err() != nil {
		return 0, fmt.Errorf("repository adSpecializedMachinery GetByIDSeen: %w", rows.Err())
	}
	count := 0
	if err := rows.Scan(&count); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return 0, fmt.Errorf("repository adSpecializedMachinery GetByIDSeen: %w", model.ErrNotFound)
		}
		return 0, fmt.Errorf("repository adSpecializedMachinery GetByIDSeen: %w", err)
	}
	return count, nil
}

// CreateSeen creates an entry in the seen table.
func (repo *adSpecializedMachinery) CreateSeen(ctx context.Context, id int) error {
	stmt := repo.db.WithContext(ctx).Table("ad_specialized_machinery_seen")
	stmt = stmt.Exec(`INSERT INTO ad_specialized_machinery_seen (ad_specialized_machinery_id)
	VALUES (?)`, id)
	if stmt.Error != nil {
		return fmt.Errorf("repository adSpecializedMachinery CreateSeen: %w", stmt.Error)
	}
	return nil
}

// IncrementSeen increments the view count for an ad.
func (repo *adSpecializedMachinery) IncrementSeen(ctx context.Context, id int) error {
	stmt := repo.db.WithContext(ctx).Table("ad_specialized_machinery_seen")
	stmt = stmt.Exec(`UPDATE ad_specialized_machinery_seen
	SET count = count + 1
	WHERE ad_specialized_machinery_id = ?`, id)
	if stmt.Error != nil {
		if errors.Is(stmt.Error, gorm.ErrRecordNotFound) {
			return fmt.Errorf("repository adSpecializedMachinery IncrementSeen: %w", model.ErrNotFound)
		}
		return fmt.Errorf("repository adSpecializedMachinery IncrementSeen: %w", stmt.Error)
	}
	return nil
}
