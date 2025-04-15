package service

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IPosition interface {
	SetPosition(ctx context.Context, p model.Position) error
	GetPosition(ctx context.Context, f model.FilterPosition) ([]model.Position, error)
}

type position struct {
	positionRepo repository.IPosition
}

func NewPosition(positionRepo repository.IPosition) IPosition {
	return &position{positionRepo: positionRepo}
}

func (s *position) SetPosition(ctx context.Context, p model.Position) error {
	err := s.positionRepo.SetPosition(ctx, p)
	if err != nil {
		return fmt.Errorf("service position: SetPosition err: %w", err)
	}

	return nil
}

func (s *position) GetPosition(ctx context.Context, f model.FilterPosition) ([]model.Position, error) {
	res, err := s.positionRepo.GetPosition(ctx, f)
	if err != nil {
		return nil, fmt.Errorf("service position: GetPosition err: %w", err)
	}

	return res, nil
}
