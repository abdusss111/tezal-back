// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StatisticImpl _$$StatisticImplFromJson(Map<String, dynamic> json) =>
    _$StatisticImpl(
      id: (json['id'] as num?)?.toInt(),
      status: json['status'] as String?,
      startStatusAt: json['start_status_at'] == null
          ? null
          : DateTime.parse(json['start_status_at'] as String),
      endStatusAt: json['end_status_at'] == null
          ? null
          : DateTime.parse(json['end_status_at'] as String),
      duration: (json['duration'] as num?)?.toInt(),
      workStartedAt: json['work_started_at'],
      workEndAt: json['work_end_at'],
      rate: (json['rate'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$StatisticImplToJson(_$StatisticImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
      'start_status_at': instance.startStatusAt?.toIso8601String(),
      'end_status_at': instance.endStatusAt?.toIso8601String(),
      'duration': instance.duration,
      'work_started_at': instance.workStartedAt,
      'work_end_at': instance.workEndAt,
      'rate': instance.rate,
    };
