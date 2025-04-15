package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
	"gorm.io/gorm/clause"
)

type IFavorite interface {
	GetAdSpecializedMachineryByUserID(userID int) ([]model.FavoriteAdSpecializedMachinery, error)
	CreateAdSpecializedMachinery(ctx context.Context, fav model.FavoriteAdSpecializedMachinery) error
	DeleteAdSpecializedMachinery(ctx context.Context, fav model.FavoriteAdSpecializedMachinery) error

	GetAdClientByUserID(ctx context.Context, userID int) ([]model.FavoriteAdClient, error)
	CreateAdClient(ctx context.Context, fav model.FavoriteAdClient) error
	DeleteAdClient(ctx context.Context, fav model.FavoriteAdClient) error

	GetAdEquipmentByUserID(ctx context.Context, userID int) ([]model.FavoriteAdEquipment, error)
	CreateAdEquipment(ctx context.Context, fav model.FavoriteAdEquipment) error
	DeleteAdEquipment(ctx context.Context, fav model.FavoriteAdEquipment) error

	GetAdEquipmentClientByUserID(ctx context.Context, userID int) ([]model.FavoriteAdEquipmentClient, error)
	CreateAdEquipmentClient(ctx context.Context, fav model.FavoriteAdEquipmentClient) error
	DeleteAdEquipmentClient(ctx context.Context, fav model.FavoriteAdEquipmentClient) error

	GetAdConstructionMaterialByUserID(ctx context.Context, userID int) ([]model.FavoriteAdConstructionMaterial, error)
	CreateAdConstructionMaterial(ctx context.Context, fav model.FavoriteAdConstructionMaterial) error
	DeleteAdConstructionMaterial(ctx context.Context, fav model.FavoriteAdConstructionMaterial) error

	GetAdConstructionMaterialClientByUserID(ctx context.Context, userID int) ([]model.FavoriteAdConstructionMaterialClient, error)
	CreateAdConstructionMaterialClient(ctx context.Context, fav model.FavoriteAdConstructionMaterialClient) error
	DeleteAdConstructionMaterialClient(ctx context.Context, fav model.FavoriteAdConstructionMaterialClient) error

	GetAdServiceByUserID(ctx context.Context, userID int) ([]model.FavoriteAdService, error)
	CreateAdService(ctx context.Context, fav model.FavoriteAdService) error
	DeleteAdService(ctx context.Context, fav model.FavoriteAdService) error

	GetAdServiceClientByUserID(ctx context.Context, userID int) ([]model.FavoriteAdServiceClient, error)
	CreateAdServiceClient(ctx context.Context, fav model.FavoriteAdServiceClient) error
	DeleteAdServiceClient(ctx context.Context, fav model.FavoriteAdServiceClient) error
}

type favorite struct {
	db *gorm.DB
}

func NewFavorite(db *gorm.DB) IFavorite {
	return &favorite{db: db}
}

func (f *favorite) GetAdSpecializedMachineryByUserID(userID int) ([]model.FavoriteAdSpecializedMachinery, error) {
	var fav []model.FavoriteAdSpecializedMachinery

	// This is a simple query text that only fetches from the favorite table.
	// (If you need joins for AdSpecializedMachinery and its related models,
	//  you must write the appropriate JOINs in this SQL.)
	query := `
		SELECT *
		FROM favorite_ad_specialized_machineries
		WHERE user_id = ?
	`

	// Run the raw query; note that we remove context usage.
	if err := f.db.Raw(query, userID).Scan(&fav).Error; err != nil {
		return nil, err
	}

	return fav, nil
}

func (f *favorite) CreateAdSpecializedMachinery(ctx context.Context, fav model.FavoriteAdSpecializedMachinery) error {
	err := f.db.WithContext(ctx).Clauses(clause.OnConflict{DoNothing: true}).Create(&fav).Error
	if err != nil {
		return err
	}

	return nil
}

func (f *favorite) DeleteAdSpecializedMachinery(ctx context.Context, fav model.FavoriteAdSpecializedMachinery) error {
	err := f.db.Where("user_id = ?", fav.UserID).Where("ad_specialized_machinery_id = ?", fav.AdSpecializedMachineryID).Delete(&fav).Error
	if err != nil {
		return err
	}

	return nil
}

func (f *favorite) GetAdClientByUserID(ctx context.Context, userID int) ([]model.FavoriteAdClient, error) {
	fav := make([]model.FavoriteAdClient, 0)

	err := f.db.WithContext(ctx).
		Unscoped().
		Preload("AdClient").
		Preload("AdClient.User").
		Preload("AdClient.Type").
		Preload("AdClient.City").
		Preload("AdClient.Documents").
		Where("user_id = ?", userID).
		Find(&fav).Error
	if err != nil {
		return nil, err
	}

	return fav, nil
}

func (f *favorite) CreateAdClient(ctx context.Context, fav model.FavoriteAdClient) error {
	err := f.db.WithContext(ctx).Clauses(clause.OnConflict{DoNothing: true}).Create(&fav).Error
	if err != nil {
		return err
	}

	return nil
}

func (f *favorite) DeleteAdClient(ctx context.Context, fav model.FavoriteAdClient) error {
	err := f.db.Where("user_id = ?", fav.UserID).Where("ad_client_id = ?", fav.AdClientID).Delete(&fav).Error
	if err != nil {
		return err
	}

	return nil
}

func (f *favorite) GetAdEquipmentByUserID(ctx context.Context, userID int) ([]model.FavoriteAdEquipment, error) {
	fav := make([]model.FavoriteAdEquipment, 0)

	err := f.db.WithContext(ctx).
		Unscoped().
		Preload("AdEquipment").
		Preload("AdEquipment.User").
		Preload("AdEquipment.EquipmentBrand").
		Preload("AdEquipment.EquipmentSubCategory").
		Preload("AdEquipment.City").
		Preload("AdEquipment.Documents").
		Where("user_id = ?", userID).
		Find(&fav).Error
	if err != nil {
		return nil, err
	}

	return fav, nil
}
func (f *favorite) CreateAdEquipment(ctx context.Context, fav model.FavoriteAdEquipment) error {
	err := f.db.WithContext(ctx).Clauses(clause.OnConflict{DoNothing: true}).Create(&fav).Error
	if err != nil {
		return fmt.Errorf("repository favorite: CreateAdEquipment: %w", err)
	}

	return nil
}
func (f *favorite) DeleteAdEquipment(ctx context.Context, fav model.FavoriteAdEquipment) error {
	err := f.db.Where("user_id = ?", fav.UserID).Where("ad_equipment_id = ?", fav.AdEquipmentID).Delete(&fav).Error
	if err != nil {
		return err
	}

	return nil
}

func (f *favorite) GetAdEquipmentClientByUserID(ctx context.Context, userID int) ([]model.FavoriteAdEquipmentClient, error) {
	fav := make([]model.FavoriteAdEquipmentClient, 0)

	err := f.db.WithContext(ctx).
		Unscoped().
		Preload("AdEquipmentClient").
		Preload("AdEquipmentClient.User").
		Preload("AdEquipmentClient.City").
		Preload("AdEquipmentClient.EquipmentSubCategory").
		Preload("AdEquipmentClient.Documents").
		Where("user_id = ?", userID).
		Find(&fav).Error
	if err != nil {
		return nil, err
	}

	return fav, nil
}
func (f *favorite) CreateAdEquipmentClient(ctx context.Context, fav model.FavoriteAdEquipmentClient) error {
	err := f.db.WithContext(ctx).Clauses(clause.OnConflict{DoNothing: true}).Create(&fav).Error
	if err != nil {
		return fmt.Errorf("repository favorite: CreateAdEquipmentClient: %w", err)
	}

	return nil
}
func (f *favorite) DeleteAdEquipmentClient(ctx context.Context, fav model.FavoriteAdEquipmentClient) error {
	err := f.db.Where("user_id = ?", fav.UserID).Where("ad_equipment_client_id = ?", fav.AdEquipmentClientID).Delete(&fav).Error
	if err != nil {
		return err
	}

	return nil
}

func (f *favorite) GetAdConstructionMaterialByUserID(ctx context.Context, userID int) ([]model.FavoriteAdConstructionMaterial, error) {
	fav := make([]model.FavoriteAdConstructionMaterial, 0)

	err := f.db.WithContext(ctx).
		Unscoped().
		Preload("AdConstructionMaterial").
		Preload("AdConstructionMaterial.User").
		Preload("AdConstructionMaterial.ConstructionMaterialBrand").
		Preload("AdConstructionMaterial.ConstructionMaterialSubCategory").
		Preload("AdConstructionMaterial.City").
		Preload("AdConstructionMaterial.Documents").
		Where("user_id = ?", userID).
		Find(&fav).Error
	if err != nil {
		return nil, err
	}

	return fav, nil
}

func (f *favorite) CreateAdConstructionMaterial(ctx context.Context, fav model.FavoriteAdConstructionMaterial) error {
	err := f.db.WithContext(ctx).Clauses(clause.OnConflict{DoNothing: true}).Create(&fav).Error
	if err != nil {
		return fmt.Errorf("repository favorite: CreateAdEquipment: %w", err)
	}

	return nil
}

func (f *favorite) DeleteAdConstructionMaterial(ctx context.Context, fav model.FavoriteAdConstructionMaterial) error {
	err := f.db.Where("user_id = ?", fav.UserID).Where("ad_construction_material_id = ?", fav.AdConstructionMaterialID).Delete(&fav).Error
	if err != nil {
		return err
	}

	return nil
}

func (f *favorite) GetAdConstructionMaterialClientByUserID(ctx context.Context, userID int) ([]model.FavoriteAdConstructionMaterialClient, error) {
	fav := make([]model.FavoriteAdConstructionMaterialClient, 0)

	err := f.db.WithContext(ctx).
		Unscoped().
		Preload("AdConstructionMaterialClient").
		Preload("AdConstructionMaterialClient.User").
		Preload("AdConstructionMaterialClient.City").
		Preload("AdConstructionMaterialClient.ConstructionMaterialSubCategory").
		Preload("AdConstructionMaterialClient.Documents").
		Where("user_id = ?", userID).
		Find(&fav).Error
	if err != nil {
		return nil, err
	}

	return fav, nil
}
func (f *favorite) CreateAdConstructionMaterialClient(ctx context.Context, fav model.FavoriteAdConstructionMaterialClient) error {
	err := f.db.WithContext(ctx).Clauses(clause.OnConflict{DoNothing: true}).Create(&fav).Error
	if err != nil {
		return fmt.Errorf("repository favorite: CreateAdConstructionMaterialClient: %w", err)
	}

	return nil
}
func (f *favorite) DeleteAdConstructionMaterialClient(ctx context.Context, fav model.FavoriteAdConstructionMaterialClient) error {
	err := f.db.Where("user_id = ?", fav.UserID).Where("ad_construction_material_client_id = ?", fav.AdConstructionMaterialClientID).Delete(&fav).Error
	if err != nil {
		return err
	}

	return nil
}

func (f *favorite) GetAdServiceByUserID(ctx context.Context, userID int) ([]model.FavoriteAdService, error) {
	fav := make([]model.FavoriteAdService, 0)

	err := f.db.WithContext(ctx).
		Unscoped().
		Preload("AdService").
		Preload("AdService.User").
		Preload("AdService.ServiceBrand").
		Preload("AdService.ServiceSubCategory").
		Preload("AdService.City").
		Preload("AdService.Documents").
		Where("user_id = ?", userID).
		Find(&fav).Error
	if err != nil {
		return nil, err
	}

	return fav, nil
}

func (f *favorite) CreateAdService(ctx context.Context, fav model.FavoriteAdService) error {
	err := f.db.WithContext(ctx).Clauses(clause.OnConflict{DoNothing: true}).Create(&fav).Error
	if err != nil {
		return fmt.Errorf("repository favorite: CreateAdService: %w", err)
	}

	return nil
}

func (f *favorite) DeleteAdService(ctx context.Context, fav model.FavoriteAdService) error {
	err := f.db.Where("user_id = ?", fav.UserID).Where("ad_service_id = ?", fav.AdServiceID).Delete(&fav).Error
	if err != nil {
		return err
	}

	return nil
}

func (f *favorite) GetAdServiceClientByUserID(ctx context.Context, userID int) ([]model.FavoriteAdServiceClient, error) {
	fav := make([]model.FavoriteAdServiceClient, 0)

	err := f.db.WithContext(ctx).
		Unscoped().
		Preload("AdServiceClient").
		Preload("AdServiceClient.User").
		Preload("AdServiceClient.City").
		Preload("AdServiceClient.ServiceSubCategory").
		Preload("AdServiceClient.Documents").
		Where("user_id = ?", userID).
		Find(&fav).Error
	if err != nil {
		return nil, err
	}

	return fav, nil
}
func (f *favorite) CreateAdServiceClient(ctx context.Context, fav model.FavoriteAdServiceClient) error {
	err := f.db.WithContext(ctx).Clauses(clause.OnConflict{DoNothing: true}).Create(&fav).Error
	if err != nil {
		return fmt.Errorf("repository favorite: CreateAdServiceClient: %w", err)
	}

	return nil
}
func (f *favorite) DeleteAdServiceClient(ctx context.Context, fav model.FavoriteAdServiceClient) error {
	err := f.db.Where("user_id = ?", fav.UserID).Where("ad_service_client_id = ?", fav.AdServiceClientID).Delete(&fav).Error
	if err != nil {
		return err
	}

	return nil
}
