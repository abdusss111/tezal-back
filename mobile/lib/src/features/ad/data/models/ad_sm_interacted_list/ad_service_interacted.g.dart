// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_service_interacted.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdServiceInteractedImpl _$$AdServiceInteractedImplFromJson(
        Map<String, dynamic> json) =>
    _$AdServiceInteractedImpl(
      id: (json['id'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'],
      adServiceId: (json['ad_service_id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AdServiceInteractedImplToJson(
        _$AdServiceInteractedImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt,
      'ad_service_id': instance.adServiceId,
      'user_id': instance.userId,
      'user': instance.user,
    };
