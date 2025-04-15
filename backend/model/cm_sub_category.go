package model

import (
	"gorm.io/gorm"
	"time"
)

type ConstructionMaterialSubCategory struct {
	ID                               int            `json:"id"`
	CreatedAt                        time.Time      `json:"created_at"`
	UpdatedAt                        time.Time      `json:"updated_at"`
	DeletedAt                        gorm.DeletedAt `json:"deleted_at" swaggertype:"string"`
	ConstructionMaterialCategoriesID int            `json:"construction_material_categories_id"`
	Name                             string         `json:"name"`
	Documents                        []Document     `json:"documents"  gorm:"many2many:construction_material_sub_categories_documents"`
	UrlDocuments                     []string       `json:"url_foto"   gorm:"-"`
	Alias                            []Alias        `json:"alias"      gorm:"many2many:construction_material_sub_categories_aliases"   form:"aliases"`
	Params                           []Param        `json:"params"     gorm:"many2many:construction_material_sub_categories_params;"`
	CountAd                          *int           `json:"count_ad" gorm:"-"`
	CountAdClient                    *int           `json:"count_ad_client" gorm:"-"`
}

type FilterConstructionMaterialSubCategory struct {
	DocumentsDetail                 *bool
	IDs                             []int
	ConstructionMaterialCategoryIDs []int
	Name                            *string
	Unscoped                        *bool
}

type ConstructionMaterialSubCategoriesDocuments struct {
	ConstructionMaterialSubCategoryID int `json:"construction_material_sub_category_id"`
	DocumentID                        int `json:"document_id"`
}

type ConstructionMaterialSubCategoriesParams struct {
	ConstructionMaterialSubCategoryID int
	ParamID                           int
}
