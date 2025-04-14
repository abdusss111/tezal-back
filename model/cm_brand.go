package model

import (
	"time"

	"gorm.io/gorm"
)

// ConstructionMaterialBrand brand_construction_material
type ConstructionMaterialBrand struct {
	ID        int            `json:"id"`
	Name      string         `json:"name"`
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `json:"deleted_at" gorm:"index" swaggertype:"string"`
}

type FilterConstructionMaterialBrand struct {
	IDs      []int
	Name     *string
	Unscoped *bool
}
