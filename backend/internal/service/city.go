package service

import (
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type ICity interface {
	Get(f model.FilterCity) ([]model.City, error)
	GetByID(id int) (model.City, error)
	Create(city model.City) error 
	Update(city model.City) error 
	Delete(id int) error 
}

type city struct {
	repo repository.ICity
}

func NewCity(repo repository.ICity) *city {
	return &city{repo: repo}
}

func (c *city) Get(f model.FilterCity) ([]model.City, error) {
	return c.repo.Get(f)
}

func (c *city) GetByID(id int) (model.City, error) {
	return c.repo.GetByID(id)
}

func (c *city) Create(city model.City) error {
	return c.repo.Create(city)
}

func (c *city) Update(city model.City) error {
	return c.repo.Update(city)
}

func (c *city) Delete(id int) error {
	return c.repo.Delete(id)
}
