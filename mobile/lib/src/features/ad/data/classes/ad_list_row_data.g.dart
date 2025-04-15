// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_list_row_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdListRowDataImpl _$$AdListRowDataImplFromJson(Map<String, dynamic> json) =>
    _$AdListRowDataImpl(
      id: (json['id'] as num?)?.toInt(),
      city: json['city'] as String?,
      title: json['title'] as String?,
      createdAt: json['createdAt'] as String?,
      imageUrl: json['imageUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      imageUrls: (json['imageUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      thumbnailUrls: (json['thumbnailUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      address: json['address'] as String?,
      status: json['status'] as String?,
      isClientType: json['isClientType'] as bool?,
      category: json['category'] as String?,
      deletedAt: json['deletedAt'],
      price: (json['price'] as num?)?.toDouble(),
      allServiceTypeEnum: $enumDecodeNullable(
          _$AllServiceTypeEnumEnumMap, json['allServiceTypeEnum']),
      rating: (json['rating'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$AdListRowDataImplToJson(_$AdListRowDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'city': instance.city,
      'title': instance.title,
      'createdAt': instance.createdAt,
      'imageUrl': instance.imageUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'imageUrls': instance.imageUrls,
      'thumbnailUrls': instance.thumbnailUrls,
      'address': instance.address,
      'status': instance.status,
      'isClientType': instance.isClientType,
      'category': instance.category,
      'deletedAt': instance.deletedAt,
      'price': instance.price,
      'allServiceTypeEnum':
          _$AllServiceTypeEnumEnumMap[instance.allServiceTypeEnum],
      'rating': instance.rating,
    };

const _$AllServiceTypeEnumEnumMap = {
  AllServiceTypeEnum.MACHINARY: 'MACHINARY',
  AllServiceTypeEnum.MACHINARY_CLIENT: 'MACHINARY_CLIENT',
  AllServiceTypeEnum.EQUIPMENT: 'EQUIPMENT',
  AllServiceTypeEnum.EQUIPMENT_CLIENT: 'EQUIPMENT_CLIENT',
  AllServiceTypeEnum.CM: 'CM',
  AllServiceTypeEnum.CM_CLIENT: 'CM_CLIENT',
  AllServiceTypeEnum.SVM: 'SVM',
  AllServiceTypeEnum.SVM_CLIENT: 'SVM_CLIENT',
  AllServiceTypeEnum.UNKNOWN: 'UNKNOWN',
};
