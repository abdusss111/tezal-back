package model

import (
	"time"

	"gorm.io/gorm"
)

// advertisement - объявление об услуге спецтехнике
type AdSpecializedMachinery struct {
	ID                int                           `json:"id"`
	CreatedAt         time.Time                     `json:"created_at"`
	UpdatedAt         time.Time                     `json:"updated_at"`
	DeletedAt         gorm.DeletedAt                `json:"deleted_at" gorm:"index" swaggertype:"string"`
	UserID            int                           `json:"user_id"`
	User              User                          `json:"user" gorm:"foreignKey:UserID"`
	BrandID           int                           `json:"brand_id"`
	Brand             Brand                         `json:"brand" gorm:"foreignKey:BrandID"`
	TypeID            int                           `json:"type_id"`
	Type              Type                          `json:"type" gorm:"foreignKey:TypeID"`
	CityID            int                           `json:"city_id"`
	City              City                          `json:"city"`
	Price             float64                       `json:"price"` //Цена за час работы
	Name              string                        `json:"name"`
	Description       string                        `json:"description"`
	CountRate         int                           `json:"count_rate"`
	Rating            float64                       `json:"rating"`
	UrlDocument       []string                      `json:"url_foto" gorm:"-"`
	ThumbnailDocument []string                      `json:"url_thumbnail" gorm:"-"`
	Document          []Document                    `json:"-" gorm:"many2many:ad_specialized_machineries_documents;"`
	Address           string                        `json:"address"`
	Latitude          *float64                      `json:"latitude"`
	Longitude         *float64                      `json:"longitude"`
	Params            AdSpecializedMachinerieParams `json:"params"`
}

// для будушей фильтрации объявлении спецтехники
type FilterAdSpecializedMachinery struct {
	UserDetail     *bool
	BrandDetail    *bool
	TypeDetail     *bool
	CityDetail     *bool
	DocumentDetail *bool
	Limit          *int
	Offset         *int
	Name           *string
	Description    *string

	UserID                     []int
	TypeID                     *int
	Unscoped                   *bool
	SubCategoryID              *int
	CityID                     *int
	ASC                        []string
	DESC                       []string
	Price                      ParamMinMax
	BodyHeight                 ParamMinMax `json:"body_height"`
	LiftHeight                 ParamMinMax `json:"lift_height"`
	BladeCuttingDepth          ParamMinMax `json:"blade_cutting_depth"`
	FenceDepth                 ParamMinMax `json:"fence_depth"`
	GripDepth                  ParamMinMax `json:"grip_depth"`
	DiggingDepth               ParamMinMax `json:"digging_depth"`
	LoadCapacity               ParamMinMax `json:"load_capacity"`
	AirPressure                ParamMinMax `json:"air_pressure"`
	DrillingDiameter           ParamMinMax `json:"drilling_diameter"`
	RollerDiameter             ParamMinMax `json:"roller_diameter"`
	BodyLength                 ParamMinMax `json:"body_length"`
	PlatformLength             ParamMinMax `json:"platform_length"`
	BoomLength                 ParamMinMax `json:"boom_length"`
	GroundClearance            ParamMinMax `json:"ground_clearance"`
	FuelTankCapacity           ParamMinMax `json:"fuel_tank_capacity"`
	NumberOfRollers            ParamMinMax `json:"number_of_rollers"`
	NumberOfAxles              ParamMinMax `json:"number_of_axles"`
	MaximumDrillingDepth       ParamMinMax `json:"maximum_drilling_depth"`
	MaximumTowableTrailerMass  ParamMinMax `json:"maximum_towable_trailer_mass"`
	EnginePower                ParamMinMax `json:"engine_power"`
	Voltage                    ParamMinMax `json:"voltage"`
	WaterTankVolume            ParamMinMax `json:"water_tank_volume"`
	BucketVolume               ParamMinMax `json:"bucket_volume"`
	BodyVolume                 ParamMinMax `json:"body_volume"`
	TankVolume                 ParamMinMax `json:"tank_volume"`
	OperatingPressure          ParamMinMax `json:"operating_pressure"`
	UnloadingRadius            ParamMinMax `json:"unloading_radius"`
	TurningRadius              ParamMinMax `json:"turning_radius"`
	RefrigeratorTemperatureMin ParamMinMax `json:"refrigerator_temperature_min"`
	RefrigeratorTemperatureMax ParamMinMax `json:"refrigerator_temperature_max"`
	TemperatureRange           ParamMinMax `json:"temperature_range"`
	RollerType                 ParamMinMax `json:"roller_type"`
	BodyType                   ParamMinMax `json:"body_type"`
	PumpType                   ParamMinMax `json:"pump_type"`
	PlatformType               ParamMinMax `json:"platform_type"`
	WeldingSourceType          ParamMinMax `json:"welding_source_type"`
	UndercarriageType          ParamMinMax `json:"undercarriage_type"`
	BladeTiltAngle             ParamMinMax `json:"blade_tilt_angle"`
	Frequency                  ParamMinMax `json:"frequency"`
	RollerWidth                ParamMinMax `json:"roller_width"`
	GripWidth                  ParamMinMax `json:"grip_width"`
	DiggingWidth               ParamMinMax `json:"digging_width"`
	BodyWidth                  ParamMinMax `json:"body_width"`
	PlatformWidth              ParamMinMax `json:"platform_width"`
	UnloadingGapWidth          ParamMinMax `json:"unloading_gap_width"`
	LayingWidth                ParamMinMax `json:"laying_width"`
	MillingWidth               ParamMinMax `json:"milling_width"`
}

type AdSpecializedMachineriesDocuments struct {
	AdSpecializedMachineryID int
	DocumentID               int
}

type AdSpecializedMachineryInteracted struct {
	ID                       int            `json:"id"`
	CreatedAt                time.Time      `json:"created_at"`
	UpdatedAt                time.Time      `json:"updated_at"`
	DeletedAt                gorm.DeletedAt `json:"deleted_at" gorm:"index" swaggertype:"string"`
	AdSpecializedMachineryID int            `json:"ad_service_id"`
	UserID                   int            `json:"user_id"`
	User                     User           `json:"user"`
}
