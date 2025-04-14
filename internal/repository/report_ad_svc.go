package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IReportAdService interface {
	Create(ctx context.Context, report model.ReportAdServices) error
	Get(ctx context.Context, f model.FilterReportAdServices) ([]model.ReportAdServices, int, error)
	GetByID(ctx context.Context, id int) (model.ReportAdServices, error)
	Delete(ctx context.Context, id int) error
}

type reportAdService struct {
	db *gorm.DB
}

func NewReportAdService(db *gorm.DB) IReportAdService {
	return &reportAdService{db: db}
}

func (r *reportAdService) Create(ctx context.Context, report model.ReportAdServices) error {
	stmt := r.db.WithContext(ctx).Create(&report)
	if stmt.Error != nil {
		return fmt.Errorf("repository reportAdService `Create`: %w", stmt.Error)
	}
	return nil
}

func (r *reportAdService) Get(ctx context.Context, f model.FilterReportAdServices) ([]model.ReportAdServices, int, error) {
	res := make([]model.ReportAdServices, 0)

	stmt := r.db.WithContext(ctx)

	if f.ReportReasonsDetail != nil && *f.ReportReasonsDetail {
		stmt = stmt.Preload("ReportReasons")
	}
	if f.AdServiceDetail != nil && *f.AdServiceDetail {
		stmt = stmt.
			Preload("AdService").
			Preload("AdService.User").
			Preload("AdService.ServiceBrand").
			Preload("AdService.ServiceSubCategory").
			Preload("AdService.City")
	}
	if f.AdServiceDocumentDetail != nil && *f.AdServiceDocumentDetail {
		stmt = stmt.Preload("AdService.Documents")
	}

	if f.IDs != nil {
		stmt = stmt.Where("id in (?)", f.IDs)
	}
	if f.ReportReasonsIDs != nil {
		stmt = stmt.Where("report_reasons_id in (?)", f.ReportReasonsIDs)
	}
	if f.AdServiceIDs != nil {
		stmt = stmt.Where("ad_service_id in (?)", f.AdServiceIDs)
	}

	if f.Limit != nil {
		stmt = stmt.Limit(*f.Limit)
	}
	if f.Offset != nil {
		stmt = stmt.Offset(*f.Offset)
	}

	stmt = stmt.Find(&res)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository reportAdService `Get`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository reportAdService `Get` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}

func (r *reportAdService) GetByID(ctx context.Context, id int) (model.ReportAdServices, error) {
	res := model.ReportAdServices{}

	stmt := r.db.WithContext(ctx).
		Preload("ReportReasons").
		Preload("AdService").
		Preload("AdService.Documents").
		Preload("AdService.User").
		Preload("AdService.ServiceBrand").
		Preload("AdService.ServiceSubCategory").
		Preload("AdService.City").
		Unscoped().Find(&res, id)
	if stmt.Error != nil {
		return model.ReportAdServices{}, fmt.Errorf("repository reportAdService `GetByID`: %w", stmt.Error)
	}

	return res, nil
}

func (r *reportAdService) Delete(ctx context.Context, id int) error {
	stmt := r.db.Delete(&model.ReportAdServices{}, id)
	if stmt.Error != nil {
		return fmt.Errorf("repository reportAdService `Delete`: %w", stmt.Error)
	}

	return nil
}
