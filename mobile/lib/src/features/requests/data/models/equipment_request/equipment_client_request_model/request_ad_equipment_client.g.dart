// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_ad_equipment_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RequestAdEquipmentClientImpl _$$RequestAdEquipmentClientImplFromJson(
        Map<String, dynamic> json) =>
    _$RequestAdEquipmentClientImpl(
      id: (json['id'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'],
      adEquipmentClientId: (json['ad_equipment_client_id'] as num?)?.toInt(),
      adEquipmentClient: json['ad_equipment_client'] == null
          ? null
          : AdEquipmentClient.fromJson(
              json['ad_equipment_client'] as Map<String, dynamic>),
      userId: (json['user_id'] as num?)?.toInt(),
      executorId: (json['executor_id'] as num?)?.toInt(),
      executor: json['executor'] == null
          ? null
          : User.fromJson(json['executor'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      status: json['status'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$RequestAdEquipmentClientImplToJson(
        _$RequestAdEquipmentClientImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt,
      'ad_equipment_client_id': instance.adEquipmentClientId,
      'ad_equipment_client': instance.adEquipmentClient,
      'user_id': instance.userId,
      'executor_id': instance.executorId,
      'executor': instance.executor,
      'user': instance.user,
      'status': instance.status,
      'description': instance.description,
    };
