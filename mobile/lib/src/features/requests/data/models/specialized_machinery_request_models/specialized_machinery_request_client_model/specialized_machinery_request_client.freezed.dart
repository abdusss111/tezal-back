// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'specialized_machinery_request_client.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SpecializedMachineryRequestClient _$SpecializedMachineryRequestClientFromJson(
    Map<String, dynamic> json) {
  return _SpecializedMachineryRequestClient.fromJson(json);
}

/// @nodoc
mixin _$SpecializedMachineryRequestClient {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  dynamic get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'ad_client_id')
  int? get adClientId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ad_client')
  AdClient? get adSm => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  dynamic get userId => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;
  int? get assigned => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_assigned')
  User? get executorUser => throw _privateConstructorUsedError;
  String? get comment => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;

  /// Serializes this SpecializedMachineryRequestClient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpecializedMachineryRequestClient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpecializedMachineryRequestClientCopyWith<SpecializedMachineryRequestClient>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpecializedMachineryRequestClientCopyWith<$Res> {
  factory $SpecializedMachineryRequestClientCopyWith(
          SpecializedMachineryRequestClient value,
          $Res Function(SpecializedMachineryRequestClient) then) =
      _$SpecializedMachineryRequestClientCopyWithImpl<$Res,
          SpecializedMachineryRequestClient>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      @JsonKey(name: 'deleted_at') dynamic deletedAt,
      @JsonKey(name: 'ad_client_id') int? adClientId,
      @JsonKey(name: 'ad_client') AdClient? adSm,
      @JsonKey(name: 'user_id') dynamic userId,
      User? user,
      int? assigned,
      @JsonKey(name: 'user_assigned') User? executorUser,
      String? comment,
      String? status});

  $AdClientCopyWith<$Res>? get adSm;
  $UserCopyWith<$Res>? get user;
  $UserCopyWith<$Res>? get executorUser;
}

/// @nodoc
class _$SpecializedMachineryRequestClientCopyWithImpl<$Res,
        $Val extends SpecializedMachineryRequestClient>
    implements $SpecializedMachineryRequestClientCopyWith<$Res> {
  _$SpecializedMachineryRequestClientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpecializedMachineryRequestClient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? adClientId = freezed,
    Object? adSm = freezed,
    Object? userId = freezed,
    Object? user = freezed,
    Object? assigned = freezed,
    Object? executorUser = freezed,
    Object? comment = freezed,
    Object? status = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      adClientId: freezed == adClientId
          ? _value.adClientId
          : adClientId // ignore: cast_nullable_to_non_nullable
              as int?,
      adSm: freezed == adSm
          ? _value.adSm
          : adSm // ignore: cast_nullable_to_non_nullable
              as AdClient?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      assigned: freezed == assigned
          ? _value.assigned
          : assigned // ignore: cast_nullable_to_non_nullable
              as int?,
      executorUser: freezed == executorUser
          ? _value.executorUser
          : executorUser // ignore: cast_nullable_to_non_nullable
              as User?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of SpecializedMachineryRequestClient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AdClientCopyWith<$Res>? get adSm {
    if (_value.adSm == null) {
      return null;
    }

    return $AdClientCopyWith<$Res>(_value.adSm!, (value) {
      return _then(_value.copyWith(adSm: value) as $Val);
    });
  }

  /// Create a copy of SpecializedMachineryRequestClient
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

  /// Create a copy of SpecializedMachineryRequestClient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get executorUser {
    if (_value.executorUser == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.executorUser!, (value) {
      return _then(_value.copyWith(executorUser: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SpecializedMachineryRequestClientImplCopyWith<$Res>
    implements $SpecializedMachineryRequestClientCopyWith<$Res> {
  factory _$$SpecializedMachineryRequestClientImplCopyWith(
          _$SpecializedMachineryRequestClientImpl value,
          $Res Function(_$SpecializedMachineryRequestClientImpl) then) =
      __$$SpecializedMachineryRequestClientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      @JsonKey(name: 'deleted_at') dynamic deletedAt,
      @JsonKey(name: 'ad_client_id') int? adClientId,
      @JsonKey(name: 'ad_client') AdClient? adSm,
      @JsonKey(name: 'user_id') dynamic userId,
      User? user,
      int? assigned,
      @JsonKey(name: 'user_assigned') User? executorUser,
      String? comment,
      String? status});

  @override
  $AdClientCopyWith<$Res>? get adSm;
  @override
  $UserCopyWith<$Res>? get user;
  @override
  $UserCopyWith<$Res>? get executorUser;
}

/// @nodoc
class __$$SpecializedMachineryRequestClientImplCopyWithImpl<$Res>
    extends _$SpecializedMachineryRequestClientCopyWithImpl<$Res,
        _$SpecializedMachineryRequestClientImpl>
    implements _$$SpecializedMachineryRequestClientImplCopyWith<$Res> {
  __$$SpecializedMachineryRequestClientImplCopyWithImpl(
      _$SpecializedMachineryRequestClientImpl _value,
      $Res Function(_$SpecializedMachineryRequestClientImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpecializedMachineryRequestClient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? adClientId = freezed,
    Object? adSm = freezed,
    Object? userId = freezed,
    Object? user = freezed,
    Object? assigned = freezed,
    Object? executorUser = freezed,
    Object? comment = freezed,
    Object? status = freezed,
  }) {
    return _then(_$SpecializedMachineryRequestClientImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as String?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as String?,
      deletedAt: freezed == deletedAt
          ? _value.deletedAt
          : deletedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      adClientId: freezed == adClientId
          ? _value.adClientId
          : adClientId // ignore: cast_nullable_to_non_nullable
              as int?,
      adSm: freezed == adSm
          ? _value.adSm
          : adSm // ignore: cast_nullable_to_non_nullable
              as AdClient?,
      userId: freezed == userId ? _value.userId! : userId,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      assigned: freezed == assigned
          ? _value.assigned
          : assigned // ignore: cast_nullable_to_non_nullable
              as int?,
      executorUser: freezed == executorUser
          ? _value.executorUser
          : executorUser // ignore: cast_nullable_to_non_nullable
              as User?,
      comment: freezed == comment
          ? _value.comment
          : comment // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpecializedMachineryRequestClientImpl
    implements _SpecializedMachineryRequestClient {
  _$SpecializedMachineryRequestClientImpl(
      {this.id,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'deleted_at') this.deletedAt,
      @JsonKey(name: 'ad_client_id') this.adClientId,
      @JsonKey(name: 'ad_client') this.adSm,
      @JsonKey(name: 'user_id') this.userId,
      this.user,
      this.assigned,
      @JsonKey(name: 'user_assigned') this.executorUser,
      this.comment,
      this.status});

  factory _$SpecializedMachineryRequestClientImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SpecializedMachineryRequestClientImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  final dynamic deletedAt;
  @override
  @JsonKey(name: 'ad_client_id')
  final int? adClientId;
  @override
  @JsonKey(name: 'ad_client')
  final AdClient? adSm;
  @override
  @JsonKey(name: 'user_id')
  final dynamic userId;
  @override
  final User? user;
  @override
  final int? assigned;
  @override
  @JsonKey(name: 'user_assigned')
  final User? executorUser;
  @override
  final String? comment;
  @override
  final String? status;

  @override
  String toString() {
    return 'SpecializedMachineryRequestClient(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, adClientId: $adClientId, adSm: $adSm, userId: $userId, user: $user, assigned: $assigned, executorUser: $executorUser, comment: $comment, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpecializedMachineryRequestClientImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.deletedAt, deletedAt) &&
            (identical(other.adClientId, adClientId) ||
                other.adClientId == adClientId) &&
            (identical(other.adSm, adSm) || other.adSm == adSm) &&
            const DeepCollectionEquality().equals(other.userId, userId) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.assigned, assigned) ||
                other.assigned == assigned) &&
            (identical(other.executorUser, executorUser) ||
                other.executorUser == executorUser) &&
            (identical(other.comment, comment) || other.comment == comment) &&
            (identical(other.status, status) || other.status == status));
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
      adSm,
      const DeepCollectionEquality().hash(userId),
      user,
      assigned,
      executorUser,
      comment,
      status);

  /// Create a copy of SpecializedMachineryRequestClient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpecializedMachineryRequestClientImplCopyWith<
          _$SpecializedMachineryRequestClientImpl>
      get copyWith => __$$SpecializedMachineryRequestClientImplCopyWithImpl<
          _$SpecializedMachineryRequestClientImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpecializedMachineryRequestClientImplToJson(
      this,
    );
  }
}

abstract class _SpecializedMachineryRequestClient
    implements SpecializedMachineryRequestClient {
  factory _SpecializedMachineryRequestClient(
      {final int? id,
      @JsonKey(name: 'created_at') final String? createdAt,
      @JsonKey(name: 'updated_at') final String? updatedAt,
      @JsonKey(name: 'deleted_at') final dynamic deletedAt,
      @JsonKey(name: 'ad_client_id') final int? adClientId,
      @JsonKey(name: 'ad_client') final AdClient? adSm,
      @JsonKey(name: 'user_id') final dynamic userId,
      final User? user,
      final int? assigned,
      @JsonKey(name: 'user_assigned') final User? executorUser,
      final String? comment,
      final String? status}) = _$SpecializedMachineryRequestClientImpl;

  factory _SpecializedMachineryRequestClient.fromJson(
          Map<String, dynamic> json) =
      _$SpecializedMachineryRequestClientImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: 'created_at')
  String? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  String? get updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  dynamic get deletedAt;
  @override
  @JsonKey(name: 'ad_client_id')
  int? get adClientId;
  @override
  @JsonKey(name: 'ad_client')
  AdClient? get adSm;
  @override
  @JsonKey(name: 'user_id')
  dynamic get userId;
  @override
  User? get user;
  @override
  int? get assigned;
  @override
  @JsonKey(name: 'user_assigned')
  User? get executorUser;
  @override
  String? get comment;
  @override
  String? get status;

  /// Create a copy of SpecializedMachineryRequestClient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpecializedMachineryRequestClientImplCopyWith<
          _$SpecializedMachineryRequestClientImpl>
      get copyWith => throw _privateConstructorUsedError;
}
