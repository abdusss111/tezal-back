package service

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IEquipmentAdParam interface {
}

type equipmentAdParam struct {
	equipmentAdParamRepo repository.IEquipmentAdParam
}

func NewEquipmentAdParam(equipmentAdParamRepo repository.IEquipmentAdParam) IEquipmentAdParam {
	return &equipmentAdParam{equipmentAdParamRepo: equipmentAdParamRepo}
}

func (service *equipmentAdParam) Get(ctx context.Context, f model.FilterEquipmentAdParam) ([]model.EquipmentAdParam, error) {
	res, err := service.equipmentAdParamRepo.Get(ctx, f)
	if err != nil {
		return nil, fmt.Errorf("service equipmentAdParam: Get: %w", err)
	}

	return res, nil
}

func (service *equipmentAdParam) GetByID(ctx context.Context, id int) (model.EquipmentAdParam, error) {
	res, err := service.equipmentAdParamRepo.GetByID(ctx, id)
	if err != nil {
		return res, fmt.Errorf("service equipmentAdParam: GetByID: %w", err)
	}

	return res, nil
}

func (service *equipmentAdParam) Create(ctx context.Context, p model.EquipmentAdParam) error {
	err := service.equipmentAdParamRepo.Create(ctx, p)
	if err != nil {
		return fmt.Errorf("service equipmentAdParam: Create: %w", err)
	}

	return nil
}

func (service *equipmentAdParam) Update(ctx context.Context, p model.EquipmentAdParam) error {
	err := service.equipmentAdParamRepo.Update(ctx, p)
	if err != nil {
		return fmt.Errorf("service equipmentAdParam: Update: %w", err)
	}

	return nil
}

func (service *equipmentAdParam) Delete(ctx context.Context, id int) error {
	err := service.equipmentAdParamRepo.Delete(ctx, id)
	if err != nil {
		return fmt.Errorf("service equipmentAdParam: Delete: %w", err)
	}

	return nil
}
