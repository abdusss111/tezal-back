// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_client_interacted.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdClientInteractedImpl _$$AdClientInteractedImplFromJson(
        Map<String, dynamic> json) =>
    _$AdClientInteractedImpl(
      id: (json['id'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'],
      adClientId: (json['ad_client_id'] as num?)?.toInt(),
      userId: (json['user_id'] as num?)?.toInt(),
      userRating: (json['user_rating'] as num?)?.toInt(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AdClientInteractedImplToJson(
        _$AdClientInteractedImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt,
      'ad_client_id': instance.adClientId,
      'user_id': instance.userId,
      'user_rating': instance.userRating,
      'user': instance.user,
    };
