package model

import (
	"time"

	"gorm.io/gorm"
)

// gorm:"foreignKey:ID;references:ConstructionMaterialSubCategoryID"

type AdConstructionMaterialClient struct {
	ID                                int                             `json:"id"`
	CreatedAt                         time.Time                       `json:"created_at"`
	UpdatedAt                         time.Time                       `json:"updated_at"`
	DeletedAt                         gorm.DeletedAt                  `json:"deleted_at"               swaggertype:"string"`
	UserID                            int                             `json:"user_id"`
	User                              User                            `json:"user"                     gorm:"foreignKey:ID;references:UserID"`
	CityID                            int                             `json:"city_id"`
	City                              City                            `json:"city"                     gorm:"foreignKey:ID;references:CityID"`
	ConstructionMaterialSubCategoryID int                             `json:"construction_material_sub_category_id"`
	ConstructionMaterialSubCategory   ConstructionMaterialSubCategory `json:"construction_material_sub_category"`
	Status                            string                          `json:"status"`
	Title                             string                          `json:"title"`
	Description                       string                          `json:"description"`
	Price                             *float64                        `json:"price"`
	StartLeaseAt                      Time                            `json:"start_lease_date"`
	EndLeaseAt                        Time                            `json:"end_lease_date"`
	Address                           string                          `json:"address"`
	Latitude                          *float64                        `json:"latitude"`
	Longitude                         *float64                        `json:"longitude"`
	Documents                         []Document                      `json:"document"                 gorm:"many2many:ad_construction_material_client_documents"`
	UrlDocument                       []string                        `json:"url_foto"                 gorm:"-"`
}

type FilterAdConstructionMaterialClients struct {
	UserDetail                            *bool
	CityDetail                            *bool
	ConstructionMaterialSubСategoryDetail *bool
	DocumentsDetail                       *bool
	Unscoped                              *bool
	Limit                                 *int
	Offset                                *int
	IDs                                   []int
	UserIDs                               []int
	CityIDs                               []int
	ConstructionMaterialSubСategoryIDs    []int
	ConstructionMaterialСategoryIDs       []int
	Status                                *string
	Title                                 *string
	Description                           *string
	Price                                 ParamMinMax
	ASC                                   []string
	DESC                                  []string
}

type AdConstructionMaterialClientDocuments struct {
	AdConstructionMaterialClientID int
	DocumentId                     int
}
