package repository

import (
	"errors"
	"fmt"
	"time"

	"gitlab.com/eqshare/eqshare-back/model"
	"gorm.io/gorm"
)

type IUser interface {
	Create(user model.User) (model.User, error)
	Get(f model.FilterUser) ([]model.User, error)
	GetByID(id int) (model.User, error)
	GetByEmail(email string) (model.User, error)
	GetByPhoneNumber(phoneNumber string) (model.User, error)
	UpdateAsDriver(user model.User) error
	UpdateAccessRole(user model.User) error
	UpdateCanDriver(id int, value bool) error
	Update(user model.User) error
	UpdateOwnerID(user model.User) error
	UpdateUserName(user model.User) error
	UpdateNickName(user model.User) error
	ResetNickName(id int) error
	UpdateCanOwner(id int, value bool) error
	UpdateFoto(user model.User, isCustom bool) error
	UpdatePassword(userID int, password string) error
	Delete(id int) error
	SaveCode(phone string, code int) error
	GetCode(phone string) (model.UserCode, error)
	CheckLastCodeTime(phone string) (time.Time, error)
}

type user struct {
	db *gorm.DB
}

func NewUser(db *gorm.DB) *user {
	return &user{db: db}
}

func (u *user) Create(user model.User) (model.User, error) {
	err := u.db.Transaction(func(tx *gorm.DB) error {
		stmt := tx.Omit("Document").Create(&user)
		if stmt.Error != nil {
			return stmt.Error
		}

		if user.Document != nil {
			user.Document.UserID = user.ID

			stmt = tx.Create(user.Document)
			if stmt.Error != nil {
				return stmt.Error
			}

			user.DocumentID = &user.Document.ID

			stmt = tx.Model(model.User{}).Where("id = ?", user.ID).Select("DocumentID").Updates(&user)
			if stmt.Error != nil {
				return stmt.Error
			}
		}

		return nil
	})
	if err != nil {
		return user, err
	}

	return user, nil

	// return user, r.db.Model(&model.User{}).
	// 	Omit("count_rate", "rating").
	// 	Create(&user).Error
}

func (u *user) Get(f model.FilterUser) ([]model.User, error) {
	users := make([]model.User, 0)
	result := u.db.Model(&model.User{})

	if f.DocumentDetail != nil && *f.DocumentDetail == true {
		result = result.Preload("Document").Preload("CustomDocument")
	}

	result = result.Order("id desc")

	if f.CanDriver != nil {
		result = result.Where("can_driver = ?", f.CanDriver)
	}

	if f.PhoneNumber != nil {
		result = result.Where("phone_number = ?", f.PhoneNumber)
	}

	if f.CanOwner != nil {
		if *f.CanOwner {
			result = result.Where("id IN (SELECT user_id FROM owners)")
		} else {
			result = result.Where("id NOT IN (SELECT user_id FROM owners)")
		}
	}

	if f.OwnerID != nil {
		switch *f.OwnerID {
		case "null":
			result = result.Where("owner_id IS NULL")
		case "not null":
			result = result.Where("owner_id IS NOT NULL")
		default:
			result = result.Where("owner_id = ?", f.OwnerID)
		}
	}

	result = result.Preload("Roles").Find(&users)

	if err := result.Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return nil, nil
		}
		return nil, err
	}

	return users, nil
}

func (u *user) GetByID(id int) (model.User, error) {
	user := model.User{
		ID: id,
	}

	result := u.db.Model(&user).
		Unscoped().
		Preload("City").
		Preload("Roles").
		Preload("Roles.Rights").
		Preload("Document").
		Preload("CustomDocument").
		Find(&user)
	if err := result.Error; err != nil {
		return user, err
	}

	return user, nil
}

func (u *user) GetByEmail(email string) (model.User, error) {
	user := model.User{}

	result := u.db.Model(&user).
		Where("email = ?", email).
		Find(&user)
	if err := result.Error; err != nil {
		return user, err
	}

	return user, nil
}

func (u *user) GetByPhoneNumber(phoneNumber string) (model.User, error) {
	user := model.User{}

	result := u.db.Model(&user).Unscoped().Preload("Roles").
		Where("phone_number = ?", phoneNumber).
		Where("deleted_at is null").
		First(&user)

	if err := result.Error; err != nil {
		if errors.Is(result.Error, gorm.ErrRecordNotFound) {
			return user, model.ErrNotFound
		} else {
			return user, err
		}
	}

	return user, nil
}

func (u *user) Update(user model.User) error {
	result := u.db.Table("users").
		Where("id = ?", user.ID).
		Update("first_name", user.FirstName).
		Update("last_name", user.LastName).
		Update("password", user.Password).
		Update("city_id", user.CityID).
		Update("email", user.Email).
		Update("updated_at", time.Now())
	if err := result.Error; err != nil {
		return err
	}

	if result.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}

	return nil
}

func (u *user) Delete(id int) error {
	result := u.db.Where("id = ?", id).Delete(&model.User{})
	if err := result.Error; err != nil {
		return err
	}

	if result.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}

	return nil
}

func (u *user) UpdateAsDriver(user model.User) error {
	result := u.db.Table("users").
		Where("id = ?", user.ID).
		Update("first_name", user.FirstName).
		Update("last_name", user.LastName).
		Update("access_role", user.AccessRole).
		Update("birth_date", user.BirthDate).
		Update("iin", user.IIN).
		Update("can_owner", true)
	if err := result.Error; err != nil {
		return err
	}

	if result.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}

	return nil
}

func (u *user) UpdateCanDriver(id int, value bool) error {
	res := u.db.
		Table("users").
		Where("id", id).
		Update("can_driver", value)

	if res.Error != nil {
		return res.Error
	}

	if res.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}

	return nil
}

func (u *user) UpdateCanOwner(id int, value bool) error {
	res := u.db.
		Table("users").
		Where("id", id).
		Update("can_owner", value)

	if res.Error != nil {
		return res.Error
	}

	if res.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}

	return nil
}

func (u *user) UpdateAccessRole(user model.User) error {
	result := u.db.Table("users").
		Where("id = ?", user.ID).
		Update("access_role", user.AccessRole)
	if err := result.Error; err != nil {
		return err
	}

	if result.RowsAffected == 0 {
		return gorm.ErrRecordNotFound
	}

	return nil
}

func (u *user) UpdateOwnerID(user model.User) error {
	return u.db.Model(&model.User{}).
		Where("id = ?", user.ID).
		Update("owner_id", user.OwnerID).
		Error
}

func (u *user) UpdateUserName(user model.User) error {
	return u.db.Model(&model.User{}).Where("id = ?", user.ID).
		Update("first_name", user.FirstName).
		Update("last_name", user.LastName).Error
}

func (u *user) UpdateNickName(user model.User) error {
	return u.db.Model(&model.User{}).Where("id = ?", user.ID).
		Update("nick_name", user.NickName).Error
}

func (u *user) ResetNickName(id int) error {
	return u.db.Model(&model.User{}).
		Where("id = ?", id).
		Update("nick_name", gorm.Expr("CONCAT(first_name, ' ', last_name)")).Error
}

func (u *user) UpdateFoto(user model.User, isCustom bool) error {
	err := u.db.Transaction(func(tx *gorm.DB) error {
		var doc *model.Document

		if isCustom {
			doc = user.CustomDocument
		} else {
			doc = user.Document
		}

		stmt := tx.Create(doc)
		if stmt.Error != nil {
			return stmt.Error
		}

		if isCustom {
			user.CustomDocumentID = &doc.ID
			stmt = tx.Model(&user).Select("custom_document_id").Updates(map[string]interface{}{
				"custom_document_id": doc.ID,
			})
		} else {
			user.DocumentID = &doc.ID
			stmt = tx.Model(&user).Select("document_id").Updates(map[string]interface{}{
				"document_id": doc.ID,
			})
		}

		if stmt.Error != nil {
			return stmt.Error
		}

		return nil
	})

	if err != nil {
		return fmt.Errorf("repository user: UpdateFoto err: %w", err)
	}

	return nil
}

func (u *user) UpdatePassword(userID int, password string) error {
	return u.db.Table("users").
		Where("id = ?", userID).
		Update("password", password).
		Update("updated_at", time.Now()).
		Error
}

func (u *user) SaveCode(phone string, code int) error {
	userCode := model.UserCode{
		Phone:     phone,
		Code:      code,
		CreatedAt: time.Now(),
	}

	if err := u.db.Create(&userCode).Error; err != nil {
		return err
	}

	return nil
}

func (u *user) GetCode(phone string) (model.UserCode, error) {
	userCode := model.UserCode{}

	result := u.db.Model(&userCode).
		Where("phone = ?", phone).
		Order("created_at DESC").
		First(&userCode)

	if err := result.Error; err != nil {
		return model.UserCode{}, err
	}

	return userCode, nil
}

func (u *user) CheckLastCodeTime(phone string) (time.Time, error) {
	var userCode model.UserCode

	result := u.db.Model(&userCode).
		Where("phone = ?", phone).
		Order("created_at DESC").
		First(&userCode)

	if err := result.Error; err != nil {
		if errors.Is(err, gorm.ErrRecordNotFound) {
			return time.Time{}, nil
		}
		return time.Time{}, err
	}

	return userCode.CreatedAt, nil
}
