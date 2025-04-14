package model

import (
	"time"

	"gorm.io/gorm"
)

type RequestAdEquipmentClient struct {
	ID                  int               `json:"id"`
	CreatedAt           time.Time         `json:"created_at"`
	UpdatedAt           time.Time         `json:"updated_at"`
	DeletedAt           gorm.DeletedAt    `json:"deleted_at"             swaggertype:"string"`
	AdEquipmentClientID int               `json:"ad_equipment_client_id"`
	AdEquipmentClient   AdEquipmentClient `json:"ad_equipment_client"`
	UserID              int               `json:"user_id"`
	User                User              `json:"user"`
	ExecutorID          *int              `json:"executor_id"`
	Executor            User              `json:"executor"               gorm:"foreignKey:ID;references:ExecutorID"`
	Status              string            `json:"status"`
	Description         string            `json:"description"`
}

type FilterRequestAdEquipmentClient struct {
	AdEquipmentClientDetail         *bool
	AdEquipmentClientDocumentDetail *bool
	UserDetail                      *bool
	ExecutorDetail                  *bool
	Unscoped                        *bool
	Limit                           *int
	Offset                          *int
	Status                          *string
	Description                     *string
	IDs                             []int
	AdEquipmentClientIDs            []int
	UserIDs                         []int
	ExecutorIDs                     []int
}
