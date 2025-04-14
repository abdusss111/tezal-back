package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IReportAdEquipment interface {
	Create(ctx context.Context, report model.ReportAdEquipments) error
	Get(ctx context.Context, f model.FilterReportAdEquipments) ([]model.ReportAdEquipments, int, error)
	GetByID(ctx context.Context, id int) (model.ReportAdEquipments, error)
	Delete(ctx context.Context, id int) error
}

type reportAdEquipment struct {
	db *gorm.DB
}

func NewReportAdEquipment(db *gorm.DB) IReportAdEquipment {
	return &reportAdEquipment{db: db}
}

func (r *reportAdEquipment) Create(ctx context.Context, report model.ReportAdEquipments) error {
	stmt := r.db.WithContext(ctx).Create(&report)
	if stmt.Error != nil {
		return fmt.Errorf("repository reportAdEquipment `Create`: %w", stmt.Error)
	}
	return nil
}

func (r *reportAdEquipment) Get(ctx context.Context, f model.FilterReportAdEquipments) ([]model.ReportAdEquipments, int, error) {
	res := make([]model.ReportAdEquipments, 0)

	stmt := r.db.WithContext(ctx)

	if f.ReportReasonsDetail != nil && *f.ReportReasonsDetail {
		stmt = stmt.Preload("ReportReasons")
	}
	if f.AdEquipmentDetail != nil && *f.AdEquipmentDetail {
		stmt = stmt.
			Preload("AdEquipment").
			Preload("AdEquipment.User").
			Preload("AdEquipment.EquipmentBrand").
			Preload("AdEquipment.EquipmentSubCategory").
			Preload("AdEquipment.City")
	}
	if f.AdEquipmentDocumentDetail != nil && *f.AdEquipmentDocumentDetail {
		stmt = stmt.Preload("AdEquipment.Documents")
	}

	if f.IDs != nil {
		stmt = stmt.Where("id in (?)", f.IDs)
	}
	if f.ReportReasonsIDs != nil {
		stmt = stmt.Where("report_reasons_id in (?)", f.ReportReasonsIDs)
	}
	if f.AdEquipmentIDs != nil {
		stmt = stmt.Where("ad_equipment_id in (?)", f.AdEquipmentIDs)
	}

	if f.Limit != nil {
		stmt = stmt.Limit(*f.Limit)
	}
	if f.Offset != nil {
		stmt = stmt.Offset(*f.Offset)
	}

	stmt = stmt.Find(&res)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository reportAdEquipment `Get`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository reportAdEquipment `Get` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}

func (r *reportAdEquipment) GetByID(ctx context.Context, id int) (model.ReportAdEquipments, error) {
	res := model.ReportAdEquipments{}

	stmt := r.db.WithContext(ctx).
		Preload("ReportReasons").
		Preload("AdEquipment").
		Preload("AdEquipment.Documents").
		Preload("AdEquipment.User").
		Preload("AdEquipment.EquipmentBrand").
		Preload("AdEquipment.EquipmentSubCategory").
		Preload("AdEquipment.City").
		Unscoped().Find(&res, id)
	if stmt.Error != nil {
		return model.ReportAdEquipments{}, fmt.Errorf("repository reportAdEquipment `GetByID`: %w", stmt.Error)
	}

	return res, nil
}

func (r *reportAdEquipment) Delete(ctx context.Context, id int) error {
	stmt := r.db.Delete(&model.ReportAdEquipments{}, id)
	if stmt.Error != nil {
		return fmt.Errorf("repository reportAdEquipment `Delete`: %w", stmt.Error)
	}

	return nil
}
