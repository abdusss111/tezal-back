// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ad_equipment.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AdEquipment _$AdEquipmentFromJson(Map<String, dynamic> json) {
  return _AdEquipment.fromJson(json);
}

/// @nodoc
mixin _$AdEquipment {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  DateTime? get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'equipment_sub_category', fromJson: SubCategory.getSubCategoryForEQ)
  SubCategory? get subcategory => throw _privateConstructorUsedError;
  City? get city => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;
  @JsonKey(name: 'equipment_brand')
  Brand? get brand => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  @JsonKey(name: 'url_foto')
  List<String>? get urlFoto => throw _privateConstructorUsedError;
  @JsonKey(name: 'url_thumbnail')
  List<String>? get urlThumbnail => throw _privateConstructorUsedError;
  Map<String, dynamic>? get params => throw _privateConstructorUsedError;
  @JsonKey(name: 'city_id')
  int? get cityId => throw _privateConstructorUsedError;

  /// Serializes this AdEquipment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdEquipment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdEquipmentCopyWith<AdEquipment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdEquipmentCopyWith<$Res> {
  factory $AdEquipmentCopyWith(
          AdEquipment value, $Res Function(AdEquipment) then) =
      _$AdEquipmentCopyWithImpl<$Res, AdEquipment>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt,
      @JsonKey(
          name: 'equipment_sub_category',
          fromJson: SubCategory.getSubCategoryForEQ)
      SubCategory? subcategory,
      City? city,
      User? user,
      @JsonKey(name: 'equipment_brand') Brand? brand,
      double price,
      String title,
      String? description,
      String address,
      double? rating,
      double? latitude,
      double? longitude,
      @JsonKey(name: 'url_foto') List<String>? urlFoto,
      @JsonKey(name: 'url_thumbnail') List<String>? urlThumbnail,
      Map<String, dynamic>? params,
      @JsonKey(name: 'city_id') int? cityId});

  $SubCategoryCopyWith<$Res>? get subcategory;
  $CityCopyWith<$Res>? get city;
  $UserCopyWith<$Res>? get user;
  $BrandCopyWith<$Res>? get brand;
}

/// @nodoc
class _$AdEquipmentCopyWithImpl<$Res, $Val extends AdEquipment>
    implements $AdEquipmentCopyWith<$Res> {
  _$AdEquipmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdEquipment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? subcategory = freezed,
    Object? city = freezed,
    Object? user = freezed,
    Object? brand = freezed,
    Object? price = null,
    Object? title = null,
    Object? description = freezed,
    Object? address = null,
    Object? rating = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? urlFoto = freezed,
    Object? urlThumbnail = freezed,
    Object? params = freezed,
    Object? cityId = freezed,
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
      subcategory: freezed == subcategory
          ? _value.subcategory
          : subcategory // ignore: cast_nullable_to_non_nullable
              as SubCategory?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as City?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as Brand?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      urlFoto: freezed == urlFoto
          ? _value.urlFoto
          : urlFoto // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      urlThumbnail: freezed == urlThumbnail
          ? _value.urlThumbnail
          : urlThumbnail // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      params: freezed == params
          ? _value.params
          : params // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      cityId: freezed == cityId
          ? _value.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }

  /// Create a copy of AdEquipment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SubCategoryCopyWith<$Res>? get subcategory {
    if (_value.subcategory == null) {
      return null;
    }

    return $SubCategoryCopyWith<$Res>(_value.subcategory!, (value) {
      return _then(_value.copyWith(subcategory: value) as $Val);
    });
  }

  /// Create a copy of AdEquipment
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

  /// Create a copy of AdEquipment
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

  /// Create a copy of AdEquipment
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
}

/// @nodoc
abstract class _$$AdEquipmentImplCopyWith<$Res>
    implements $AdEquipmentCopyWith<$Res> {
  factory _$$AdEquipmentImplCopyWith(
          _$AdEquipmentImpl value, $Res Function(_$AdEquipmentImpl) then) =
      __$$AdEquipmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') DateTime? deletedAt,
      @JsonKey(
          name: 'equipment_sub_category',
          fromJson: SubCategory.getSubCategoryForEQ)
      SubCategory? subcategory,
      City? city,
      User? user,
      @JsonKey(name: 'equipment_brand') Brand? brand,
      double price,
      String title,
      String? description,
      String address,
      double? rating,
      double? latitude,
      double? longitude,
      @JsonKey(name: 'url_foto') List<String>? urlFoto,
      @JsonKey(name: 'url_thumbnail') List<String>? urlThumbnail,
      Map<String, dynamic>? params,
      @JsonKey(name: 'city_id') int? cityId});

  @override
  $SubCategoryCopyWith<$Res>? get subcategory;
  @override
  $CityCopyWith<$Res>? get city;
  @override
  $UserCopyWith<$Res>? get user;
  @override
  $BrandCopyWith<$Res>? get brand;
}

/// @nodoc
class __$$AdEquipmentImplCopyWithImpl<$Res>
    extends _$AdEquipmentCopyWithImpl<$Res, _$AdEquipmentImpl>
    implements _$$AdEquipmentImplCopyWith<$Res> {
  __$$AdEquipmentImplCopyWithImpl(
      _$AdEquipmentImpl _value, $Res Function(_$AdEquipmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of AdEquipment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? subcategory = freezed,
    Object? city = freezed,
    Object? user = freezed,
    Object? brand = freezed,
    Object? price = null,
    Object? title = null,
    Object? description = freezed,
    Object? address = null,
    Object? rating = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? urlFoto = freezed,
    Object? urlThumbnail = freezed,
    Object? params = freezed,
    Object? cityId = freezed,
  }) {
    return _then(_$AdEquipmentImpl(
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
      subcategory: freezed == subcategory
          ? _value.subcategory
          : subcategory // ignore: cast_nullable_to_non_nullable
              as SubCategory?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as City?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as Brand?,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      address: null == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      urlFoto: freezed == urlFoto
          ? _value._urlFoto
          : urlFoto // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      urlThumbnail: freezed == urlThumbnail
          ? _value._urlThumbnail
          : urlThumbnail // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      params: freezed == params
          ? _value._params
          : params // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      cityId: freezed == cityId
          ? _value.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdEquipmentImpl implements _AdEquipment {
  const _$AdEquipmentImpl(
      {required this.id,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'deleted_at') this.deletedAt,
      @JsonKey(
          name: 'equipment_sub_category',
          fromJson: SubCategory.getSubCategoryForEQ)
      this.subcategory,
      this.city,
      this.user,
      @JsonKey(name: 'equipment_brand') this.brand,
      required this.price,
      required this.title,
      this.description,
      required this.address,
      this.rating,
      this.latitude,
      this.longitude,
      @JsonKey(name: 'url_foto') final List<String>? urlFoto,
      @JsonKey(name: 'url_thumbnail') final List<String>? urlThumbnail,
      final Map<String, dynamic>? params,
      @JsonKey(name: 'city_id') this.cityId})
      : _urlFoto = urlFoto,
        _urlThumbnail = urlThumbnail,
        _params = params;

  factory _$AdEquipmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdEquipmentImplFromJson(json);

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
  @JsonKey(
      name: 'equipment_sub_category', fromJson: SubCategory.getSubCategoryForEQ)
  final SubCategory? subcategory;
  @override
  final City? city;
  @override
  final User? user;
  @override
  @JsonKey(name: 'equipment_brand')
  final Brand? brand;
  @override
  final double price;
  @override
  final String title;
  @override
  final String? description;
  @override
  final String address;
  @override
  final double? rating;
  @override
  final double? latitude;
  @override
  final double? longitude;
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

  final Map<String, dynamic>? _params;
  @override
  Map<String, dynamic>? get params {
    final value = _params;
    if (value == null) return null;
    if (_params is EqualUnmodifiableMapView) return _params;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  @JsonKey(name: 'city_id')
  final int? cityId;

  @override
  String toString() {
    return 'AdEquipment(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, subcategory: $subcategory, city: $city, user: $user, brand: $brand, price: $price, title: $title, description: $description, address: $address, rating: $rating, latitude: $latitude, longitude: $longitude, urlFoto: $urlFoto, urlThumbnail: $urlThumbnail, params: $params, cityId: $cityId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdEquipmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.subcategory, subcategory) ||
                other.subcategory == subcategory) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            const DeepCollectionEquality().equals(other._urlFoto, _urlFoto) &&
            const DeepCollectionEquality()
                .equals(other._urlThumbnail, _urlThumbnail) &&
            const DeepCollectionEquality().equals(other._params, _params) &&
            (identical(other.cityId, cityId) || other.cityId == cityId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        createdAt,
        updatedAt,
        deletedAt,
        subcategory,
        city,
        user,
        brand,
        price,
        title,
        description,
        address,
        rating,
        latitude,
        longitude,
        const DeepCollectionEquality().hash(_urlFoto),
        const DeepCollectionEquality().hash(_urlThumbnail),
        const DeepCollectionEquality().hash(_params),
        cityId
      ]);

  /// Create a copy of AdEquipment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdEquipmentImplCopyWith<_$AdEquipmentImpl> get copyWith =>
      __$$AdEquipmentImplCopyWithImpl<_$AdEquipmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdEquipmentImplToJson(
      this,
    );
  }
}

abstract class _AdEquipment implements AdEquipment {
  const factory _AdEquipment(
      {required final int id,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') final DateTime? deletedAt,
      @JsonKey(
          name: 'equipment_sub_category',
          fromJson: SubCategory.getSubCategoryForEQ)
      final SubCategory? subcategory,
      final City? city,
      final User? user,
      @JsonKey(name: 'equipment_brand') final Brand? brand,
      required final double price,
      required final String title,
      final String? description,
      required final String address,
      final double? rating,
      final double? latitude,
      final double? longitude,
      @JsonKey(name: 'url_foto') final List<String>? urlFoto,
      @JsonKey(name: 'url_thumbnail') final List<String>? urlThumbnail,
      final Map<String, dynamic>? params,
      @JsonKey(name: 'city_id') final int? cityId}) = _$AdEquipmentImpl;

  factory _AdEquipment.fromJson(Map<String, dynamic> json) =
      _$AdEquipmentImpl.fromJson;

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
  @JsonKey(
      name: 'equipment_sub_category', fromJson: SubCategory.getSubCategoryForEQ)
  SubCategory? get subcategory;
  @override
  City? get city;
  @override
  User? get user;
  @override
  @JsonKey(name: 'equipment_brand')
  Brand? get brand;
  @override
  double get price;
  @override
  String get title;
  @override
  String? get description;
  @override
  String get address;
  @override
  double? get rating;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  @JsonKey(name: 'url_foto')
  List<String>? get urlFoto;
  @override
  @JsonKey(name: 'url_thumbnail')
  List<String>? get urlThumbnail;
  @override
  Map<String, dynamic>? get params;
  @override
  @JsonKey(name: 'city_id')
  int? get cityId;

  /// Create a copy of AdEquipment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdEquipmentImplCopyWith<_$AdEquipmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
