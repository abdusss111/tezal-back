package model

import (
	"time"

	"gorm.io/gorm"
)

// advertisement - объявление об аренде
type AdRental struct {
	ID          int            `json:"id"`
	CreatedAt   time.Time      `json:"created_at"`
	UpdatedAt   time.Time      `json:"updated_at"`
	DeletedAt   gorm.DeletedAt `json:"deleted_at" gorm:"index" swaggertype:"string"`
	Description string         `json:"description"`
	//TODO параметры
}

type RentalRequest struct {
	ID          int            `json:"id"`
	CreatedAt   time.Time      `json:"created_at"`
	UpdatedAt   time.Time      `json:"updated_at"`
	DeletedAt   gorm.DeletedAt `json:"deleted_at" gorm:"index" swaggertype:"string"`
	Status      string         `json:"status"`
	Description string         `json:"description"`
	//TODO параметры
}
