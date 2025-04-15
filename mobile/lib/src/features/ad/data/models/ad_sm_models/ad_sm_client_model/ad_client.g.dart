// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdClientImpl _$$AdClientImplFromJson(Map<String, dynamic> json) =>
    _$AdClientImpl(
      id: (json['id'] as num).toInt(),
      description: json['description'] as String?,
      headline: json['headline'] as String,
      price: (json['price'] as num?)?.toDouble(),
      typeId: (json['type_id'] as num?)?.toInt(),
      type: json['type'] == null
          ? null
          : SubCategory.fromJson(json['type'] as Map<String, dynamic>),
      documents: (json['documents'] as List<dynamic>?)
          ?.map((e) => Document.fromJson(e as Map<String, dynamic>))
          .toList(),
      startDate: json['start_date'] as String?,
      endDate: json['end_date'],
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      urlThumbnail: (json['url_thumbnail'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      address: json['address'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      status: json['status'] as String?,
      city: json['city'] == null
          ? null
          : City.fromJson(json['city'] as Map<String, dynamic>),
      cityId: (json['city_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$AdClientImplToJson(_$AdClientImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'headline': instance.headline,
      'price': instance.price,
      'type_id': instance.typeId,
      'type': instance.type,
      'documents': instance.documents,
      'start_date': instance.startDate,
      'end_date': instance.endDate,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'url_thumbnail': instance.urlThumbnail,
      'user': instance.user,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'status': instance.status,
      'city': instance.city,
      'city_id': instance.cityId,
    };
