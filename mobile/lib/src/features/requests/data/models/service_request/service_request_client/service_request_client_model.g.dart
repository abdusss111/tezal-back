// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_request_client_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ServiceRequestClientModelImpl _$$ServiceRequestClientModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ServiceRequestClientModelImpl(
      id: (json['id'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'],
      adClientID: (json['ad_service_client_id'] as num?)?.toInt(),
      adClient: json['ad_service_client'] == null
          ? null
          : AdServiceClientModel.fromJson(
              json['ad_service_client'] as Map<String, dynamic>),
      userId: json['user_id'],
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      executorId: (json['executor_id'] as num?)?.toInt(),
      executor: json['executor'] == null
          ? null
          : User.fromJson(json['executor'] as Map<String, dynamic>),
      description: json['description'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$$ServiceRequestClientModelImplToJson(
        _$ServiceRequestClientModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
      'ad_service_client_id': instance.adClientID,
      'ad_service_client': instance.adClient,
      'user_id': instance.userId,
      'user': instance.user,
      'executor_id': instance.executorId,
      'executor': instance.executor,
      'description': instance.description,
      'status': instance.status,
    };
