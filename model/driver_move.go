package model

import "time"

type DriverMove struct {
	DriverId          int       `json:"driver_id" db:"driver_id"`
	Name              string    `json:"name" db:"-"`
	LastName          string    `json:"last_name" db:"-"`
	Longitude         float64   `json:"longitude" db:"longitude"`
	Latitude          float64   `json:"latitude" db:"latitude"`
	CreatedAt         time.Time `json:"time" db:"created_at" gorm:"autoCreateTime"`
	Message           string    `json:"message,omitempty" db:"-"`
	IsLocationEnabled bool      `json:"is_location_enabled" db:"is_location_enabled"`
}

type FilterDriverMove struct {
	DescCreatedAt *bool
	AscCreatedAt  *bool
	Limit         *int
}
