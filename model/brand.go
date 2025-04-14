package model

import (
	"time"

	"gorm.io/gorm"
)

// brand_specialized_machinery
type Brand struct {
	ID        int            `json:"id"`
	Name      string         `json:"name"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `json:"deleted_at" gorm:"index" swaggertype:"string"`
}

type FilterBrand struct {
}

