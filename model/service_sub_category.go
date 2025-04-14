package model

import (
	"time"

	"gorm.io/gorm"
)

type ServiceSubCategory struct {
	ID                  int            `json:"id"`
	CreatedAt           time.Time      `json:"created_at"`
	UpdatedAt           time.Time      `json:"updated_at"`
	DeletedAt           gorm.DeletedAt `json:"deleted_at" swaggertype:"string"`
	ServiceCategoriesID int            `json:"service_categories_id"`
	Name                string         `json:"name"`
	Documents           []Document     `json:"documents"  gorm:"many2many:service_sub_categories_documents"`
	UrlDocuments        []string       `json:"url_foto"   gorm:"-"`
	Alias               []Alias        `json:"alias"      gorm:"many2many:service_sub_categories_aliases"   form:"aliases"`
	Params              []Param        `json:"params"     gorm:"many2many:service_sub_categories_params;"`
	CountAd             *int           `json:"count_ad" gorm:"-"`
	CountAdClinet       *int           `json:"count_ad_client" gorm:"-"`
}

type FilterServiceSubCategory struct {
	DocumentsDetail    *bool
	IDs                []int
	ServiceCategoryIDs []int
	Name               *string
	Unscoped           *bool
}

type ServiceSubCategoriesDocuments struct {
	ServiceSubCategoryID int `json:"service_sub_category_id"`
	DocumentID           int `json:"document_id"`
}

type ServiceSubCategoriesParams struct {
	ServiceSubCategoryID int
	ParamID              int
}
