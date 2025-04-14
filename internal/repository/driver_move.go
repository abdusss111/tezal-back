package repository

import (
	"context"
	"github.com/sirupsen/logrus"
	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IDriverMove interface {
	GetDriverCoordinateByID(ctx context.Context, id int, f model.FilterDriverMove) (*model.DriverMove, error)
	CreateDriverCoordinate(ctx context.Context, cord model.DriverMove) error
	GetDriversByOwnerID(ctx context.Context, ownerID int) ([]model.User, error)
	UpdateLocationStatus(id int, isEnabled bool) error
	IsLocationSharingEnabled(id int) (bool, error)
}

type driverMove struct {
	db *gorm.DB
}

func NewDriverMove(db *gorm.DB) *driverMove {
	return &driverMove{db: db}
}

func (r *driverMove) GetDriverCoordinateByID(ctx context.Context, id int, f model.FilterDriverMove) (*model.DriverMove, error) {
	var move model.DriverMove

	stmt := r.db.WithContext(ctx).Table("driver_move").
		Select("driver_move.longitude, driver_move.latitude, driver_move.created_at, users.is_location_enabled").
		Joins("JOIN users ON users.id = driver_move.driver_id").
		Where("driver_move.driver_id = ?", id)

	if f.DescCreatedAt != nil && *f.DescCreatedAt {
		stmt = stmt.Order("driver_move.created_at DESC")
	} else if f.AscCreatedAt != nil && *f.AscCreatedAt {
		stmt = stmt.Order("driver_move.created_at ASC")
	}

	if f.Limit != nil {
		stmt = stmt.Limit(*f.Limit)
	} else {
		stmt = stmt.Limit(1)
	}

	logrus.Info("Fetching coordinates for driver ID:", id)

	err := stmt.First(&move).Error
	if err != nil {
		return nil, err
	}

	return &move, nil
}

func (r *driverMove) CreateDriverCoordinate(ctx context.Context, cord model.DriverMove) error {
	err := r.db.WithContext(ctx).Table("driver_move").Select("driver_id", "longitude", "latitude", "created_at").Create(&cord).Error
	if err != nil {
		logrus.Info("Error creating driver coordinate: %v", err)
		return err
	}
	return nil
}

func (r *driverMove) GetDriversByOwnerID(ctx context.Context, ownerID int) ([]model.User, error) {
	var users []model.User

	if err := r.db.WithContext(ctx).
		Where("owner_id = $1", ownerID).
		Find(&users).Error; err != nil {
		return nil, err
	}

	return users, nil
}

func (r *driverMove) UpdateLocationStatus(id int, isEnabled bool) error {
	return r.db.Model(&model.User{}).
		Where("id = ?", id).
		Update("is_location_enabled", isEnabled).Error
}

func (r *driverMove) IsLocationSharingEnabled(id int) (bool, error) {
	var status bool
	err := r.db.Model(&model.User{}).
		Select("is_location_enabled").
		Where("id = ?", id).
		Scan(&status).Error

	if err != nil {
		return false, err
	}
	return status, nil
}
