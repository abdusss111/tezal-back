package model

import (
	"time"

	"gorm.io/gorm"
)

type City struct {
	ID          int            `json:"id"`
	Name        string         `json:"name"`
	CreatedAt   time.Time      `json:"created_at"`
	UpdatedAt   time.Time      `json:"updated_at"`
	DeletedAt   gorm.DeletedAt `json:"deleted_at,omitempty" gorm:"index" swaggertype:"string"`
	Latitude    *float64       `json:"latitude"`
	Longitude   *float64       `json:"longitude"`
	Weight      int            `json:"weight"`
	Region_name string         `json:"region_name"`
	Region_id   int            `json:"region_id"`
}

type FilterCity struct {
}
