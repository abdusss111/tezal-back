package model

import (
	"errors"
	"fmt"
	"regexp"
	"strconv"
)

type Param struct {
	ID      int    `json:"id"`
	Name    string `json:"name"`
	NameEng string `json:"name_eng"`
}

type AdSpecializedMachinerieParams struct {
	AdSpecializedMachineryID   int      `json:"ad_specialized_machinery_id"`
	BodyHeight                 *float64 `json:"body_height"`
	LiftHeight                 *float64 `json:"lift_height"`
	BladeCuttingDepth          *float64 `json:"blade_cutting_depth"`
	FenceDepth                 *float64 `json:"fence_depth"`
	GripDepth                  *float64 `json:"grip_depth"`
	DiggingDepth               *float64 `json:"digging_depth"`
	LoadCapacity               *float64 `json:"load_capacity"`
	AirPressure                *float64 `json:"air_pressure"`
	DrillingDiameter           *float64 `json:"drilling_diameter"`
	RollerDiameter             *float64 `json:"roller_diameter"`
	BodyLength                 *float64 `json:"body_length"`
	PlatformLength             *float64 `json:"platform_length"`
	BoomLength                 *float64 `json:"boom_length"`
	GroundClearance            *float64 `json:"ground_clearance"`
	FuelTankCapacity           *float64 `json:"fuel_tank_capacity"`
	NumberOfRollers            *float64 `json:"number_of_rollers"`
	NumberOfAxles              *float64 `json:"number_of_axles"`
	MaximumDrillingDepth       *float64 `json:"maximum_drilling_depth"`
	MaximumTowableTrailerMass  *float64 `json:"maximum_towable_trailer_mass"`
	EnginePower                *float64 `json:"engine_power"`
	Voltage                    *float64 `json:"voltage"`
	WaterTankVolume            *float64 `json:"water_tank_volume"`
	BucketVolume               *float64 `json:"bucket_volume"`
	BodyVolume                 *float64 `json:"body_volume"`
	TankVolume                 *float64 `json:"tank_volume"`
	OperatingPressure          *float64 `json:"operating_pressure"`
	UnloadingRadius            *float64 `json:"unloading_radius"`
	TurningRadius              *float64 `json:"turning_radius"`
	RefrigeratorTemperatureMin *float64 `json:"refrigerator_temperature_min"`
	RefrigeratorTemperatureMax *float64 `json:"refrigerator_temperature_max"`
	TemperatureRange           *float64 `json:"temperature_range"`
	RollerType                 *float64 `json:"roller_type"`
	BodyType                   *float64 `json:"body_type"`
	PumpType                   *float64 `json:"pump_type"`
	PlatformType               *float64 `json:"platform_type"`
	WeldingSourceType          *float64 `json:"welding_source_type"`
	UndercarriageType          *float64 `json:"undercarriage_type"`
	BladeTiltAngle             *float64 `json:"blade_tilt_angle"`
	Frequency                  *float64 `json:"frequency"`
	RollerWidth                *float64 `json:"roller_width"`
	GripWidth                  *float64 `json:"grip_width"`
	DiggingWidth               *float64 `json:"digging_width"`
	BodyWidth                  *float64 `json:"body_width"`
	PlatformWidth              *float64 `json:"platform_width"`
	UnloadingGapWidth          *float64 `json:"unloading_gap_width"`
	LayingWidth                *float64 `json:"laying_width"`
	MillingWidth               *float64 `json:"milling_width"`
}

type AdEquipmentParams struct {
	AdEquipmentID                        int      `json:"ad_equipment_id"`
	Weight                               *float64 `json:"weight"`
	Reach                                *float64 `json:"reach"`
	Height                               *float64 `json:"height"`
	LiftingHeight                        *float64 `json:"lifting_height"`
	WorkingDepth                         *float64 `json:"working_depth"`
	CuttingDepth                         *float64 `json:"cutting_depth"`
	LoadCapacityKg                       *float64 `json:"load_capacity_kg"`
	LoadCapacityT                        *float64 `json:"load_capacity_t"`
	BendingDiameter                      *float64 `json:"bending_diameter"`
	MachiningDiameter                    *float64 `json:"machining_diameter"`
	ChuckDiameter                        *float64 `json:"chuck_diameter"`
	SawBladeDiameter                     *float64 `json:"saw_blade_diameter"`
	CuttingDiameter                      *float64 `json:"cutting_diameter"`
	DrillingDiameter                     *float64 `json:"drilling_diameter"`
	PipeDiameter                         *float64 `json:"pipe_diameter"`
	AngleMeasuringRange                  *float64 `json:"angle_measuring_range"`
	HoseLength                           *float64 `json:"hose_length"`
	HoseDiameter                         *float64 `json:"hose_diameter"`
	MeasuringLength                      *float64 `json:"measuring_length"`
	SawBandLength                        *float64 `json:"saw_band_length"`
	SawBandWidth                         *float64 `json:"saw_band_width"`
	RopeLength                           *float64 `json:"rope_length"`
	Length                               *float64 `json:"length"`
	WorkingLength                        *float64 `json:"working_length"`
	CuttingLength                        *float64 `json:"cutting_length"`
	HandleLength                         *float64 `json:"handle_length"`
	CableLength                          *float64 `json:"cable_length"`
	OilTankCapacity                      *float64 `json:"oil_tank_capacity"`
	FuelTankCapacity                     *float64 `json:"fuel_tank_capacity"`
	NumberTools                          *float64 `json:"number_tools"`
	TypeOfTools                          *float64 `json:"type_of_tools"`
	NumberOfAxles                        *float64 `json:"number_of_axles"`
	NumberOfFlasks                       *float64 `json:"number_of_flasks"`
	MaxWorkpieceHeight                   *float64 `json:"max_workpiece_height"`
	MaximumLiftingHeight                 *float64 `json:"maximum_lifting_height"`
	MaximumCuttingDepthInWood            *float64 `json:"maximum_cutting_depth_in_wood"`
	MaximumCuttingDepthInMetal           *float64 `json:"maximum_cutting_depth_in_metal"`
	MaximumCuttingDepthInPlastic         *float64 `json:"maximum_cutting_depth_in_plastic"`
	MaximumCuttingDepth                  *float64 `json:"maximum_cutting_depth"`
	MaximumCuttingDepthAt90              *float64 `json:"maximum_cutting_depth_at90"`
	MaximumCuttingDepthAtAngularPosition *float64 `json:"maximum_cutting_depth_at_angular_position"`
	MaximumWheelWeight                   *float64 `json:"maximum_wheel_weight"`
	MaximumPowerW                        *float64 `json:"maximum_power_w"`
	MaximumPowerKw                       *float64 `json:"maximum_power_kw"`
	MaximumLoad                          *float64 `json:"maximum_load"`
	MaximumLiftingSpeed                  *float64 `json:"maximum_lifting_speed"`
	MaximumMaterialThickness             *float64 `json:"maximum_material_thickness"`
	MaximumCuttingWidth                  *float64 `json:"maximum_cutting_width"`
	MaximumForce                         *float64 `json:"maximum_force"`
	MaximumWheelDiameter                 *float64 `json:"maximum_wheel_diameter"`
	MaximumDiameterOfSelfDrillingScrew   *float64 `json:"maximum_diameter_of_self_drilling_screw"`
	MaximumDrillingDiameterInWood        *float64 `json:"maximum_drilling_diameter_in_wood"`
	MaximumDrillingDiameterInMetal       *float64 `json:"maximum_drilling_diameter_in_metal"`
	TubeMaterial                         *float64 `json:"tube_material"`
	BandLockingMechanism                 *float64 `json:"band_locking_mechanism"`
	PowerW                               *float64 `json:"power_w"`
	BurnerPower                          *float64 `json:"burner_power"`
	MotorPower                           *float64 `json:"motor_power"`
	PowerKw                              *float64 `json:"power_kw"`
	DrivePower                           *float64 `json:"drive_power"`
	SpindlePower                         *float64 `json:"spindle_power"`
	Voltage                              *float64 `json:"voltage"`
	Frequency                            *float64 `json:"frequency"`
	RatedFrequency                       *float64 `json:"rated_frequency"`
	RatedVoltage                         *float64 `json:"rated_voltage"`
	RatedCurrent                         *float64 `json:"rated_current"`
	DrumVolume                           *float64 `json:"drum_volume"`
	CapacityKgh                          *float64 `json:"capacity_kgh"`
	CapacityKw                           *float64 `json:"capacity_kw"`
	CapacityLitersHour                   *float64 `json:"capacity_liters_hour"`
	CapacityTh                           *float64 `json:"capacity_th"`
	WorkingPressure                      *float64 `json:"working_pressure"`
	GasWorkingPressure                   *float64 `json:"gas_working_pressure"`
	TableWorkingSize                     *float64 `json:"table_working_size"`
	BendingRadiusM                       *float64 `json:"bending_radius_m"`
	BendingRadiusMm                      *float64 `json:"bending_radius_mm"`
	TableDimensionsMm                    *float64 `json:"table_dimensions_mm"`
	TableDimensionsMm2                   *float64 `json:"table_dimensions_mm2"`
	GasSupplySystem                      *float64 `json:"gas_supply_system"`
	DrumRotationSpeed                    *float64 `json:"drum_rotation_speed"`
	RotationSpeed                        *float64 `json:"rotation_speed"`
	SawBladeSpeed                        *float64 `json:"saw_blade_speed"`
	SpindleSpeed                         *float64 `json:"spindle_speed"`
	BeltSpeed                            *float64 `json:"belt_speed"`
	Speed                                *float64 `json:"speed"`
	LiftingSpeed                         *float64 `json:"lifting_speed"`
	CuttingSpeed                         *float64 `json:"cutting_speed"`
	TemperatureRange                     *float64 `json:"temperature_range"`
	BatteryType                          *float64 `json:"battery_type"`
	DisplayType                          *float64 `json:"display_type"`
	StartType                            *float64 `json:"start_type"`
	MeasurementType                      *float64 `json:"measurement_type"`
	TypeOfGasUsed                        *float64 `json:"type_of_gas_used"`
	TypeOfSawsUsed                       *float64 `json:"type_of_saws_used"`
	TypeOfCableBender                    *float64 `json:"type_of_cable_bender"`
	TypeOfCableCutter                    *float64 `json:"type_of_cable_cutter"`
	TypeOfRope                           *float64 `json:"type_of_rope"`
	CraneType                            *float64 `json:"crane_type"`
	TypeOfTape                           *float64 `json:"type_of_tape"`
	PumpType                             *float64 `json:"pump_type"`
	HammerType                           *float64 `json:"hammer_type"`
	SolderingElementType                 *float64 `json:"soldering_element_type"`
	PowerSupplyType                      *float64 `json:"power_supply_type"`
	DrillType                            *float64 `json:"drill_type"`
	PlatformType                         *float64 `json:"platform_type"`
	BearingType                          *float64 `json:"bearing_type"`
	ElevatorType                         *float64 `json:"elevator_type"`
	DriveType                            *float64 `json:"drive_type"`
	CuttingMechanismType                 *float64 `json:"cutting_mechanism_type"`
	WeldingType                          *float64 `json:"welding_type"`
	TypeOfWeldingMachine                 *float64 `json:"type_of_welding_machine"`
	TypeOfControlSystem                  *float64 `json:"type_of_control_system"`
	FuelType                             *float64 `json:"fuel_type"`
	CableType                            *float64 `json:"cable_type"`
	PipeBenderType                       *float64 `json:"pipe_bender_type"`
	PipeCutterType                       *float64 `json:"pipe_cutter_type"`
	ControlType                          *float64 `json:"control_type"`
	FilterType                           *float64 `json:"filter_type"`
	WeldingCurrent                       *float64 `json:"welding_current"`
	CuttingThickness                     *float64 `json:"cutting_thickness"`
	MeasuringAccuracy                    *float64 `json:"measuring_accuracy"`
	CuttingAccuracy                      *float64 `json:"cutting_accuracy"`
	SawBladeTiltAngle                    *float64 `json:"saw_blade_tilt_angle"`
	TableTiltAngle                       *float64 `json:"table_tilt_angle"`
	PressingForce                        *float64 `json:"pressing_force"`
	TravelLength                         *float64 `json:"travel_length"`
	SawStroke                            *float64 `json:"saw_stroke"`
	StrokeOfThePress                     *float64 `json:"stroke_of_the_press"`
	StrokeFrequency                      *float64 `json:"stroke_frequency"`
	NumberOfRevolutions                  *float64 `json:"number_of_revolutions"`
	NumberOfSawStrokesPerMinute          *float64 `json:"number_of_saw_strokes_per_minute"`
	Width                                *float64 `json:"width"`
	BeltWidth                            *float64 `json:"belt_width"`
	WorkingWidth                         *float64 `json:"working_width"`
}

type AdConstructionMaterialParams struct {
	AdConstructionMaterialID             int      `json:"ad_construction_material_id"`
	Weight                               *float64 `json:"weight"`
	Reach                                *float64 `json:"reach"`
	Height                               *float64 `json:"height"`
	LiftingHeight                        *float64 `json:"lifting_height"`
	WorkingDepth                         *float64 `json:"working_depth"`
	CuttingDepth                         *float64 `json:"cutting_depth"`
	LoadCapacityKg                       *float64 `json:"load_capacity_kg"`
	LoadCapacityT                        *float64 `json:"load_capacity_t"`
	BendingDiameter                      *float64 `json:"bending_diameter"`
	MachiningDiameter                    *float64 `json:"machining_diameter"`
	ChuckDiameter                        *float64 `json:"chuck_diameter"`
	SawBladeDiameter                     *float64 `json:"saw_blade_diameter"`
	CuttingDiameter                      *float64 `json:"cutting_diameter"`
	DrillingDiameter                     *float64 `json:"drilling_diameter"`
	PipeDiameter                         *float64 `json:"pipe_diameter"`
	AngleMeasuringRange                  *float64 `json:"angle_measuring_range"`
	HoseLength                           *float64 `json:"hose_length"`
	HoseDiameter                         *float64 `json:"hose_diameter"`
	MeasuringLength                      *float64 `json:"measuring_length"`
	SawBandLength                        *float64 `json:"saw_band_length"`
	SawBandWidth                         *float64 `json:"saw_band_width"`
	RopeLength                           *float64 `json:"rope_length"`
	Length                               *float64 `json:"length"`
	WorkingLength                        *float64 `json:"working_length"`
	CuttingLength                        *float64 `json:"cutting_length"`
	HandleLength                         *float64 `json:"handle_length"`
	CableLength                          *float64 `json:"cable_length"`
	OilTankCapacity                      *float64 `json:"oil_tank_capacity"`
	FuelTankCapacity                     *float64 `json:"fuel_tank_capacity"`
	NumberTools                          *float64 `json:"number_tools"`
	TypeOfTools                          *float64 `json:"type_of_tools"`
	NumberOfAxles                        *float64 `json:"number_of_axles"`
	NumberOfFlasks                       *float64 `json:"number_of_flasks"`
	MaxWorkpieceHeight                   *float64 `json:"max_workpiece_height"`
	MaximumLiftingHeight                 *float64 `json:"maximum_lifting_height"`
	MaximumCuttingDepthInWood            *float64 `json:"maximum_cutting_depth_in_wood"`
	MaximumCuttingDepthInMetal           *float64 `json:"maximum_cutting_depth_in_metal"`
	MaximumCuttingDepthInPlastic         *float64 `json:"maximum_cutting_depth_in_plastic"`
	MaximumCuttingDepth                  *float64 `json:"maximum_cutting_depth"`
	MaximumCuttingDepthAt90              *float64 `json:"maximum_cutting_depth_at90"`
	MaximumCuttingDepthAtAngularPosition *float64 `json:"maximum_cutting_depth_at_angular_position"`
	MaximumWheelWeight                   *float64 `json:"maximum_wheel_weight"`
	MaximumPowerW                        *float64 `json:"maximum_power_w"`
	MaximumPowerKw                       *float64 `json:"maximum_power_kw"`
	MaximumLoad                          *float64 `json:"maximum_load"`
	MaximumLiftingSpeed                  *float64 `json:"maximum_lifting_speed"`
	MaximumMaterialThickness             *float64 `json:"maximum_material_thickness"`
	MaximumCuttingWidth                  *float64 `json:"maximum_cutting_width"`
	MaximumForce                         *float64 `json:"maximum_force"`
	MaximumWheelDiameter                 *float64 `json:"maximum_wheel_diameter"`
	MaximumDiameterOfSelfDrillingScrew   *float64 `json:"maximum_diameter_of_self_drilling_screw"`
	MaximumDrillingDiameterInWood        *float64 `json:"maximum_drilling_diameter_in_wood"`
	MaximumDrillingDiameterInMetal       *float64 `json:"maximum_drilling_diameter_in_metal"`
	TubeMaterial                         *float64 `json:"tube_material"`
	BandLockingMechanism                 *float64 `json:"band_locking_mechanism"`
	PowerW                               *float64 `json:"power_w"`
	BurnerPower                          *float64 `json:"burner_power"`
	MotorPower                           *float64 `json:"motor_power"`
	PowerKw                              *float64 `json:"power_kw"`
	DrivePower                           *float64 `json:"drive_power"`
	SpindlePower                         *float64 `json:"spindle_power"`
	Voltage                              *float64 `json:"voltage"`
	Frequency                            *float64 `json:"frequency"`
	RatedFrequency                       *float64 `json:"rated_frequency"`
	RatedVoltage                         *float64 `json:"rated_voltage"`
	RatedCurrent                         *float64 `json:"rated_current"`
	DrumVolume                           *float64 `json:"drum_volume"`
	CapacityKgh                          *float64 `json:"capacity_kgh"`
	CapacityKw                           *float64 `json:"capacity_kw"`
	CapacityLitersHour                   *float64 `json:"capacity_liters_hour"`
	CapacityTh                           *float64 `json:"capacity_th"`
	WorkingPressure                      *float64 `json:"working_pressure"`
	GasWorkingPressure                   *float64 `json:"gas_working_pressure"`
	TableWorkingSize                     *float64 `json:"table_working_size"`
	BendingRadiusM                       *float64 `json:"bending_radius_m"`
	BendingRadiusMm                      *float64 `json:"bending_radius_mm"`
	TableDimensionsMm                    *float64 `json:"table_dimensions_mm"`
	TableDimensionsMm2                   *float64 `json:"table_dimensions_mm2"`
	GasSupplySystem                      *float64 `json:"gas_supply_system"`
	DrumRotationSpeed                    *float64 `json:"drum_rotation_speed"`
	RotationSpeed                        *float64 `json:"rotation_speed"`
	SawBladeSpeed                        *float64 `json:"saw_blade_speed"`
	SpindleSpeed                         *float64 `json:"spindle_speed"`
	BeltSpeed                            *float64 `json:"belt_speed"`
	Speed                                *float64 `json:"speed"`
	LiftingSpeed                         *float64 `json:"lifting_speed"`
	CuttingSpeed                         *float64 `json:"cutting_speed"`
	TemperatureRange                     *float64 `json:"temperature_range"`
	BatteryType                          *float64 `json:"battery_type"`
	DisplayType                          *float64 `json:"display_type"`
	StartType                            *float64 `json:"start_type"`
	MeasurementType                      *float64 `json:"measurement_type"`
	TypeOfGasUsed                        *float64 `json:"type_of_gas_used"`
	TypeOfSawsUsed                       *float64 `json:"type_of_saws_used"`
	TypeOfCableBender                    *float64 `json:"type_of_cable_bender"`
	TypeOfCableCutter                    *float64 `json:"type_of_cable_cutter"`
	TypeOfRope                           *float64 `json:"type_of_rope"`
	CraneType                            *float64 `json:"crane_type"`
	TypeOfTape                           *float64 `json:"type_of_tape"`
	PumpType                             *float64 `json:"pump_type"`
	HammerType                           *float64 `json:"hammer_type"`
	SolderingElementType                 *float64 `json:"soldering_element_type"`
	PowerSupplyType                      *float64 `json:"power_supply_type"`
	DrillType                            *float64 `json:"drill_type"`
	PlatformType                         *float64 `json:"platform_type"`
	BearingType                          *float64 `json:"bearing_type"`
	ElevatorType                         *float64 `json:"elevator_type"`
	DriveType                            *float64 `json:"drive_type"`
	CuttingMechanismType                 *float64 `json:"cutting_mechanism_type"`
	WeldingType                          *float64 `json:"welding_type"`
	TypeOfWeldingMachine                 *float64 `json:"type_of_welding_machine"`
	TypeOfControlSystem                  *float64 `json:"type_of_control_system"`
	FuelType                             *float64 `json:"fuel_type"`
	CableType                            *float64 `json:"cable_type"`
	PipeBenderType                       *float64 `json:"pipe_bender_type"`
	PipeCutterType                       *float64 `json:"pipe_cutter_type"`
	ControlType                          *float64 `json:"control_type"`
	FilterType                           *float64 `json:"filter_type"`
	WeldingCurrent                       *float64 `json:"welding_current"`
	CuttingThickness                     *float64 `json:"cutting_thickness"`
	MeasuringAccuracy                    *float64 `json:"measuring_accuracy"`
	CuttingAccuracy                      *float64 `json:"cutting_accuracy"`
	SawBladeTiltAngle                    *float64 `json:"saw_blade_tilt_angle"`
	TableTiltAngle                       *float64 `json:"table_tilt_angle"`
	PressingForce                        *float64 `json:"pressing_force"`
	TravelLength                         *float64 `json:"travel_length"`
	SawStroke                            *float64 `json:"saw_stroke"`
	StrokeOfThePress                     *float64 `json:"stroke_of_the_press"`
	StrokeFrequency                      *float64 `json:"stroke_frequency"`
	NumberOfRevolutions                  *float64 `json:"number_of_revolutions"`
	NumberOfSawStrokesPerMinute          *float64 `json:"number_of_saw_strokes_per_minute"`
	Width                                *float64 `json:"width"`
	BeltWidth                            *float64 `json:"belt_width"`
	WorkingWidth                         *float64 `json:"working_width"`
}

type AdServiceParams struct {
	AdServiceID                          int      `json:"ad_service_id"`
	Weight                               *float64 `json:"weight"`
	Reach                                *float64 `json:"reach"`
	Height                               *float64 `json:"height"`
	LiftingHeight                        *float64 `json:"lifting_height"`
	WorkingDepth                         *float64 `json:"working_depth"`
	CuttingDepth                         *float64 `json:"cutting_depth"`
	LoadCapacityKg                       *float64 `json:"load_capacity_kg"`
	LoadCapacityT                        *float64 `json:"load_capacity_t"`
	BendingDiameter                      *float64 `json:"bending_diameter"`
	MachiningDiameter                    *float64 `json:"machining_diameter"`
	ChuckDiameter                        *float64 `json:"chuck_diameter"`
	SawBladeDiameter                     *float64 `json:"saw_blade_diameter"`
	CuttingDiameter                      *float64 `json:"cutting_diameter"`
	DrillingDiameter                     *float64 `json:"drilling_diameter"`
	PipeDiameter                         *float64 `json:"pipe_diameter"`
	AngleMeasuringRange                  *float64 `json:"angle_measuring_range"`
	HoseLength                           *float64 `json:"hose_length"`
	HoseDiameter                         *float64 `json:"hose_diameter"`
	MeasuringLength                      *float64 `json:"measuring_length"`
	SawBandLength                        *float64 `json:"saw_band_length"`
	SawBandWidth                         *float64 `json:"saw_band_width"`
	RopeLength                           *float64 `json:"rope_length"`
	Length                               *float64 `json:"length"`
	WorkingLength                        *float64 `json:"working_length"`
	CuttingLength                        *float64 `json:"cutting_length"`
	HandleLength                         *float64 `json:"handle_length"`
	CableLength                          *float64 `json:"cable_length"`
	OilTankCapacity                      *float64 `json:"oil_tank_capacity"`
	FuelTankCapacity                     *float64 `json:"fuel_tank_capacity"`
	NumberTools                          *float64 `json:"number_tools"`
	TypeOfTools                          *float64 `json:"type_of_tools"`
	NumberOfAxles                        *float64 `json:"number_of_axles"`
	NumberOfFlasks                       *float64 `json:"number_of_flasks"`
	MaxWorkpieceHeight                   *float64 `json:"max_workpiece_height"`
	MaximumLiftingHeight                 *float64 `json:"maximum_lifting_height"`
	MaximumCuttingDepthInWood            *float64 `json:"maximum_cutting_depth_in_wood"`
	MaximumCuttingDepthInMetal           *float64 `json:"maximum_cutting_depth_in_metal"`
	MaximumCuttingDepthInPlastic         *float64 `json:"maximum_cutting_depth_in_plastic"`
	MaximumCuttingDepth                  *float64 `json:"maximum_cutting_depth"`
	MaximumCuttingDepthAt90              *float64 `json:"maximum_cutting_depth_at90"`
	MaximumCuttingDepthAtAngularPosition *float64 `json:"maximum_cutting_depth_at_angular_position"`
	MaximumWheelWeight                   *float64 `json:"maximum_wheel_weight"`
	MaximumPowerW                        *float64 `json:"maximum_power_w"`
	MaximumPowerKw                       *float64 `json:"maximum_power_kw"`
	MaximumLoad                          *float64 `json:"maximum_load"`
	MaximumLiftingSpeed                  *float64 `json:"maximum_lifting_speed"`
	MaximumMaterialThickness             *float64 `json:"maximum_material_thickness"`
	MaximumCuttingWidth                  *float64 `json:"maximum_cutting_width"`
	MaximumForce                         *float64 `json:"maximum_force"`
	MaximumWheelDiameter                 *float64 `json:"maximum_wheel_diameter"`
	MaximumDiameterOfSelfDrillingScrew   *float64 `json:"maximum_diameter_of_self_drilling_screw"`
	MaximumDrillingDiameterInWood        *float64 `json:"maximum_drilling_diameter_in_wood"`
	MaximumDrillingDiameterInMetal       *float64 `json:"maximum_drilling_diameter_in_metal"`
	TubeMaterial                         *float64 `json:"tube_material"`
	BandLockingMechanism                 *float64 `json:"band_locking_mechanism"`
	PowerW                               *float64 `json:"power_w"`
	BurnerPower                          *float64 `json:"burner_power"`
	MotorPower                           *float64 `json:"motor_power"`
	PowerKw                              *float64 `json:"power_kw"`
	DrivePower                           *float64 `json:"drive_power"`
	SpindlePower                         *float64 `json:"spindle_power"`
	Voltage                              *float64 `json:"voltage"`
	Frequency                            *float64 `json:"frequency"`
	RatedFrequency                       *float64 `json:"rated_frequency"`
	RatedVoltage                         *float64 `json:"rated_voltage"`
	RatedCurrent                         *float64 `json:"rated_current"`
	DrumVolume                           *float64 `json:"drum_volume"`
	CapacityKgh                          *float64 `json:"capacity_kgh"`
	CapacityKw                           *float64 `json:"capacity_kw"`
	CapacityLitersHour                   *float64 `json:"capacity_liters_hour"`
	CapacityTh                           *float64 `json:"capacity_th"`
	WorkingPressure                      *float64 `json:"working_pressure"`
	GasWorkingPressure                   *float64 `json:"gas_working_pressure"`
	TableWorkingSize                     *float64 `json:"table_working_size"`
	BendingRadiusM                       *float64 `json:"bending_radius_m"`
	BendingRadiusMm                      *float64 `json:"bending_radius_mm"`
	TableDimensionsMm                    *float64 `json:"table_dimensions_mm"`
	TableDimensionsMm2                   *float64 `json:"table_dimensions_mm2"`
	GasSupplySystem                      *float64 `json:"gas_supply_system"`
	DrumRotationSpeed                    *float64 `json:"drum_rotation_speed"`
	RotationSpeed                        *float64 `json:"rotation_speed"`
	SawBladeSpeed                        *float64 `json:"saw_blade_speed"`
	SpindleSpeed                         *float64 `json:"spindle_speed"`
	BeltSpeed                            *float64 `json:"belt_speed"`
	Speed                                *float64 `json:"speed"`
	LiftingSpeed                         *float64 `json:"lifting_speed"`
	CuttingSpeed                         *float64 `json:"cutting_speed"`
	TemperatureRange                     *float64 `json:"temperature_range"`
	BatteryType                          *float64 `json:"battery_type"`
	DisplayType                          *float64 `json:"display_type"`
	StartType                            *float64 `json:"start_type"`
	MeasurementType                      *float64 `json:"measurement_type"`
	TypeOfGasUsed                        *float64 `json:"type_of_gas_used"`
	TypeOfSawsUsed                       *float64 `json:"type_of_saws_used"`
	TypeOfCableBender                    *float64 `json:"type_of_cable_bender"`
	TypeOfCableCutter                    *float64 `json:"type_of_cable_cutter"`
	TypeOfRope                           *float64 `json:"type_of_rope"`
	CraneType                            *float64 `json:"crane_type"`
	TypeOfTape                           *float64 `json:"type_of_tape"`
	PumpType                             *float64 `json:"pump_type"`
	HammerType                           *float64 `json:"hammer_type"`
	SolderingElementType                 *float64 `json:"soldering_element_type"`
	PowerSupplyType                      *float64 `json:"power_supply_type"`
	DrillType                            *float64 `json:"drill_type"`
	PlatformType                         *float64 `json:"platform_type"`
	BearingType                          *float64 `json:"bearing_type"`
	ElevatorType                         *float64 `json:"elevator_type"`
	DriveType                            *float64 `json:"drive_type"`
	CuttingMechanismType                 *float64 `json:"cutting_mechanism_type"`
	WeldingType                          *float64 `json:"welding_type"`
	TypeOfWeldingMachine                 *float64 `json:"type_of_welding_machine"`
	TypeOfControlSystem                  *float64 `json:"type_of_control_system"`
	FuelType                             *float64 `json:"fuel_type"`
	CableType                            *float64 `json:"cable_type"`
	PipeBenderType                       *float64 `json:"pipe_bender_type"`
	PipeCutterType                       *float64 `json:"pipe_cutter_type"`
	ControlType                          *float64 `json:"control_type"`
	FilterType                           *float64 `json:"filter_type"`
	WeldingCurrent                       *float64 `json:"welding_current"`
	CuttingThickness                     *float64 `json:"cutting_thickness"`
	MeasuringAccuracy                    *float64 `json:"measuring_accuracy"`
	CuttingAccuracy                      *float64 `json:"cutting_accuracy"`
	SawBladeTiltAngle                    *float64 `json:"saw_blade_tilt_angle"`
	TableTiltAngle                       *float64 `json:"table_tilt_angle"`
	PressingForce                        *float64 `json:"pressing_force"`
	TravelLength                         *float64 `json:"travel_length"`
	SawStroke                            *float64 `json:"saw_stroke"`
	StrokeOfThePress                     *float64 `json:"stroke_of_the_press"`
	StrokeFrequency                      *float64 `json:"stroke_frequency"`
	NumberOfRevolutions                  *float64 `json:"number_of_revolutions"`
	NumberOfSawStrokesPerMinute          *float64 `json:"number_of_saw_strokes_per_minute"`
	Width                                *float64 `json:"width"`
	BeltWidth                            *float64 `json:"belt_width"`
	WorkingWidth                         *float64 `json:"working_width"`
}

type FilterParam struct {
	ID     []int
	Limit  *int
	Offset *int
}

type ParamMinMax struct {
	Min   *float64
	Max   *float64
	Valid bool
}

func Parse(data string) (ParamMinMax, error) {
	p := ParamMinMax{}

	re, err := regexp.Compile(`\A(?P<min>[0-9]+|[0-9]+.{1}[0-9]+|\*)-(?P<max>[0-9]+|[0-9]+.{1}[0-9]+|\*)\z`)
	if err != nil {
		return p, err
	}

	res := re.FindAllStringSubmatch(data, -1)

	if len(res) == 0 {
		return p, errors.New("not compile")
	}

	for _, v := range res {
		for kk, vv := range re.SubexpNames() {
			if vv == "min" {
				if v[kk] == "*" {
				} else {
					n, err := strconv.ParseFloat(v[kk], 64)
					if err != nil {
						return p, fmt.Errorf("parse min: %w", err)
					}
					p.Min = &n
				}
			}
			if vv == "max" {
				if v[kk] == "*" {
				} else {
					n, err := strconv.ParseFloat(v[kk], 64)
					if err != nil {
						return p, fmt.Errorf("parse max: %w", err)
					}
					p.Max = &n
				}
			}
		}
	}

	if p.Max != nil && p.Min == nil {
		var n float64
		p.Min = &n
	}

	p.Valid = true

	return p, nil
}
