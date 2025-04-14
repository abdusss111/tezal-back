package model

type FavoriteAdSpecializedMachinery struct {
	UserID                   int                    `json:"user_id"`
	AdSpecializedMachineryID int                    `json:"ad_specialized_machinery_id"`
	AdSpecializedMachinery   AdSpecializedMachinery `json:"ad_specialized_machinery"`
}

type FavoriteAdClient struct {
	UserID     int      `json:"user_id"`
	AdClientID int      `json:"ad_client_id"`
	AdClient   AdClient `json:"ad_client"`
}

type FavoriteAdEquipment struct {
	UserID        int         `json:"user_id"`
	AdEquipmentID int         `json:"ad_equipment_id"`
	AdEquipment   AdEquipment `json:"ad_equipment"`
}

type FavoriteAdEquipmentClient struct {
	UserID              int               `json:"user_id"`
	AdEquipmentClientID int               `json:"ad_equipment_client_id"`
	AdEquipmentClient   AdEquipmentClient `json:"ad_equipment_client"`
}

type FavoriteAdConstructionMaterial struct {
	UserID                   int                    `json:"user_id"`
	AdConstructionMaterialID int                    `json:"ad_construction_material_id"`
	AdConstructionMaterial   AdConstructionMaterial `json:"ad_construction_material"`
}

type FavoriteAdConstructionMaterialClient struct {
	UserID                         int                          `json:"user_id"`
	AdConstructionMaterialClientID int                          `json:"ad_construction_material_client_id"`
	AdConstructionMaterialClient   AdConstructionMaterialClient `json:"ad_construction_material_client"`
}

type FavoriteAdService struct {
	UserID      int       `json:"user_id"`
	AdServiceID int       `json:"ad_service_id"`
	AdService   AdService `json:"ad_service"`
}

type FavoriteAdServiceClient struct {
	UserID            int             `json:"user_id"`
	AdServiceClientID int             `json:"ad_service_client_id"`
	AdServiceClient   AdServiceClient `json:"ad_service_client"`
}
