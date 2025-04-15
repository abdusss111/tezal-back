package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IReportAdSpecializedMachineryClient interface {
	Create(ctx context.Context, report model.ReportAdSpecializedMachineriesClient) error
	Get(ctx context.Context, f model.FilterReportAdSpecializedMachineriesClient) ([]model.ReportAdSpecializedMachineriesClient, int, error)
	GetByID(ctx context.Context, id int) (model.ReportAdSpecializedMachineriesClient, error)
	Delete(ctx context.Context, id int) error
}

type reportAdSpecializedMachineryClient struct {
	db *gorm.DB
}

func NewReportAdSpecializedMachineryClient(db *gorm.DB) IReportAdSpecializedMachineryClient {
	return &reportAdSpecializedMachineryClient{db: db}
}

func (r *reportAdSpecializedMachineryClient) Create(ctx context.Context, report model.ReportAdSpecializedMachineriesClient) error {
	stmt := r.db.WithContext(ctx).Create(&report)
	if stmt.Error != nil {
		return fmt.Errorf("repository reportAdSpecializedMachineryClient `Create`: %w", stmt.Error)
	}
	return nil
}

func (r *reportAdSpecializedMachineryClient) Get(ctx context.Context, f model.FilterReportAdSpecializedMachineriesClient) ([]model.ReportAdSpecializedMachineriesClient, int, error) {
	res := make([]model.ReportAdSpecializedMachineriesClient, 0)

	stmt := r.db.WithContext(ctx)

	if f.ReportReasonsDetail != nil && *f.ReportReasonsDetail {
		stmt = stmt.Preload("ReportReasons")
	}
	if f.AdClientDetail != nil && *f.AdClientDetail {
		stmt = stmt.
			Preload("AdClient").
			Preload("AdClient.User").
			Preload("AdClient.Type").
			Preload("AdClient.City")
	}

	if f.AdClientDocumentDetail != nil && *f.AdClientDocumentDetail {
		stmt = stmt.Preload("AdClient.Document")
	}

	if f.IDs != nil {
		stmt = stmt.Where("id in (?)", f.IDs)
	}
	if f.ReportReasonsIDs != nil {
		stmt = stmt.Where("report_reasons_id in (?)", f.ReportReasonsIDs)
	}
	if f.AdClientIDs != nil {
		stmt = stmt.Where("ad_client_id in (?)", f.AdClientIDs)
	}

	if f.Limit != nil {
		stmt = stmt.Limit(*f.Limit)
	}
	if f.Offset != nil {
		stmt = stmt.Offset(*f.Offset)
	}

	stmt = stmt.Find(&res)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository reportAdSpecializedMachineryClient `Get`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository reportAdSpecializedMachineryClient `Get` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}

func (r *reportAdSpecializedMachineryClient) GetByID(ctx context.Context, id int) (model.ReportAdSpecializedMachineriesClient, error) {
	res := model.ReportAdSpecializedMachineriesClient{}

	stmt := r.db.WithContext(ctx).
		Preload("AdClient").
		Preload("ReportReasons").
		Preload("AdClient.Document").
		Preload("AdClient.User").
		Preload("AdClient.Brand").
		Preload("AdClient.Type").
		Preload("AdClient.City").
		Unscoped().Find(&res, id)
	if stmt.Error != nil {
		return model.ReportAdSpecializedMachineriesClient{}, fmt.Errorf("repository reportAdSpecializedMachineryClient `GetByID`: %w", stmt.Error)
	}

	return res, nil
}

func (r *reportAdSpecializedMachineryClient) Delete(ctx context.Context, id int) error {
	stmt := r.db.Delete(&model.ReportAdSpecializedMachineriesClient{}, id)
	if stmt.Error != nil {
		return fmt.Errorf("repository reportAdSpecializedMachineryClient `Delete`: %w", stmt.Error)
	}

	return nil
}
