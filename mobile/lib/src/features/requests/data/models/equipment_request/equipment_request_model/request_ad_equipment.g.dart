// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_ad_equipment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RequestAdEquipmentImpl _$$RequestAdEquipmentImplFromJson(
        Map<String, dynamic> json) =>
    _$RequestAdEquipmentImpl(
      id: (json['id'] as num).toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      status: json['status'] as String?,
      userId: (json['user_id'] as num?)?.toInt(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      executorId: (json['executor_id'] as num?)?.toInt(),
      executor: json['executor'] == null
          ? null
          : User.fromJson(json['executor'] as Map<String, dynamic>),
      adEquipmentId: (json['ad_equipment_id'] as num?)?.toInt(),
      adEquipment: json['ad_equipment'] == null
          ? null
          : AdEquipment.fromJson(json['ad_equipment'] as Map<String, dynamic>),
      startLeaseAt: json['start_lease_at'] as String?,
      endLeaseAt: json['end_lease_at'] as String?,
      countHour: json['count_hour'],
      orderAmount: json['order_amount'],
      subCategory: json['equipment_sub_category'] == null
          ? null
          : SubCategory.fromJson(
              json['equipment_sub_category'] as Map<String, dynamic>),
      description: json['description'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
      title: json['title'] as String?,
      city: json['city'] == null
          ? null
          : City.fromJson(json['city'] as Map<String, dynamic>),
      urlFoto: (json['url_foto'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$RequestAdEquipmentImplToJson(
        _$RequestAdEquipmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'status': instance.status,
      'user_id': instance.userId,
      'user': instance.user,
      'executor_id': instance.executorId,
      'executor': instance.executor,
      'ad_equipment_id': instance.adEquipmentId,
      'ad_equipment': instance.adEquipment,
      'start_lease_at': instance.startLeaseAt,
      'end_lease_at': instance.endLeaseAt,
      'count_hour': instance.countHour,
      'order_amount': instance.orderAmount,
      'equipment_sub_category': instance.subCategory,
      'description': instance.description,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'price': instance.price,
      'title': instance.title,
      'city': instance.city,
      'url_foto': instance.urlFoto,
    };
