package service

import (
	"gitlab.com/eqshare/eqshare-back/internal/repository"
	"gitlab.com/eqshare/eqshare-back/model"
)

type IRole interface {
	Create(role model.Role) error
	Get() ([]model.Role, error)
	GetUserRole(userRole model.UserRole) (model.UserRole, error)
	GetByID(id int) (model.Role, error)
	Update(role model.Role) error
	Delete(id int) error
}

type role struct {
	repo repository.IRole
	// repoRights repository.IRigthr
	// repoDoc    repository.IDocument
}

func NewRole(repo repository.IRole) *role {
	return &role{repo: repo}
}

func (r *role) Create(role model.Role) error {
	return r.repo.Create(role)
}

func (r *role) Get() ([]model.Role, error) {
	return r.repo.Get()
}

func (r *role) GetByID(id int) (model.Role, error) {
	return r.repo.GetByID(id)
}

func (r *role) Update(role model.Role) error {
	return r.repo.Update(role)
}

func (r *role) Delete(id int) error {
	return r.repo.Delete(id)
}

func (s *role) GetUserRole(userRole model.UserRole) (model.UserRole, error) {
	return s.repo.GetUserRole(userRole)
}
