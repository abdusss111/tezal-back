package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IReportReason interface {
	Get(ctx context.Context) ([]model.ReportReason, error)
	GetReasonSystem(ctx context.Context) ([]model.ReportReasonSystem, error)
}

type reportReason struct {
	db *gorm.DB
}

func NewReportReasons(db *gorm.DB) IReportReason {
	return &reportReason{db: db}
}

func (r *reportReason) Get(ctx context.Context) ([]model.ReportReason, error) {
	res := make([]model.ReportReason, 0)

	stmt := r.db.WithContext(ctx).Find(&res)
	if stmt.Error != nil {
		return nil, fmt.Errorf("repository reportReason `Get` `Find`: %w", stmt.Error)
	}

	return res, nil
}

func (r *reportReason) GetReasonSystem(ctx context.Context) ([]model.ReportReasonSystem, error) {
	res := make([]model.ReportReasonSystem, 0)

	stmt := r.db.WithContext(ctx).Find(&res)
	if err := stmt.Error; err != nil {
		return nil, fmt.Errorf("repository reportReason `CreateReasonSystem` `Find`: %w", stmt.Error)
	}

	return res, nil
}
