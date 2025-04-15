package model

import (
	"time"

	"gorm.io/gorm"
)

type RequestAdConstructionMaterialClient struct {
	ID                             int                          `json:"id"`
	CreatedAt                      time.Time                    `json:"created_at"`
	UpdatedAt                      time.Time                    `json:"updated_at"`
	DeletedAt                      gorm.DeletedAt               `json:"deleted_at"             swaggertype:"string"`
	AdConstructionMaterialClientID int                          `json:"ad_construction_material_client_id"`
	AdConstructionMaterialClient   AdConstructionMaterialClient `json:"ad_construction_material_client"`
	UserID                         int                          `json:"user_id"`
	User                           User                         `json:"user"`
	ExecutorID                     *int                         `json:"executor_id"`
	Executor                       User                         `json:"executor"               gorm:"foreignKey:ID;references:ExecutorID"`
	Status                         string                       `json:"status"`
	Description                    string                       `json:"description"`
}

type FilterRequestAdConstructionMaterialClient struct {
	AdConstructionMaterialClientDetail         *bool
	AdConstructionMaterialClientDocumentDetail *bool
	UserDetail                                 *bool
	ExecutorDetail                             *bool
	Unscoped                                   *bool
	Limit                                      *int
	Offset                                     *int
	Status                                     *string
	Description                                *string
	IDs                                        []int
	AdConstructionMaterialClientIDs            []int
	UserIDs                                    []int
	ExecutorIDs                                []int
}
