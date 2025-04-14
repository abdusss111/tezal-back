package repository

import (
	"errors"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IBrand interface {
	Get(f model.FilterBrand) ([]model.Brand, error)
	GetByID(id int) (model.Brand, error)
	Create(brand model.Brand) error
	Update(brand model.Brand) error
	Delete(id int) error
}

type brand struct {
	db *gorm.DB
}

func NewBrand(db *gorm.DB) *brand {
	return &brand{db: db}
}

func (b *brand) Get(f model.FilterBrand) ([]model.Brand, error) {
	brands := make([]model.Brand, 0)

	result := b.db.Find(&brands)
	if err := result.Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}

	return brands, nil
}

func (b *brand) GetByID(id int) (model.Brand, error) {
	brand := model.Brand{}

	if err := b.db.First(&brand, id).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return brand, model.ErrNotFound
		}
		return brand, err
	}

	return brand, nil
}

func (b *brand) Create(brand model.Brand) error {
	return b.db.Create(&brand).Error
}

func (b *brand) Update(brand model.Brand) error {
	return b.db.Model(&model.Brand{}).Where("id = ?", brand.ID).Update("name", brand.Name).Error
}

func (b *brand) Delete(id int) error {
	return b.db.Where("id = ?", id).Delete(&model.Brand{}).Error
}
