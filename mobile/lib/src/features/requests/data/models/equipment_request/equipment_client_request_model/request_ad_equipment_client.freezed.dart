// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_ad_equipment_client.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RequestAdEquipmentClient _$RequestAdEquipmentClientFromJson(
    Map<String, dynamic> json) {
  return _RequestAdEquipmentClient.fromJson(json);
}

/// @nodoc
mixin _$RequestAdEquipmentClient {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  dynamic? get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'ad_equipment_client_id')
  int? get adEquipmentClientId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ad_equipment_client')
  AdEquipmentClient? get adEquipmentClient =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'executor_id')
  int? get executorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'executor')
  User? get executor => throw _privateConstructorUsedError;
  @JsonKey(name: 'user')
  User? get user => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this RequestAdEquipmentClient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RequestAdEquipmentClient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RequestAdEquipmentClientCopyWith<RequestAdEquipmentClient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestAdEquipmentClientCopyWith<$Res> {
  factory $RequestAdEquipmentClientCopyWith(RequestAdEquipmentClient value,
          $Res Function(RequestAdEquipmentClient) then) =
      _$RequestAdEquipmentClientCopyWithImpl<$Res, RequestAdEquipmentClient>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') dynamic? deletedAt,
      @JsonKey(name: 'ad_equipment_client_id') int? adEquipmentClientId,
      @JsonKey(name: 'ad_equipment_client')
      AdEquipmentClient? adEquipmentClient,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'executor_id') int? executorId,
      @JsonKey(name: 'executor') User? executor,
      @JsonKey(name: 'user') User? user,
      String? status,
      String? description});

  $AdEquipmentClientCopyWith<$Res>? get adEquipmentClient;
  $UserCopyWith<$Res>? get executor;
  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class _$RequestAdEquipmentClientCopyWithImpl<$Res,
        $Val extends RequestAdEquipmentClient>
    implements $RequestAdEquipmentClientCopyWith<$Res> {
  _$RequestAdEquipmentClientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RequestAdEquipmentClient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? adEquipmentClientId = freezed,
    Object? adEquipmentClient = freezed,
    Object? userId = freezed,
    Object? executorId = freezed,
    Object? executor = freezed,
    Object? user = freezed,
    Object? status = freezed,
    Object? description = freezed,
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
              as dynamic?,
      adEquipmentClientId: freezed == adEquipmentClientId
          ? _value.adEquipmentClientId
          : adEquipmentClientId // ignore: cast_nullable_to_non_nullable
              as int?,
      adEquipmentClient: freezed == adEquipmentClient
          ? _value.adEquipmentClient
          : adEquipmentClient // ignore: cast_nullable_to_non_nullable
              as AdEquipmentClient?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      executorId: freezed == executorId
          ? _value.executorId
          : executorId // ignore: cast_nullable_to_non_nullable
              as int?,
      executor: freezed == executor
          ? _value.executor
          : executor // ignore: cast_nullable_to_non_nullable
              as User?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of RequestAdEquipmentClient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AdEquipmentClientCopyWith<$Res>? get adEquipmentClient {
    if (_value.adEquipmentClient == null) {
      return null;
    }

    return $AdEquipmentClientCopyWith<$Res>(_value.adEquipmentClient!, (value) {
      return _then(_value.copyWith(adEquipmentClient: value) as $Val);
    });
  }

  /// Create a copy of RequestAdEquipmentClient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get executor {
    if (_value.executor == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.executor!, (value) {
      return _then(_value.copyWith(executor: value) as $Val);
    });
  }

  /// Create a copy of RequestAdEquipmentClient
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
abstract class _$$RequestAdEquipmentClientImplCopyWith<$Res>
    implements $RequestAdEquipmentClientCopyWith<$Res> {
  factory _$$RequestAdEquipmentClientImplCopyWith(
          _$RequestAdEquipmentClientImpl value,
          $Res Function(_$RequestAdEquipmentClientImpl) then) =
      __$$RequestAdEquipmentClientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') dynamic? deletedAt,
      @JsonKey(name: 'ad_equipment_client_id') int? adEquipmentClientId,
      @JsonKey(name: 'ad_equipment_client')
      AdEquipmentClient? adEquipmentClient,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'executor_id') int? executorId,
      @JsonKey(name: 'executor') User? executor,
      @JsonKey(name: 'user') User? user,
      String? status,
      String? description});

  @override
  $AdEquipmentClientCopyWith<$Res>? get adEquipmentClient;
  @override
  $UserCopyWith<$Res>? get executor;
  @override
  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class __$$RequestAdEquipmentClientImplCopyWithImpl<$Res>
    extends _$RequestAdEquipmentClientCopyWithImpl<$Res,
        _$RequestAdEquipmentClientImpl>
    implements _$$RequestAdEquipmentClientImplCopyWith<$Res> {
  __$$RequestAdEquipmentClientImplCopyWithImpl(
      _$RequestAdEquipmentClientImpl _value,
      $Res Function(_$RequestAdEquipmentClientImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestAdEquipmentClient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? adEquipmentClientId = freezed,
    Object? adEquipmentClient = freezed,
    Object? userId = freezed,
    Object? executorId = freezed,
    Object? executor = freezed,
    Object? user = freezed,
    Object? status = freezed,
    Object? description = freezed,
  }) {
    return _then(_$RequestAdEquipmentClientImpl(
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
              as dynamic?,
      adEquipmentClientId: freezed == adEquipmentClientId
          ? _value.adEquipmentClientId
          : adEquipmentClientId // ignore: cast_nullable_to_non_nullable
              as int?,
      adEquipmentClient: freezed == adEquipmentClient
          ? _value.adEquipmentClient
          : adEquipmentClient // ignore: cast_nullable_to_non_nullable
              as AdEquipmentClient?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      executorId: freezed == executorId
          ? _value.executorId
          : executorId // ignore: cast_nullable_to_non_nullable
              as int?,
      executor: freezed == executor
          ? _value.executor
          : executor // ignore: cast_nullable_to_non_nullable
              as User?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RequestAdEquipmentClientImpl implements _RequestAdEquipmentClient {
  _$RequestAdEquipmentClientImpl(
      {this.id,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'deleted_at') this.deletedAt,
      @JsonKey(name: 'ad_equipment_client_id') this.adEquipmentClientId,
      @JsonKey(name: 'ad_equipment_client') this.adEquipmentClient,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'executor_id') this.executorId,
      @JsonKey(name: 'executor') this.executor,
      @JsonKey(name: 'user') this.user,
      this.status,
      this.description});

  factory _$RequestAdEquipmentClientImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequestAdEquipmentClientImplFromJson(json);

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
  final dynamic? deletedAt;
  @override
  @JsonKey(name: 'ad_equipment_client_id')
  final int? adEquipmentClientId;
  @override
  @JsonKey(name: 'ad_equipment_client')
  final AdEquipmentClient? adEquipmentClient;
  @override
  @JsonKey(name: 'user_id')
  final int? userId;
  @override
  @JsonKey(name: 'executor_id')
  final int? executorId;
  @override
  @JsonKey(name: 'executor')
  final User? executor;
  @override
  @JsonKey(name: 'user')
  final User? user;
  @override
  final String? status;
  @override
  final String? description;

  @override
  String toString() {
    return 'RequestAdEquipmentClient(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, adEquipmentClientId: $adEquipmentClientId, adEquipmentClient: $adEquipmentClient, userId: $userId, executorId: $executorId, executor: $executor, user: $user, status: $status, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestAdEquipmentClientImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.deletedAt, deletedAt) &&
            (identical(other.adEquipmentClientId, adEquipmentClientId) ||
                other.adEquipmentClientId == adEquipmentClientId) &&
            (identical(other.adEquipmentClient, adEquipmentClient) ||
                other.adEquipmentClient == adEquipmentClient) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.executorId, executorId) ||
                other.executorId == executorId) &&
            (identical(other.executor, executor) ||
                other.executor == executor) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(deletedAt),
      adEquipmentClientId,
      adEquipmentClient,
      userId,
      executorId,
      executor,
      user,
      status,
      description);

  /// Create a copy of RequestAdEquipmentClient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestAdEquipmentClientImplCopyWith<_$RequestAdEquipmentClientImpl>
      get copyWith => __$$RequestAdEquipmentClientImplCopyWithImpl<
          _$RequestAdEquipmentClientImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestAdEquipmentClientImplToJson(
      this,
    );
  }
}

abstract class _RequestAdEquipmentClient implements RequestAdEquipmentClient {
  factory _RequestAdEquipmentClient(
      {final int? id,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') final dynamic? deletedAt,
      @JsonKey(name: 'ad_equipment_client_id') final int? adEquipmentClientId,
      @JsonKey(name: 'ad_equipment_client')
      final AdEquipmentClient? adEquipmentClient,
      @JsonKey(name: 'user_id') final int? userId,
      @JsonKey(name: 'executor_id') final int? executorId,
      @JsonKey(name: 'executor') final User? executor,
      @JsonKey(name: 'user') final User? user,
      final String? status,
      final String? description}) = _$RequestAdEquipmentClientImpl;

  factory _RequestAdEquipmentClient.fromJson(Map<String, dynamic> json) =
      _$RequestAdEquipmentClientImpl.fromJson;

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
  dynamic? get deletedAt;
  @override
  @JsonKey(name: 'ad_equipment_client_id')
  int? get adEquipmentClientId;
  @override
  @JsonKey(name: 'ad_equipment_client')
  AdEquipmentClient? get adEquipmentClient;
  @override
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  @JsonKey(name: 'executor_id')
  int? get executorId;
  @override
  @JsonKey(name: 'executor')
  User? get executor;
  @override
  @JsonKey(name: 'user')
  User? get user;
  @override
  String? get status;
  @override
  String? get description;

  /// Create a copy of RequestAdEquipmentClient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RequestAdEquipmentClientImplCopyWith<_$RequestAdEquipmentClientImpl>
      get copyWith => throw _privateConstructorUsedError;
}
