package model

import (
	"time"

	"gorm.io/gorm"
)

type ReportAdSpecializedMachineries struct {
	ID                       int                    `json:"id"`
	CreatedAt                time.Time              `json:"created_at"`
	UpdatedAt                time.Time              `json:"updated_at"`
	DeletedAt                gorm.DeletedAt         `json:"deleted_at" gorm:"index" swaggertype:"string"`
	UserID                   int                    `json:"user_id"`
	User                     User                   `json:"user"`
	ReportReasonsID          int                    `json:"report_reasons_id"`
	ReportReasons            ReportReason           `json:"report_reasons"`
	Description              string                 `json:"description"`
	AdSpecializedMachineryID int                    `json:"ad_specialized_machinery_id"`
	AdSpecializedMachinery   AdSpecializedMachinery `json:"ad_specialized_machinery"`
}

type FilterReportAdSpecializedMachineries struct {
	ReportReasonsDetail                  *bool
	AdSpecializedMachineryDetail         *bool
	AdSpecializedMachineryDocumentDetail *bool
	IDs                                  []int
	ReportReasonsIDs                     []int
	AdSpecializedMachineryIDs            []int
	Limit                                *int
	Offset                               *int
}

type ReportAdSpecializedMachineriesClient struct {
	ID              int            `json:"id"`
	CreatedAt       time.Time      `json:"created_at"`
	UpdatedAt       time.Time      `json:"updated_at"`
	DeletedAt       gorm.DeletedAt `json:"deleted_at" gorm:"index" swaggertype:"string"`
	UserID          int            `json:"user_id"`
	User            User           `json:"user"`
	ReportReasonsID int            `json:"report_reasons_id"`
	ReportReasons   ReportReason   `json:"report_reasons"`
	Description     string         `json:"description"`
	AdClientID      int            `json:"ad_client_id"`
	AdClient        AdClient       `json:"ad_client"`
}

type FilterReportAdSpecializedMachineriesClient struct {
	ReportReasonsDetail    *bool
	AdClientDetail         *bool
	AdClientDocumentDetail *bool
	IDs                    []int
	ReportReasonsIDs       []int
	AdClientIDs            []int
	Limit                  *int
	Offset                 *int
}

type ReportAdEquipments struct {
	ID              int            `json:"id"`
	CreatedAt       time.Time      `json:"created_at"`
	UpdatedAt       time.Time      `json:"updated_at"`
	DeletedAt       gorm.DeletedAt `json:"deleted_at" gorm:"index" swaggertype:"string"`
	UserID          int            `json:"user_id"`
	User            User           `json:"user"`
	ReportReasonsID int            `json:"report_reasons_id"`
	ReportReasons   ReportReason   `json:"report_reasons"`
	Description     string         `json:"description"`
	AdEquipmentID   int            `json:"ad_equipment_id"`
	AdEquipment     AdEquipment    `json:"ad_equipment"`
}

type FilterReportAdEquipments struct {
	ReportReasonsDetail       *bool
	AdEquipmentDetail         *bool
	AdEquipmentDocumentDetail *bool
	IDs                       []int
	ReportReasonsIDs          []int
	AdEquipmentIDs            []int
	Limit                     *int
	Offset                    *int
}

type ReportAdEquipmentClient struct {
	ID                  int               `json:"id"`
	CreatedAt           time.Time         `json:"created_at"`
	UpdatedAt           time.Time         `json:"updated_at"`
	DeletedAt           gorm.DeletedAt    `json:"deleted_at" gorm:"index" swaggertype:"string"`
	UserID              int               `json:"user_id"`
	User                User              `json:"user"`
	ReportReasonsID     int               `json:"report_reasons_id"`
	ReportReasons       ReportReason      `json:"report_reasons"`
	Description         string            `json:"description"`
	AdEquipmentClientID int               `json:"ad_equipment_client_id"`
	AdEquipmentClient   AdEquipmentClient `json:"ad_equipment_client"`
}

type FilterReportAdEquipmentsClient struct {
	ReportReasonsDetail             *bool
	AdEquipmentClientDetail         *bool
	AdEquipmentClientDocumentDetail *bool
	IDs                             []int
	ReportReasonsIDs                []int
	AdEquipmentClientIDs            []int
	Limit                           *int
	Offset                          *int
}

type ReportReason struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

type ReportSystem struct {
	ID                   int                `json:"id"`
	CreatedAt            time.Time          `json:"created_at"`
	UpdatedAt            time.Time          `json:"updated_at"`
	DeletedAt            gorm.DeletedAt     `json:"deleted_at" gorm:"index" swaggertype:"string"`
	UserID               int                `json:"user_id"`
	User                 User               `json:"user"`
	ReportReasonSystemID int                `json:"report_reason_system_id"`
	ReportReasonSystem   ReportReasonSystem `json:"report_reason_system"`
	Description          string             `json:"description"`
}

type FilterReportSystem struct {
	UserDetail               *bool
	ReportReasonSystemDetail *bool
	ID                       []int
	UserID                   []int
	ReportReasonSystemID     []int
	Limit                    *int
	Offset                   *int
}

type ReportReasonSystem struct {
	ID   int    `json:"id"`
	Name string `json:"name"`
}

type ReportAdConstructionMaterials struct {
	ID                       int                    `json:"id"`
	CreatedAt                time.Time              `json:"created_at"`
	UpdatedAt                time.Time              `json:"updated_at"`
	DeletedAt                gorm.DeletedAt         `json:"deleted_at" gorm:"index" swaggertype:"string"`
	UserID                   int                    `json:"user_id"`
	User                     User                   `json:"user"`
	ReportReasonsID          int                    `json:"report_reasons_id"`
	ReportReasons            ReportReason           `json:"report_reasons"`
	Description              string                 `json:"description"`
	AdConstructionMaterialID int                    `json:"ad_construction_material_id"`
	AdConstructionMaterial   AdConstructionMaterial `json:"ad_construction_material"`
}

type FilterReportAdConstructionMaterials struct {
	ReportReasonsDetail                  *bool
	AdConstructionMaterialDetail         *bool
	AdConstructionMaterialDocumentDetail *bool
	IDs                                  []int
	ReportReasonsIDs                     []int
	AdConstructionMaterialIDs            []int
	Limit                                *int
	Offset                               *int
}

type ReportAdConstructionMaterialClient struct {
	ID                             int                          `json:"id"`
	CreatedAt                      time.Time                    `json:"created_at"`
	UpdatedAt                      time.Time                    `json:"updated_at"`
	DeletedAt                      gorm.DeletedAt               `json:"deleted_at" gorm:"index" swaggertype:"string"`
	UserID                         int                          `json:"user_id"`
	User                           User                         `json:"user"`
	ReportReasonsID                int                          `json:"report_reasons_id"`
	ReportReasons                  ReportReason                 `json:"report_reasons"`
	Description                    string                       `json:"description"`
	AdConstructionMaterialClientID int                          `json:"ad_construction_material_client_id"`
	AdConstructionMaterialClient   AdConstructionMaterialClient `json:"ad_construction_material_client"`
}

type FilterReportAdConstructionMaterialsClient struct {
	ReportReasonsDetail                        *bool
	AdConstructionMaterialClientDetail         *bool
	AdConstructionMaterialClientDocumentDetail *bool
	IDs                                        []int
	ReportReasonsIDs                           []int
	AdConstructionMaterialClientIDs            []int
	Limit                                      *int
	Offset                                     *int
}

type ReportAdServices struct {
	ID              int            `json:"id"`
	CreatedAt       time.Time      `json:"created_at"`
	UpdatedAt       time.Time      `json:"updated_at"`
	DeletedAt       gorm.DeletedAt `json:"deleted_at" gorm:"index" swaggertype:"string"`
	UserID          int            `json:"user_id"`
	User            User           `json:"user"`
	ReportReasonsID int            `json:"report_reasons_id"`
	ReportReasons   ReportReason   `json:"report_reasons"`
	Description     string         `json:"description"`
	AdServiceID     int            `json:"ad_service_id"`
	AdService       AdService      `json:"ad_service"`
}

type FilterReportAdServices struct {
	ReportReasonsDetail     *bool
	AdServiceDetail         *bool
	AdServiceDocumentDetail *bool
	IDs                     []int
	ReportReasonsIDs        []int
	AdServiceIDs            []int
	Limit                   *int
	Offset                  *int
}

type ReportAdServiceClient struct {
	ID                int             `json:"id"`
	CreatedAt         time.Time       `json:"created_at"`
	UpdatedAt         time.Time       `json:"updated_at"`
	DeletedAt         gorm.DeletedAt  `json:"deleted_at" gorm:"index" swaggertype:"string"`
	UserID            int             `json:"user_id"`
	User              User            `json:"user"`
	ReportReasonsID   int             `json:"report_reasons_id"`
	ReportReasons     ReportReason    `json:"report_reasons"`
	Description       string          `json:"description"`
	AdServiceClientID int             `json:"ad_service_client_id"`
	AdServiceClient   AdServiceClient `json:"ad_service_client"`
}

type FilterReportAdServicesClient struct {
	ReportReasonsDetail           *bool
	AdServiceClientDetail         *bool
	AdServiceClientDocumentDetail *bool
	IDs                           []int
	ReportReasonsIDs              []int
	AdServiceClientIDs            []int
	Limit                         *int
	Offset                        *int
}
