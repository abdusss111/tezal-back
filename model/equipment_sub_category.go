package model

import (
	"time"

	"gorm.io/gorm"
)

type EquipmentSubCategory struct {
	ID                    int            `json:"id"`
	CreatedAt             time.Time      `json:"created_at"`
	UpdatedAt             time.Time      `json:"updated_at"`
	DeletedAt             gorm.DeletedAt `json:"deleted_at" swaggertype:"string"`
	EquipmentCategoriesID int            `json:"equipment_categories_id"`
	Name                  string         `json:"name"`
	Documents             []Document     `json:"documents"  gorm:"many2many:equipment_sub_categories_documents"`
	UrlDocuments          []string       `json:"url_foto"   gorm:"-"`
	Alias                 []Alias        `json:"alias"      gorm:"many2many:equipment_sub_categories_aliases"   form:"aliases"`
	Params                []Param        `json:"params"     gorm:"many2many:equipment_sub_categories_params;"`
	CountAd               *int           `json:"count_ad" gorm:"-"`
	CountAdClinet         *int           `json:"count_ad_client" gorm:"-"`
}

type FilterEquipmentSubCategory struct {
	DocumentsDetail      *bool
	IDs                  []int
	EquipmentCategoryIDs []int
	Name                 *string
	Unscoped             *bool
}

type EquipmentSubCategoriesDocuments struct {
	EquipmentSubCategoryID int `json:"equipment_sub_category_id"`
	DocumentID             int `json:"document_id"`
}

type EquipmentSubCategoriesParams struct {
	EquipmentSubCategoryID int
	ParamID                int
}
