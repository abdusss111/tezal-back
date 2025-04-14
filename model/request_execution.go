package model

import (
	"time"

	"gorm.io/gorm"
)

const (
	DefaultPageSize = 0
	DefaultPage     = -1
)

// выполнение работы
type RequestExecution struct {
	ID                                    int                                 `json:"id"`
	CreatedAt                             time.Time                           `json:"created_at"`
	UpdatedAt                             time.Time                           `json:"updated_at"`
	DeletedAt                             gorm.DeletedAt                      `json:"deleted_at" gorm:"index" swaggertype:"string"`
	Src                                   string                              `json:"src"`
	SpecializedMachineryRequestID         *int                                `json:"specialized_machinery_request_id"`
	SpecializedMachineryRequest           SpecializedMachineryRequest         `json:"specialized_machinery_request,omitempty" gorm:"foreignKey:SpecializedMachineryRequestID"`
	RequestID                             *int                                `json:"request_id"`
	Request                               Request                             `json:"request,omitempty" gorm:"foreignKey:RequestID"`
	RequestAdEquipmentClientID            *int                                `json:"request_ad_equipment_client_id"`
	RequestAdEquipmentClient              RequestAdEquipmentClient            `json:"request_ad_equipment_client"`
	RequestAdEquipmentID                  *int                                `json:"request_ad_equipment_id"`
	RequestAdEquipment                    RequestAdEquipment                  `json:"request_ad_equipment"`
	RequestAdConstructionMaterialID       *int                                `json:"request_ad_construction_material_id"`
	RequestAdConstructionMaterial         RequestAdConstructionMaterial       `json:"request_ad_construction_material"`
	RequestAdConstructionMaterialClientID *int                                `json:"request_ad_construction_material_client_id"`
	RequestAdConstructionMaterialClient   RequestAdConstructionMaterialClient `json:"request_ad_construction_material_client"`
	RequestAdServiceID                    *int                                `json:"request_ad_service_id"`
	RequestAdService                      RequestAdService                    `json:"request_ad_service"`
	RequestAdServiceClientID              *int                                `json:"request_ad_service_client_id"`
	RequestAdServiceClient                RequestAdServiceClient              `json:"request_ad_service_client"`
	Status                                string                              `json:"status"`
	WorkStartedClinet                     bool                                `json:"work_started_clinet"`
	WorkStartedDriver                     bool                                `json:"work_started_driver"`
	WorkStartedAt                         Time                                `json:"work_started_at"`
	WorkEndAt                             Time                                `json:"work_end_at"`
	AssignTo                              *int                                `json:"assigned"`
	UserAssignTo                          *User                               `json:"user_assigned" gorm:"foreignKey:AssignTo"`
	Rate                                  *int                                `json:"rate"`
	RateComment                           *string                             `json:"rate_comment"`
	Movements                             []RequestExecutionMove              `json:"movements" gorm:"<-:false;foreignKey:RequestExectionID;references:ID"`
	DriverID                              *int                                `json:"driver_id"`
	Driver                                User                                `json:"driver" gorm:"foreignKey:DriverID"`
	ClinetID                              *int                                `json:"clinet_id"`
	Clinet                                User                                `json:"clinet" gorm:"foreignKey:ClinetID"`
	Documents                             []Document                          `json:"-"    gorm:"many2many:request_executions_documents"`
	UrlDocument                           []string                            `json:"url_foto"          gorm:"-"`
	Title                                 string                              `json:"title"`
	ClinetPaymentAmount                   *int                                `json:"clinet_payment_amount"`
	DriverPaymentAmount                   *int                                `json:"driver_payment_amount"`
	FinishAddress                         *string                             `json:"finish_address"`
	FinishLatitude                        *float64                            `json:"finish_latitude"`
	FinishLongitude                       *float64                            `json:"finish_longitude"`
	StartLeaseAt                          Time                                `json:"start_lease_at"`
	EndLeaseAt                            Time                                `json:"end_lease_at"`
	PostNotification                      bool                                `json:"post_notification"`
	ForgotToStart                         bool                                `json:"forgot_to_start"`
	ForgotToEnd                           bool                                `json:"forgot_to_end"`
	WTCFullNameClient                     *string                             `json:"wtc_full_name_client"`
	WTCPhoneNumber                        *string                             `json:"wtc_phone_number"`
	WTCDescription                        *string                             `json:"wtc_description"`
	// Latitude                      *float64                    `json:"latitude"`
	// Longitude                     *float64                    `json:"longitude"`
}

// статусы
// в пути
// в работе
// приостановлено
// завершено

type FilterRequestExecution struct {
	DocumentDetail     *bool
	ASC                []string
	DESC               []string
	ID                 []int
	ClientID           *int
	DriverID           *int
	AssignTo           *int
	Src                []string
	Status             []string
	Limit              *int
	Offset             *int
	MinUpdatedAt       Time
	MaxUpdatedAt       Time
	AfterStartLeaseAt  Time
	BeforeStartLeaseAt Time
	AfterEndLeaseAt    Time
	BeforeEndLeaseAt   Time
	PostNotification   *bool
	ForgotToStart      *bool
	ForgotToEnd        *bool
}

type RequestExecutionMove struct {
	RequestExectionID int       `json:"request_exection_id"`
	CreatedAt         time.Time `json:"created_at"`
	Latitude          float64   `json:"latitude"`
	Longitude         float64   `json:"longitude"`
}

type FilterRequestExecutionMove struct {
	DescCreatedAt *bool
	AscCreatedAt  *bool
	Limit         *int
}

type RequestExecutionDTO struct {
	RequestExecution
	SubCategoryName string   `json:"sub_category_name"`
	Price           *float64 `json:"price"`
	// Latitude                      *float64                    `json:"latitude"`
	// Longitude                     *float64                    `json:"longitude"`
}
