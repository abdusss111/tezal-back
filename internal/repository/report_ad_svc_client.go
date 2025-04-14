package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IReportAdServiceClient interface {
	Create(ctx context.Context, report model.ReportAdServiceClient) error
	Get(ctx context.Context, f model.FilterReportAdServicesClient) ([]model.ReportAdServiceClient, int, error)
	GetByID(ctx context.Context, id int) (model.ReportAdServiceClient, error)
	Delete(ctx context.Context, id int) error
}

type reportAdServiceClient struct {
	db *gorm.DB
}

func NewReportAdServiceClient(db *gorm.DB) IReportAdServiceClient {
	return &reportAdServiceClient{db: db}
}

func (r *reportAdServiceClient) Create(ctx context.Context, report model.ReportAdServiceClient) error {
	stmt := r.db.WithContext(ctx).Create(&report)
	if stmt.Error != nil {
		return fmt.Errorf("repository reportAdServiceClient `Create`: %w", stmt.Error)
	}
	return nil
}

func (r *reportAdServiceClient) Get(ctx context.Context, f model.FilterReportAdServicesClient) ([]model.ReportAdServiceClient, int, error) {
	res := make([]model.ReportAdServiceClient, 0)

	stmt := r.db.WithContext(ctx)

	if f.ReportReasonsDetail != nil && *f.ReportReasonsDetail {
		stmt = stmt.Preload("ReportReasons")
	}
	if f.AdServiceClientDetail != nil && *f.AdServiceClientDetail {
		stmt = stmt.
			Preload("AdServiceClient").
			Preload("AdServiceClient.User").
			Preload("AdServiceClient.ServiceSubCategory").
			Preload("AdServiceClient.City")
	}
	if f.AdServiceClientDocumentDetail != nil && *f.AdServiceClientDocumentDetail {
		stmt = stmt.Preload("AdServiceClient.Documents")
	}

	if f.IDs != nil {
		stmt = stmt.Where("id in (?)", f.IDs)
	}
	if f.ReportReasonsIDs != nil {
		stmt = stmt.Where("report_reasons_id in (?)", f.ReportReasonsIDs)
	}
	if f.AdServiceClientIDs != nil {
		stmt = stmt.Where("ad_service_client_id in (?)", f.AdServiceClientIDs)
	}

	if f.Limit != nil {
		stmt = stmt.Limit(*f.Limit)
	}
	if f.Offset != nil {
		stmt = stmt.Offset(*f.Offset)
	}

	stmt = stmt.Find(&res)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository reportAdServiceClient `Get`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository reportAdServiceClient `Get` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}

func (r *reportAdServiceClient) GetByID(ctx context.Context, id int) (model.ReportAdServiceClient, error) {
	res := model.ReportAdServiceClient{}

	stmt := r.db.WithContext(ctx).
		Preload("ReportReasons").
		Preload("AdServiceClient").
		Preload("AdServiceClient.Documents").
		Preload("AdServiceClient.User").
		Preload("AdServiceClient.ServiceSubCategory").
		Preload("AdServiceClient.City").
		Unscoped().Find(&res, id)
	if stmt.Error != nil {
		return model.ReportAdServiceClient{}, fmt.Errorf("repository reportAdServiceClient `GetByID`: %w", stmt.Error)
	}

	return res, nil
}

func (r *reportAdServiceClient) Delete(ctx context.Context, id int) error {
	stmt := r.db.Delete(&model.ReportAdServiceClient{}, id)
	if stmt.Error != nil {
		return fmt.Errorf("repository reportAdServiceClient `Delete`: %w", stmt.Error)
	}

	return nil
}
