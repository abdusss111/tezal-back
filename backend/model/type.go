package model

import (
	"gorm.io/gorm"
	"time"
)

// child_category
type Type struct {
	ID            int            `json:"id"`
	Name          string         `json:"name"`
	UserID        int            `json:"-" gorm:"-"`
	SubCategoryID int            `json:"sub_category_id"`
	CreatedAt     time.Time      `json:"-" gorm:"<-:create;"`
	UpdatedAt     time.Time      `json:"-" gorm:"<-:update;"`
	DeletedAt     gorm.DeletedAt `json:"-" gorm:"index"`
	Documents     []Document     `json:"documents,omitempty" gorm:"many2many:type_documents" form:"documents"`
	UrlDocument   []string       `json:"url_foto" gorm:"-"`
	Params        []Param        `json:"params" gorm:"many2many:types_params;"`
	Alias         []Alias        `json:"alias,omitempty" gorm:"many2many:type_aliases" form:"aliases"`
	CountAd       *int           `json:"count_ad" gorm:"-"`
	CountAdClinet *int           `json:"count_ad_client" gorm:"-"`
}

type Alias struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

type TypeDocuments struct {
	TypeID     int `json:"type_id"`
	DocumentID int `json:"document_id"`
}

type FilterType struct {
	ID int
}
