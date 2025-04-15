// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SubCategoryImpl _$$SubCategoryImplFromJson(Map<String, dynamic> json) =>
    _$SubCategoryImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      documents: json['documents'] as List<dynamic>?,
      mainCategoryID: (json['sub_category_id'] as num?)?.toInt(),
      urlFoto: (json['url_foto'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$SubCategoryImplToJson(_$SubCategoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'documents': instance.documents,
      'sub_category_id': instance.mainCategoryID,
      'url_foto': instance.urlFoto,
    };
