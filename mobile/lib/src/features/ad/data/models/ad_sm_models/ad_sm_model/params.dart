import 'package:freezed_annotation/freezed_annotation.dart';

part 'params.freezed.dart';
part 'params.g.dart';

@freezed
class Params with _$Params {
  factory Params({
    @JsonKey(name: 'ad_specialized_machinery_id') int? adSpecializedMachineryId,
    @JsonKey(name: 'body_height') double? bodyHeight,
    @JsonKey(name: 'lift_height') double? liftHeight,
    @JsonKey(name: 'blade_cutting_depth') double? bladeCuttingDepth,
    @JsonKey(name: 'fence_depth') double? fenceDepth,
    @JsonKey(name: 'grip_depth') double? gripDepth,
    @JsonKey(name: 'digging_depth') double? diggingDepth,
    @JsonKey(name: 'load_capacity') double? loadCapacity,
    @JsonKey(name: 'air_pressure') double? airPressure,
    @JsonKey(name: 'drilling_diameter') double? drillingDiameter,
    @JsonKey(name: 'roller_diameter') double? rollerDiameter,
    @JsonKey(name: 'body_length') double? bodyLength,
    @JsonKey(name: 'platform_length') double? platformLength,
    @JsonKey(name: 'boom_length') double? boomLength,
    @JsonKey(name: 'ground_clearance') double? groundClearance,
    @JsonKey(name: 'fuel_tank_capacity') double? fuelTankCapacity,
    @JsonKey(name: 'number_of_rollers') double? numberOfRollers,
    @JsonKey(name: 'number_of_axles') double? numberOfAxles,
    @JsonKey(name: 'maximum_drilling_depth') double? maximumDrillingDepth,
    @JsonKey(name: 'maximum_towable_trailer_mass')
    double? maximumTowableTrailerMass,
    @JsonKey(name: 'engine_power') double? enginePower,
    double? voltage,
    @JsonKey(name: 'water_tank_volume') double? waterTankVolume,
    @JsonKey(name: 'bucket_volume') double? bucketVolume,
    @JsonKey(name: 'body_volume') double? bodyVolume,
    @JsonKey(name: 'tank_volume') double? tankVolume,
    @JsonKey(name: 'operating_pressure') double? operatingPressure,
    @JsonKey(name: 'unloading_radius') double? unloadingRadius,
    @JsonKey(name: 'turning_radius') double? turningRadius,
    @JsonKey(name: 'refrigerator_temperature_min')
    double? refrigeratorTemperatureMin,
    @JsonKey(name: 'refrigerator_temperature_max')
    double? refrigeratorTemperatureMax,
    @JsonKey(name: 'temperature_range') double? temperatureRange,
    @JsonKey(name: 'roller_type') double? rollerType,
    @JsonKey(name: 'body_type') double? bodyType,
    @JsonKey(name: 'pump_type') double? pumpType,
    @JsonKey(name: 'platform_type') double? platformType,
    @JsonKey(name: 'welding_source_type') double? weldingSourceType,
    @JsonKey(name: 'undercarriage_type') double? undercarriageType,
    @JsonKey(name: 'blade_tilt_angle') double? bladeTiltAngle,
    double? frequency,
    @JsonKey(name: 'roller_width') double? rollerWidth,
    @JsonKey(name: 'grip_width') double? gripWidth,
    @JsonKey(name: 'digging_width') double? diggingWidth,
    @JsonKey(name: 'body_width') double? bodyWidth,
    @JsonKey(name: 'platform_width') double? platformWidth,
    @JsonKey(name: 'unloading_gap_width') double? unloadingGapWidth,
    @JsonKey(name: 'laying_width') double? layingWidth,
    @JsonKey(name: 'milling_width') double? millingWidth,
  }) = _Params;

  factory Params.fromJson(Map<String, dynamic> json) => _$ParamsFromJson(json);
}
