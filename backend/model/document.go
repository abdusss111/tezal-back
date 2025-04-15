package model

import (
	"io"
	"time"

	"gorm.io/gorm"

	"github.com/google/uuid"
)

type Document struct {
	ID                int            `json:"id" gorm:"<-:create;primarykey;"`
	UserID            int            `json:"-"  gorm:"<-:create;varchar(50)"`
	CreatedAt         time.Time      `json:"-" gorm:"<-:create;"`
	UpdatedAt         time.Time      `json:"-" gorm:"<-:update"`
	DeletedAt         gorm.DeletedAt `json:"-" gorm:"<-:delete;"`
	Title             string         `form:"title,omitempty" json:"title,omitempty" gorm:"varchar(2000)"`
	Extension         string         `json:"-" gorm:"varchar(10);<-:create"`
	Size              int64          `json:"-" gorm:"number;<-:create;"`
	Type              string         `json:"-" gorm:"varchar(255);<-:create"`
	Path              uuid.UUID      `json:"-" gorm:"<-:create;type:uuid;default:gen_random_uuid()"`
	ShareLink         string         `json:"shareLink,omitempty" gorm:"-:all"`
	ThumbnailLink     string         `json:"thumbnailLink,omitempty" gorm:"-:all"`
	RequestContent    io.ReadSeeker  `gorm:"-:all" json:"-"`
	CompressedContent io.ReadSeeker  `gorm:"-:all" json:"-"`
	ResponseContent   []byte         `gorm:"-:all" json:"-"`
}

type DriverLicense struct {
	ID             int        `json:"id"`
	CreatedAt      time.Time  `json:"-"`
	UpdatedAt      time.Time  `json:"-"`
	UserID         int        `json:"user_id"`
	Documents      []Document `json:"documents,omitempty" gorm:"-"`
	DeletedAt      time.Time  `json:"-"`
	LicenseNumber  string     `json:"license_number"`
	ExpirationDate time.Time  `json:"expiration_date"`
}

type DriverDocuments struct {
	DriverLicenseID int `json:"driver_license_id"`
	DocID           int `json:"doc_id"`
}
