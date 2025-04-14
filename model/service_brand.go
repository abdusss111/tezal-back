package model

import (
	"time"

	"gorm.io/gorm"
)

type ServiceBrand struct {
	ID        int            `json:"id"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `json:"deleted_at" swaggertype:"string"`
	Name      string         `json:"name"`
}

type FilterServiceBrand struct {
	IDs      []int
	Name     *string
	Unscoped *bool
}
