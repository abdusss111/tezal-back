package service

import (
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IRigthr interface {
	Get() ([]model.Right, error)
	GetByID(id int) (model.Right, error)
	Create(rigth model.Right) error
	Update(right model.Right) error
	Delete(id int) error
}

type right struct {
	repo repository.IRigthr
}

func NewRight(repo repository.IRigthr) *right {
	return &right{repo: repo}
}

func (r *right) Create(rigth model.Right) error {
	return r.repo.Create(rigth)

}

func (r *right) Get() ([]model.Right, error) {
	return r.repo.Get()
}

func (r *right) GetByID(id int) (model.Right, error) {
	return r.repo.GetByID(id)
}

func (r *right) Update(right model.Right) error {
	return r.repo.Update(right)

}

func (r *right) Delete(id int) error {
	return r.repo.Delete(id)

}
