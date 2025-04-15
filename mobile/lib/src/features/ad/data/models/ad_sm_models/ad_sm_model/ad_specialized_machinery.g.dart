// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_specialized_machinery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdSpecializedMachineryImpl _$$AdSpecializedMachineryImplFromJson(
        Map<String, dynamic> json) =>
    _$AdSpecializedMachineryImpl(
      id: (json['id'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      userId: (json['user_id'] as num?)?.toInt(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      brandId: (json['brand_id'] as num?)?.toInt(),
      brand: json['brand'] == null
          ? null
          : Brand.fromJson(json['brand'] as Map<String, dynamic>),
      typeId: (json['type_id'] as num?)?.toInt(),
      type: json['type'] == null
          ? null
          : SubCategory.fromJson(json['type'] as Map<String, dynamic>),
      cityId: (json['city_id'] as num?)?.toInt(),
      city: json['city'] == null
          ? null
          : City.fromJson(json['city'] as Map<String, dynamic>),
      price: (json['price'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      countRate: (json['count_rate'] as num?)?.toInt(),
      rating: (json['rating'] as num?)?.toDouble(),
      urlFoto: (json['url_foto'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      urlThumbnail: (json['url_thumbnail'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      params: json['params'] == null
          ? null
          : Params.fromJson(json['params'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$AdSpecializedMachineryImplToJson(
        _$AdSpecializedMachineryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'user_id': instance.userId,
      'user': instance.user,
      'brand_id': instance.brandId,
      'brand': instance.brand,
      'type_id': instance.typeId,
      'type': instance.type,
      'city_id': instance.cityId,
      'city': instance.city,
      'price': instance.price,
      'name': instance.name,
      'description': instance.description,
      'count_rate': instance.countRate,
      'rating': instance.rating,
      'url_foto': instance.urlFoto,
      'url_thumbnail': instance.urlThumbnail,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'params': instance.params,
    };
