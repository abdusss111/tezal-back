// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_service_client_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdServiceClientModelImpl _$$AdServiceClientModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AdServiceClientModelImpl(
      id: (json['id'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      userID: (json['user_id'] as num?)?.toInt(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      status: json['status'] as String?,
      subCategoryID: (json['service_sub_category_id'] as num?)?.toInt(),
      subcategory: SubCategory.getSubCategoryForSVM(
          json['service_sub_category'] as Map<String, dynamic>),
      cityId: (json['city_id'] as num?)?.toInt(),
      city: json['city'] == null
          ? null
          : City.fromJson(json['city'] as Map<String, dynamic>),
      price: (json['price'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      document: json['document'] as List<dynamic>?,
      startLeaseDate: json['start_lease_date'] as String?,
      endLeaseDate: json['end_lease_date'] as String?,
      urlFoto: (json['url_foto'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      urlThumbnail: (json['url_thumbnail'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      countRate: (json['count_rate'] as num?)?.toDouble(),
      rating: (json['rating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$AdServiceClientModelImplToJson(
        _$AdServiceClientModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'deleted_at': instance.deletedAt,
      'user_id': instance.userID,
      'user': instance.user,
      'status': instance.status,
      'service_sub_category_id': instance.subCategoryID,
      'service_sub_category': instance.subcategory,
      'city_id': instance.cityId,
      'city': instance.city,
      'price': instance.price,
      'title': instance.title,
      'description': instance.description,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'document': instance.document,
      'start_lease_date': instance.startLeaseDate,
      'end_lease_date': instance.endLeaseDate,
      'url_foto': instance.urlFoto,
      'url_thumbnail': instance.urlThumbnail,
      'count_rate': instance.countRate,
      'rating': instance.rating,
    };
