package service

import (
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IBrand interface {
	Get(f model.FilterBrand) ([]model.Brand, error)
	GetByID(id int) (model.Brand, error)
	Create(brand model.Brand) error
	Update(brand model.Brand) error
	Delete(id int) error
}

type brand struct {
	repo repository.IBrand
}

func NewBrand(repo repository.IBrand) *brand {
	return &brand{repo: repo}
}

func (b *brand) Get(f model.FilterBrand) ([]model.Brand, error) {
	return b.repo.Get(f)
}

func (b *brand) GetByID(id int) (model.Brand, error) {
	return b.repo.GetByID(id)
}

func (b *brand) Create(brand model.Brand) error {
	return b.repo.Create(brand)
}

func (b *brand) Update(brand model.Brand) error {
	return b.repo.Update(brand)
}

func (b *brand) Delete(id int) error {
	return b.repo.Delete(id)
}
