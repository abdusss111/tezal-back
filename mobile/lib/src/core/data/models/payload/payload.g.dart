// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PayloadImpl _$$PayloadImplFromJson(Map<String, dynamic> json) =>
    _$PayloadImpl(
      aud: json['aud'] as String?,
      exp: (json['exp'] as num?)?.toInt(),
      iat: (json['iat'] as num?)?.toInt(),
      iss: json['iss'] as String?,
      nbf: (json['nbf'] as num?)?.toInt(),
      sub: json['sub'] as String?,
    );

Map<String, dynamic> _$$PayloadImplToJson(_$PayloadImpl instance) =>
    <String, dynamic>{
      'aud': instance.aud,
      'exp': instance.exp,
      'iat': instance.iat,
      'iss': instance.iss,
      'nbf': instance.nbf,
      'sub': instance.sub,
    };
