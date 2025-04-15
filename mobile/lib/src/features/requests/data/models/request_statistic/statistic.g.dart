// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistic.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StatisticImpl _$$StatisticImplFromJson(Map<String, dynamic> json) =>
    _$StatisticImpl(
      awaitsStart: (json['awaits_start'] as num?)?.toInt(),
      working: (json['working'] as num?)?.toInt(),
      pause: (json['pause'] as num?)?.toInt(),
      finished: (json['finished'] as num?)?.toInt(),
      onRoad: (json['on_road'] as num?)?.toInt(),
      totalWork: (json['total_work'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$StatisticImplToJson(_$StatisticImpl instance) =>
    <String, dynamic>{
      'awaits_start': instance.awaitsStart,
      'working': instance.working,
      'pause': instance.pause,
      'finished': instance.finished,
      'on_road': instance.onRoad,
      'total_work': instance.totalWork,
      'total': instance.total,
    };
