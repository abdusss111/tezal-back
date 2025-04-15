package service

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IServiceBrand interface {
	Get(ctx context.Context, f model.FilterServiceBrand) ([]model.ServiceBrand, error)
	GetByID(ctx context.Context, id int) (model.ServiceBrand, error)
	Create(ctx context.Context, b model.ServiceBrand) error
	Update(ctx context.Context, b model.ServiceBrand) error
	Delete(ctx context.Context, id int) error
}

type serviceBrand struct {
	serviceBrandRepo repository.IServiceBrand
}

func NewServiceBrand(serviceBrandRepo repository.IServiceBrand) IServiceBrand {
	return &serviceBrand{serviceBrandRepo: serviceBrandRepo}
}

func (service *serviceBrand) Get(ctx context.Context, f model.FilterServiceBrand) ([]model.ServiceBrand, error) {
	res, err := service.serviceBrandRepo.Get(ctx, f)
	if err != nil {
		return nil, fmt.Errorf("service serviceBrand: Get: %w", err)
	}

	return res, nil

}

func (service *serviceBrand) GetByID(ctx context.Context, id int) (model.ServiceBrand, error) {
	res, err := service.serviceBrandRepo.GetByID(ctx, id)
	if err != nil {
		return res, fmt.Errorf("service serviceBrand: GetByID: %w", err)
	}

	return res, nil
}

func (service *serviceBrand) Create(ctx context.Context, b model.ServiceBrand) error {
	err := service.serviceBrandRepo.Create(ctx, b)
	if err != nil {
		return fmt.Errorf("service serviceBrand: Create: %w", err)
	}

	return nil
}

func (service *serviceBrand) Update(ctx context.Context, b model.ServiceBrand) error {
	err := service.serviceBrandRepo.Update(ctx, b)
	if err != nil {
		return fmt.Errorf("service serviceBrand: Update: %w", err)
	}

	return nil
}

func (service *serviceBrand) Delete(ctx context.Context, id int) error {
	err := service.serviceBrandRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service serviceBrand: Delete: %w", err)
	}

	return nil
}
