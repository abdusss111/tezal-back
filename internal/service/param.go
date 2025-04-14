package service

import (
	"context"

	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IParam interface {
	Get(ctx context.Context, f model.FilterParam) ([]model.Param, error)
	GetByID(ctx context.Context, id int) (model.Param, error)
}

type param struct {
	repo repository.IParam
}

func NewParam(repo repository.IParam) *param {
	return &param{repo: repo}
}

func (p *param) Get(ctx context.Context, f model.FilterParam) ([]model.Param, error) {
	return p.repo.Get(ctx, f)
}

func (p *param) GetByID(ctx context.Context, id int) (model.Param, error) {
	return p.repo.GetByID(ctx, id)
}
