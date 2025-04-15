package model

import (
	"time"

	"gorm.io/gorm"
)

type AdClient struct {
	ID           int            `json:"id"`
	CreatedAt    time.Time      `json:"created_at"`
	UpdatedAt    time.Time      `json:"updated_at"`
	DeletedAt    gorm.DeletedAt `json:"deleted_at" gorm:"index" swaggertype:"string"`
	UserID       int            `json:"user_id"`
	User         *User          `json:"user"`
	Description  string         `json:"description"`
	Headline     string         `json:"headline"`
	Price        float64        `json:"price"`
	TypeID       int            `json:"type_id"`
	Type         Type           `json:"type"`
	CityID       int            `json:"city_id"`
	City         City           `json:"city"`
	Documents    []Document     `json:"documents" gorm:"many2many:ad_client_documents"`
	UrlDocuments []string       `json:"url_documents" gorm:"-"`
	StartDate    time.Time      `json:"start_date"`
	EndDate      Time           `json:"end_date"`
	Address      string         `json:"address"`
	Latitude     *float64       `json:"latitude"`
	Longitude    *float64       `json:"longitude"`
	Status       string         `json:"status"`
}

type FilterAdClient struct {
	UserID        *int
	Unscoped      *bool
	TypeID        *int
	SubCategoryID *int
	CityID        *int
	Deleted       *bool
	Limit         *int
	Offset        *int
	Status        *string
	ID            []int
	ASC           []string
	DESC          []string
}

type AdClientDocuments struct {
	AdClientID int
	DocID      int
}

type AdClientInteracted struct {
	ID         int            `json:"id"`
	CreatedAt  time.Time      `json:"created_at"`
	UpdatedAt  time.Time      `json:"updated_at"`
	DeletedAt  gorm.DeletedAt `json:"deleted_at" gorm:"index" swaggertype:"string"`
	AdClientID int            `json:"ad_client_id"`
	UserID     int            `json:"user_id"`
	UserRating float64        `json:"user_rating" gorm:"-"`
	User       User           `json:"user"`
}
