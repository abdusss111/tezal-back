package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IReportSysytem interface {
	Create(ctx context.Context, report model.ReportSystem) error
	Get(ctx context.Context, f model.FilterReportSystem) ([]model.ReportSystem, int, error)
	GetByID(ctx context.Context, id int) (model.ReportSystem, error)
	Delete(ctx context.Context, id int) error
}

type reportSysytem struct {
	db *gorm.DB
}

func NewReportSysytem(db *gorm.DB) IReportSysytem {
	return &reportSysytem{db: db}
}

func (r *reportSysytem) Create(ctx context.Context, report model.ReportSystem) error {
	stmt := r.db.WithContext(ctx).Create(&report)
	if stmt.Error != nil {
		return fmt.Errorf("repository reportSysytem `Create`: %w", stmt.Error)
	}
	return nil
}

func (r *reportSysytem) Get(ctx context.Context, f model.FilterReportSystem) ([]model.ReportSystem, int, error) {
	res := make([]model.ReportSystem, 0)

	stmt := r.db.WithContext(ctx)

	if f.ReportReasonSystemDetail != nil && *f.ReportReasonSystemDetail {
		stmt = stmt.Preload("ReportReasonSystem")
	}
	if f.ID != nil {
		stmt = stmt.Where("id in (?)", f.ID)
	}
	if f.ReportReasonSystemID != nil {
		stmt = stmt.Where("report_reason_system_id in (?)", f.ReportReasonSystemID)
	}
	if f.Limit != nil {
		stmt = stmt.Limit(*f.Limit)
	}
	if f.Offset != nil {
		stmt = stmt.Offset(*f.Offset)
	}

	stmt = stmt.Find(&res)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository reportSysytem `Get`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository reportSysytem `Get` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}

func (r *reportSysytem) GetByID(ctx context.Context, id int) (model.ReportSystem, error) {
	res := model.ReportSystem{}

	stmt := r.db.WithContext(ctx).
		Preload("User").
		Preload("ReportReasonSystem").
		Unscoped().Find(&res, id)
	if stmt.Error != nil {
		return model.ReportSystem{}, fmt.Errorf("repository reportSysytem `GetByID`: %w", stmt.Error)
	}

	return res, nil
}

func (r *reportSysytem) Delete(ctx context.Context, id int) error {
	stmt := r.db.Delete(&model.ReportSystem{}, id)
	if stmt.Error != nil {
		return fmt.Errorf("repository reportSysytem `Delete`: %w", stmt.Error)
	}

	return nil
}
