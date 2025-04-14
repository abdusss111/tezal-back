package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IReportAdSpecializedMachinery interface {
	Create(ctx context.Context, report model.ReportAdSpecializedMachineries) error
	Get(ctx context.Context, f model.FilterReportAdSpecializedMachineries) ([]model.ReportAdSpecializedMachineries, int, error)
	GetByID(ctx context.Context, id int) (model.ReportAdSpecializedMachineries, error)
	Delete(ctx context.Context, id int) error
}

type reportAdSpecializedMachinery struct {
	db *gorm.DB
}

func NewReportAdSpecializedMachinery(db *gorm.DB) IReportAdSpecializedMachinery {
	return &reportAdSpecializedMachinery{db: db}
}

func (r *reportAdSpecializedMachinery) Create(ctx context.Context, report model.ReportAdSpecializedMachineries) error {
	stmt := r.db.WithContext(ctx).Create(&report)
	if stmt.Error != nil {
		return fmt.Errorf("repository reportAdSpecializedMachinery `Create`: %w", stmt.Error)
	}
	return nil
}

func (r *reportAdSpecializedMachinery) Get(ctx context.Context, f model.FilterReportAdSpecializedMachineries) ([]model.ReportAdSpecializedMachineries, int, error) {
	res := make([]model.ReportAdSpecializedMachineries, 0)

	stmt := r.db.WithContext(ctx)

	if f.ReportReasonsDetail != nil && *f.ReportReasonsDetail {
		stmt = stmt.Preload("ReportReasons")
	}
	if f.AdSpecializedMachineryDetail != nil && *f.AdSpecializedMachineryDetail {
		stmt = stmt.
			Preload("AdSpecializedMachinery").
			Preload("AdSpecializedMachinery.User").
			Preload("AdSpecializedMachinery.Brand").
			Preload("AdSpecializedMachinery.Type").
			Preload("AdSpecializedMachinery.City")
	}
	if f.AdSpecializedMachineryDocumentDetail != nil && *f.AdSpecializedMachineryDocumentDetail {
		stmt = stmt.Preload("AdSpecializedMachinery.Document")
	}

	if f.IDs != nil {
		stmt = stmt.Where("id in (?)", f.IDs)
	}
	if f.ReportReasonsIDs != nil {
		stmt = stmt.Where("report_reasons_id in (?)", f.ReportReasonsIDs)
	}
	if f.AdSpecializedMachineryIDs != nil {
		stmt = stmt.Where("ad_specialized_machinery_id in (?)", f.AdSpecializedMachineryIDs)
	}

	if f.Limit != nil {
		stmt = stmt.Limit(*f.Limit)
	}
	if f.Offset != nil {
		stmt = stmt.Offset(*f.Offset)
	}

	stmt = stmt.Find(&res)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository reportAdSpecializedMachinery `Get`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository reportAdSpecializedMachinery `Get` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}

func (r *reportAdSpecializedMachinery) GetByID(ctx context.Context, id int) (model.ReportAdSpecializedMachineries, error) {
	res := model.ReportAdSpecializedMachineries{}

	stmt := r.db.WithContext(ctx).
		Preload("AdSpecializedMachinery").
		Preload("ReportReasons").
		Preload("AdSpecializedMachinery.Document").
		Preload("AdSpecializedMachinery.User").
		Preload("AdSpecializedMachinery.Brand").
		Preload("AdSpecializedMachinery.Type").
		Preload("AdSpecializedMachinery.City").
		Unscoped().Find(&res, id)
	if stmt.Error != nil {
		return model.ReportAdSpecializedMachineries{}, fmt.Errorf("repository reportAdSpecializedMachinery `GetByID`: %w", stmt.Error)
	}

	return res, nil
}

func (r *reportAdSpecializedMachinery) Delete(ctx context.Context, id int) error {
	stmt := r.db.Delete(&model.ReportAdSpecializedMachineries{}, id)
	if stmt.Error != nil {
		return fmt.Errorf("repository reportAdSpecializedMachinery `Delete`: %w", stmt.Error)
	}

	return nil
}
