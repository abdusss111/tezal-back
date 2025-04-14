package repository

import (
	"errors"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IRigthr interface {
	Create(rigth model.Right) error
	Get() ([]model.Right, error)
	GetByID(id int) (model.Right, error)
	GetRoleRights(roleID int) ([]model.Right, error)
	Update(right model.Right) error
	Delete(id int) error
}

type right struct {
	db *gorm.DB
}

func NewRight(db *gorm.DB) *right {
	return &right{db: db}
}

func (r *right) Create(rigth model.Right) error {
	result := r.db.Create(&rigth)

	if err := result.Error; err != nil {
		return err
	}

	return nil
}

func (r *right) GetRoleRights(roleID int) (rights []model.Right, err error) {
	result := r.db.Model(&model.RoleRight{}).Where("role_id = ?", roleID).Scan(&rights)
	if err = result.Error; err != nil {
		return rights, err
	}

	return rights, nil
}

func (r *right) Get() ([]model.Right, error) {
	rights := make([]model.Right, 0)

	result := r.db.Find(&rights)
	if err := result.Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}

	return rights, nil
}

func (r *right) GetByID(id int) (model.Right, error) {
	right := model.Right{
		ID: id,
	}

	result := r.db.First(&right, id)
	if err := result.Error; err != nil {
		return right, err
	}

	return right, nil
}

func (r *right) Update(right model.Right) error {
	result := r.db.Model(right).Where("id = ?", right.ID).Updates(right)
	if err := result.Error; err != nil {
		return err
	}

	if result.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}

	return nil
}

func (r *right) Delete(id int) error {
	result := r.db.Where("id = ?", id).Delete(&model.Right{})
	if err := result.Error; err != nil {
		return err
	}

	if result.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}

	return nil
}
