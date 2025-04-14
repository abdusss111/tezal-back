package model

import "time"

type Coordinates struct {
	RequestExecutionID int       `json:"-" gorm:"-" `
	CreatedAt          time.Time `json:"created_at"`
	Address            string    `json:"address"`
	Latitude           *float64  `json:"latitude"`
	Longitude          *float64  `json:"longitude"`
}
