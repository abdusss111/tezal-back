package service

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IConstructionMaterialBrand interface {
	Get(ctx context.Context, f model.FilterConstructionMaterialBrand) ([]model.ConstructionMaterialBrand, error)
	GetByID(ctx context.Context, id int) (model.ConstructionMaterialBrand, error)
	Create(ctx context.Context, b model.ConstructionMaterialBrand) error
	Update(ctx context.Context, b model.ConstructionMaterialBrand) error
	Delete(ctx context.Context, id int) error
}

type constructionMaterialBrand struct {
	constructionMaterialBrandRepo repository.IConstructionMaterialBrand
}

func NewConstructionMaterialBrand(constructionMaterialBrandRepo repository.IConstructionMaterialBrand) IConstructionMaterialBrand {
	return &constructionMaterialBrand{constructionMaterialBrandRepo: constructionMaterialBrandRepo}
}

func (service *constructionMaterialBrand) Get(ctx context.Context, f model.FilterConstructionMaterialBrand) ([]model.ConstructionMaterialBrand, error) {
	res, err := service.constructionMaterialBrandRepo.Get(ctx, f)
	if err != nil {
		return nil, fmt.Errorf("service constructionMaterialBrand: Get: %w", err)
	}

	return res, nil

}

func (service *constructionMaterialBrand) GetByID(ctx context.Context, id int) (model.ConstructionMaterialBrand, error) {
	res, err := service.constructionMaterialBrandRepo.GetByID(ctx, id)
	if err != nil {
		return res, fmt.Errorf("service constructionMaterialBrand: GetByID: %w", err)
	}

	return res, nil
}

func (service *constructionMaterialBrand) Create(ctx context.Context, b model.ConstructionMaterialBrand) error {
	err := service.constructionMaterialBrandRepo.Create(ctx, b)
	if err != nil {
		return fmt.Errorf("service constructionMaterialBrand: Create: %w", err)
	}

	return nil
}

func (service *constructionMaterialBrand) Update(ctx context.Context, b model.ConstructionMaterialBrand) error {
	err := service.constructionMaterialBrandRepo.Update(ctx, b)
	if err != nil {
		return fmt.Errorf("service constructionMaterialBrand: Update: %w", err)
	}

	return nil
}

func (service *constructionMaterialBrand) Delete(ctx context.Context, id int) error {
	err := service.constructionMaterialBrandRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service constructionMaterialBrand: Delete: %w", err)
	}

	return nil
}
