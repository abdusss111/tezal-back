package model

import "time"

type UserCode struct {
	ID        uint      `gorm:"primary_key"`
	Phone     string    `gorm:"not null"`
	Code      int       `gorm:"not null"`
	CreatedAt time.Time `gorm:"not null"`
}
