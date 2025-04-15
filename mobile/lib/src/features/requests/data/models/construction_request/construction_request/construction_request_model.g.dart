// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'construction_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ConstructionRequestModelImpl _$$ConstructionRequestModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ConstructionRequestModelImpl(
      id: (json['id'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'],
      adConstructionMaterialId:
          (json['ad_construction_material_id'] as num?)?.toInt(),
      adConstructionModel: json['ad_construction_material'] == null
          ? null
          : AdConstrutionModel.fromJson(
              json['ad_construction_material'] as Map<String, dynamic>),
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
      startLeaseAt: json['start_lease_at'] as String?,
      endLeaseAt: json['end_lease_at'] as String?,
      countHour: (json['count_hour'] as num?)?.toInt(),
      latitude: (json['latitude'] as num?)?.toInt(),
      longitude: (json['longitude'] as num?)?.toInt(),
      orderAmount: (json['order_amount'] as num?)?.toInt(),
      address: json['address'] as String?,
      imagesUrl: (json['url_foto'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$ConstructionRequestModelImplToJson(
        _$ConstructionRequestModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
      'ad_construction_material_id': instance.adConstructionMaterialId,
      'ad_construction_material': instance.adConstructionModel,
      'user_id': instance.userId,
      'user': instance.user,
      'executor_id': instance.executorId,
      'executor': instance.executorUser,
      'description': instance.description,
      'status': instance.status,
      'start_lease_at': instance.startLeaseAt,
      'end_lease_at': instance.endLeaseAt,
      'count_hour': instance.countHour,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'order_amount': instance.orderAmount,
      'address': instance.address,
      'url_foto': instance.imagesUrl,
    };
