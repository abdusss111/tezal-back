// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_construction_client_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdConstructionClientModelImpl _$$AdConstructionClientModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AdConstructionClientModelImpl(
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
      constructionMaterialSubCategoryId:
          (json['construction_material_sub_category_id'] as num?)?.toInt(),
      constructionMaterialBrand: json['construction_material_brand'] == null
          ? null
          : Brand.fromJson(
              json['construction_material_brand'] as Map<String, dynamic>),
      constructionMaterialSubCategory: SubCategory.getSubCategoryForCM(
          json['construction_material_sub_category'] as Map<String, dynamic>),
      title: json['title'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toInt(),
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      status: json['status'] as String?,
      startLeaseDate: json['start_lease_date'] == null
          ? null
          : DateTime.parse(json['start_lease_date'] as String),
      endLeaseDate: json['end_lease_date'] == null
          ? null
          : DateTime.parse(json['end_lease_date'] as String),
      urlFoto: (json['url_foto'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      urlThumbnail: (json['url_thumbnail'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      document: (json['document'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$$AdConstructionClientModelImplToJson(
        _$AdConstructionClientModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt,
      'user_id': instance.userId,
      'user': instance.user,
      'city_id': instance.cityId,
      'city': instance.city,
      'construction_material_sub_category_id':
          instance.constructionMaterialSubCategoryId,
      'construction_material_brand': instance.constructionMaterialBrand,
      'construction_material_sub_category':
          instance.constructionMaterialSubCategory,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'status': instance.status,
      'start_lease_date': instance.startLeaseDate?.toIso8601String(),
      'end_lease_date': instance.endLeaseDate?.toIso8601String(),
      'url_foto': instance.urlFoto,
      'url_thumbnail': instance.urlThumbnail,
      'document': instance.document,
    };
