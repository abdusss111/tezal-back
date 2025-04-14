package repository

import (
	"errors"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IRole interface {
	Create(role model.Role) error
	CreateUserRole(userRole model.UserRole) error
	Get() ([]model.Role, error)
	GetByID(id int) (model.Role, error)
	GetUserRole(userRole model.UserRole) (model.UserRole, error)
	Update(role model.Role) error
	Delete(id int) error
}

type role struct {
	db *gorm.DB
}

func NewRole(db *gorm.DB) *role {
	return &role{db: db}
}

func (r *role) Create(role model.Role) error {
	result := r.db.Create(&role)

	if err := result.Error; err != nil {
		return err
	}

	return nil
}

func (r *role) Get() ([]model.Role, error) {
	roles := make([]model.Role, 0)

	result := r.db.Model(&model.Role{}).Preload("Rights").Find(&roles)
	if err := result.Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}

	return roles, nil
}

func (r *role) GetByID(id int) (model.Role, error) {
	role := model.Role{
		ID: id,
	}

	result := r.db.Model(&role).Preload("Rights").Find(&role)
	if err := result.Error; err != nil {
		return role, err
	}

	return role, nil
}

func (r *role) Update(role model.Role) error {
	result := r.db.Model(role).Where("id = ?", role.ID).Updates(role)
	if err := result.Error; err != nil {
		return err
	}

	if result.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}

	return nil
}

func (r *role) Delete(id int) error {
	result := r.db.Where("id = ?", id).Delete(&model.Role{})
	if err := result.Error; err != nil {
		return err
	}

	if result.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}

	return nil
}

func (r *role) GetUserRole(userRole model.UserRole) (model.UserRole, error) {
	result := r.db.Model(model.UserRole{}).Where("user_id = ?", userRole.UserID).First(&userRole)
	if err := result.Error; err != nil {
		return userRole, err
	}

	if result.RowsAffected == 0 {
		return userRole, gorm.ErrRecordNotFound
	}

	return userRole, nil
}

func (r *role) CreateUserRole(userRole model.UserRole) error {
	return r.db.Model(&model.UserRole{}).Create(&userRole).Error
}
