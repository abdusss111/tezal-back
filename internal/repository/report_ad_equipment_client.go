package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IReportAdEquipmentClient interface {
	Create(ctx context.Context, report model.ReportAdEquipmentClient) error
	Get(ctx context.Context, f model.FilterReportAdEquipmentsClient) ([]model.ReportAdEquipmentClient, int, error)
	GetByID(ctx context.Context, id int) (model.ReportAdEquipmentClient, error)
	Delete(ctx context.Context, id int) error
}

type reportAdEquipmentClient struct {
	db *gorm.DB
}

func NewReportAdEquipmentClient(db *gorm.DB) IReportAdEquipmentClient {
	return &reportAdEquipmentClient{db: db}
}

func (r *reportAdEquipmentClient) Create(ctx context.Context, report model.ReportAdEquipmentClient) error {
	stmt := r.db.WithContext(ctx).Create(&report)
	if stmt.Error != nil {
		return fmt.Errorf("repository reportAdEquipmentClient `Create`: %w", stmt.Error)
	}
	return nil
}

func (r *reportAdEquipmentClient) Get(ctx context.Context, f model.FilterReportAdEquipmentsClient) ([]model.ReportAdEquipmentClient, int, error) {
	res := make([]model.ReportAdEquipmentClient, 0)

	stmt := r.db.WithContext(ctx)

	if f.ReportReasonsDetail != nil && *f.ReportReasonsDetail {
		stmt = stmt.Preload("ReportReasons")
	}
	if f.AdEquipmentClientDetail != nil && *f.AdEquipmentClientDetail {
		stmt = stmt.
			Preload("AdEquipmentClient").
			Preload("AdEquipmentClient.User").
			Preload("AdEquipmentClient.EquipmentSubCategory").
			Preload("AdEquipmentClient.City")
	}
	if f.AdEquipmentClientDocumentDetail != nil && *f.AdEquipmentClientDocumentDetail {
		stmt = stmt.Preload("AdEquipmentClient.Documents")
	}

	if f.IDs != nil {
		stmt = stmt.Where("id in (?)", f.IDs)
	}
	if f.ReportReasonsIDs != nil {
		stmt = stmt.Where("report_reasons_id in (?)", f.ReportReasonsIDs)
	}
	if f.AdEquipmentClientIDs != nil {
		stmt = stmt.Where("ad_equipment_client_id in (?)", f.AdEquipmentClientIDs)
	}

	if f.Limit != nil {
		stmt = stmt.Limit(*f.Limit)
	}
	if f.Offset != nil {
		stmt = stmt.Offset(*f.Offset)
	}

	stmt = stmt.Find(&res)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository reportAdEquipmentClient `Get`: %w", stmt.Error)
	}

	var n int64
	stmt = stmt.Limit(-1).Offset(-1)
	stmt = stmt.Count(&n)
	if stmt.Error != nil {
		return nil, 0, fmt.Errorf("repository reportAdEquipmentClient `Get` `Count`: %w", stmt.Error)
	}

	return res, int(n), nil
}

func (r *reportAdEquipmentClient) GetByID(ctx context.Context, id int) (model.ReportAdEquipmentClient, error) {
	res := model.ReportAdEquipmentClient{}

	stmt := r.db.WithContext(ctx).
		Preload("ReportReasons").
		Preload("AdEquipmentClient").
		Preload("AdEquipmentClient.Documents").
		Preload("AdEquipmentClient.User").
		Preload("AdEquipmentClient.EquipmentSubCategory").
		Preload("AdEquipmentClient.City").
		Unscoped().Find(&res, id)
	if stmt.Error != nil {
		return model.ReportAdEquipmentClient{}, fmt.Errorf("repository reportAdEquipmentClient `GetByID`: %w", stmt.Error)
	}

	return res, nil
}

func (r *reportAdEquipmentClient) Delete(ctx context.Context, id int) error {
	stmt := r.db.Delete(&model.ReportAdEquipmentClient{}, id)
	if stmt.Error != nil {
		return fmt.Errorf("repository reportAdEquipmentClient `Delete`: %w", stmt.Error)
	}

	return nil
}
