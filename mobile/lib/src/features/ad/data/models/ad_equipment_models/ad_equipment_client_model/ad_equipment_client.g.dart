// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_equipment_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdEquipmentClientImpl _$$AdEquipmentClientImplFromJson(
        Map<String, dynamic> json) =>
    _$AdEquipmentClientImpl(
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
      cityId: (json['city_id'] as num?)?.toInt(),
      city: json['city'] == null
          ? null
          : City.fromJson(json['city'] as Map<String, dynamic>),
      equipmentSubcategoryId:
          (json['equipment_sub_category_id'] as num?)?.toInt(),
      equipmentSubcategory: SubCategory.getSubCategoryForEQ(
          json['equipment_sub_category'] as Map<String, dynamic>),
      status: json['status'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      startLeaseDate: json['start_lease_date'] as String?,
      endLeaseDate: json['end_lease_date'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      document: (json['document'] as List<dynamic>?)
          ?.map((e) => Document.fromJson(e as Map<String, dynamic>))
          .toList(),
      urlFoto: (json['url_foto'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      urlThumbnail: (json['url_thumbnail'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$AdEquipmentClientImplToJson(
        _$AdEquipmentClientImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt,
      'user_id': instance.userId,
      'user': instance.user,
      'city_id': instance.cityId,
      'city': instance.city,
      'equipment_sub_category_id': instance.equipmentSubcategoryId,
      'equipment_sub_category': instance.equipmentSubcategory,
      'status': instance.status,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'start_lease_date': instance.startLeaseDate,
      'end_lease_date': instance.endLeaseDate,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'document': instance.document,
      'url_foto': instance.urlFoto,
      'url_thumbnail': instance.urlThumbnail,
    };
