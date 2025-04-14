package model

import (
	"time"

	"gorm.io/gorm"
)

// parent_category
type SubCategory struct {
	ID            int            `json:"id" form:"id"        gorm:"primaryKey"`
	Name          string         `json:"name"                form:"name"`
	UserID        int            `json:"-"                   gorm:"-"`
	Documents     []Document     `json:"documents,omitempty" gorm:"many2many:sub_category_documents"`
	UrlDocument   []string       `json:"url_foto" gorm:"-"`
	CreatedAt     time.Time      `json:"-"                   gorm:"<-:create;"`
	UpdatedAt     time.Time      `json:"-"                   gorm:"<-:update;"`
	DeletedAt     gorm.DeletedAt `json:"-"                   gorm:"index"`
	Alias         []Alias        `json:"alias"               gorm:"many2many:sub_category_aliases"`
	Types         []Type         `json:"sub_categories"      gorm:"foreignKey:SubCategoryID"`
	CountAd       *int           `json:"count_ad" gorm:"-"`
	CountAdClinet *int           `json:"count_ad_client" gorm:"-"`
}

type ShortCategories struct {
	ID            int                  `json:"id" form:"id"`
	Name          string               `json:"name" form:"name"`
	SubCategories []ShortSubCategories `json:"sub_categories"`
}

type ShortSubCategories struct {
	ID                   int                      `json:"id" form:"id"`
	Name                 string                   `json:"name" form:"name"`
	SpecializedMachinery []AdSpecializedMachinery `json:"specialized_machinery"`
}

type SubCategoryDocuments struct {
	SubCategoryID int `json:"sub_category_id"`
	DocumentID    int `json:"document_id"`
}
