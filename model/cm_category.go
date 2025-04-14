package model

import (
	"time"

	"gorm.io/gorm"
)

type ConstructionMaterialCategory struct {
	ID                                int                               `json:"id"`
	CreatedAt                         time.Time                         `json:"created_at"`
	UpdatedAt                         time.Time                         `json:"updated_at"`
	DeletedAt                         gorm.DeletedAt                    `json:"deleted_at" swaggertype:"string"`
	Name                              string                            `json:"name"`
	ConstructionMaterialSubCategories []ConstructionMaterialSubCategory `json:"construction_material_sub_categories" gorm:"foreignKey:ConstructionMaterialCategoriesID"`
	Documents                         []Document                        `json:"documents" gorm:"many2many:construction_material_categories_documents"`
	UrlDocuments                      []string                          `json:"url_foto" gorm:"-"`
	CountAd                           *int                              `json:"count_ad" gorm:"-"`
	CountAdClient                     *int                              `json:"count_ad_client" gorm:"-"`
}

type FilterConstructionMaterialCategory struct {
	CountAdDetail                    *bool
	CountAdClientDetail              *bool
	SubCategoriesCountAdDetail       *bool
	SubCategoriesCountAdClientDetail *bool
	DocumentsDetail                  *bool
	SubCategoriesDetail              *bool
	SubCategoriesDocumentsDetail     *bool
	IDs                              []int
	Name                             *string
	Unscoped                         *bool
}

type ConstructionMaterialCategoryDocuments struct {
	ConstructionMaterialCategoryID int `json:"construction_material_category_id"`
	DocumentID                     int `json:"document_id"`
}
