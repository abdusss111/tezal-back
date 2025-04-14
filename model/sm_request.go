package model

import (
	"time"

	"gorm.io/gorm"
)

type SpecializedMachineryRequest struct {
	ID                       int                    `json:"id"`
	CreatedAt                time.Time              `json:"created_at"`
	UpdatedAt                time.Time              `json:"updated_at"`
	DeletedAt                gorm.DeletedAt         `json:"deleted_at" gorm:"index" swaggertype:"string"`
	UserID                   int                    `json:"user_id"`
	User                     User                   `json:"user"`
	AdSpecializedMachineryID int                    `json:"ad_specialized_machinery_id"` //индентификатор объявление
	AdSpecializedMachinery   AdSpecializedMachinery `json:"ad_specialized_machinery"`
	StartLeaseAt             time.Time              `json:"start_lease_at"` //начало работы
	EndLeaseAt               Time                   `json:"end_lease_at"`   //конец работы
	CountHour                *int                   `json:"count_hour"`     //кол часов
	OrderAmount              *float64               `json:"order_amount"`   //сумаа заказа
	Description              string                 `json:"description"`    //комментарии
	Status                   string                 `json:"status"`
	UrlDocument              []string               `json:"url_foto" gorm:"-"`
	Document                 []Document             `json:"-" gorm:"many2many:specialized_machinery_requests_documents;"`
	Coordinates
}

// для будушей фильтрации заявок на объявлении спецтехники
type FilterSpecializedMachineryRequest struct {
	UserDetail *bool
	// идентификатора автор объявление
	AdSpecializedMachineryUserID *int
	AdSpecializedMachineryID     []int
	UserID                       *int
	CityID                       *int
	// OwnerID                      *int
	Limit  *int
	Offset *int
	Status *string
}
