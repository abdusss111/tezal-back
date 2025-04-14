package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IReportAdConstructionMaterialClient interface {
	Create(ctx context.Context, report model.ReportAdConstructionMaterialClient) error
	Get(ctx context.Context, f model.FilterReportAdConstructionMaterialsClient) ([]model.ReportAdConstructionMaterialClient, int, error)
	GetByID(ctx context.Context, id int) (model.ReportAdConstructionMaterialClient, error)
	Delete(ctx context.Context, id int) error
}

type reportAdConstructionMaterialClient struct {
	db *gorm.DB
}

func NewReportAdConstructionMaterialClient(db *gorm.DB) IReportAdConstructionMaterialClient {
	return &reportAdConstructionMaterialClient{db: db}
}

func (r *reportAdConstructionMaterialClient) Create(ctx context.Context, report model.ReportAdConstructionMaterialClient) error {
	stmt := r.db.WithContext(ctx).Create(&report)
	if stmt.Error != nil {
		return fmt.Errorf("repository reportAdConstructionMaterialClient `Create`: %w", stmt.Error)
	}
	return nil
}

func (r *reportAdConstructionMaterialClient) Get(ctx context.Context, f model.FilterReportAdConstructionMaterialsClient) ([]model.ReportAdConstructionMaterialClient, int, error) {
	res := make([]model.ReportAdConstructionMaterialClient, 0)

	stmt := r.db.WithContext(ctx)

	if f.ReportReasonsDetail != nil && *f.ReportReasonsDetail {
		stmt = stmt.Preload("ReportReasons")
	}
	if f.AdConstructionMaterialClientDetail != nil && *f.AdConstructionMaterialClientDetail {
		stmt = stmt.
			Preload("AdConstructionMaterialClient").
			Preload("AdConstructionMaterialClient.User").
			Preload("AdConstructionMaterialClient.ConstructionMaterialSubCategory").
			Preload("AdConstructionMaterialClient.City")
	}
	if f.AdConstructionMaterialClientDocumentDetail != nil && *f.AdConstructionMaterialClientDocumentDetail {
		stmt = stmt.Preload("AdConstructionMaterialClient.Documents")
	}

	if f.IDs != nil {
		stmt = stmt.Where("id in (?)", f.IDs)
	}
	if f.ReportReasonsIDs != nil {
		stmt = stmt.Where("report_reasons_id in (?)", f.ReportReasonsIDs)
	}
	if f.AdConstructionMaterialClientIDs != nil {
		stmt = stmt.Where("ad_construction_material_client_id in (?)", f.AdConstructionMaterialClientIDs)
	}

	if f.Limit != nil {
		stmt = stmt.Limit(*f.Limit)
	}
	if f.Offset != nil {
		stmt = stmt.Offset(*f.Offset)
	}

	stmt = stmt.Find(&res)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository reportAdConstructionMaterialClient `Get`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository reportAdConstructionMaterialClient `Get` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}

func (r *reportAdConstructionMaterialClient) GetByID(ctx context.Context, id int) (model.ReportAdConstructionMaterialClient, error) {
	res := model.ReportAdConstructionMaterialClient{}

	stmt := r.db.WithContext(ctx).
		Preload("ReportReasons").
		Preload("AdConstructionMaterialClient").
		Preload("AdConstructionMaterialClient.Documents").
		Preload("AdConstructionMaterialClient.User").
		Preload("AdConstructionMaterialClient.ConstructionMaterialSubCategory").
		Preload("AdConstructionMaterialClient.City").
		Unscoped().Find(&res, id)
	if stmt.Error != nil {
		return model.ReportAdConstructionMaterialClient{}, fmt.Errorf("repository reportAdConstructionMaterialClient `GetByID`: %w", stmt.Error)
	}

	return res, nil
}

func (r *reportAdConstructionMaterialClient) Delete(ctx context.Context, id int) error {
	stmt := r.db.Delete(&model.ReportAdConstructionMaterialClient{}, id)
	if stmt.Error != nil {
		return fmt.Errorf("repository reportAdConstructionMaterialClient `Delete`: %w", stmt.Error)
	}

	return nil
}
