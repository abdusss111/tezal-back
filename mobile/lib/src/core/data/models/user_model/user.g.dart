// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: (json['id'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'],
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      nickName: json['nick_name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      accessRole: json['access_role'] as String?,
      cityId: (json['city_id'] as num?)?.toInt(),
      birthDate: json['birth_date'] as String?,
      iin: json['iin'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      city: json['city'] == null
          ? null
          : City.fromJson(json['city'] as Map<String, dynamic>),
      canDriver: json['can_driver'] as bool?,
      ownerId: json['owner_id'],
      owner: json['owner'],
      canOwner: json['can_owner'] as bool?,
      urlImage: json['url_document'] as String?,
      customUrlImage: json['custom_url_document'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      email: json['email'] as String?,
      isLocationEnabled: json['is_location_enabled'] as bool?,
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'deleted_at': instance.deletedAt,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'nick_name': instance.nickName,
      'phone_number': instance.phoneNumber,
      'access_role': instance.accessRole,
      'city_id': instance.cityId,
      'birth_date': instance.birthDate,
      'iin': instance.iin,
      'rating': instance.rating,
      'city': instance.city,
      'can_driver': instance.canDriver,
      'owner_id': instance.ownerId,
      'owner': instance.owner,
      'can_owner': instance.canOwner,
      'url_document': instance.urlImage,
      'custom_url_document': instance.customUrlImage,
      'avatar_url': instance.avatarUrl,
      'email': instance.email,
      'is_location_enabled': instance.isLocationEnabled,
    };
