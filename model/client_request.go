package model

import (
	"time"

	"gorm.io/gorm"
)

type Request struct {
	ID           int            `json:"id"`
	CreatedAt    time.Time      `json:"created_at"`
	UpdatedAt    time.Time      `json:"updated_at"`
	DeletedAt    gorm.DeletedAt `json:"deleted_at" gorm:"index" swaggertype:"string"`
	AdClientID   int            `json:"ad_client_id"`
	AdClient     AdClient       `json:"ad_client"`
	Assigned     *int           `json:"assigned"`
	UserAssigned *User          `json:"user_assigned" gorm:"foreignKey:Assigned"`
	UserID       int            `json:"user_id"`
	User         User           `json:"user"`
	Status       string         `json:"status"`
	Comment      string         `json:"comment"`
}

type FilterRequest struct {
	AdClient       []int
	AdClientUserID *int
	UserID         *int
	UserDetail     *bool
	UserAssigned   *bool
	Status         *string
	Limit          *int
	Offset         *int
}

type ForceRequest struct {
	AdClientID int `json:"ad_client_id"`
	UserID     int `json:"user_id"`
}
