package model

import (
	"time"

	"gorm.io/gorm"
)

type RequestAdConstructionMaterial struct {
	ID                       int                    `json:"id"`
	CreatedAt                time.Time              `json:"created_at"`
	UpdatedAt                time.Time              `json:"updated_at"`
	DeletedAt                gorm.DeletedAt         `json:"deleted_at"       swaggertype:"string"`
	Status                   string                 `json:"status"`
	UserID                   int                    `json:"user_id"`
	User                     User                   `json:"user"`
	ExecutorID               *int                   `json:"executor_id"`
	Executor                 User                   `json:"executor"         gorm:"foreignKey:ID;references:ExecutorID"`
	AdConstructionMaterialID int                    `json:"ad_construction_material_id"`
	AdConstructionMaterial   AdConstructionMaterial `json:"ad_construction_material"`
	StartLeaseAt             Time                   `json:"start_lease_at"`
	EndLeaseAt               Time                   `json:"end_lease_at"`
	CountHour                *int                   `json:"count_hour"`
	OrderAmount              *int                   `json:"order_amount"`
	Description              string                 `json:"description"`
	Address                  string                 `json:"address"`
	Latitude                 *float64               `json:"latitude"`
	Longitude                *float64               `json:"longitude"`
	Document                 []Document             `json:"-"                 gorm:"many2many:request_ad_construction_materials_documents"`
	UrlDocument              []string               `json:"url_foto"          gorm:"-"`
}

type FilterRequestAdConstructionMaterial struct {
	UserDetail                    *bool
	ExecutorDetail                *bool
	AdConstructionMaterialDetail  *bool
	DocumentDetail                *bool
	Unscoped                      *bool
	IDs                           []int
	AdConstructionMaterialIDs     []int
	AdConstructionMaterialUserIDs []int
	UserIDs                       []int
	Limit                         *int
	Offset                        *int
	Status                        *string
}
