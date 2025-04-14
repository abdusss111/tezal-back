package model

import (
	"time"
)

type Position struct {
	CreatedAt time.Time `json:"created_at"`
	UserID    int       `json:"user_id"`
	User      User      `json:"user"`
	Latitude  float64   `json:"latitude"`
	Longitude float64   `json:"longitude"`
}

type FilterPosition struct {
	UserDetail      *bool
	UserIDs         []int
	AfterCreatedAt  Time
	BeforeCreatedAt Time
}
