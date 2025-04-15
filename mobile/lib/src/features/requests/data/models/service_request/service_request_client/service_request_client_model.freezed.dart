// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_request_client_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ServiceRequestClientModel _$ServiceRequestClientModelFromJson(
    Map<String, dynamic> json) {
  return _ServiceRequestClientModel.fromJson(json);
}

/// @nodoc
mixin _$ServiceRequestClientModel {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  dynamic get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'ad_service_client_id')
  int? get adClientID => throw _privateConstructorUsedError;
  @JsonKey(name: 'ad_service_client')
  AdServiceClientModel? get adClient => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  dynamic get userId => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;
  @JsonKey(name: 'executor_id')
  int? get executorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'executor')
  User? get executor => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;

  /// Serializes this ServiceRequestClientModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ServiceRequestClientModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ServiceRequestClientModelCopyWith<ServiceRequestClientModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ServiceRequestClientModelCopyWith<$Res> {
  factory $ServiceRequestClientModelCopyWith(ServiceRequestClientModel value,
          $Res Function(ServiceRequestClientModel) then) =
      _$ServiceRequestClientModelCopyWithImpl<$Res, ServiceRequestClientModel>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      @JsonKey(name: 'deleted_at') dynamic deletedAt,
      @JsonKey(name: 'ad_service_client_id') int? adClientID,
      @JsonKey(name: 'ad_service_client') AdServiceClientModel? adClient,
      @JsonKey(name: 'user_id') dynamic userId,
      User? user,
      @JsonKey(name: 'executor_id') int? executorId,
      @JsonKey(name: 'executor') User? executor,
      String? description,
      String? status});

  $AdServiceClientModelCopyWith<$Res>? get adClient;
  $UserCopyWith<$Res>? get user;
  $UserCopyWith<$Res>? get executor;
}

/// @nodoc
class _$ServiceRequestClientModelCopyWithImpl<$Res,
        $Val extends ServiceRequestClientModel>
    implements $ServiceRequestClientModelCopyWith<$Res> {
  _$ServiceRequestClientModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ServiceRequestClientModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? adClientID = freezed,
    Object? adClient = freezed,
    Object? userId = freezed,
    Object? user = freezed,
    Object? executorId = freezed,
    Object? executor = freezed,
    Object? description = freezed,
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
      adClientID: freezed == adClientID
          ? _value.adClientID
          : adClientID // ignore: cast_nullable_to_non_nullable
              as int?,
      adClient: freezed == adClient
          ? _value.adClient
          : adClient // ignore: cast_nullable_to_non_nullable
              as AdServiceClientModel?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      executorId: freezed == executorId
          ? _value.executorId
          : executorId // ignore: cast_nullable_to_non_nullable
              as int?,
      executor: freezed == executor
          ? _value.executor
          : executor // ignore: cast_nullable_to_non_nullable
              as User?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of ServiceRequestClientModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AdServiceClientModelCopyWith<$Res>? get adClient {
    if (_value.adClient == null) {
      return null;
    }

    return $AdServiceClientModelCopyWith<$Res>(_value.adClient!, (value) {
      return _then(_value.copyWith(adClient: value) as $Val);
    });
  }

  /// Create a copy of ServiceRequestClientModel
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

  /// Create a copy of ServiceRequestClientModel
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
}

/// @nodoc
abstract class _$$ServiceRequestClientModelImplCopyWith<$Res>
    implements $ServiceRequestClientModelCopyWith<$Res> {
  factory _$$ServiceRequestClientModelImplCopyWith(
          _$ServiceRequestClientModelImpl value,
          $Res Function(_$ServiceRequestClientModelImpl) then) =
      __$$ServiceRequestClientModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      @JsonKey(name: 'deleted_at') dynamic deletedAt,
      @JsonKey(name: 'ad_service_client_id') int? adClientID,
      @JsonKey(name: 'ad_service_client') AdServiceClientModel? adClient,
      @JsonKey(name: 'user_id') dynamic userId,
      User? user,
      @JsonKey(name: 'executor_id') int? executorId,
      @JsonKey(name: 'executor') User? executor,
      String? description,
      String? status});

  @override
  $AdServiceClientModelCopyWith<$Res>? get adClient;
  @override
  $UserCopyWith<$Res>? get user;
  @override
  $UserCopyWith<$Res>? get executor;
}

/// @nodoc
class __$$ServiceRequestClientModelImplCopyWithImpl<$Res>
    extends _$ServiceRequestClientModelCopyWithImpl<$Res,
        _$ServiceRequestClientModelImpl>
    implements _$$ServiceRequestClientModelImplCopyWith<$Res> {
  __$$ServiceRequestClientModelImplCopyWithImpl(
      _$ServiceRequestClientModelImpl _value,
      $Res Function(_$ServiceRequestClientModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ServiceRequestClientModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? adClientID = freezed,
    Object? adClient = freezed,
    Object? userId = freezed,
    Object? user = freezed,
    Object? executorId = freezed,
    Object? executor = freezed,
    Object? description = freezed,
    Object? status = freezed,
  }) {
    return _then(_$ServiceRequestClientModelImpl(
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
      adClientID: freezed == adClientID
          ? _value.adClientID
          : adClientID // ignore: cast_nullable_to_non_nullable
              as int?,
      adClient: freezed == adClient
          ? _value.adClient
          : adClient // ignore: cast_nullable_to_non_nullable
              as AdServiceClientModel?,
      userId: freezed == userId ? _value.userId! : userId,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      executorId: freezed == executorId
          ? _value.executorId
          : executorId // ignore: cast_nullable_to_non_nullable
              as int?,
      executor: freezed == executor
          ? _value.executor
          : executor // ignore: cast_nullable_to_non_nullable
              as User?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
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
class _$ServiceRequestClientModelImpl implements _ServiceRequestClientModel {
  _$ServiceRequestClientModelImpl(
      {this.id,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'deleted_at') this.deletedAt,
      @JsonKey(name: 'ad_service_client_id') this.adClientID,
      @JsonKey(name: 'ad_service_client') this.adClient,
      @JsonKey(name: 'user_id') this.userId,
      this.user,
      @JsonKey(name: 'executor_id') this.executorId,
      @JsonKey(name: 'executor') this.executor,
      this.description,
      this.status});

  factory _$ServiceRequestClientModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ServiceRequestClientModelImplFromJson(json);

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
  @JsonKey(name: 'ad_service_client_id')
  final int? adClientID;
  @override
  @JsonKey(name: 'ad_service_client')
  final AdServiceClientModel? adClient;
  @override
  @JsonKey(name: 'user_id')
  final dynamic userId;
  @override
  final User? user;
  @override
  @JsonKey(name: 'executor_id')
  final int? executorId;
  @override
  @JsonKey(name: 'executor')
  final User? executor;
  @override
  final String? description;
  @override
  final String? status;

  @override
  String toString() {
    return 'ServiceRequestClientModel(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, adClientID: $adClientID, adClient: $adClient, userId: $userId, user: $user, executorId: $executorId, executor: $executor, description: $description, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServiceRequestClientModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.deletedAt, deletedAt) &&
            (identical(other.adClientID, adClientID) ||
                other.adClientID == adClientID) &&
            (identical(other.adClient, adClient) ||
                other.adClient == adClient) &&
            const DeepCollectionEquality().equals(other.userId, userId) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.executorId, executorId) ||
                other.executorId == executorId) &&
            (identical(other.executor, executor) ||
                other.executor == executor) &&
            (identical(other.description, description) ||
                other.description == description) &&
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
      adClientID,
      adClient,
      const DeepCollectionEquality().hash(userId),
      user,
      executorId,
      executor,
      description,
      status);

  /// Create a copy of ServiceRequestClientModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ServiceRequestClientModelImplCopyWith<_$ServiceRequestClientModelImpl>
      get copyWith => __$$ServiceRequestClientModelImplCopyWithImpl<
          _$ServiceRequestClientModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ServiceRequestClientModelImplToJson(
      this,
    );
  }
}

abstract class _ServiceRequestClientModel implements ServiceRequestClientModel {
  factory _ServiceRequestClientModel(
      {final int? id,
      @JsonKey(name: 'created_at') final String? createdAt,
      @JsonKey(name: 'updated_at') final String? updatedAt,
      @JsonKey(name: 'deleted_at') final dynamic deletedAt,
      @JsonKey(name: 'ad_service_client_id') final int? adClientID,
      @JsonKey(name: 'ad_service_client') final AdServiceClientModel? adClient,
      @JsonKey(name: 'user_id') final dynamic userId,
      final User? user,
      @JsonKey(name: 'executor_id') final int? executorId,
      @JsonKey(name: 'executor') final User? executor,
      final String? description,
      final String? status}) = _$ServiceRequestClientModelImpl;

  factory _ServiceRequestClientModel.fromJson(Map<String, dynamic> json) =
      _$ServiceRequestClientModelImpl.fromJson;

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
  @JsonKey(name: 'ad_service_client_id')
  int? get adClientID;
  @override
  @JsonKey(name: 'ad_service_client')
  AdServiceClientModel? get adClient;
  @override
  @JsonKey(name: 'user_id')
  dynamic get userId;
  @override
  User? get user;
  @override
  @JsonKey(name: 'executor_id')
  int? get executorId;
  @override
  @JsonKey(name: 'executor')
  User? get executor;
  @override
  String? get description;
  @override
  String? get status;

  /// Create a copy of ServiceRequestClientModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ServiceRequestClientModelImplCopyWith<_$ServiceRequestClientModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
