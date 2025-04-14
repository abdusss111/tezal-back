package service

import (
	"context"
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IDriverMoveService interface {
	DriverGetStreamCoordinatesByID(ctx context.Context, driverID int) (model.DriverMove, error)
	CreateDriverCoordinates(ctx context.Context, dm model.DriverMove) error
	GetDriversByOwnerID(ctx context.Context, id int) ([]model.User, error)
	IsLocationSharingEnabled(id int) (bool, error)
}

type driverMoveService struct {
	driverRepo repository.IDriverMove
}

func NewDriverMoveService(driverRepo repository.IDriverMove) *driverMoveService {
	return &driverMoveService{
		driverRepo: driverRepo,
	}
}

func (r *driverMoveService) DriverGetStreamCoordinatesByID(ctx context.Context, driverID int) (model.DriverMove, error) {
	limitCord := 1
	desc := true

	moves, err := r.driverRepo.GetDriverCoordinateByID(ctx, driverID, model.FilterDriverMove{
		DescCreatedAt: &desc,
		Limit:         &limitCord,
	})
	if err != nil {
		return model.DriverMove{}, err
	}

	return *moves, nil
}
func (r *driverMoveService) GetDriversByOwnerID(ctx context.Context, id int) ([]model.User, error) {
	return r.driverRepo.GetDriversByOwnerID(ctx, id)
}

func (r *driverMoveService) CreateDriverCoordinates(ctx context.Context, dm model.DriverMove) error {
	return r.driverRepo.CreateDriverCoordinate(ctx, dm)
}

func (r *driverMoveService) IsLocationSharingEnabled(id int) (bool, error) {
	return r.driverRepo.IsLocationSharingEnabled(id)
}
