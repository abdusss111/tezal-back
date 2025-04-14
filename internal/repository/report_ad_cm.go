package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IReportAdConstructionMaterial interface {
	Create(ctx context.Context, report model.ReportAdConstructionMaterials) error
	Get(ctx context.Context, f model.FilterReportAdConstructionMaterials) ([]model.ReportAdConstructionMaterials, int, error)
	GetByID(ctx context.Context, id int) (model.ReportAdConstructionMaterials, error)
	Delete(ctx context.Context, id int) error
}

type reportAdConstructionMaterial struct {
	db *gorm.DB
}

func NewReportAdConstructionMaterial(db *gorm.DB) IReportAdConstructionMaterial {
	return &reportAdConstructionMaterial{db: db}
}

func (r *reportAdConstructionMaterial) Create(ctx context.Context, report model.ReportAdConstructionMaterials) error {
	stmt := r.db.WithContext(ctx).Create(&report)
	if stmt.Error != nil {
		return fmt.Errorf("repository reportAdConstructionMaterial `Create`: %w", stmt.Error)
	}
	return nil
}

func (r *reportAdConstructionMaterial) Get(ctx context.Context, f model.FilterReportAdConstructionMaterials) ([]model.ReportAdConstructionMaterials, int, error) {
	res := make([]model.ReportAdConstructionMaterials, 0)

	stmt := r.db.WithContext(ctx)

	if f.ReportReasonsDetail != nil && *f.ReportReasonsDetail {
		stmt = stmt.Preload("ReportReasons")
	}
	if f.AdConstructionMaterialDetail != nil && *f.AdConstructionMaterialDetail {
		stmt = stmt.
			Preload("AdConstructionMaterial").
			Preload("AdConstructionMaterial.User").
			Preload("AdConstructionMaterial.ConstructionMaterialBrand").
			Preload("AdConstructionMaterial.ConstructionMaterialSubCategory").
			Preload("AdConstructionMaterial.City")
	}
	if f.AdConstructionMaterialDocumentDetail != nil && *f.AdConstructionMaterialDocumentDetail {
		stmt = stmt.Preload("AdConstructionMaterial.Documents")
	}

	if f.IDs != nil {
		stmt = stmt.Where("id in (?)", f.IDs)
	}
	if f.ReportReasonsIDs != nil {
		stmt = stmt.Where("report_reasons_id in (?)", f.ReportReasonsIDs)
	}
	if f.AdConstructionMaterialIDs != nil {
		stmt = stmt.Where("ad_construction_material_id in (?)", f.AdConstructionMaterialIDs)
	}

	if f.Limit != nil {
		stmt = stmt.Limit(*f.Limit)
	}
	if f.Offset != nil {
		stmt = stmt.Offset(*f.Offset)
	}

	stmt = stmt.Find(&res)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository reportAdConstructionMaterial `Get`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository reportAdConstructionMaterial `Get` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}

func (r *reportAdConstructionMaterial) GetByID(ctx context.Context, id int) (model.ReportAdConstructionMaterials, error) {
	res := model.ReportAdConstructionMaterials{}

	stmt := r.db.WithContext(ctx).
		Preload("ReportReasons").
		Preload("AdConstructionMaterial").
		Preload("AdConstructionMaterial.Documents").
		Preload("AdConstructionMaterial.User").
		Preload("AdConstructionMaterial.ConstructionMaterialBrand").
		Preload("AdConstructionMaterial.ConstructionMaterialSubCategory").
		Preload("AdConstructionMaterial.City").
		Unscoped().Find(&res, id)
	if stmt.Error != nil {
		return model.ReportAdConstructionMaterials{}, fmt.Errorf("repository reportAdConstructionMaterial `GetByID`: %w", stmt.Error)
	}

	return res, nil
}

func (r *reportAdConstructionMaterial) Delete(ctx context.Context, id int) error {
	stmt := r.db.Delete(&model.ReportAdConstructionMaterials{}, id)
	if stmt.Error != nil {
		return fmt.Errorf("repository reportAdConstructionMaterial `Delete`: %w", stmt.Error)
	}

	return nil
}
