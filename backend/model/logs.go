package model

import (
	"time"
)

type Logs struct {
	ID          int       `json:"id"`
	Text        string    `json:"text"`
	Author      string    `json:"author"`
	Description string    `json:"description"`
	CreatedAt   time.Time `json:"created_at"`
	UpdatedAt   time.Time `json:"updated_at"`
	DeletedAt   time.Time `json:"deleted_at" gorm:"index"`
}
