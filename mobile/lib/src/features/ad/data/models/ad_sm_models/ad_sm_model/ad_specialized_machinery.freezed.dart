// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ad_specialized_machinery.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AdSpecializedMachinery _$AdSpecializedMachineryFromJson(
    Map<String, dynamic> json) {
  return _AdSpecializedMachinery.fromJson(json);
}

/// @nodoc
mixin _$AdSpecializedMachinery {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;
  @JsonKey(name: 'brand_id')
  int? get brandId => throw _privateConstructorUsedError;
  Brand? get brand => throw _privateConstructorUsedError;
  @JsonKey(name: 'type_id')
  int? get typeId => throw _privateConstructorUsedError;
  SubCategory? get type => throw _privateConstructorUsedError;
  @JsonKey(name: 'city_id')
  int? get cityId => throw _privateConstructorUsedError;
  City? get city => throw _privateConstructorUsedError;
  int? get price => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'count_rate')
  int? get countRate => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  @JsonKey(name: 'url_foto')
  List<String>? get urlFoto => throw _privateConstructorUsedError;
  @JsonKey(name: 'url_thumbnail')
  List<String>? get urlThumbnail => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  Params? get params => throw _privateConstructorUsedError;

  /// Serializes this AdSpecializedMachinery to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdSpecializedMachinery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdSpecializedMachineryCopyWith<AdSpecializedMachinery> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdSpecializedMachineryCopyWith<$Res> {
  factory $AdSpecializedMachineryCopyWith(AdSpecializedMachinery value,
          $Res Function(AdSpecializedMachinery) then) =
      _$AdSpecializedMachineryCopyWithImpl<$Res, AdSpecializedMachinery>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt,
      @JsonKey(name: 'user_id') int? userId,
      User? user,
      @JsonKey(name: 'brand_id') int? brandId,
      Brand? brand,
      @JsonKey(name: 'type_id') int? typeId,
      SubCategory? type,
      @JsonKey(name: 'city_id') int? cityId,
      City? city,
      int? price,
      String? name,
      String? description,
      @JsonKey(name: 'count_rate') int? countRate,
      double? rating,
      @JsonKey(name: 'url_foto') List<String>? urlFoto,
      @JsonKey(name: 'url_thumbnail') List<String>? urlThumbnail,
      String? address,
      double? latitude,
      double? longitude,
      Params? params});

  $UserCopyWith<$Res>? get user;
  $BrandCopyWith<$Res>? get brand;
  $SubCategoryCopyWith<$Res>? get type;
  $CityCopyWith<$Res>? get city;
  $ParamsCopyWith<$Res>? get params;
}

/// @nodoc
class _$AdSpecializedMachineryCopyWithImpl<$Res,
        $Val extends AdSpecializedMachinery>
    implements $AdSpecializedMachineryCopyWith<$Res> {
  _$AdSpecializedMachineryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdSpecializedMachinery
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
    Object? brandId = freezed,
    Object? brand = freezed,
    Object? typeId = freezed,
    Object? type = freezed,
    Object? cityId = freezed,
    Object? city = freezed,
    Object? price = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? countRate = freezed,
    Object? rating = freezed,
    Object? urlFoto = freezed,
    Object? urlThumbnail = freezed,
    Object? address = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? params = freezed,
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
              as DateTime?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      brandId: freezed == brandId
          ? _value.brandId
          : brandId // ignore: cast_nullable_to_non_nullable
              as int?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as Brand?,
      typeId: freezed == typeId
          ? _value.typeId
          : typeId // ignore: cast_nullable_to_non_nullable
              as int?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SubCategory?,
      cityId: freezed == cityId
          ? _value.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as int?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as City?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      countRate: freezed == countRate
          ? _value.countRate
          : countRate // ignore: cast_nullable_to_non_nullable
              as int?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      urlFoto: freezed == urlFoto
          ? _value.urlFoto
          : urlFoto // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      urlThumbnail: freezed == urlThumbnail
          ? _value.urlThumbnail
          : urlThumbnail // ignore: cast_nullable_to_non_nullable
              as List<String>?,
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
      params: freezed == params
          ? _value.params
          : params // ignore: cast_nullable_to_non_nullable
              as Params?,
    ) as $Val);
  }

  /// Create a copy of AdSpecializedMachinery
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

  /// Create a copy of AdSpecializedMachinery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BrandCopyWith<$Res>? get brand {
    if (_value.brand == null) {
      return null;
    }

    return $BrandCopyWith<$Res>(_value.brand!, (value) {
      return _then(_value.copyWith(brand: value) as $Val);
    });
  }

  /// Create a copy of AdSpecializedMachinery
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

  /// Create a copy of AdSpecializedMachinery
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

  /// Create a copy of AdSpecializedMachinery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ParamsCopyWith<$Res>? get params {
    if (_value.params == null) {
      return null;
    }

    return $ParamsCopyWith<$Res>(_value.params!, (value) {
      return _then(_value.copyWith(params: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AdSpecializedMachineryImplCopyWith<$Res>
    implements $AdSpecializedMachineryCopyWith<$Res> {
  factory _$$AdSpecializedMachineryImplCopyWith(
          _$AdSpecializedMachineryImpl value,
          $Res Function(_$AdSpecializedMachineryImpl) then) =
      __$$AdSpecializedMachineryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt,
      @JsonKey(name: 'user_id') int? userId,
      User? user,
      @JsonKey(name: 'brand_id') int? brandId,
      Brand? brand,
      @JsonKey(name: 'type_id') int? typeId,
      SubCategory? type,
      @JsonKey(name: 'city_id') int? cityId,
      City? city,
      int? price,
      String? name,
      String? description,
      @JsonKey(name: 'count_rate') int? countRate,
      double? rating,
      @JsonKey(name: 'url_foto') List<String>? urlFoto,
      @JsonKey(name: 'url_thumbnail') List<String>? urlThumbnail,
      String? address,
      double? latitude,
      double? longitude,
      Params? params});

  @override
  $UserCopyWith<$Res>? get user;
  @override
  $BrandCopyWith<$Res>? get brand;
  @override
  $SubCategoryCopyWith<$Res>? get type;
  @override
  $CityCopyWith<$Res>? get city;
  @override
  $ParamsCopyWith<$Res>? get params;
}

/// @nodoc
class __$$AdSpecializedMachineryImplCopyWithImpl<$Res>
    extends _$AdSpecializedMachineryCopyWithImpl<$Res,
        _$AdSpecializedMachineryImpl>
    implements _$$AdSpecializedMachineryImplCopyWith<$Res> {
  __$$AdSpecializedMachineryImplCopyWithImpl(
      _$AdSpecializedMachineryImpl _value,
      $Res Function(_$AdSpecializedMachineryImpl) _then)
      : super(_value, _then);

  /// Create a copy of AdSpecializedMachinery
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
    Object? brandId = freezed,
    Object? brand = freezed,
    Object? typeId = freezed,
    Object? type = freezed,
    Object? cityId = freezed,
    Object? city = freezed,
    Object? price = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? countRate = freezed,
    Object? rating = freezed,
    Object? urlFoto = freezed,
    Object? urlThumbnail = freezed,
    Object? address = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? params = freezed,
  }) {
    return _then(_$AdSpecializedMachineryImpl(
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
              as DateTime?,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      brandId: freezed == brandId
          ? _value.brandId
          : brandId // ignore: cast_nullable_to_non_nullable
              as int?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as Brand?,
      typeId: freezed == typeId
          ? _value.typeId
          : typeId // ignore: cast_nullable_to_non_nullable
              as int?,
      type: freezed == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SubCategory?,
      cityId: freezed == cityId
          ? _value.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as int?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as City?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      countRate: freezed == countRate
          ? _value.countRate
          : countRate // ignore: cast_nullable_to_non_nullable
              as int?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      urlFoto: freezed == urlFoto
          ? _value._urlFoto
          : urlFoto // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      urlThumbnail: freezed == urlThumbnail
          ? _value._urlThumbnail
          : urlThumbnail // ignore: cast_nullable_to_non_nullable
              as List<String>?,
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
      params: freezed == params
          ? _value.params
          : params // ignore: cast_nullable_to_non_nullable
              as Params?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdSpecializedMachineryImpl implements _AdSpecializedMachinery {
  _$AdSpecializedMachineryImpl(
      {this.id,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'deleted_at') this.deletedAt,
      @JsonKey(name: 'user_id') this.userId,
      this.user,
      @JsonKey(name: 'brand_id') this.brandId,
      this.brand,
      @JsonKey(name: 'type_id') this.typeId,
      this.type,
      @JsonKey(name: 'city_id') this.cityId,
      this.city,
      this.price,
      this.name,
      this.description,
      @JsonKey(name: 'count_rate') this.countRate,
      this.rating,
      @JsonKey(name: 'url_foto') final List<String>? urlFoto,
      @JsonKey(name: 'url_thumbnail') final List<String>? urlThumbnail,
      this.address,
      this.latitude,
      this.longitude,
      this.params})
      : _urlFoto = urlFoto,
        _urlThumbnail = urlThumbnail;

  factory _$AdSpecializedMachineryImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdSpecializedMachineryImplFromJson(json);

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
  final DateTime? deletedAt;
  @override
  @JsonKey(name: 'user_id')
  final int? userId;
  @override
  final User? user;
  @override
  @JsonKey(name: 'brand_id')
  final int? brandId;
  @override
  final Brand? brand;
  @override
  @JsonKey(name: 'type_id')
  final int? typeId;
  @override
  final SubCategory? type;
  @override
  @JsonKey(name: 'city_id')
  final int? cityId;
  @override
  final City? city;
  @override
  final int? price;
  @override
  final String? name;
  @override
  final String? description;
  @override
  @JsonKey(name: 'count_rate')
  final int? countRate;
  @override
  final double? rating;
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
  final String? address;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final Params? params;

  @override
  String toString() {
    return 'AdSpecializedMachinery(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, userId: $userId, user: $user, brandId: $brandId, brand: $brand, typeId: $typeId, type: $type, cityId: $cityId, city: $city, price: $price, name: $name, description: $description, countRate: $countRate, rating: $rating, urlFoto: $urlFoto, urlThumbnail: $urlThumbnail, address: $address, latitude: $latitude, longitude: $longitude, params: $params)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdSpecializedMachineryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.brandId, brandId) || other.brandId == brandId) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.typeId, typeId) || other.typeId == typeId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.countRate, countRate) ||
                other.countRate == countRate) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            const DeepCollectionEquality().equals(other._urlFoto, _urlFoto) &&
            const DeepCollectionEquality()
                .equals(other._urlThumbnail, _urlThumbnail) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.params, params) || other.params == params));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        createdAt,
        updatedAt,
        deletedAt,
        userId,
        user,
        brandId,
        brand,
        typeId,
        type,
        cityId,
        city,
        price,
        name,
        description,
        countRate,
        rating,
        const DeepCollectionEquality().hash(_urlFoto),
        const DeepCollectionEquality().hash(_urlThumbnail),
        address,
        latitude,
        longitude,
        params
      ]);

  /// Create a copy of AdSpecializedMachinery
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdSpecializedMachineryImplCopyWith<_$AdSpecializedMachineryImpl>
      get copyWith => __$$AdSpecializedMachineryImplCopyWithImpl<
          _$AdSpecializedMachineryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdSpecializedMachineryImplToJson(
      this,
    );
  }
}

abstract class _AdSpecializedMachinery implements AdSpecializedMachinery {
  factory _AdSpecializedMachinery(
      {final int? id,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') final DateTime? deletedAt,
      @JsonKey(name: 'user_id') final int? userId,
      final User? user,
      @JsonKey(name: 'brand_id') final int? brandId,
      final Brand? brand,
      @JsonKey(name: 'type_id') final int? typeId,
      final SubCategory? type,
      @JsonKey(name: 'city_id') final int? cityId,
      final City? city,
      final int? price,
      final String? name,
      final String? description,
      @JsonKey(name: 'count_rate') final int? countRate,
      final double? rating,
      @JsonKey(name: 'url_foto') final List<String>? urlFoto,
      @JsonKey(name: 'url_thumbnail') final List<String>? urlThumbnail,
      final String? address,
      final double? latitude,
      final double? longitude,
      final Params? params}) = _$AdSpecializedMachineryImpl;

  factory _AdSpecializedMachinery.fromJson(Map<String, dynamic> json) =
      _$AdSpecializedMachineryImpl.fromJson;

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
  DateTime? get deletedAt;
  @override
  @JsonKey(name: 'user_id')
  int? get userId;
  @override
  User? get user;
  @override
  @JsonKey(name: 'brand_id')
  int? get brandId;
  @override
  Brand? get brand;
  @override
  @JsonKey(name: 'type_id')
  int? get typeId;
  @override
  SubCategory? get type;
  @override
  @JsonKey(name: 'city_id')
  int? get cityId;
  @override
  City? get city;
  @override
  int? get price;
  @override
  String? get name;
  @override
  String? get description;
  @override
  @JsonKey(name: 'count_rate')
  int? get countRate;
  @override
  double? get rating;
  @override
  @JsonKey(name: 'url_foto')
  List<String>? get urlFoto;
  @override
  @JsonKey(name: 'url_thumbnail')
  List<String>? get urlThumbnail;
  @override
  String? get address;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  Params? get params;

  /// Create a copy of AdSpecializedMachinery
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdSpecializedMachineryImplCopyWith<_$AdSpecializedMachineryImpl>
      get copyWith => throw _privateConstructorUsedError;
}
