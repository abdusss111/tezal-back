package service

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IEquipmentBrand interface {
	Get(ctx context.Context, f model.FilterEquipmentBrand) ([]model.EquipmentBrand, error)
	GetByID(ctx context.Context, id int) (model.EquipmentBrand, error)
	Create(ctx context.Context, b model.EquipmentBrand) error
	Update(ctx context.Context, b model.EquipmentBrand) error
	Delete(ctx context.Context, id int) error
}

type equipmentBrand struct {
	equipmentBrandRepo repository.IEquipmentBrand
}

func NewEquipmentBrand(equipmentBrandRepo repository.IEquipmentBrand) IEquipmentBrand {
	return &equipmentBrand{equipmentBrandRepo: equipmentBrandRepo}
}

func (service *equipmentBrand) Get(ctx context.Context, f model.FilterEquipmentBrand) ([]model.EquipmentBrand, error) {
	res, err := service.equipmentBrandRepo.Get(ctx, f)
	if err != nil {
		return nil, fmt.Errorf("service equipmentBrand: Get: %w", err)
	}

	return res, nil

}

func (service *equipmentBrand) GetByID(ctx context.Context, id int) (model.EquipmentBrand, error) {
	res, err := service.equipmentBrandRepo.GetByID(ctx, id)
	if err != nil {
		return res, fmt.Errorf("service equipmentBrand: GetByID: %w", err)
	}

	return res, nil
}

func (service *equipmentBrand) Create(ctx context.Context, b model.EquipmentBrand) error {
	err := service.equipmentBrandRepo.Create(ctx, b)
	if err != nil {
		return fmt.Errorf("service equipmentBrand: Create: %w", err)
	}

	return nil
}

func (service *equipmentBrand) Update(ctx context.Context, b model.EquipmentBrand) error {
	err := service.equipmentBrandRepo.Update(ctx, b)
	if err != nil {
		return fmt.Errorf("service equipmentBrand: Update: %w", err)
	}

	return nil
}

func (service *equipmentBrand) Delete(ctx context.Context, id int) error {
	err := service.equipmentBrandRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service equipmentBrand: Delete: %w", err)
	}

	return nil
}
