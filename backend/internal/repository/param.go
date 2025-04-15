package repository

import (
	"context"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IParam interface {
	Get(ctx context.Context, f model.FilterParam) ([]model.Param, error)
	GetByID(ctx context.Context, id int) (model.Param, error)
}

type param struct {
	db *gorm.DB
}

func NewParam(db *gorm.DB) *param {
	return &param{db: db}
}

func (p *param) Get(ctx context.Context, f model.FilterParam) ([]model.Param, error) {
	params := make([]model.Param, 0)

	stms := p.db.Model(model.Param{})

	if len(f.ID) != 0 {
		stms = stms.Where("id = ?", f.ID)
	}

	if f.Limit != nil {
		stms = stms.Limit(*f.Limit)
	}

	if f.Offset != nil {
		stms = stms.Offset(*f.Offset)
	}

	res := stms.Find(&params)
	if res.Error != nil {
		return nil, res.Error
	}

	return params, nil
}

func (p *param) GetByID(ctx context.Context, id int) (model.Param, error) {
	param := model.Param{}

	res := p.db.Find(&param, id)
	if res.Error != nil {
		return param, res.Error
	}

	return param, nil
}
