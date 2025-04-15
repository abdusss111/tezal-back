// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'construction_request_client_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConstructionRequestClientModelImpl
    _$$ConstructionRequestClientModelImplFromJson(Map<String, dynamic> json) =>
        _$ConstructionRequestClientModelImpl(
          id: (json['id'] as num?)?.toInt(),
          createdAt: json['created_at'] as String?,
          updatedAt: json['updated_at'] as String?,
          deletedAt: json['deleted_at'],
          adConstructionMaterialClientId:
              (json['ad_construction_material_client_id'] as num?)?.toInt(),
          adConstructionClientModel:
              json['ad_construction_material_client'] == null
                  ? null
                  : AdConstructionClientModel.fromJson(
                      json['ad_construction_material_client']
                          as Map<String, dynamic>),
          userId: json['user_id'],
          user: json['user'] == null
              ? null
              : User.fromJson(json['user'] as Map<String, dynamic>),
          executorId: (json['executor_id'] as num?)?.toInt(),
          executorUser: json['executor'] == null
              ? null
              : User.fromJson(json['executor'] as Map<String, dynamic>),
          description: json['description'] as String?,
          status: json['status'] as String?,
        );

Map<String, dynamic> _$$ConstructionRequestClientModelImplToJson(
        _$ConstructionRequestClientModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
      'ad_construction_material_client_id':
          instance.adConstructionMaterialClientId,
      'ad_construction_material_client': instance.adConstructionClientModel,
      'user_id': instance.userId,
      'user': instance.user,
      'executor_id': instance.executorId,
      'executor': instance.executorUser,
      'description': instance.description,
      'status': instance.status,
    };
