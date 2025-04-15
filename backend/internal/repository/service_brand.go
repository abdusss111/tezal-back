package repository

import (
	"context"
	"fmt"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IServiceBrand interface {
	Get(ctx context.Context, f model.FilterServiceBrand) ([]model.ServiceBrand, error)
	GetByID(ctx context.Context, id int) (model.ServiceBrand, error)
	Create(ctx context.Context, b model.ServiceBrand) error
	Update(ctx context.Context, b model.ServiceBrand) error
	Delete(ctx context.Context, id int) error
}

type serviceBrand struct {
	db *gorm.DB
}

func NewServiceBrand(db *gorm.DB) IServiceBrand {
	return &serviceBrand{db: db}
}

func (repo *serviceBrand) Get(ctx context.Context, f model.FilterServiceBrand) ([]model.ServiceBrand, error) {
	res := make([]model.ServiceBrand, 0)

	stmt := repo.db.WithContext(ctx).Model(&model.ServiceBrand{})

	if f.Unscoped != nil && *f.Unscoped {
		stmt = stmt.Unscoped()
	}

	if len(f.IDs) != 0 {
		stmt = stmt.Where("id IN (?)", f.IDs)
	}

	if f.Name != nil {
		stmt = stmt.Where("name ILIKE '%' || ? || '%' ", f.Name)
	}

	stmt = stmt.Find(&res)
	if stmt.Error != nil {
		return nil, fmt.Errorf("repository serviceBrand `Get` `Find`: %w", stmt.Error)
	}

	return res, nil
}

func (repo *serviceBrand) GetByID(ctx context.Context, id int) (model.ServiceBrand, error) {
	res := model.ServiceBrand{}

	err := repo.db.WithContext(ctx).Unscoped().Find(&res, id).Error
	if err != nil {
		return res, fmt.Errorf("repository serviceBrand `GetByID` `Find`: %w", err)
	}

	return res, nil
}

func (repo *serviceBrand) Create(ctx context.Context, b model.ServiceBrand) error {
	err := repo.db.WithContext(ctx).Create(&b).Error
	if err != nil {
		return fmt.Errorf("repository serviceBrand `Create` `Create`: %w", err)
	}

	return nil
}

func (repo *serviceBrand) Update(ctx context.Context, b model.ServiceBrand) error {
	value := map[string]interface{}{
		"name": b.Name,
	}

	err := repo.db.WithContext(ctx).Model(&model.ServiceBrand{}).Where("id = ?", b.ID).Updates(value).Error
	if err != nil {
		return fmt.Errorf("repository serviceBrand `Update` `Updates`: %w", err)
	}

	return nil
}

func (repo *serviceBrand) Delete(ctx context.Context, id int) error {
	err := repo.db.WithContext(ctx).Delete(&model.ServiceBrand{}, id).Error
	if err != nil {
		return fmt.Errorf("repository serviceBrand `Delete` `Delete`: %w", err)
	}

	return nil
}
