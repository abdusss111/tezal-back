// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_ad_equipment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RequestAdEquipment _$RequestAdEquipmentFromJson(Map<String, dynamic> json) {
  return _RequestAdEquipment.fromJson(json);
}

/// @nodoc
mixin _$RequestAdEquipment {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;
  @JsonKey(name: 'executor_id')
  int? get executorId => throw _privateConstructorUsedError;
  User? get executor => throw _privateConstructorUsedError;
  @JsonKey(name: 'ad_equipment_id')
  int? get adEquipmentId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ad_equipment')
  AdEquipment? get adEquipment => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_lease_at')
  String? get startLeaseAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_lease_at')
  String? get endLeaseAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'count_hour')
  dynamic get countHour => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_amount')
  dynamic get orderAmount => throw _privateConstructorUsedError;
  @JsonKey(name: 'equipment_sub_category')
  SubCategory? get subCategory => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  City? get city => throw _privateConstructorUsedError;
  @JsonKey(name: 'url_foto')
  List<String>? get urlFoto => throw _privateConstructorUsedError;

  /// Serializes this RequestAdEquipment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RequestAdEquipment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RequestAdEquipmentCopyWith<RequestAdEquipment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestAdEquipmentCopyWith<$Res> {
  factory $RequestAdEquipmentCopyWith(
          RequestAdEquipment value, $Res Function(RequestAdEquipment) then) =
      _$RequestAdEquipmentCopyWithImpl<$Res, RequestAdEquipment>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt,
      String? status,
      @JsonKey(name: 'user_id') int? userId,
      User? user,
      @JsonKey(name: 'executor_id') int? executorId,
      User? executor,
      @JsonKey(name: 'ad_equipment_id') int? adEquipmentId,
      @JsonKey(name: 'ad_equipment') AdEquipment? adEquipment,
      @JsonKey(name: 'start_lease_at') String? startLeaseAt,
      @JsonKey(name: 'end_lease_at') String? endLeaseAt,
      @JsonKey(name: 'count_hour') dynamic countHour,
      @JsonKey(name: 'order_amount') dynamic orderAmount,
      @JsonKey(name: 'equipment_sub_category') SubCategory? subCategory,
      String? description,
      String? address,
      double? latitude,
      double? longitude,
      double? price,
      String? title,
      City? city,
      @JsonKey(name: 'url_foto') List<String>? urlFoto});

  $UserCopyWith<$Res>? get user;
  $UserCopyWith<$Res>? get executor;
  $AdEquipmentCopyWith<$Res>? get adEquipment;
  $SubCategoryCopyWith<$Res>? get subCategory;
  $CityCopyWith<$Res>? get city;
}

/// @nodoc
class _$RequestAdEquipmentCopyWithImpl<$Res, $Val extends RequestAdEquipment>
    implements $RequestAdEquipmentCopyWith<$Res> {
  _$RequestAdEquipmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RequestAdEquipment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? status = freezed,
    Object? userId = freezed,
    Object? user = freezed,
    Object? executorId = freezed,
    Object? executor = freezed,
    Object? adEquipmentId = freezed,
    Object? adEquipment = freezed,
    Object? startLeaseAt = freezed,
    Object? endLeaseAt = freezed,
    Object? countHour = freezed,
    Object? orderAmount = freezed,
    Object? subCategory = freezed,
    Object? description = freezed,
    Object? address = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? price = freezed,
    Object? title = freezed,
    Object? city = freezed,
    Object? urlFoto = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
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
              as DateTime?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
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
      adEquipmentId: freezed == adEquipmentId
          ? _value.adEquipmentId
          : adEquipmentId // ignore: cast_nullable_to_non_nullable
              as int?,
      adEquipment: freezed == adEquipment
          ? _value.adEquipment
          : adEquipment // ignore: cast_nullable_to_non_nullable
              as AdEquipment?,
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
              as dynamic,
      orderAmount: freezed == orderAmount
          ? _value.orderAmount
          : orderAmount // ignore: cast_nullable_to_non_nullable
              as dynamic,
      subCategory: freezed == subCategory
          ? _value.subCategory
          : subCategory // ignore: cast_nullable_to_non_nullable
              as SubCategory?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as City?,
      urlFoto: freezed == urlFoto
          ? _value.urlFoto
          : urlFoto // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }

  /// Create a copy of RequestAdEquipment
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

  /// Create a copy of RequestAdEquipment
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

  /// Create a copy of RequestAdEquipment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AdEquipmentCopyWith<$Res>? get adEquipment {
    if (_value.adEquipment == null) {
      return null;
    }

    return $AdEquipmentCopyWith<$Res>(_value.adEquipment!, (value) {
      return _then(_value.copyWith(adEquipment: value) as $Val);
    });
  }

  /// Create a copy of RequestAdEquipment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SubCategoryCopyWith<$Res>? get subCategory {
    if (_value.subCategory == null) {
      return null;
    }

    return $SubCategoryCopyWith<$Res>(_value.subCategory!, (value) {
      return _then(_value.copyWith(subCategory: value) as $Val);
    });
  }

  /// Create a copy of RequestAdEquipment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CityCopyWith<$Res>? get city {
    if (_value.city == null) {
      return null;
    }

    return $CityCopyWith<$Res>(_value.city!, (value) {
      return _then(_value.copyWith(city: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RequestAdEquipmentImplCopyWith<$Res>
    implements $RequestAdEquipmentCopyWith<$Res> {
  factory _$$RequestAdEquipmentImplCopyWith(_$RequestAdEquipmentImpl value,
          $Res Function(_$RequestAdEquipmentImpl) then) =
      __$$RequestAdEquipmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt,
      String? status,
      @JsonKey(name: 'user_id') int? userId,
      User? user,
      @JsonKey(name: 'executor_id') int? executorId,
      User? executor,
      @JsonKey(name: 'ad_equipment_id') int? adEquipmentId,
      @JsonKey(name: 'ad_equipment') AdEquipment? adEquipment,
      @JsonKey(name: 'start_lease_at') String? startLeaseAt,
      @JsonKey(name: 'end_lease_at') String? endLeaseAt,
      @JsonKey(name: 'count_hour') dynamic countHour,
      @JsonKey(name: 'order_amount') dynamic orderAmount,
      @JsonKey(name: 'equipment_sub_category') SubCategory? subCategory,
      String? description,
      String? address,
      double? latitude,
      double? longitude,
      double? price,
      String? title,
      City? city,
      @JsonKey(name: 'url_foto') List<String>? urlFoto});

  @override
  $UserCopyWith<$Res>? get user;
  @override
  $UserCopyWith<$Res>? get executor;
  @override
  $AdEquipmentCopyWith<$Res>? get adEquipment;
  @override
  $SubCategoryCopyWith<$Res>? get subCategory;
  @override
  $CityCopyWith<$Res>? get city;
}

/// @nodoc
class __$$RequestAdEquipmentImplCopyWithImpl<$Res>
    extends _$RequestAdEquipmentCopyWithImpl<$Res, _$RequestAdEquipmentImpl>
    implements _$$RequestAdEquipmentImplCopyWith<$Res> {
  __$$RequestAdEquipmentImplCopyWithImpl(_$RequestAdEquipmentImpl _value,
      $Res Function(_$RequestAdEquipmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestAdEquipment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? status = freezed,
    Object? userId = freezed,
    Object? user = freezed,
    Object? executorId = freezed,
    Object? executor = freezed,
    Object? adEquipmentId = freezed,
    Object? adEquipment = freezed,
    Object? startLeaseAt = freezed,
    Object? endLeaseAt = freezed,
    Object? countHour = freezed,
    Object? orderAmount = freezed,
    Object? subCategory = freezed,
    Object? description = freezed,
    Object? address = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? price = freezed,
    Object? title = freezed,
    Object? city = freezed,
    Object? urlFoto = freezed,
  }) {
    return _then(_$RequestAdEquipmentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
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
              as DateTime?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
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
      adEquipmentId: freezed == adEquipmentId
          ? _value.adEquipmentId
          : adEquipmentId // ignore: cast_nullable_to_non_nullable
              as int?,
      adEquipment: freezed == adEquipment
          ? _value.adEquipment
          : adEquipment // ignore: cast_nullable_to_non_nullable
              as AdEquipment?,
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
              as dynamic,
      orderAmount: freezed == orderAmount
          ? _value.orderAmount
          : orderAmount // ignore: cast_nullable_to_non_nullable
              as dynamic,
      subCategory: freezed == subCategory
          ? _value.subCategory
          : subCategory // ignore: cast_nullable_to_non_nullable
              as SubCategory?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as City?,
      urlFoto: freezed == urlFoto
          ? _value._urlFoto
          : urlFoto // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RequestAdEquipmentImpl implements _RequestAdEquipment {
  const _$RequestAdEquipmentImpl(
      {required this.id,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'deleted_at') this.deletedAt,
      this.status,
      @JsonKey(name: 'user_id') this.userId,
      this.user,
      @JsonKey(name: 'executor_id') this.executorId,
      this.executor,
      @JsonKey(name: 'ad_equipment_id') this.adEquipmentId,
      @JsonKey(name: 'ad_equipment') this.adEquipment,
      @JsonKey(name: 'start_lease_at') this.startLeaseAt,
      @JsonKey(name: 'end_lease_at') this.endLeaseAt,
      @JsonKey(name: 'count_hour') this.countHour,
      @JsonKey(name: 'order_amount') this.orderAmount,
      @JsonKey(name: 'equipment_sub_category') this.subCategory,
      this.description,
      this.address,
      this.latitude,
      this.longitude,
      this.price,
      this.title,
      this.city,
      @JsonKey(name: 'url_foto') final List<String>? urlFoto})
      : _urlFoto = urlFoto;

  factory _$RequestAdEquipmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequestAdEquipmentImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;
  @override
  final String? status;
  @override
  @JsonKey(name: 'user_id')
  final int? userId;
  @override
  final User? user;
  @override
  @JsonKey(name: 'executor_id')
  final int? executorId;
  @override
  final User? executor;
  @override
  @JsonKey(name: 'ad_equipment_id')
  final int? adEquipmentId;
  @override
  @JsonKey(name: 'ad_equipment')
  final AdEquipment? adEquipment;
  @override
  @JsonKey(name: 'start_lease_at')
  final String? startLeaseAt;
  @override
  @JsonKey(name: 'end_lease_at')
  final String? endLeaseAt;
  @override
  @JsonKey(name: 'count_hour')
  final dynamic countHour;
  @override
  @JsonKey(name: 'order_amount')
  final dynamic orderAmount;
  @override
  @JsonKey(name: 'equipment_sub_category')
  final SubCategory? subCategory;
  @override
  final String? description;
  @override
  final String? address;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final double? price;
  @override
  final String? title;
  @override
  final City? city;
  final List<String>? _urlFoto;
  @override
  @JsonKey(name: 'url_foto')
  List<String>? get urlFoto {
    final value = _urlFoto;
    if (value == null) return null;
    if (_urlFoto is EqualUnmodifiableListView) return _urlFoto;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'RequestAdEquipment(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, status: $status, userId: $userId, user: $user, executorId: $executorId, executor: $executor, adEquipmentId: $adEquipmentId, adEquipment: $adEquipment, startLeaseAt: $startLeaseAt, endLeaseAt: $endLeaseAt, countHour: $countHour, orderAmount: $orderAmount, subCategory: $subCategory, description: $description, address: $address, latitude: $latitude, longitude: $longitude, price: $price, title: $title, city: $city, urlFoto: $urlFoto)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestAdEquipmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.executorId, executorId) ||
                other.executorId == executorId) &&
            (identical(other.executor, executor) ||
                other.executor == executor) &&
            (identical(other.adEquipmentId, adEquipmentId) ||
                other.adEquipmentId == adEquipmentId) &&
            (identical(other.adEquipment, adEquipment) ||
                other.adEquipment == adEquipment) &&
            (identical(other.startLeaseAt, startLeaseAt) ||
                other.startLeaseAt == startLeaseAt) &&
            (identical(other.endLeaseAt, endLeaseAt) ||
                other.endLeaseAt == endLeaseAt) &&
            const DeepCollectionEquality().equals(other.countHour, countHour) &&
            const DeepCollectionEquality()
                .equals(other.orderAmount, orderAmount) &&
            (identical(other.subCategory, subCategory) ||
                other.subCategory == subCategory) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.city, city) || other.city == city) &&
            const DeepCollectionEquality().equals(other._urlFoto, _urlFoto));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        createdAt,
        updatedAt,
        deletedAt,
        status,
        userId,
        user,
        executorId,
        executor,
        adEquipmentId,
        adEquipment,
        startLeaseAt,
        endLeaseAt,
        const DeepCollectionEquality().hash(countHour),
        const DeepCollectionEquality().hash(orderAmount),
        subCategory,
        description,
        address,
        latitude,
        longitude,
        price,
        title,
        city,
        const DeepCollectionEquality().hash(_urlFoto)
      ]);

  /// Create a copy of RequestAdEquipment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestAdEquipmentImplCopyWith<_$RequestAdEquipmentImpl> get copyWith =>
      __$$RequestAdEquipmentImplCopyWithImpl<_$RequestAdEquipmentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestAdEquipmentImplToJson(
      this,
    );
  }
}

abstract class _RequestAdEquipment implements RequestAdEquipment {
  const factory _RequestAdEquipment(
      {required final int id,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') final DateTime? deletedAt,
      final String? status,
      @JsonKey(name: 'user_id') final int? userId,
      final User? user,
      @JsonKey(name: 'executor_id') final int? executorId,
      final User? executor,
      @JsonKey(name: 'ad_equipment_id') final int? adEquipmentId,
      @JsonKey(name: 'ad_equipment') final AdEquipment? adEquipment,
      @JsonKey(name: 'start_lease_at') final String? startLeaseAt,
      @JsonKey(name: 'end_lease_at') final String? endLeaseAt,
      @JsonKey(name: 'count_hour') final dynamic countHour,
      @JsonKey(name: 'order_amount') final dynamic orderAmount,
      @JsonKey(name: 'equipment_sub_category') final SubCategory? subCategory,
      final String? description,
      final String? address,
      final double? latitude,
      final double? longitude,
      final double? price,
      final String? title,
      final City? city,
      @JsonKey(name: 'url_foto')
      final List<String>? urlFoto}) = _$RequestAdEquipmentImpl;

  factory _RequestAdEquipment.fromJson(Map<String, dynamic> json) =
      _$RequestAdEquipmentImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  DateTime? get deletedAt;
  @override
  String? get status;
  @override
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  User? get user;
  @override
  @JsonKey(name: 'executor_id')
  int? get executorId;
  @override
  User? get executor;
  @override
  @JsonKey(name: 'ad_equipment_id')
  int? get adEquipmentId;
  @override
  @JsonKey(name: 'ad_equipment')
  AdEquipment? get adEquipment;
  @override
  @JsonKey(name: 'start_lease_at')
  String? get startLeaseAt;
  @override
  @JsonKey(name: 'end_lease_at')
  String? get endLeaseAt;
  @override
  @JsonKey(name: 'count_hour')
  dynamic get countHour;
  @override
  @JsonKey(name: 'order_amount')
  dynamic get orderAmount;
  @override
  @JsonKey(name: 'equipment_sub_category')
  SubCategory? get subCategory;
  @override
  String? get description;
  @override
  String? get address;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  double? get price;
  @override
  String? get title;
  @override
  City? get city;
  @override
  @JsonKey(name: 'url_foto')
  List<String>? get urlFoto;

  /// Create a copy of RequestAdEquipment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RequestAdEquipmentImplCopyWith<_$RequestAdEquipmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
