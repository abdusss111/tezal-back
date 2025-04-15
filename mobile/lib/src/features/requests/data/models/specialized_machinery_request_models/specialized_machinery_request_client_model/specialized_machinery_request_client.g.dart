// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialized_machinery_request_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpecializedMachineryRequestClientImpl
    _$$SpecializedMachineryRequestClientImplFromJson(
            Map<String, dynamic> json) =>
        _$SpecializedMachineryRequestClientImpl(
          id: (json['id'] as num?)?.toInt(),
          createdAt: json['created_at'] as String?,
          updatedAt: json['updated_at'] as String?,
          deletedAt: json['deleted_at'],
          adClientId: (json['ad_client_id'] as num?)?.toInt(),
          adSm: json['ad_client'] == null
              ? null
              : AdClient.fromJson(json['ad_client'] as Map<String, dynamic>),
          userId: json['user_id'],
          user: json['user'] == null
              ? null
              : User.fromJson(json['user'] as Map<String, dynamic>),
          assigned: (json['assigned'] as num?)?.toInt(),
          executorUser: json['user_assigned'] == null
              ? null
              : User.fromJson(json['user_assigned'] as Map<String, dynamic>),
          comment: json['comment'] as String?,
          status: json['status'] as String?,
        );

Map<String, dynamic> _$$SpecializedMachineryRequestClientImplToJson(
        _$SpecializedMachineryRequestClientImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
      'ad_client_id': instance.adClientId,
      'ad_client': instance.adSm,
      'user_id': instance.userId,
      'user': instance.user,
      'assigned': instance.assigned,
      'user_assigned': instance.executorUser,
      'comment': instance.comment,
      'status': instance.status,
    };
