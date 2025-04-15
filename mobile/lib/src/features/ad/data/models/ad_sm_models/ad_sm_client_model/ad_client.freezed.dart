// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ad_client.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AdClient _$AdClientFromJson(Map<String, dynamic> json) {
  return _AdClient.fromJson(json);
}

/// @nodoc
mixin _$AdClient {
  int get id => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get headline => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'type_id')
  int? get typeId => throw _privateConstructorUsedError;
  SubCategory? get type => throw _privateConstructorUsedError;
  List<Document>? get documents => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_date')
  String? get startDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_date')
  dynamic get endDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'url_thumbnail')
  List<String>? get urlThumbnail => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  City? get city => throw _privateConstructorUsedError;
  @JsonKey(name: 'city_id')
  int? get cityId => throw _privateConstructorUsedError;

  /// Serializes this AdClient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdClient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdClientCopyWith<AdClient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdClientCopyWith<$Res> {
  factory $AdClientCopyWith(AdClient value, $Res Function(AdClient) then) =
      _$AdClientCopyWithImpl<$Res, AdClient>;
  @useResult
  $Res call(
      {int id,
      String? description,
      String headline,
      double? price,
      @JsonKey(name: 'type_id') int? typeId,
      SubCategory? type,
      List<Document>? documents,
      @JsonKey(name: 'start_date') String? startDate,
      @JsonKey(name: 'end_date') dynamic endDate,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt,
      @JsonKey(name: 'url_thumbnail') List<String>? urlThumbnail,
      User? user,
      String address,
      double? latitude,
      double? longitude,
      String? status,
      City? city,
      @JsonKey(name: 'city_id') int? cityId});

  $SubCategoryCopyWith<$Res>? get type;
  $UserCopyWith<$Res>? get user;
  $CityCopyWith<$Res>? get city;
}

/// @nodoc
class _$AdClientCopyWithImpl<$Res, $Val extends AdClient>
    implements $AdClientCopyWith<$Res> {
  _$AdClientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdClient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = freezed,
    Object? headline = null,
    Object? price = freezed,
    Object? typeId = freezed,
    Object? type = freezed,
    Object? documents = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? urlThumbnail = freezed,
    Object? user = freezed,
    Object? address = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? status = freezed,
    Object? city = freezed,
    Object? cityId = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      headline: null == headline
          ? _value.headline
          : headline // ignore: cast_nullable_to_non_nullable
              as String,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      typeId: freezed == typeId
          ? _value.typeId
          : typeId // ignore: cast_nullable_to_non_nullable
              as int?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SubCategory?,
      documents: freezed == documents
          ? _value.documents
          : documents // ignore: cast_nullable_to_non_nullable
              as List<Document>?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as dynamic,
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
      urlThumbnail: freezed == urlThumbnail
          ? _value.urlThumbnail
          : urlThumbnail // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as City?,
      cityId: freezed == cityId
          ? _value.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  /// Create a copy of AdClient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SubCategoryCopyWith<$Res>? get type {
    if (_value.type == null) {
      return null;
    }

    return $SubCategoryCopyWith<$Res>(_value.type!, (value) {
      return _then(_value.copyWith(type: value) as $Val);
    });
  }

  /// Create a copy of AdClient
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

  /// Create a copy of AdClient
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
abstract class _$$AdClientImplCopyWith<$Res>
    implements $AdClientCopyWith<$Res> {
  factory _$$AdClientImplCopyWith(
          _$AdClientImpl value, $Res Function(_$AdClientImpl) then) =
      __$$AdClientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String? description,
      String headline,
      double? price,
      @JsonKey(name: 'type_id') int? typeId,
      SubCategory? type,
      List<Document>? documents,
      @JsonKey(name: 'start_date') String? startDate,
      @JsonKey(name: 'end_date') dynamic endDate,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt,
      @JsonKey(name: 'url_thumbnail') List<String>? urlThumbnail,
      User? user,
      String address,
      double? latitude,
      double? longitude,
      String? status,
      City? city,
      @JsonKey(name: 'city_id') int? cityId});

  @override
  $SubCategoryCopyWith<$Res>? get type;
  @override
  $UserCopyWith<$Res>? get user;
  @override
  $CityCopyWith<$Res>? get city;
}

/// @nodoc
class __$$AdClientImplCopyWithImpl<$Res>
    extends _$AdClientCopyWithImpl<$Res, _$AdClientImpl>
    implements _$$AdClientImplCopyWith<$Res> {
  __$$AdClientImplCopyWithImpl(
      _$AdClientImpl _value, $Res Function(_$AdClientImpl) _then)
      : super(_value, _then);

  /// Create a copy of AdClient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = freezed,
    Object? headline = null,
    Object? price = freezed,
    Object? typeId = freezed,
    Object? type = freezed,
    Object? documents = freezed,
    Object? startDate = freezed,
    Object? endDate = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? urlThumbnail = freezed,
    Object? user = freezed,
    Object? address = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? status = freezed,
    Object? city = freezed,
    Object? cityId = freezed,
  }) {
    return _then(_$AdClientImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      headline: null == headline
          ? _value.headline
          : headline // ignore: cast_nullable_to_non_nullable
              as String,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double?,
      typeId: freezed == typeId
          ? _value.typeId
          : typeId // ignore: cast_nullable_to_non_nullable
              as int?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SubCategory?,
      documents: freezed == documents
          ? _value._documents
          : documents // ignore: cast_nullable_to_non_nullable
              as List<Document>?,
      startDate: freezed == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as String?,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as dynamic,
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
      urlThumbnail: freezed == urlThumbnail
          ? _value._urlThumbnail
          : urlThumbnail // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as City?,
      cityId: freezed == cityId
          ? _value.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdClientImpl implements _AdClient {
  const _$AdClientImpl(
      {required this.id,
      this.description,
      required this.headline,
      this.price,
      @JsonKey(name: 'type_id') this.typeId,
      this.type,
      final List<Document>? documents,
      @JsonKey(name: 'start_date') this.startDate,
      @JsonKey(name: 'end_date') this.endDate,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'deleted_at') this.deletedAt,
      @JsonKey(name: 'url_thumbnail') final List<String>? urlThumbnail,
      this.user,
      required this.address,
      this.latitude,
      this.longitude,
      this.status,
      this.city,
      @JsonKey(name: 'city_id') this.cityId})
      : _documents = documents,
        _urlThumbnail = urlThumbnail;

  factory _$AdClientImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdClientImplFromJson(json);

  @override
  final int id;
  @override
  final String? description;
  @override
  final String headline;
  @override
  final double? price;
  @override
  @JsonKey(name: 'type_id')
  final int? typeId;
  @override
  final SubCategory? type;
  final List<Document>? _documents;
  @override
  List<Document>? get documents {
    final value = _documents;
    if (value == null) return null;
    if (_documents is EqualUnmodifiableListView) return _documents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(name: 'start_date')
  final String? startDate;
  @override
  @JsonKey(name: 'end_date')
  final dynamic endDate;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @override
  @JsonKey(name: 'deleted_at')
  final DateTime? deletedAt;
  final List<String>? _urlThumbnail;
  @override
  @JsonKey(name: 'url_thumbnail')
  List<String>? get urlThumbnail {
    final value = _urlThumbnail;
    if (value == null) return null;
    if (_urlThumbnail is EqualUnmodifiableListView) return _urlThumbnail;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final User? user;
  @override
  final String address;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String? status;
  @override
  final City? city;
  @override
  @JsonKey(name: 'city_id')
  final int? cityId;

  @override
  String toString() {
    return 'AdClient(id: $id, description: $description, headline: $headline, price: $price, typeId: $typeId, type: $type, documents: $documents, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, urlThumbnail: $urlThumbnail, user: $user, address: $address, latitude: $latitude, longitude: $longitude, status: $status, city: $city, cityId: $cityId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdClientImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.headline, headline) ||
                other.headline == headline) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.typeId, typeId) || other.typeId == typeId) &&
            (identical(other.type, type) || other.type == type) &&
            const DeepCollectionEquality()
                .equals(other._documents, _documents) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            const DeepCollectionEquality().equals(other.endDate, endDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            const DeepCollectionEquality()
                .equals(other._urlThumbnail, _urlThumbnail) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.cityId, cityId) || other.cityId == cityId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        description,
        headline,
        price,
        typeId,
        type,
        const DeepCollectionEquality().hash(_documents),
        startDate,
        const DeepCollectionEquality().hash(endDate),
        createdAt,
        updatedAt,
        deletedAt,
        const DeepCollectionEquality().hash(_urlThumbnail),
        user,
        address,
        latitude,
        longitude,
        status,
        city,
        cityId
      ]);

  /// Create a copy of AdClient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdClientImplCopyWith<_$AdClientImpl> get copyWith =>
      __$$AdClientImplCopyWithImpl<_$AdClientImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdClientImplToJson(
      this,
    );
  }
}

abstract class _AdClient implements AdClient {
  const factory _AdClient(
      {required final int id,
      final String? description,
      required final String headline,
      final double? price,
      @JsonKey(name: 'type_id') final int? typeId,
      final SubCategory? type,
      final List<Document>? documents,
      @JsonKey(name: 'start_date') final String? startDate,
      @JsonKey(name: 'end_date') final dynamic endDate,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') final DateTime? deletedAt,
      @JsonKey(name: 'url_thumbnail') final List<String>? urlThumbnail,
      final User? user,
      required final String address,
      final double? latitude,
      final double? longitude,
      final String? status,
      final City? city,
      @JsonKey(name: 'city_id') final int? cityId}) = _$AdClientImpl;

  factory _AdClient.fromJson(Map<String, dynamic> json) =
      _$AdClientImpl.fromJson;

  @override
  int get id;
  @override
  String? get description;
  @override
  String get headline;
  @override
  double? get price;
  @override
  @JsonKey(name: 'type_id')
  int? get typeId;
  @override
  SubCategory? get type;
  @override
  List<Document>? get documents;
  @override
  @JsonKey(name: 'start_date')
  String? get startDate;
  @override
  @JsonKey(name: 'end_date')
  dynamic get endDate;
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
  @JsonKey(name: 'url_thumbnail')
  List<String>? get urlThumbnail;
  @override
  User? get user;
  @override
  String get address;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  String? get status;
  @override
  City? get city;
  @override
  @JsonKey(name: 'city_id')
  int? get cityId;

  /// Create a copy of AdClient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdClientImplCopyWith<_$AdClientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
