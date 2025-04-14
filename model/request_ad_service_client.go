package model

import (
	"time"

	"gorm.io/gorm"
)

type RequestAdServiceClient struct {
	ID                int             `json:"id"`
	CreatedAt         time.Time       `json:"created_at"`
	UpdatedAt         time.Time       `json:"updated_at"`
	DeletedAt         gorm.DeletedAt  `json:"deleted_at"             swaggertype:"string"`
	AdServiceClientID int             `json:"ad_service_client_id"`
	AdServiceClient   AdServiceClient `json:"ad_service_client"`
	UserID            int             `json:"user_id"`
	User              User            `json:"user"`
	ExecutorID        *int            `json:"executor_id"`
	Executor          User            `json:"executor"               gorm:"foreignKey:ID;references:ExecutorID"`
	Status            string          `json:"status"`
	Description       string          `json:"description"`
}

type FilterRequestAdServiceClient struct {
	AdServiceClientDetail         *bool
	AdServiceClientDocumentDetail *bool
	UserDetail                    *bool
	ExecutorDetail                *bool
	Unscoped                      *bool
	IDs                           []int
	AdServiceClientIDs            []int
	UserIDs                       []int
	ExecutorIDs                   []int
	Limit                         *int
	Offset                        *int
	Status                        *string
	Description                   *string
}
