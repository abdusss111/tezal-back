// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_constrution_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdConstrutionModelImpl _$$AdConstrutionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AdConstrutionModelImpl(
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
      constructionMaterialBrandId:
          (json['construction_material_brand_id'] as num?)?.toInt(),
      constructionMaterialBrand: json['construction_material_brand'] == null
          ? null
          : Brand.fromJson(
              json['construction_material_brand'] as Map<String, dynamic>),
      constructionMaterialSubCategory: SubCategory.getSubCategoryForCM(
          json['construction_material_sub_category'] as Map<String, dynamic>),
      constructionMaterialSubCategoryID:
          (json['construction_material_sub_category_id'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toInt(),
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
      params: json['params'] as Map<String, dynamic>?,
      document: json['document'] as List<dynamic>?,
      countRate: (json['countRate'] as num?)?.toDouble(),
      urlFoto: (json['url_foto'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      urlThumbnail: (json['url_thumbnail'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$AdConstrutionModelImplToJson(
        _$AdConstrutionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt,
      'user_id': instance.userId,
      'user': instance.user,
      'city_id': instance.cityId,
      'city': instance.city,
      'construction_material_brand_id': instance.constructionMaterialBrandId,
      'construction_material_brand': instance.constructionMaterialBrand,
      'construction_material_sub_category':
          instance.constructionMaterialSubCategory,
      'construction_material_sub_category_id':
          instance.constructionMaterialSubCategoryID,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'rating': instance.rating,
      'params': instance.params,
      'document': instance.document,
      'countRate': instance.countRate,
      'url_foto': instance.urlFoto,
      'url_thumbnail': instance.urlThumbnail,
    };
