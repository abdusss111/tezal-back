// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'categories_params.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CategoriesParams _$CategoriesParamsFromJson(Map<String, dynamic> json) {
  return _CategoriesParams.fromJson(json);
}

/// @nodoc
mixin _$CategoriesParams {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'name')
  String? get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'name_eng')
  String? get nameEng => throw _privateConstructorUsedError;

  /// Serializes this CategoriesParams to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CategoriesParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CategoriesParamsCopyWith<CategoriesParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CategoriesParamsCopyWith<$Res> {
  factory $CategoriesParamsCopyWith(
          CategoriesParams value, $Res Function(CategoriesParams) then) =
      _$CategoriesParamsCopyWithImpl<$Res, CategoriesParams>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'name_eng') String? nameEng});
}

/// @nodoc
class _$CategoriesParamsCopyWithImpl<$Res, $Val extends CategoriesParams>
    implements $CategoriesParamsCopyWith<$Res> {
  _$CategoriesParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CategoriesParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? nameEng = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      nameEng: freezed == nameEng
          ? _value.nameEng
          : nameEng // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CategoriesParamsImplCopyWith<$Res>
    implements $CategoriesParamsCopyWith<$Res> {
  factory _$$CategoriesParamsImplCopyWith(_$CategoriesParamsImpl value,
          $Res Function(_$CategoriesParamsImpl) then) =
      __$$CategoriesParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'name') String? name,
      @JsonKey(name: 'name_eng') String? nameEng});
}

/// @nodoc
class __$$CategoriesParamsImplCopyWithImpl<$Res>
    extends _$CategoriesParamsCopyWithImpl<$Res, _$CategoriesParamsImpl>
    implements _$$CategoriesParamsImplCopyWith<$Res> {
  __$$CategoriesParamsImplCopyWithImpl(_$CategoriesParamsImpl _value,
      $Res Function(_$CategoriesParamsImpl) _then)
      : super(_value, _then);

  /// Create a copy of CategoriesParams
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? nameEng = freezed,
  }) {
    return _then(_$CategoriesParamsImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      nameEng: freezed == nameEng
          ? _value.nameEng
          : nameEng // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CategoriesParamsImpl implements _CategoriesParams {
  _$CategoriesParamsImpl(
      {this.id,
      @JsonKey(name: 'name') this.name,
      @JsonKey(name: 'name_eng') this.nameEng});

  factory _$CategoriesParamsImpl.fromJson(Map<String, dynamic> json) =>
      _$$CategoriesParamsImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'name')
  final String? name;
  @override
  @JsonKey(name: 'name_eng')
  final String? nameEng;

  @override
  String toString() {
    return 'CategoriesParams(id: $id, name: $name, nameEng: $nameEng)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CategoriesParamsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.nameEng, nameEng) || other.nameEng == nameEng));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, nameEng);

  /// Create a copy of CategoriesParams
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CategoriesParamsImplCopyWith<_$CategoriesParamsImpl> get copyWith =>
      __$$CategoriesParamsImplCopyWithImpl<_$CategoriesParamsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CategoriesParamsImplToJson(
      this,
    );
  }
}

abstract class _CategoriesParams implements CategoriesParams {
  factory _CategoriesParams(
          {final int? id,
          @JsonKey(name: 'name') final String? name,
          @JsonKey(name: 'name_eng') final String? nameEng}) =
      _$CategoriesParamsImpl;

  factory _CategoriesParams.fromJson(Map<String, dynamic> json) =
      _$CategoriesParamsImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'name')
  String? get name;
  @override
  @JsonKey(name: 'name_eng')
  String? get nameEng;

  /// Create a copy of CategoriesParams
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CategoriesParamsImplCopyWith<_$CategoriesParamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
