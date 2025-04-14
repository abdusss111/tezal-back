package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IPosition interface {
	SetPosition(ctx context.Context, p model.Position) error
	GetPosition(ctx context.Context, f model.FilterPosition) ([]model.Position, error)
}

type position struct {
	db *gorm.DB
}

func NewPosition(db *gorm.DB) IPosition {
	return &position{db: db}
}

func (s *position) SetPosition(ctx context.Context, p model.Position) error {
	stmt := s.db.WithContext(ctx).Create(&p)
	if stmt.Error != nil {
		return fmt.Errorf("repository position: SetPosition err: %w", stmt.Error)
	}
	return nil
}

func (s *position) GetPosition(ctx context.Context, f model.FilterPosition) ([]model.Position, error) {
	res := make([]model.Position, 0)

	stmt := s.db.WithContext(ctx)

	if f.UserDetail != nil && *f.UserDetail {
		stmt = stmt.Preload("User")
	}

	if f.UserIDs != nil {
		stmt = stmt.Where("user_id in (?)", f.UserIDs)
	}

	if f.AfterCreatedAt.Valid {
		stmt = stmt.Where("created_at >= ?", f.AfterCreatedAt)
	}

	if f.BeforeCreatedAt.Valid {
		stmt = stmt.Where("created_at <= ?", f.BeforeCreatedAt)
	}

	stmt = stmt.Find(&res)
	if stmt.Error != nil {
		return nil, fmt.Errorf("repository position: GetPosition err: %w", stmt.Error)
	}

	return res, nil
}
