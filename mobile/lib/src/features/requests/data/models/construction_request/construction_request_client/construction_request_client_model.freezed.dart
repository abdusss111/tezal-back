// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'construction_request_client_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConstructionRequestClientModel _$ConstructionRequestClientModelFromJson(
    Map<String, dynamic> json) {
  return _ConstructionRequestClientModel.fromJson(json);
}

/// @nodoc
mixin _$ConstructionRequestClientModel {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  dynamic get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'ad_construction_material_client_id')
  int? get adConstructionMaterialClientId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ad_construction_material_client')
  AdConstructionClientModel? get adConstructionClientModel =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  dynamic get userId => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;
  @JsonKey(name: 'executor_id')
  int? get executorId => throw _privateConstructorUsedError;
  @JsonKey(name: 'executor')
  User? get executorUser => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;

  /// Serializes this ConstructionRequestClientModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConstructionRequestClientModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConstructionRequestClientModelCopyWith<ConstructionRequestClientModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConstructionRequestClientModelCopyWith<$Res> {
  factory $ConstructionRequestClientModelCopyWith(
          ConstructionRequestClientModel value,
          $Res Function(ConstructionRequestClientModel) then) =
      _$ConstructionRequestClientModelCopyWithImpl<$Res,
          ConstructionRequestClientModel>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      @JsonKey(name: 'deleted_at') dynamic deletedAt,
      @JsonKey(name: 'ad_construction_material_client_id')
      int? adConstructionMaterialClientId,
      @JsonKey(name: 'ad_construction_material_client')
      AdConstructionClientModel? adConstructionClientModel,
      @JsonKey(name: 'user_id') dynamic userId,
      User? user,
      @JsonKey(name: 'executor_id') int? executorId,
      @JsonKey(name: 'executor') User? executorUser,
      String? description,
      String? status});

  $AdConstructionClientModelCopyWith<$Res>? get adConstructionClientModel;
  $UserCopyWith<$Res>? get user;
  $UserCopyWith<$Res>? get executorUser;
}

/// @nodoc
class _$ConstructionRequestClientModelCopyWithImpl<$Res,
        $Val extends ConstructionRequestClientModel>
    implements $ConstructionRequestClientModelCopyWith<$Res> {
  _$ConstructionRequestClientModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConstructionRequestClientModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? adConstructionMaterialClientId = freezed,
    Object? adConstructionClientModel = freezed,
    Object? userId = freezed,
    Object? user = freezed,
    Object? executorId = freezed,
    Object? executorUser = freezed,
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
      adConstructionMaterialClientId: freezed == adConstructionMaterialClientId
          ? _value.adConstructionMaterialClientId
          : adConstructionMaterialClientId // ignore: cast_nullable_to_non_nullable
              as int?,
      adConstructionClientModel: freezed == adConstructionClientModel
          ? _value.adConstructionClientModel
          : adConstructionClientModel // ignore: cast_nullable_to_non_nullable
              as AdConstructionClientModel?,
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
      executorUser: freezed == executorUser
          ? _value.executorUser
          : executorUser // ignore: cast_nullable_to_non_nullable
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

  /// Create a copy of ConstructionRequestClientModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AdConstructionClientModelCopyWith<$Res>? get adConstructionClientModel {
    if (_value.adConstructionClientModel == null) {
      return null;
    }

    return $AdConstructionClientModelCopyWith<$Res>(
        _value.adConstructionClientModel!, (value) {
      return _then(_value.copyWith(adConstructionClientModel: value) as $Val);
    });
  }

  /// Create a copy of ConstructionRequestClientModel
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

  /// Create a copy of ConstructionRequestClientModel
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
abstract class _$$ConstructionRequestClientModelImplCopyWith<$Res>
    implements $ConstructionRequestClientModelCopyWith<$Res> {
  factory _$$ConstructionRequestClientModelImplCopyWith(
          _$ConstructionRequestClientModelImpl value,
          $Res Function(_$ConstructionRequestClientModelImpl) then) =
      __$$ConstructionRequestClientModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      @JsonKey(name: 'deleted_at') dynamic deletedAt,
      @JsonKey(name: 'ad_construction_material_client_id')
      int? adConstructionMaterialClientId,
      @JsonKey(name: 'ad_construction_material_client')
      AdConstructionClientModel? adConstructionClientModel,
      @JsonKey(name: 'user_id') dynamic userId,
      User? user,
      @JsonKey(name: 'executor_id') int? executorId,
      @JsonKey(name: 'executor') User? executorUser,
      String? description,
      String? status});

  @override
  $AdConstructionClientModelCopyWith<$Res>? get adConstructionClientModel;
  @override
  $UserCopyWith<$Res>? get user;
  @override
  $UserCopyWith<$Res>? get executorUser;
}

/// @nodoc
class __$$ConstructionRequestClientModelImplCopyWithImpl<$Res>
    extends _$ConstructionRequestClientModelCopyWithImpl<$Res,
        _$ConstructionRequestClientModelImpl>
    implements _$$ConstructionRequestClientModelImplCopyWith<$Res> {
  __$$ConstructionRequestClientModelImplCopyWithImpl(
      _$ConstructionRequestClientModelImpl _value,
      $Res Function(_$ConstructionRequestClientModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConstructionRequestClientModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? adConstructionMaterialClientId = freezed,
    Object? adConstructionClientModel = freezed,
    Object? userId = freezed,
    Object? user = freezed,
    Object? executorId = freezed,
    Object? executorUser = freezed,
    Object? description = freezed,
    Object? status = freezed,
  }) {
    return _then(_$ConstructionRequestClientModelImpl(
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
      adConstructionMaterialClientId: freezed == adConstructionMaterialClientId
          ? _value.adConstructionMaterialClientId
          : adConstructionMaterialClientId // ignore: cast_nullable_to_non_nullable
              as int?,
      adConstructionClientModel: freezed == adConstructionClientModel
          ? _value.adConstructionClientModel
          : adConstructionClientModel // ignore: cast_nullable_to_non_nullable
              as AdConstructionClientModel?,
      userId: freezed == userId ? _value.userId! : userId,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      executorId: freezed == executorId
          ? _value.executorId
          : executorId // ignore: cast_nullable_to_non_nullable
              as int?,
      executorUser: freezed == executorUser
          ? _value.executorUser
          : executorUser // ignore: cast_nullable_to_non_nullable
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
class _$ConstructionRequestClientModelImpl
    implements _ConstructionRequestClientModel {
  _$ConstructionRequestClientModelImpl(
      {this.id,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'deleted_at') this.deletedAt,
      @JsonKey(name: 'ad_construction_material_client_id')
      this.adConstructionMaterialClientId,
      @JsonKey(name: 'ad_construction_material_client')
      this.adConstructionClientModel,
      @JsonKey(name: 'user_id') this.userId,
      this.user,
      @JsonKey(name: 'executor_id') this.executorId,
      @JsonKey(name: 'executor') this.executorUser,
      this.description,
      this.status});

  factory _$ConstructionRequestClientModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$ConstructionRequestClientModelImplFromJson(json);

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
  @JsonKey(name: 'ad_construction_material_client_id')
  final int? adConstructionMaterialClientId;
  @override
  @JsonKey(name: 'ad_construction_material_client')
  final AdConstructionClientModel? adConstructionClientModel;
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
  final User? executorUser;
  @override
  final String? description;
  @override
  final String? status;

  @override
  String toString() {
    return 'ConstructionRequestClientModel(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, adConstructionMaterialClientId: $adConstructionMaterialClientId, adConstructionClientModel: $adConstructionClientModel, userId: $userId, user: $user, executorId: $executorId, executorUser: $executorUser, description: $description, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConstructionRequestClientModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.deletedAt, deletedAt) &&
            (identical(other.adConstructionMaterialClientId,
                    adConstructionMaterialClientId) ||
                other.adConstructionMaterialClientId ==
                    adConstructionMaterialClientId) &&
            (identical(other.adConstructionClientModel,
                    adConstructionClientModel) ||
                other.adConstructionClientModel == adConstructionClientModel) &&
            const DeepCollectionEquality().equals(other.userId, userId) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.executorId, executorId) ||
                other.executorId == executorId) &&
            (identical(other.executorUser, executorUser) ||
                other.executorUser == executorUser) &&
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
      adConstructionMaterialClientId,
      adConstructionClientModel,
      const DeepCollectionEquality().hash(userId),
      user,
      executorId,
      executorUser,
      description,
      status);

  /// Create a copy of ConstructionRequestClientModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConstructionRequestClientModelImplCopyWith<
          _$ConstructionRequestClientModelImpl>
      get copyWith => __$$ConstructionRequestClientModelImplCopyWithImpl<
          _$ConstructionRequestClientModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConstructionRequestClientModelImplToJson(
      this,
    );
  }
}

abstract class _ConstructionRequestClientModel
    implements ConstructionRequestClientModel {
  factory _ConstructionRequestClientModel(
      {final int? id,
      @JsonKey(name: 'created_at') final String? createdAt,
      @JsonKey(name: 'updated_at') final String? updatedAt,
      @JsonKey(name: 'deleted_at') final dynamic deletedAt,
      @JsonKey(name: 'ad_construction_material_client_id')
      final int? adConstructionMaterialClientId,
      @JsonKey(name: 'ad_construction_material_client')
      final AdConstructionClientModel? adConstructionClientModel,
      @JsonKey(name: 'user_id') final dynamic userId,
      final User? user,
      @JsonKey(name: 'executor_id') final int? executorId,
      @JsonKey(name: 'executor') final User? executorUser,
      final String? description,
      final String? status}) = _$ConstructionRequestClientModelImpl;

  factory _ConstructionRequestClientModel.fromJson(Map<String, dynamic> json) =
      _$ConstructionRequestClientModelImpl.fromJson;

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
  @JsonKey(name: 'ad_construction_material_client_id')
  int? get adConstructionMaterialClientId;
  @override
  @JsonKey(name: 'ad_construction_material_client')
  AdConstructionClientModel? get adConstructionClientModel;
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
  User? get executorUser;
  @override
  String? get description;
  @override
  String? get status;

  /// Create a copy of ConstructionRequestClientModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConstructionRequestClientModelImplCopyWith<
          _$ConstructionRequestClientModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
