package model

import (
	"time"

	"gorm.io/gorm"
)

type AdConstructionMaterial struct {
	ID                                int                             `json:"id"`
	CreatedAt                         time.Time                       `json:"created_at"`
	UpdatedAt                         time.Time                       `json:"updated_at"`
	DeletedAt                         gorm.DeletedAt                  `json:"deleted_at"              swaggertype:"string"`
	UserID                            int                             `json:"user_id"`
	User                              User                            `json:"user"`
	ConstructionMaterialBrandID       int                             `json:"construction_material_brand_id"`
	ConstructionMaterialBrand         ConstructionMaterialBrand       `json:"construction_material_brand"`
	ConstructionMaterialSubCategoryID int                             `json:"construction_material_sub_category_id"`
	ConstructionMaterialSubCategory   ConstructionMaterialSubCategory `json:"construction_material_sub_category"`
	CityID                            int                             `json:"city_id"`
	City                              City                            `json:"city"`
	Price                             float64                         `json:"price"`
	Title                             string                          `json:"title"`
	Description                       string                          `json:"description"`
	Address                           string                          `json:"address"`
	Latitude                          *float64                        `json:"latitude"`
	Longitude                         *float64                        `json:"longitude"`
	Params                            AdConstructionMaterialParams    `json:"params"`
	Documents                         []Document                      `json:"document"                 gorm:"many2many:ad_construction_material_documents"   swaggerignore:"true"`
	UrlDocument                       []string                        `json:"url_foto"                 gorm:"-"`
	CountRate                         *int                            `json:"count_rate"`
	Rating                            *float64                        `json:"rating"`
}

type FilterAdConstructionMaterial struct {
	UserDetail                            *bool
	ConstructionMaterialBrandDetail       *bool
	ConstructionMaterialSubcategoryDetail *bool
	CityDetail                            *bool
	DocumentsDetail                       *bool
	ParamsDetail                          *bool
	Unscoped                              *bool
	Limit                                 *int
	Offset                                *int
	IDs                                   []int
	UserIDs                               []int
	ConstructionMaterialBrandIDs          []int
	ConstructionMaterialSubСategoryIDs    []int
	ConstructionMaterialСategoryIDs       []int
	CityIDs                               []int
	Title                                 *string
	Description                           *string
	Price                                 ParamMinMax
	ASC                                   []string
	DESC                                  []string

	HaveParamCondition                   bool
	Weight                               ParamMinMax `json:"weight"`
	Reach                                ParamMinMax `json:"reach"`
	Height                               ParamMinMax `json:"height"`
	LiftingHeight                        ParamMinMax `json:"lifting_height"`
	WorkingDepth                         ParamMinMax `json:"working_depth"`
	CuttingDepth                         ParamMinMax `json:"cutting_depth"`
	LoadCapacityKg                       ParamMinMax `json:"load_capacity_kg"`
	LoadCapacityT                        ParamMinMax `json:"load_capacity_t"`
	BendingDiameter                      ParamMinMax `json:"bending_diameter"`
	MachiningDiameter                    ParamMinMax `json:"machining_diameter"`
	ChuckDiameter                        ParamMinMax `json:"chuck_diameter"`
	SawBladeDiameter                     ParamMinMax `json:"saw_blade_diameter"`
	CuttingDiameter                      ParamMinMax `json:"cutting_diameter"`
	DrillingDiameter                     ParamMinMax `json:"drilling_diameter"`
	PipeDiameter                         ParamMinMax `json:"pipe_diameter"`
	AngleMeasuringRange                  ParamMinMax `json:"angle_measuring_range"`
	HoseLength                           ParamMinMax `json:"hose_length"`
	HoseDiameter                         ParamMinMax `json:"hose_diameter"`
	MeasuringLength                      ParamMinMax `json:"measuring_length"`
	SawBandLength                        ParamMinMax `json:"saw_band_length"`
	SawBandWidth                         ParamMinMax `json:"saw_band_width"`
	RopeLength                           ParamMinMax `json:"rope_length"`
	Length                               ParamMinMax `json:"length"`
	WorkingLength                        ParamMinMax `json:"working_length"`
	CuttingLength                        ParamMinMax `json:"cutting_length"`
	HandleLength                         ParamMinMax `json:"handle_length"`
	CableLength                          ParamMinMax `json:"cable_length"`
	OilTankCapacity                      ParamMinMax `json:"oil_tank_capacity"`
	FuelTankCapacity                     ParamMinMax `json:"fuel_tank_capacity"`
	NumberTools                          ParamMinMax `json:"number_tools"`
	TypeOfTools                          ParamMinMax `json:"type_of_tools"`
	NumberOfAxles                        ParamMinMax `json:"number_of_axles"`
	NumberOfFlasks                       ParamMinMax `json:"number_of_flasks"`
	MaxWorkpieceHeight                   ParamMinMax `json:"max_workpiece_height"`
	MaximumLiftingHeight                 ParamMinMax `json:"maximum_lifting_height"`
	MaximumCuttingDepthInWood            ParamMinMax `json:"maximum_cutting_depth_in_wood"`
	MaximumCuttingDepthInMetal           ParamMinMax `json:"maximum_cutting_depth_in_metal"`
	MaximumCuttingDepthInPlastic         ParamMinMax `json:"maximum_cutting_depth_in_plastic"`
	MaximumCuttingDepth                  ParamMinMax `json:"maximum_cutting_depth"`
	MaximumCuttingDepthAt90              ParamMinMax `json:"maximum_cutting_depth_at90"`
	MaximumCuttingDepthAtAngularPosition ParamMinMax `json:"maximum_cutting_depth_at_angular_position"`
	MaximumWheelWeight                   ParamMinMax `json:"maximum_wheel_weight"`
	MaximumPowerW                        ParamMinMax `json:"maximum_power_w"`
	MaximumPowerKw                       ParamMinMax `json:"maximum_power_kw"`
	MaximumLoad                          ParamMinMax `json:"maximum_load"`
	MaximumLiftingSpeed                  ParamMinMax `json:"maximum_lifting_speed"`
	MaximumMaterialThickness             ParamMinMax `json:"maximum_material_thickness"`
	MaximumCuttingWidth                  ParamMinMax `json:"maximum_cutting_width"`
	MaximumForce                         ParamMinMax `json:"maximum_force"`
	MaximumWheelDiameter                 ParamMinMax `json:"maximum_wheel_diameter"`
	MaximumDiameterOfSelfDrillingScrew   ParamMinMax `json:"maximum_diameter_of_self_drilling_screw"`
	MaximumDrillingDiameterInWood        ParamMinMax `json:"maximum_drilling_diameter_in_wood"`
	MaximumDrillingDiameterInMetal       ParamMinMax `json:"maximum_drilling_diameter_in_metal"`
	TubeMaterial                         ParamMinMax `json:"tube_material"`
	BandLockingMechanism                 ParamMinMax `json:"band_locking_mechanism"`
	PowerW                               ParamMinMax `json:"power_w"`
	BurnerPower                          ParamMinMax `json:"burner_power"`
	MotorPower                           ParamMinMax `json:"motor_power"`
	PowerKw                              ParamMinMax `json:"power_kw"`
	DrivePower                           ParamMinMax `json:"drive_power"`
	SpindlePower                         ParamMinMax `json:"spindle_power"`
	Voltage                              ParamMinMax `json:"voltage"`
	Frequency                            ParamMinMax `json:"frequency"`
	RatedFrequency                       ParamMinMax `json:"rated_frequency"`
	RatedVoltage                         ParamMinMax `json:"rated_voltage"`
	RatedCurrent                         ParamMinMax `json:"rated_current"`
	DrumVolume                           ParamMinMax `json:"drum_volume"`
	CapacityKgh                          ParamMinMax `json:"capacity_kgh"`
	CapacityKw                           ParamMinMax `json:"capacity_kw"`
	CapacityLitersHour                   ParamMinMax `json:"capacity_liters_hour"`
	CapacityTh                           ParamMinMax `json:"capacity_th"`
	WorkingPressure                      ParamMinMax `json:"working_pressure"`
	GasWorkingPressure                   ParamMinMax `json:"gas_working_pressure"`
	TableWorkingSize                     ParamMinMax `json:"table_working_size"`
	BendingRadiusM                       ParamMinMax `json:"bending_radius_m"`
	BendingRadiusMm                      ParamMinMax `json:"bending_radius_mm"`
	TableDimensionsMm                    ParamMinMax `json:"table_dimensions_mm"`
	TableDimensionsMm2                   ParamMinMax `json:"table_dimensions_mm2"`
	GasSupplySystem                      ParamMinMax `json:"gas_supply_system"`
	DrumRotationSpeed                    ParamMinMax `json:"drum_rotation_speed"`
	RotationSpeed                        ParamMinMax `json:"rotation_speed"`
	SawBladeSpeed                        ParamMinMax `json:"saw_blade_speed"`
	SpindleSpeed                         ParamMinMax `json:"spindle_speed"`
	BeltSpeed                            ParamMinMax `json:"belt_speed"`
	Speed                                ParamMinMax `json:"speed"`
	LiftingSpeed                         ParamMinMax `json:"lifting_speed"`
	CuttingSpeed                         ParamMinMax `json:"cutting_speed"`
	TemperatureRange                     ParamMinMax `json:"temperature_range"`
	BatteryType                          ParamMinMax `json:"battery_type"`
	DisplayType                          ParamMinMax `json:"display_type"`
	StartType                            ParamMinMax `json:"start_type"`
	MeasurementType                      ParamMinMax `json:"measurement_type"`
	TypeOfGasUsed                        ParamMinMax `json:"type_of_gas_used"`
	TypeOfSawsUsed                       ParamMinMax `json:"type_of_saws_used"`
	TypeOfCableBender                    ParamMinMax `json:"type_of_cable_bender"`
	TypeOfCableCutter                    ParamMinMax `json:"type_of_cable_cutter"`
	TypeOfRope                           ParamMinMax `json:"type_of_rope"`
	CraneType                            ParamMinMax `json:"crane_type"`
	TypeOfTape                           ParamMinMax `json:"type_of_tape"`
	PumpType                             ParamMinMax `json:"pump_type"`
	HammerType                           ParamMinMax `json:"hammer_type"`
	SolderingElementType                 ParamMinMax `json:"soldering_element_type"`
	PowerSupplyType                      ParamMinMax `json:"power_supply_type"`
	DrillType                            ParamMinMax `json:"drill_type"`
	PlatformType                         ParamMinMax `json:"platform_type"`
	BearingType                          ParamMinMax `json:"bearing_type"`
	ElevatorType                         ParamMinMax `json:"elevator_type"`
	DriveType                            ParamMinMax `json:"drive_type"`
	CuttingMechanismType                 ParamMinMax `json:"cutting_mechanism_type"`
	WeldingType                          ParamMinMax `json:"welding_type"`
	TypeOfWeldingMachine                 ParamMinMax `json:"type_of_welding_machine"`
	TypeOfControlSystem                  ParamMinMax `json:"type_of_control_system"`
	FuelType                             ParamMinMax `json:"fuel_type"`
	CableType                            ParamMinMax `json:"cable_type"`
	PipeBenderType                       ParamMinMax `json:"pipe_bender_type"`
	PipeCutterType                       ParamMinMax `json:"pipe_cutter_type"`
	ControlType                          ParamMinMax `json:"control_type"`
	FilterType                           ParamMinMax `json:"filter_type"`
	WeldingCurrent                       ParamMinMax `json:"welding_current"`
	CuttingThickness                     ParamMinMax `json:"cutting_thickness"`
	MeasuringAccuracy                    ParamMinMax `json:"measuring_accuracy"`
	CuttingAccuracy                      ParamMinMax `json:"cutting_accuracy"`
	SawBladeTiltAngle                    ParamMinMax `json:"saw_blade_tilt_angle"`
	TableTiltAngle                       ParamMinMax `json:"table_tilt_angle"`
	PressingForce                        ParamMinMax `json:"pressing_force"`
	TravelLength                         ParamMinMax `json:"travel_length"`
	SawStroke                            ParamMinMax `json:"saw_stroke"`
	StrokeOfThePress                     ParamMinMax `json:"stroke_of_the_press"`
	StrokeFrequency                      ParamMinMax `json:"stroke_frequency"`
	NumberOfRevolutions                  ParamMinMax `json:"number_of_revolutions"`
	NumberOfSawStrokesPerMinute          ParamMinMax `json:"number_of_saw_strokes_per_minute"`
	Width                                ParamMinMax `json:"width"`
	BeltWidth                            ParamMinMax `json:"belt_width"`
	WorkingWidth                         ParamMinMax `json:"working_width"`
}

type AdConstructionMaterialInteracted struct {
	ID                       int            `json:"id"`
	CreatedAt                time.Time      `json:"created_at"`
	UpdatedAt                time.Time      `json:"updated_at"`
	DeletedAt                gorm.DeletedAt `json:"deleted_at"      gorm:"index" swaggertype:"string"`
	AdConstructionMaterialID int            `json:"ad_construction_material_id"`
	UserID                   int            `json:"user_id"`
	User                     User           `json:"user"`
}

type AdConstructionMaterialDocuments struct {
	AdConstructionMaterialId int
	DocumentId               int
}
