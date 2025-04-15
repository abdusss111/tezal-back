package model

import (
	"time"

	"gorm.io/gorm"
)

type EquipmentCategory struct {
	ID                     int                    `json:"id"`
	CreatedAt              time.Time              `json:"created_at"`
	UpdatedAt              time.Time              `json:"updated_at"`
	DeletedAt              gorm.DeletedAt         `json:"deleted_at" swaggertype:"string"`
	Name                   string                 `json:"name"`
	EquipmentSubCategories []EquipmentSubCategory `json:"equipment_sub_categories" gorm:"foreignKey:EquipmentCategoriesID"`
	Documents              []Document             `json:"documents" gorm:"many2many:equipment_categoriy_documents"`
	UrlDocuments           []string               `json:"url_foto" gorm:"-"`
	CountAd                *int                   `json:"count_ad" gorm:"-"`
	CountAdClinet          *int                   `json:"count_ad_client" gorm:"-"`
}

type FilterEquipmentCategory struct {
	CountAdDetail                    *bool
	CountAdClientDetail              *bool
	SubCategoriesCountAdDetail       *bool
	SubCategoriesCountAdClientDetail *bool
	DocumentsDetail                  *bool
	SubCategoriesDatail              *bool
	SubCategoriesDocumentsDetail     *bool
	IDs                              []int
	Name                             *string
	Unscoped                         *bool
}

type EquipmentCategoriyDocuments struct {
	EquipmentCategoryID int `json:"equipment_category_id"`
	DocumentID          int `json:"document_id"`
}
