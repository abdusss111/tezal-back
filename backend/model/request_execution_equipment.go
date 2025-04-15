package model

import (
	"time"

	"gorm.io/gorm"
)

type RequestExecutionEquipment struct {
	ID                         int            `json:"id"`
	CreatedAt                  time.Time      `json:"created_at"`
	UpdatedAt                  time.Time      `json:"updated_at"`
	DeletedAt                  gorm.DeletedAt `json:"deleted_at" swaggertype:"string"`
	RequestAdEquipmentID       *int           `json:"request_ad_equipment_id"`
	RequestAdEquipmentClientID *int           `json:"request_ad_equipment_client_id"`
	ExecutorID                 int            `json:"executor_id"`
	Status                     string         `json:"status"`
	SendAt                     Time           `json:"send_at"`
	GetAt                      Time           `json:"get_at"`
	Rate                       *int           `json:"rate"`
}

type FilterRequestExecutionEquipment struct {
	Unscoped                    *bool
	IDs                         []int
	RequestAdEquipmentIDs       []int
	RequestAdEquipmentClientIDs []int
	ExecutorIDs                 []int
	Status                      *string
}
