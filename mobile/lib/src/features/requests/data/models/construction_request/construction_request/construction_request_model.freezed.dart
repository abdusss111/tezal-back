// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'construction_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ConstructionRequestModel _$ConstructionRequestModelFromJson(
    Map<String, dynamic> json) {
  return _ConstructionRequestModel.fromJson(json);
}

/// @nodoc
mixin _$ConstructionRequestModel {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  String? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  dynamic get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'ad_construction_material_id')
  int? get adConstructionMaterialId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ad_construction_material')
  AdConstrutionModel? get adConstructionModel =>
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
  @JsonKey(name: 'start_lease_at')
  String? get startLeaseAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_lease_at')
  String? get endLeaseAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'count_hour')
  int? get countHour => throw _privateConstructorUsedError;
  int? get latitude => throw _privateConstructorUsedError;
  int? get longitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_amount')
  int? get orderAmount => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'url_foto')
  List<String>? get imagesUrl => throw _privateConstructorUsedError;

  /// Serializes this ConstructionRequestModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ConstructionRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConstructionRequestModelCopyWith<ConstructionRequestModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConstructionRequestModelCopyWith<$Res> {
  factory $ConstructionRequestModelCopyWith(ConstructionRequestModel value,
          $Res Function(ConstructionRequestModel) then) =
      _$ConstructionRequestModelCopyWithImpl<$Res, ConstructionRequestModel>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      @JsonKey(name: 'deleted_at') dynamic deletedAt,
      @JsonKey(name: 'ad_construction_material_id')
      int? adConstructionMaterialId,
      @JsonKey(name: 'ad_construction_material')
      AdConstrutionModel? adConstructionModel,
      @JsonKey(name: 'user_id') dynamic userId,
      User? user,
      @JsonKey(name: 'executor_id') int? executorId,
      @JsonKey(name: 'executor') User? executorUser,
      String? description,
      String? status,
      @JsonKey(name: 'start_lease_at') String? startLeaseAt,
      @JsonKey(name: 'end_lease_at') String? endLeaseAt,
      @JsonKey(name: 'count_hour') int? countHour,
      int? latitude,
      int? longitude,
      @JsonKey(name: 'order_amount') int? orderAmount,
      String? address,
      @JsonKey(name: 'url_foto') List<String>? imagesUrl});

  $AdConstrutionModelCopyWith<$Res>? get adConstructionModel;
  $UserCopyWith<$Res>? get user;
  $UserCopyWith<$Res>? get executorUser;
}

/// @nodoc
class _$ConstructionRequestModelCopyWithImpl<$Res,
        $Val extends ConstructionRequestModel>
    implements $ConstructionRequestModelCopyWith<$Res> {
  _$ConstructionRequestModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ConstructionRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? adConstructionMaterialId = freezed,
    Object? adConstructionModel = freezed,
    Object? userId = freezed,
    Object? user = freezed,
    Object? executorId = freezed,
    Object? executorUser = freezed,
    Object? description = freezed,
    Object? status = freezed,
    Object? startLeaseAt = freezed,
    Object? endLeaseAt = freezed,
    Object? countHour = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? orderAmount = freezed,
    Object? address = freezed,
    Object? imagesUrl = freezed,
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
      adConstructionMaterialId: freezed == adConstructionMaterialId
          ? _value.adConstructionMaterialId
          : adConstructionMaterialId // ignore: cast_nullable_to_non_nullable
              as int?,
      adConstructionModel: freezed == adConstructionModel
          ? _value.adConstructionModel
          : adConstructionModel // ignore: cast_nullable_to_non_nullable
              as AdConstrutionModel?,
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
      startLeaseAt: freezed == startLeaseAt
          ? _value.startLeaseAt
          : startLeaseAt // ignore: cast_nullable_to_non_nullable
              as String?,
      endLeaseAt: freezed == endLeaseAt
          ? _value.endLeaseAt
          : endLeaseAt // ignore: cast_nullable_to_non_nullable
              as String?,
      countHour: freezed == countHour
          ? _value.countHour
          : countHour // ignore: cast_nullable_to_non_nullable
              as int?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as int?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as int?,
      orderAmount: freezed == orderAmount
          ? _value.orderAmount
          : orderAmount // ignore: cast_nullable_to_non_nullable
              as int?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      imagesUrl: freezed == imagesUrl
          ? _value.imagesUrl
          : imagesUrl // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }

  /// Create a copy of ConstructionRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AdConstrutionModelCopyWith<$Res>? get adConstructionModel {
    if (_value.adConstructionModel == null) {
      return null;
    }

    return $AdConstrutionModelCopyWith<$Res>(_value.adConstructionModel!,
        (value) {
      return _then(_value.copyWith(adConstructionModel: value) as $Val);
    });
  }

  /// Create a copy of ConstructionRequestModel
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

  /// Create a copy of ConstructionRequestModel
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
abstract class _$$ConstructionRequestModelImplCopyWith<$Res>
    implements $ConstructionRequestModelCopyWith<$Res> {
  factory _$$ConstructionRequestModelImplCopyWith(
          _$ConstructionRequestModelImpl value,
          $Res Function(_$ConstructionRequestModelImpl) then) =
      __$$ConstructionRequestModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'created_at') String? createdAt,
      @JsonKey(name: 'updated_at') String? updatedAt,
      @JsonKey(name: 'deleted_at') dynamic deletedAt,
      @JsonKey(name: 'ad_construction_material_id')
      int? adConstructionMaterialId,
      @JsonKey(name: 'ad_construction_material')
      AdConstrutionModel? adConstructionModel,
      @JsonKey(name: 'user_id') dynamic userId,
      User? user,
      @JsonKey(name: 'executor_id') int? executorId,
      @JsonKey(name: 'executor') User? executorUser,
      String? description,
      String? status,
      @JsonKey(name: 'start_lease_at') String? startLeaseAt,
      @JsonKey(name: 'end_lease_at') String? endLeaseAt,
      @JsonKey(name: 'count_hour') int? countHour,
      int? latitude,
      int? longitude,
      @JsonKey(name: 'order_amount') int? orderAmount,
      String? address,
      @JsonKey(name: 'url_foto') List<String>? imagesUrl});

  @override
  $AdConstrutionModelCopyWith<$Res>? get adConstructionModel;
  @override
  $UserCopyWith<$Res>? get user;
  @override
  $UserCopyWith<$Res>? get executorUser;
}

/// @nodoc
class __$$ConstructionRequestModelImplCopyWithImpl<$Res>
    extends _$ConstructionRequestModelCopyWithImpl<$Res,
        _$ConstructionRequestModelImpl>
    implements _$$ConstructionRequestModelImplCopyWith<$Res> {
  __$$ConstructionRequestModelImplCopyWithImpl(
      _$ConstructionRequestModelImpl _value,
      $Res Function(_$ConstructionRequestModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of ConstructionRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? adConstructionMaterialId = freezed,
    Object? adConstructionModel = freezed,
    Object? userId = freezed,
    Object? user = freezed,
    Object? executorId = freezed,
    Object? executorUser = freezed,
    Object? description = freezed,
    Object? status = freezed,
    Object? startLeaseAt = freezed,
    Object? endLeaseAt = freezed,
    Object? countHour = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? orderAmount = freezed,
    Object? address = freezed,
    Object? imagesUrl = freezed,
  }) {
    return _then(_$ConstructionRequestModelImpl(
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
      adConstructionMaterialId: freezed == adConstructionMaterialId
          ? _value.adConstructionMaterialId
          : adConstructionMaterialId // ignore: cast_nullable_to_non_nullable
              as int?,
      adConstructionModel: freezed == adConstructionModel
          ? _value.adConstructionModel
          : adConstructionModel // ignore: cast_nullable_to_non_nullable
              as AdConstrutionModel?,
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
      startLeaseAt: freezed == startLeaseAt
          ? _value.startLeaseAt
          : startLeaseAt // ignore: cast_nullable_to_non_nullable
              as String?,
      endLeaseAt: freezed == endLeaseAt
          ? _value.endLeaseAt
          : endLeaseAt // ignore: cast_nullable_to_non_nullable
              as String?,
      countHour: freezed == countHour
          ? _value.countHour
          : countHour // ignore: cast_nullable_to_non_nullable
              as int?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as int?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as int?,
      orderAmount: freezed == orderAmount
          ? _value.orderAmount
          : orderAmount // ignore: cast_nullable_to_non_nullable
              as int?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      imagesUrl: freezed == imagesUrl
          ? _value._imagesUrl
          : imagesUrl // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ConstructionRequestModelImpl implements _ConstructionRequestModel {
  _$ConstructionRequestModelImpl(
      {this.id,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'deleted_at') this.deletedAt,
      @JsonKey(name: 'ad_construction_material_id')
      this.adConstructionMaterialId,
      @JsonKey(name: 'ad_construction_material') this.adConstructionModel,
      @JsonKey(name: 'user_id') this.userId,
      this.user,
      @JsonKey(name: 'executor_id') this.executorId,
      @JsonKey(name: 'executor') this.executorUser,
      this.description,
      this.status,
      @JsonKey(name: 'start_lease_at') this.startLeaseAt,
      @JsonKey(name: 'end_lease_at') this.endLeaseAt,
      @JsonKey(name: 'count_hour') this.countHour,
      this.latitude,
      this.longitude,
      @JsonKey(name: 'order_amount') this.orderAmount,
      this.address,
      @JsonKey(name: 'url_foto') final List<String>? imagesUrl})
      : _imagesUrl = imagesUrl;

  factory _$ConstructionRequestModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConstructionRequestModelImplFromJson(json);

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
  @JsonKey(name: 'ad_construction_material_id')
  final int? adConstructionMaterialId;
  @override
  @JsonKey(name: 'ad_construction_material')
  final AdConstrutionModel? adConstructionModel;
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
  @JsonKey(name: 'start_lease_at')
  final String? startLeaseAt;
  @override
  @JsonKey(name: 'end_lease_at')
  final String? endLeaseAt;
  @override
  @JsonKey(name: 'count_hour')
  final int? countHour;
  @override
  final int? latitude;
  @override
  final int? longitude;
  @override
  @JsonKey(name: 'order_amount')
  final int? orderAmount;
  @override
  final String? address;
  final List<String>? _imagesUrl;
  @override
  @JsonKey(name: 'url_foto')
  List<String>? get imagesUrl {
    final value = _imagesUrl;
    if (value == null) return null;
    if (_imagesUrl is EqualUnmodifiableListView) return _imagesUrl;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ConstructionRequestModel(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, adConstructionMaterialId: $adConstructionMaterialId, adConstructionModel: $adConstructionModel, userId: $userId, user: $user, executorId: $executorId, executorUser: $executorUser, description: $description, status: $status, startLeaseAt: $startLeaseAt, endLeaseAt: $endLeaseAt, countHour: $countHour, latitude: $latitude, longitude: $longitude, orderAmount: $orderAmount, address: $address, imagesUrl: $imagesUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConstructionRequestModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.deletedAt, deletedAt) &&
            (identical(
                    other.adConstructionMaterialId, adConstructionMaterialId) ||
                other.adConstructionMaterialId == adConstructionMaterialId) &&
            (identical(other.adConstructionModel, adConstructionModel) ||
                other.adConstructionModel == adConstructionModel) &&
            const DeepCollectionEquality().equals(other.userId, userId) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.executorId, executorId) ||
                other.executorId == executorId) &&
            (identical(other.executorUser, executorUser) ||
                other.executorUser == executorUser) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startLeaseAt, startLeaseAt) ||
                other.startLeaseAt == startLeaseAt) &&
            (identical(other.endLeaseAt, endLeaseAt) ||
                other.endLeaseAt == endLeaseAt) &&
            (identical(other.countHour, countHour) ||
                other.countHour == countHour) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.orderAmount, orderAmount) ||
                other.orderAmount == orderAmount) &&
            (identical(other.address, address) || other.address == address) &&
            const DeepCollectionEquality()
                .equals(other._imagesUrl, _imagesUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(deletedAt),
        adConstructionMaterialId,
        adConstructionModel,
        const DeepCollectionEquality().hash(userId),
        user,
        executorId,
        executorUser,
        description,
        status,
        startLeaseAt,
        endLeaseAt,
        countHour,
        latitude,
        longitude,
        orderAmount,
        address,
        const DeepCollectionEquality().hash(_imagesUrl)
      ]);

  /// Create a copy of ConstructionRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConstructionRequestModelImplCopyWith<_$ConstructionRequestModelImpl>
      get copyWith => __$$ConstructionRequestModelImplCopyWithImpl<
          _$ConstructionRequestModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConstructionRequestModelImplToJson(
      this,
    );
  }
}

abstract class _ConstructionRequestModel implements ConstructionRequestModel {
  factory _ConstructionRequestModel(
          {final int? id,
          @JsonKey(name: 'created_at') final String? createdAt,
          @JsonKey(name: 'updated_at') final String? updatedAt,
          @JsonKey(name: 'deleted_at') final dynamic deletedAt,
          @JsonKey(name: 'ad_construction_material_id')
          final int? adConstructionMaterialId,
          @JsonKey(name: 'ad_construction_material')
          final AdConstrutionModel? adConstructionModel,
          @JsonKey(name: 'user_id') final dynamic userId,
          final User? user,
          @JsonKey(name: 'executor_id') final int? executorId,
          @JsonKey(name: 'executor') final User? executorUser,
          final String? description,
          final String? status,
          @JsonKey(name: 'start_lease_at') final String? startLeaseAt,
          @JsonKey(name: 'end_lease_at') final String? endLeaseAt,
          @JsonKey(name: 'count_hour') final int? countHour,
          final int? latitude,
          final int? longitude,
          @JsonKey(name: 'order_amount') final int? orderAmount,
          final String? address,
          @JsonKey(name: 'url_foto') final List<String>? imagesUrl}) =
      _$ConstructionRequestModelImpl;

  factory _ConstructionRequestModel.fromJson(Map<String, dynamic> json) =
      _$ConstructionRequestModelImpl.fromJson;

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
  @JsonKey(name: 'ad_construction_material_id')
  int? get adConstructionMaterialId;
  @override
  @JsonKey(name: 'ad_construction_material')
  AdConstrutionModel? get adConstructionModel;
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
  @override
  @JsonKey(name: 'start_lease_at')
  String? get startLeaseAt;
  @override
  @JsonKey(name: 'end_lease_at')
  String? get endLeaseAt;
  @override
  @JsonKey(name: 'count_hour')
  int? get countHour;
  @override
  int? get latitude;
  @override
  int? get longitude;
  @override
  @JsonKey(name: 'order_amount')
  int? get orderAmount;
  @override
  String? get address;
  @override
  @JsonKey(name: 'url_foto')
  List<String>? get imagesUrl;

  /// Create a copy of ConstructionRequestModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConstructionRequestModelImplCopyWith<_$ConstructionRequestModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
