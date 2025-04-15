// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ad_sm_interacted_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AdSmInteractedListImpl _$$AdSmInteractedListImplFromJson(
        Map<String, dynamic> json) =>
    _$AdSmInteractedListImpl(
      adServiceInteracted: (json['ad_service_interacted'] as List<dynamic>?)
          ?.map((e) => AdServiceInteracted.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$AdSmInteractedListImplToJson(
        _$AdSmInteractedListImpl instance) =>
    <String, dynamic>{
      'ad_service_interacted': instance.adServiceInteracted,
    };
