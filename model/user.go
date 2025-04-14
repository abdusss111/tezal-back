package model

import (
	"time"

	"gorm.io/gorm"
)

type User struct {
	ID                int            `json:"id"`
	CreatedAt         time.Time      `json:"created_at"`
	UpdatedAt         time.Time      `json:"updated_at"`
	DeletedAt         gorm.DeletedAt `json:"deleted_at,omitempty" gorm:"index" swaggertype:"string"`
	FirstName         string         `json:"first_name"`
	LastName          string         `json:"last_name"`
	NickName          string         `json:"nick_name"`
	PhoneNumber       string         `json:"phone_number"`
	Password          string         `json:"-"`
	DriverLicense     *DriverLicense `json:"driver_license,omitempty" gorm:"-"`
	Roles             []Role         `json:"roles,omitempty" gorm:"many2many:user_role"`
	AccessRole        string         `json:"access_role"`
	CityID            uint           `json:"city_id"`
	BirthDate         time.Time      `json:"birth_date"`
	IIN               string         `json:"iin"`
	Rating            float64        `json:"rating"`
	CountRate         int            `json:"-"`
	City              *City          `json:"city,omitempty" gorm:"foreignKey:CityID"`
	CanDriver         bool           `json:"can_driver"`
	OwnerID           *int           `json:"owner_id"`
	Owner             *Owner         `json:"owner"`
	CanOwner          bool           `json:"can_owner"`
	DocumentID        *int           `json:"document_id"`
	CustomDocumentID  *int           `json:"custom_document_id"`
	Document          *Document      `json:"document" gorm:"foreignKey:DocumentID;references:ID"`
	CustomDocument    *Document      `json:"custom_document" gorm:"foreignKey:CustomDocumentID;references:ID"`
	UrlDocument       *string        `json:"url_document" gorm:"-"`
	CustomUrlDocument *string        `json:"custom_url_document" gorm:"-"`
	Email             string         `json:"email"`
	IsLocationEnabled bool           `json:"is_location_enabled"`
}

type FilterUser struct {
	DocumentDetail *bool
	CanDriver      *bool
	//true выводить пользователей которые владельцы
	//false выводить пользователей которые не владельцы
	CanOwner    *bool
	PhoneNumber *string
	OwnerID     *string
}
