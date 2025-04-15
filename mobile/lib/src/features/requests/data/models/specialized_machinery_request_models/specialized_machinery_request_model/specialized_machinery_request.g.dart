// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'specialized_machinery_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpecializedMachineryRequestImpl _$$SpecializedMachineryRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$SpecializedMachineryRequestImpl(
      id: (json['id'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'],
      userId: (json['user_id'] as num?)?.toInt(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      adSpecializedMachineryId:
          (json['ad_specialized_machinery_id'] as num?)?.toInt(),
      adSpecializedMachinery: json['ad_specialized_machinery'] == null
          ? null
          : AdSpecializedMachinery.fromJson(
              json['ad_specialized_machinery'] as Map<String, dynamic>),
      startLeaseAt: json['start_lease_at'] == null
          ? null
          : DateTime.parse(json['start_lease_at'] as String),
      endLeaseAt: json['end_lease_at'] == null
          ? null
          : DateTime.parse(json['end_lease_at'] as String),
      countHour: (json['count_hour'] as num?)?.toInt(),
      address: json['address'] as String?,
      orderAmount: (json['order_amount'] as num?)?.toDouble(),
      description: json['description'] as String?,
      status: json['status'] as String?,
      urlFoto: (json['url_foto'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$SpecializedMachineryRequestImplToJson(
        _$SpecializedMachineryRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt,
      'user_id': instance.userId,
      'user': instance.user,
      'ad_specialized_machinery_id': instance.adSpecializedMachineryId,
      'ad_specialized_machinery': instance.adSpecializedMachinery,
      'start_lease_at': instance.startLeaseAt?.toIso8601String(),
      'end_lease_at': instance.endLeaseAt?.toIso8601String(),
      'count_hour': instance.countHour,
      'address': instance.address,
      'order_amount': instance.orderAmount,
      'description': instance.description,
      'status': instance.status,
      'url_foto': instance.urlFoto,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
