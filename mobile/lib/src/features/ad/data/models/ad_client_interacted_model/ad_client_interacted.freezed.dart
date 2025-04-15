// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ad_client_interacted.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AdClientInteracted _$AdClientInteractedFromJson(Map<String, dynamic> json) {
  return _AdClientInteracted.fromJson(json);
}

/// @nodoc
mixin _$AdClientInteracted {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  dynamic get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'ad_client_id')
  int? get adClientId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_rating')
  int? get userRating => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;

  /// Serializes this AdClientInteracted to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdClientInteracted
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdClientInteractedCopyWith<AdClientInteracted> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdClientInteractedCopyWith<$Res> {
  factory $AdClientInteractedCopyWith(
          AdClientInteracted value, $Res Function(AdClientInteracted) then) =
      _$AdClientInteractedCopyWithImpl<$Res, AdClientInteracted>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') dynamic deletedAt,
      @JsonKey(name: 'ad_client_id') int? adClientId,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'user_rating') int? userRating,
      User? user});

  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class _$AdClientInteractedCopyWithImpl<$Res, $Val extends AdClientInteracted>
    implements $AdClientInteractedCopyWith<$Res> {
  _$AdClientInteractedCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdClientInteracted
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? adClientId = freezed,
    Object? userId = freezed,
    Object? userRating = freezed,
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
      adClientId: freezed == adClientId
          ? _value.adClientId
          : adClientId // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      userRating: freezed == userRating
          ? _value.userRating
          : userRating // ignore: cast_nullable_to_non_nullable
              as int?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
    ) as $Val);
  }

  /// Create a copy of AdClientInteracted
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
abstract class _$$AdClientInteractedImplCopyWith<$Res>
    implements $AdClientInteractedCopyWith<$Res> {
  factory _$$AdClientInteractedImplCopyWith(_$AdClientInteractedImpl value,
          $Res Function(_$AdClientInteractedImpl) then) =
      __$$AdClientInteractedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') dynamic deletedAt,
      @JsonKey(name: 'ad_client_id') int? adClientId,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'user_rating') int? userRating,
      User? user});

  @override
  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class __$$AdClientInteractedImplCopyWithImpl<$Res>
    extends _$AdClientInteractedCopyWithImpl<$Res, _$AdClientInteractedImpl>
    implements _$$AdClientInteractedImplCopyWith<$Res> {
  __$$AdClientInteractedImplCopyWithImpl(_$AdClientInteractedImpl _value,
      $Res Function(_$AdClientInteractedImpl) _then)
      : super(_value, _then);

  /// Create a copy of AdClientInteracted
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? adClientId = freezed,
    Object? userId = freezed,
    Object? userRating = freezed,
    Object? user = freezed,
  }) {
    return _then(_$AdClientInteractedImpl(
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
      adClientId: freezed == adClientId
          ? _value.adClientId
          : adClientId // ignore: cast_nullable_to_non_nullable
              as int?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      userRating: freezed == userRating
          ? _value.userRating
          : userRating // ignore: cast_nullable_to_non_nullable
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
class _$AdClientInteractedImpl implements _AdClientInteracted {
  _$AdClientInteractedImpl(
      {this.id,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'deleted_at') this.deletedAt,
      @JsonKey(name: 'ad_client_id') this.adClientId,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'user_rating') this.userRating,
      this.user});

  factory _$AdClientInteractedImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdClientInteractedImplFromJson(json);

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
  @JsonKey(name: 'ad_client_id')
  final int? adClientId;
  @override
  @JsonKey(name: 'user_id')
  final int? userId;
  @override
  @JsonKey(name: 'user_rating')
  final int? userRating;
  @override
  final User? user;

  @override
  String toString() {
    return 'AdClientInteracted(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, adClientId: $adClientId, userId: $userId, userRating: $userRating, user: $user)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdClientInteractedImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.deletedAt, deletedAt) &&
            (identical(other.adClientId, adClientId) ||
                other.adClientId == adClientId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userRating, userRating) ||
                other.userRating == userRating) &&
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
      adClientId,
      userId,
      userRating,
      user);

  /// Create a copy of AdClientInteracted
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdClientInteractedImplCopyWith<_$AdClientInteractedImpl> get copyWith =>
      __$$AdClientInteractedImplCopyWithImpl<_$AdClientInteractedImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdClientInteractedImplToJson(
      this,
    );
  }
}

abstract class _AdClientInteracted implements AdClientInteracted {
  factory _AdClientInteracted(
      {final int? id,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') final dynamic deletedAt,
      @JsonKey(name: 'ad_client_id') final int? adClientId,
      @JsonKey(name: 'user_id') final int? userId,
      @JsonKey(name: 'user_rating') final int? userRating,
      final User? user}) = _$AdClientInteractedImpl;

  factory _AdClientInteracted.fromJson(Map<String, dynamic> json) =
      _$AdClientInteractedImpl.fromJson;

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
  @JsonKey(name: 'ad_client_id')
  int? get adClientId;
  @override
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  @JsonKey(name: 'user_rating')
  int? get userRating;
  @override
  User? get user;

  /// Create a copy of AdClientInteracted
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdClientInteractedImplCopyWith<_$AdClientInteractedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
