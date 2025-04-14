package model

import (
	"time"

	"gorm.io/gorm"
)

type ServiceCategory struct {
	ID                   int                  `json:"id"`
	CreatedAt            time.Time            `json:"created_at"`
	UpdatedAt            time.Time            `json:"updated_at"`
	DeletedAt            gorm.DeletedAt       `json:"deleted_at" swaggertype:"string"`
	Name                 string               `json:"name"`
	ServiceSubCategories []ServiceSubCategory `json:"service_sub_categories" gorm:"foreignKey:ServiceCategoriesID"`
	Documents            []Document           `json:"documents" gorm:"many2many:service_categories_documents"`
	UrlDocuments         []string             `json:"url_foto" gorm:"-"`
	CountAd              *int                 `json:"count_ad" gorm:"-"`
	CountAdClinet        *int                 `json:"count_ad_client" gorm:"-"`
}

type FilterServiceCategory struct {
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

type ServiceCategoriyDocuments struct {
	ServiceCategoryID int `json:"service_category_id"`
	DocumentID        int `json:"document_id"`
}
