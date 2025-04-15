// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories_params.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CategoriesParamsImpl _$$CategoriesParamsImplFromJson(
        Map<String, dynamic> json) =>
    _$CategoriesParamsImpl(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      nameEng: json['name_eng'] as String?,
    );

Map<String, dynamic> _$$CategoriesParamsImplToJson(
        _$CategoriesParamsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'name_eng': instance.nameEng,
    };
