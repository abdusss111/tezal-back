package model

type FilterSearch struct {
	CategorySmDetail                    *bool
	CategoryEqDetail                    *bool
	AdSpecializedMachineriesDetail      *bool
	AdClientsDetail                     *bool
	AdEquipmentsDetail                  *bool
	AdEquipmentClientsDetail            *bool
	AdConstructionMaterialDetail        *bool
	AdConstructionMaterialClientsDetail *bool
	AdServiceDetail                     *bool
	AdServiceClientsDetail              *bool
	General                             string
	CityID                              *int
	Limit                               *int
	Offset                              *int

	SubCategoryID       []int
	EquipmentCategoryID []int

	//AdConstructionMaterialParams *AdConstructionMaterialParams `json:"ad_construction_material_params"`
	//
	//AdSearchParams []AdSearchParams
}

type AdSearchParams struct {
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
	NumberTools                          ParamMinMax `json:"number_tools"`
	TypeOfTools                          ParamMinMax `json:"type_of_tools"`
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
	HammerType                           ParamMinMax `json:"hammer_type"`
	SolderingElementType                 ParamMinMax `json:"soldering_element_type"`
	PowerSupplyType                      ParamMinMax `json:"power_supply_type"`
	DrillType                            ParamMinMax `json:"drill_type"`
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

type SearchSMResult struct {
	SubCategories       []SubCategory       `json:"categories"`
	EquipmentCategories []EquipmentCategory `json:"equipment_categories"`

	AdSpecializedMachineries      []AdSpecializedMachinery       `json:"ad_specialized_machineries"`
	AdClients                     []AdClient                     `json:"ad_clients"`
	AdEquipments                  []AdEquipment                  `json:"ad_equipments"`
	AdEquipmentClients            []AdEquipmentClient            `json:"ad_equipment_clients"`
	AdConstructionMaterial        []AdConstructionMaterial       `json:"ad_construction_material"`
	AdConstructionMaterialClients []AdConstructionMaterialClient `json:"ad_construction_material_clients"`
	AdService                     []AdService                    `json:"ad_service"`
	AdServiceClients              []AdServiceClient              `json:"ad_service_clients"`
}

type AdSearchResult struct {
	ID          int      `json:"id"`
	Price       float64  `json:"price"`
	BodyHeight  float64  `json:"body_height"`
	UrlDocument []string `json:"url_document"`
}
