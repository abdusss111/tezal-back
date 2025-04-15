// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_statistic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RequestStatisticImpl _$$RequestStatisticImplFromJson(
        Map<String, dynamic> json) =>
    _$RequestStatisticImpl(
      statistic: json['statistic'] == null
          ? null
          : Statistic.fromJson(json['statistic'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$RequestStatisticImplToJson(
        _$RequestStatisticImpl instance) =>
    <String, dynamic>{
      'statistic': instance.statistic,
    };
