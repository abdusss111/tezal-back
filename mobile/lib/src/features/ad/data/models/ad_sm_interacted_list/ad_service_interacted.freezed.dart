// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ad_service_interacted.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AdServiceInteracted _$AdServiceInteractedFromJson(Map<String, dynamic> json) {
  return _AdServiceInteracted.fromJson(json);
}

/// @nodoc
mixin _$AdServiceInteracted {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  dynamic get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'ad_service_id')
  int? get adServiceId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;

  /// Serializes this AdServiceInteracted to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdServiceInteracted
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdServiceInteractedCopyWith<AdServiceInteracted> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdServiceInteractedCopyWith<$Res> {
  factory $AdServiceInteractedCopyWith(
          AdServiceInteracted value, $Res Function(AdServiceInteracted) then) =
      _$AdServiceInteractedCopyWithImpl<$Res, AdServiceInteracted>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') dynamic deletedAt,
      @JsonKey(name: 'ad_service_id') int? adServiceId,
      @JsonKey(name: 'user_id') int? userId,
      User? user});

  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class _$AdServiceInteractedCopyWithImpl<$Res, $Val extends AdServiceInteracted>
    implements $AdServiceInteractedCopyWith<$Res> {
  _$AdServiceInteractedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdServiceInteracted
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? adServiceId = freezed,
    Object? userId = freezed,
    Object? user = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      adServiceId: freezed == adServiceId
          ? _value.adServiceId
          : adServiceId // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
    ) as $Val);
  }

  /// Create a copy of AdServiceInteracted
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AdServiceInteractedImplCopyWith<$Res>
    implements $AdServiceInteractedCopyWith<$Res> {
  factory _$$AdServiceInteractedImplCopyWith(_$AdServiceInteractedImpl value,
          $Res Function(_$AdServiceInteractedImpl) then) =
      __$$AdServiceInteractedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') dynamic deletedAt,
      @JsonKey(name: 'ad_service_id') int? adServiceId,
      @JsonKey(name: 'user_id') int? userId,
      User? user});

  @override
  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class __$$AdServiceInteractedImplCopyWithImpl<$Res>
    extends _$AdServiceInteractedCopyWithImpl<$Res, _$AdServiceInteractedImpl>
    implements _$$AdServiceInteractedImplCopyWith<$Res> {
  __$$AdServiceInteractedImplCopyWithImpl(_$AdServiceInteractedImpl _value,
      $Res Function(_$AdServiceInteractedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AdServiceInteracted
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? adServiceId = freezed,
    Object? userId = freezed,
    Object? user = freezed,
  }) {
    return _then(_$AdServiceInteractedImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      adServiceId: freezed == adServiceId
          ? _value.adServiceId
          : adServiceId // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdServiceInteractedImpl implements _AdServiceInteracted {
  _$AdServiceInteractedImpl(
      {this.id,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'deleted_at') this.deletedAt,
      @JsonKey(name: 'ad_service_id') this.adServiceId,
      @JsonKey(name: 'user_id') this.userId,
      this.user});

  factory _$AdServiceInteractedImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdServiceInteractedImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  final dynamic deletedAt;
  @override
  @JsonKey(name: 'ad_service_id')
  final int? adServiceId;
  @override
  @JsonKey(name: 'user_id')
  final int? userId;
  @override
  final User? user;

  @override
  String toString() {
    return 'AdServiceInteracted(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, adServiceId: $adServiceId, userId: $userId, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdServiceInteractedImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.deletedAt, deletedAt) &&
            (identical(other.adServiceId, adServiceId) ||
                other.adServiceId == adServiceId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.user, user) || other.user == user));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(deletedAt),
      adServiceId,
      userId,
      user);

  /// Create a copy of AdServiceInteracted
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdServiceInteractedImplCopyWith<_$AdServiceInteractedImpl> get copyWith =>
      __$$AdServiceInteractedImplCopyWithImpl<_$AdServiceInteractedImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdServiceInteractedImplToJson(
      this,
    );
  }
}

abstract class _AdServiceInteracted implements AdServiceInteracted {
  factory _AdServiceInteracted(
      {final int? id,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') final dynamic deletedAt,
      @JsonKey(name: 'ad_service_id') final int? adServiceId,
      @JsonKey(name: 'user_id') final int? userId,
      final User? user}) = _$AdServiceInteractedImpl;

  factory _AdServiceInteracted.fromJson(Map<String, dynamic> json) =
      _$AdServiceInteractedImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  dynamic get deletedAt;
  @override
  @JsonKey(name: 'ad_service_id')
  int? get adServiceId;
  @override
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  User? get user;

  /// Create a copy of AdServiceInteracted
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdServiceInteractedImplCopyWith<_$AdServiceInteractedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
