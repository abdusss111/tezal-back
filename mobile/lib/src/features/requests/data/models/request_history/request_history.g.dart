// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RequestHistoryImpl _$$RequestHistoryImplFromJson(Map<String, dynamic> json) =>
    _$RequestHistoryImpl(
      statistic: (json['statistic'] as List<dynamic>?)
          ?.map((e) => Statistic.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$RequestHistoryImplToJson(
        _$RequestHistoryImpl instance) =>
    <String, dynamic>{
      'statistic': instance.statistic,
    };
