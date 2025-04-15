// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_equipment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdEquipmentImpl _$$AdEquipmentImplFromJson(Map<String, dynamic> json) =>
    _$AdEquipmentImpl(
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
      subcategory: SubCategory.getSubCategoryForEQ(
          json['equipment_sub_category'] as Map<String, dynamic>),
      city: json['city'] == null
          ? null
          : City.fromJson(json['city'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      brand: json['equipment_brand'] == null
          ? null
          : Brand.fromJson(json['equipment_brand'] as Map<String, dynamic>),
      price: (json['price'] as num).toDouble(),
      title: json['title'] as String,
      description: json['description'] as String?,
      address: json['address'] as String,
      rating: (json['rating'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      urlFoto: (json['url_foto'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      urlThumbnail: (json['url_thumbnail'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      params: json['params'] as Map<String, dynamic>?,
      cityId: (json['city_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$AdEquipmentImplToJson(_$AdEquipmentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'equipment_sub_category': instance.subcategory,
      'city': instance.city,
      'user': instance.user,
      'equipment_brand': instance.brand,
      'price': instance.price,
      'title': instance.title,
      'description': instance.description,
      'address': instance.address,
      'rating': instance.rating,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'url_foto': instance.urlFoto,
      'url_thumbnail': instance.urlThumbnail,
      'params': instance.params,
      'city_id': instance.cityId,
    };
