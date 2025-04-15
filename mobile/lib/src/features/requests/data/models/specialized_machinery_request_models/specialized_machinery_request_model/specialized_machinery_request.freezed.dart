// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'specialized_machinery_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SpecializedMachineryRequest _$SpecializedMachineryRequestFromJson(
    Map<String, dynamic> json) {
  return _SpecializedMachineryRequest.fromJson(json);
}

/// @nodoc
mixin _$SpecializedMachineryRequest {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  dynamic get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user')
  User? get user => throw _privateConstructorUsedError;
  @JsonKey(name: 'ad_specialized_machinery_id')
  int? get adSpecializedMachineryId => throw _privateConstructorUsedError;
  @JsonKey(name: 'ad_specialized_machinery')
  AdSpecializedMachinery? get adSpecializedMachinery =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'start_lease_at')
  DateTime? get startLeaseAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_lease_at')
  DateTime? get endLeaseAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'count_hour')
  int? get countHour => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  @JsonKey(name: 'order_amount')
  double? get orderAmount => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'url_foto')
  List<String>? get urlFoto => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;

  /// Serializes this SpecializedMachineryRequest to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpecializedMachineryRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpecializedMachineryRequestCopyWith<SpecializedMachineryRequest>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpecializedMachineryRequestCopyWith<$Res> {
  factory $SpecializedMachineryRequestCopyWith(
          SpecializedMachineryRequest value,
          $Res Function(SpecializedMachineryRequest) then) =
      _$SpecializedMachineryRequestCopyWithImpl<$Res,
          SpecializedMachineryRequest>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') dynamic deletedAt,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'user') User? user,
      @JsonKey(name: 'ad_specialized_machinery_id')
      int? adSpecializedMachineryId,
      @JsonKey(name: 'ad_specialized_machinery')
      AdSpecializedMachinery? adSpecializedMachinery,
      @JsonKey(name: 'start_lease_at') DateTime? startLeaseAt,
      @JsonKey(name: 'end_lease_at') DateTime? endLeaseAt,
      @JsonKey(name: 'count_hour') int? countHour,
      String? address,
      @JsonKey(name: 'order_amount') double? orderAmount,
      String? description,
      String? status,
      @JsonKey(name: 'url_foto') List<String>? urlFoto,
      double? latitude,
      double? longitude});

  $UserCopyWith<$Res>? get user;
  $AdSpecializedMachineryCopyWith<$Res>? get adSpecializedMachinery;
}

/// @nodoc
class _$SpecializedMachineryRequestCopyWithImpl<$Res,
        $Val extends SpecializedMachineryRequest>
    implements $SpecializedMachineryRequestCopyWith<$Res> {
  _$SpecializedMachineryRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpecializedMachineryRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? userId = freezed,
    Object? user = freezed,
    Object? adSpecializedMachineryId = freezed,
    Object? adSpecializedMachinery = freezed,
    Object? startLeaseAt = freezed,
    Object? endLeaseAt = freezed,
    Object? countHour = freezed,
    Object? address = freezed,
    Object? orderAmount = freezed,
    Object? description = freezed,
    Object? status = freezed,
    Object? urlFoto = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
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
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      adSpecializedMachineryId: freezed == adSpecializedMachineryId
          ? _value.adSpecializedMachineryId
          : adSpecializedMachineryId // ignore: cast_nullable_to_non_nullable
              as int?,
      adSpecializedMachinery: freezed == adSpecializedMachinery
          ? _value.adSpecializedMachinery
          : adSpecializedMachinery // ignore: cast_nullable_to_non_nullable
              as AdSpecializedMachinery?,
      startLeaseAt: freezed == startLeaseAt
          ? _value.startLeaseAt
          : startLeaseAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endLeaseAt: freezed == endLeaseAt
          ? _value.endLeaseAt
          : endLeaseAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      countHour: freezed == countHour
          ? _value.countHour
          : countHour // ignore: cast_nullable_to_non_nullable
              as int?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      orderAmount: freezed == orderAmount
          ? _value.orderAmount
          : orderAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      urlFoto: freezed == urlFoto
          ? _value.urlFoto
          : urlFoto // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }

  /// Create a copy of SpecializedMachineryRequest
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

  /// Create a copy of SpecializedMachineryRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AdSpecializedMachineryCopyWith<$Res>? get adSpecializedMachinery {
    if (_value.adSpecializedMachinery == null) {
      return null;
    }

    return $AdSpecializedMachineryCopyWith<$Res>(_value.adSpecializedMachinery!,
        (value) {
      return _then(_value.copyWith(adSpecializedMachinery: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$SpecializedMachineryRequestImplCopyWith<$Res>
    implements $SpecializedMachineryRequestCopyWith<$Res> {
  factory _$$SpecializedMachineryRequestImplCopyWith(
          _$SpecializedMachineryRequestImpl value,
          $Res Function(_$SpecializedMachineryRequestImpl) then) =
      __$$SpecializedMachineryRequestImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') dynamic deletedAt,
      @JsonKey(name: 'user_id') int? userId,
      @JsonKey(name: 'user') User? user,
      @JsonKey(name: 'ad_specialized_machinery_id')
      int? adSpecializedMachineryId,
      @JsonKey(name: 'ad_specialized_machinery')
      AdSpecializedMachinery? adSpecializedMachinery,
      @JsonKey(name: 'start_lease_at') DateTime? startLeaseAt,
      @JsonKey(name: 'end_lease_at') DateTime? endLeaseAt,
      @JsonKey(name: 'count_hour') int? countHour,
      String? address,
      @JsonKey(name: 'order_amount') double? orderAmount,
      String? description,
      String? status,
      @JsonKey(name: 'url_foto') List<String>? urlFoto,
      double? latitude,
      double? longitude});

  @override
  $UserCopyWith<$Res>? get user;
  @override
  $AdSpecializedMachineryCopyWith<$Res>? get adSpecializedMachinery;
}

/// @nodoc
class __$$SpecializedMachineryRequestImplCopyWithImpl<$Res>
    extends _$SpecializedMachineryRequestCopyWithImpl<$Res,
        _$SpecializedMachineryRequestImpl>
    implements _$$SpecializedMachineryRequestImplCopyWith<$Res> {
  __$$SpecializedMachineryRequestImplCopyWithImpl(
      _$SpecializedMachineryRequestImpl _value,
      $Res Function(_$SpecializedMachineryRequestImpl) _then)
      : super(_value, _then);

  /// Create a copy of SpecializedMachineryRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? userId = freezed,
    Object? user = freezed,
    Object? adSpecializedMachineryId = freezed,
    Object? adSpecializedMachinery = freezed,
    Object? startLeaseAt = freezed,
    Object? endLeaseAt = freezed,
    Object? countHour = freezed,
    Object? address = freezed,
    Object? orderAmount = freezed,
    Object? description = freezed,
    Object? status = freezed,
    Object? urlFoto = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
  }) {
    return _then(_$SpecializedMachineryRequestImpl(
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
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      adSpecializedMachineryId: freezed == adSpecializedMachineryId
          ? _value.adSpecializedMachineryId
          : adSpecializedMachineryId // ignore: cast_nullable_to_non_nullable
              as int?,
      adSpecializedMachinery: freezed == adSpecializedMachinery
          ? _value.adSpecializedMachinery
          : adSpecializedMachinery // ignore: cast_nullable_to_non_nullable
              as AdSpecializedMachinery?,
      startLeaseAt: freezed == startLeaseAt
          ? _value.startLeaseAt
          : startLeaseAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endLeaseAt: freezed == endLeaseAt
          ? _value.endLeaseAt
          : endLeaseAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      countHour: freezed == countHour
          ? _value.countHour
          : countHour // ignore: cast_nullable_to_non_nullable
              as int?,
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      orderAmount: freezed == orderAmount
          ? _value.orderAmount
          : orderAmount // ignore: cast_nullable_to_non_nullable
              as double?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      urlFoto: freezed == urlFoto
          ? _value._urlFoto
          : urlFoto // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SpecializedMachineryRequestImpl
    implements _SpecializedMachineryRequest {
  _$SpecializedMachineryRequestImpl(
      {this.id,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'deleted_at') this.deletedAt,
      @JsonKey(name: 'user_id') this.userId,
      @JsonKey(name: 'user') this.user,
      @JsonKey(name: 'ad_specialized_machinery_id')
      this.adSpecializedMachineryId,
      @JsonKey(name: 'ad_specialized_machinery') this.adSpecializedMachinery,
      @JsonKey(name: 'start_lease_at') this.startLeaseAt,
      @JsonKey(name: 'end_lease_at') this.endLeaseAt,
      @JsonKey(name: 'count_hour') this.countHour,
      this.address,
      @JsonKey(name: 'order_amount') this.orderAmount,
      this.description,
      this.status,
      @JsonKey(name: 'url_foto') final List<String>? urlFoto,
      this.latitude,
      this.longitude})
      : _urlFoto = urlFoto;

  factory _$SpecializedMachineryRequestImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$SpecializedMachineryRequestImplFromJson(json);

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
  @JsonKey(name: 'user_id')
  final int? userId;
  @override
  @JsonKey(name: 'user')
  final User? user;
  @override
  @JsonKey(name: 'ad_specialized_machinery_id')
  final int? adSpecializedMachineryId;
  @override
  @JsonKey(name: 'ad_specialized_machinery')
  final AdSpecializedMachinery? adSpecializedMachinery;
  @override
  @JsonKey(name: 'start_lease_at')
  final DateTime? startLeaseAt;
  @override
  @JsonKey(name: 'end_lease_at')
  final DateTime? endLeaseAt;
  @override
  @JsonKey(name: 'count_hour')
  final int? countHour;
  @override
  final String? address;
  @override
  @JsonKey(name: 'order_amount')
  final double? orderAmount;
  @override
  final String? description;
  @override
  final String? status;
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
  final double? latitude;
  @override
  final double? longitude;

  @override
  String toString() {
    return 'SpecializedMachineryRequest(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, userId: $userId, user: $user, adSpecializedMachineryId: $adSpecializedMachineryId, adSpecializedMachinery: $adSpecializedMachinery, startLeaseAt: $startLeaseAt, endLeaseAt: $endLeaseAt, countHour: $countHour, address: $address, orderAmount: $orderAmount, description: $description, status: $status, urlFoto: $urlFoto, latitude: $latitude, longitude: $longitude)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpecializedMachineryRequestImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.deletedAt, deletedAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(
                    other.adSpecializedMachineryId, adSpecializedMachineryId) ||
                other.adSpecializedMachineryId == adSpecializedMachineryId) &&
            (identical(other.adSpecializedMachinery, adSpecializedMachinery) ||
                other.adSpecializedMachinery == adSpecializedMachinery) &&
            (identical(other.startLeaseAt, startLeaseAt) ||
                other.startLeaseAt == startLeaseAt) &&
            (identical(other.endLeaseAt, endLeaseAt) ||
                other.endLeaseAt == endLeaseAt) &&
            (identical(other.countHour, countHour) ||
                other.countHour == countHour) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.orderAmount, orderAmount) ||
                other.orderAmount == orderAmount) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(other._urlFoto, _urlFoto) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(deletedAt),
      userId,
      user,
      adSpecializedMachineryId,
      adSpecializedMachinery,
      startLeaseAt,
      endLeaseAt,
      countHour,
      address,
      orderAmount,
      description,
      status,
      const DeepCollectionEquality().hash(_urlFoto),
      latitude,
      longitude);

  /// Create a copy of SpecializedMachineryRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpecializedMachineryRequestImplCopyWith<_$SpecializedMachineryRequestImpl>
      get copyWith => __$$SpecializedMachineryRequestImplCopyWithImpl<
          _$SpecializedMachineryRequestImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SpecializedMachineryRequestImplToJson(
      this,
    );
  }
}

abstract class _SpecializedMachineryRequest
    implements SpecializedMachineryRequest {
  factory _SpecializedMachineryRequest(
      {final int? id,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') final dynamic deletedAt,
      @JsonKey(name: 'user_id') final int? userId,
      @JsonKey(name: 'user') final User? user,
      @JsonKey(name: 'ad_specialized_machinery_id')
      final int? adSpecializedMachineryId,
      @JsonKey(name: 'ad_specialized_machinery')
      final AdSpecializedMachinery? adSpecializedMachinery,
      @JsonKey(name: 'start_lease_at') final DateTime? startLeaseAt,
      @JsonKey(name: 'end_lease_at') final DateTime? endLeaseAt,
      @JsonKey(name: 'count_hour') final int? countHour,
      final String? address,
      @JsonKey(name: 'order_amount') final double? orderAmount,
      final String? description,
      final String? status,
      @JsonKey(name: 'url_foto') final List<String>? urlFoto,
      final double? latitude,
      final double? longitude}) = _$SpecializedMachineryRequestImpl;

  factory _SpecializedMachineryRequest.fromJson(Map<String, dynamic> json) =
      _$SpecializedMachineryRequestImpl.fromJson;

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
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  @JsonKey(name: 'user')
  User? get user;
  @override
  @JsonKey(name: 'ad_specialized_machinery_id')
  int? get adSpecializedMachineryId;
  @override
  @JsonKey(name: 'ad_specialized_machinery')
  AdSpecializedMachinery? get adSpecializedMachinery;
  @override
  @JsonKey(name: 'start_lease_at')
  DateTime? get startLeaseAt;
  @override
  @JsonKey(name: 'end_lease_at')
  DateTime? get endLeaseAt;
  @override
  @JsonKey(name: 'count_hour')
  int? get countHour;
  @override
  String? get address;
  @override
  @JsonKey(name: 'order_amount')
  double? get orderAmount;
  @override
  String? get description;
  @override
  String? get status;
  @override
  @JsonKey(name: 'url_foto')
  List<String>? get urlFoto;
  @override
  double? get latitude;
  @override
  double? get longitude;

  /// Create a copy of SpecializedMachineryRequest
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpecializedMachineryRequestImplCopyWith<_$SpecializedMachineryRequestImpl>
      get copyWith => throw _privateConstructorUsedError;
}
