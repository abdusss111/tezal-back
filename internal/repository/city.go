package repository

import (
	"errors"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type ICity interface {
	Get(f model.FilterCity) ([]model.City, error)
	GetByID(id int) (model.City, error)
	Create(city model.City) error
	Update(city model.City) error
	Delete(id int) error
}

type city struct {
	db *gorm.DB
}

func NewCity(db *gorm.DB) *city {
	return &city{db: db}
}

func (c *city) Get(f model.FilterCity) ([]model.City, error) {
	cities := make([]model.City, 0)

	stmt := c.db
	stmt = stmt.Order("weight DESC, name ASC")

	if err := stmt.Find(&cities).Error; err != nil {
		return nil, err
	}

	return cities, nil
}

func (c *city) GetByID(id int) (model.City, error) {
	city := model.City{}

	if err := c.db.First(&city, id).Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return city, model.ErrNotFound
		}
		return city, err
	}

	return city, nil
}

func (c *city) Create(city model.City) error {
	result := c.db.Create(&city)

	if err := result.Error; err != nil {
		return err
	}

	return nil
}

func (c *city) Update(city model.City) error {
	result := c.db.Model(city).Where("id = ?", city.ID).Updates(city)
	if err := result.Error; err != nil {
		return err
	}

	if result.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}

	return nil
}

func (c *city) Delete(id int) error {
	result := c.db.Where("id = ?", id).Delete(&model.City{})
	if err := result.Error; err != nil {
		return err
	}

	if result.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}

	return nil
}
