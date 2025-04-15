// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ad_service_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AdServiceModel _$AdServiceModelFromJson(Map<String, dynamic> json) {
  return _AdServiceModel.fromJson(json);
}

/// @nodoc
mixin _$AdServiceModel {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: "created_at")
  String? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: "updated_at")
  String? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: "deleted_at")
  String? get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userID => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_brand_id')
  int? get brandID => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_brand')
  Brand? get brand => throw _privateConstructorUsedError;
  @JsonKey(name: 'service_sub_category_id')
  int? get subCategoryID => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'service_sub_category', fromJson: SubCategory.getSubCategoryForSVM)
  SubCategory? get subcategory => throw _privateConstructorUsedError;
  @JsonKey(name: 'city_id')
  int? get cityId => throw _privateConstructorUsedError;
  @JsonKey(name: 'city')
  City? get city => throw _privateConstructorUsedError;
  int? get price => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  Map<String, dynamic>? get params => throw _privateConstructorUsedError;
  List<dynamic>? get document => throw _privateConstructorUsedError;
  @JsonKey(name: 'url_foto')
  List<String>? get urlFoto => throw _privateConstructorUsedError;
  @JsonKey(name: 'url_thumbnail')
  List<String>? get urlThumbnail => throw _privateConstructorUsedError;
  @JsonKey(name: 'count_rate')
  double? get countRate => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;

  /// Serializes this AdServiceModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdServiceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdServiceModelCopyWith<AdServiceModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdServiceModelCopyWith<$Res> {
  factory $AdServiceModelCopyWith(
          AdServiceModel value, $Res Function(AdServiceModel) then) =
      _$AdServiceModelCopyWithImpl<$Res, AdServiceModel>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: "created_at") String? createdAt,
      @JsonKey(name: "updated_at") String? updatedAt,
      @JsonKey(name: "deleted_at") String? deletedAt,
      @JsonKey(name: 'user_id') int? userID,
      User? user,
      @JsonKey(name: 'service_brand_id') int? brandID,
      @JsonKey(name: 'service_brand') Brand? brand,
      @JsonKey(name: 'service_sub_category_id') int? subCategoryID,
      @JsonKey(
          name: 'service_sub_category',
          fromJson: SubCategory.getSubCategoryForSVM)
      SubCategory? subcategory,
      @JsonKey(name: 'city_id') int? cityId,
      @JsonKey(name: 'city') City? city,
      int? price,
      String? title,
      String? description,
      String? address,
      double? latitude,
      double? longitude,
      Map<String, dynamic>? params,
      List<dynamic>? document,
      @JsonKey(name: 'url_foto') List<String>? urlFoto,
      @JsonKey(name: 'url_thumbnail') List<String>? urlThumbnail,
      @JsonKey(name: 'count_rate') double? countRate,
      double? rating});

  $UserCopyWith<$Res>? get user;
  $BrandCopyWith<$Res>? get brand;
  $SubCategoryCopyWith<$Res>? get subcategory;
  $CityCopyWith<$Res>? get city;
}

/// @nodoc
class _$AdServiceModelCopyWithImpl<$Res, $Val extends AdServiceModel>
    implements $AdServiceModelCopyWith<$Res> {
  _$AdServiceModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdServiceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? userID = freezed,
    Object? user = freezed,
    Object? brandID = freezed,
    Object? brand = freezed,
    Object? subCategoryID = freezed,
    Object? subcategory = freezed,
    Object? cityId = freezed,
    Object? city = freezed,
    Object? price = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? address = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? params = freezed,
    Object? document = freezed,
    Object? urlFoto = freezed,
    Object? urlThumbnail = freezed,
    Object? countRate = freezed,
    Object? rating = freezed,
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
              as String?,
      userID: freezed == userID
          ? _value.userID
          : userID // ignore: cast_nullable_to_non_nullable
              as int?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      brandID: freezed == brandID
          ? _value.brandID
          : brandID // ignore: cast_nullable_to_non_nullable
              as int?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as Brand?,
      subCategoryID: freezed == subCategoryID
          ? _value.subCategoryID
          : subCategoryID // ignore: cast_nullable_to_non_nullable
              as int?,
      subcategory: freezed == subcategory
          ? _value.subcategory
          : subcategory // ignore: cast_nullable_to_non_nullable
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
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
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
      params: freezed == params
          ? _value.params
          : params // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      document: freezed == document
          ? _value.document
          : document // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      urlFoto: freezed == urlFoto
          ? _value.urlFoto
          : urlFoto // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      urlThumbnail: freezed == urlThumbnail
          ? _value.urlThumbnail
          : urlThumbnail // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      countRate: freezed == countRate
          ? _value.countRate
          : countRate // ignore: cast_nullable_to_non_nullable
              as double?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }

  /// Create a copy of AdServiceModel
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

  /// Create a copy of AdServiceModel
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

  /// Create a copy of AdServiceModel
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

  /// Create a copy of AdServiceModel
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
abstract class _$$AdServiceModelImplCopyWith<$Res>
    implements $AdServiceModelCopyWith<$Res> {
  factory _$$AdServiceModelImplCopyWith(_$AdServiceModelImpl value,
          $Res Function(_$AdServiceModelImpl) then) =
      __$$AdServiceModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: "created_at") String? createdAt,
      @JsonKey(name: "updated_at") String? updatedAt,
      @JsonKey(name: "deleted_at") String? deletedAt,
      @JsonKey(name: 'user_id') int? userID,
      User? user,
      @JsonKey(name: 'service_brand_id') int? brandID,
      @JsonKey(name: 'service_brand') Brand? brand,
      @JsonKey(name: 'service_sub_category_id') int? subCategoryID,
      @JsonKey(
          name: 'service_sub_category',
          fromJson: SubCategory.getSubCategoryForSVM)
      SubCategory? subcategory,
      @JsonKey(name: 'city_id') int? cityId,
      @JsonKey(name: 'city') City? city,
      int? price,
      String? title,
      String? description,
      String? address,
      double? latitude,
      double? longitude,
      Map<String, dynamic>? params,
      List<dynamic>? document,
      @JsonKey(name: 'url_foto') List<String>? urlFoto,
      @JsonKey(name: 'url_thumbnail') List<String>? urlThumbnail,
      @JsonKey(name: 'count_rate') double? countRate,
      double? rating});

  @override
  $UserCopyWith<$Res>? get user;
  @override
  $BrandCopyWith<$Res>? get brand;
  @override
  $SubCategoryCopyWith<$Res>? get subcategory;
  @override
  $CityCopyWith<$Res>? get city;
}

/// @nodoc
class __$$AdServiceModelImplCopyWithImpl<$Res>
    extends _$AdServiceModelCopyWithImpl<$Res, _$AdServiceModelImpl>
    implements _$$AdServiceModelImplCopyWith<$Res> {
  __$$AdServiceModelImplCopyWithImpl(
      _$AdServiceModelImpl _value, $Res Function(_$AdServiceModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AdServiceModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? userID = freezed,
    Object? user = freezed,
    Object? brandID = freezed,
    Object? brand = freezed,
    Object? subCategoryID = freezed,
    Object? subcategory = freezed,
    Object? cityId = freezed,
    Object? city = freezed,
    Object? price = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? address = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? params = freezed,
    Object? document = freezed,
    Object? urlFoto = freezed,
    Object? urlThumbnail = freezed,
    Object? countRate = freezed,
    Object? rating = freezed,
  }) {
    return _then(_$AdServiceModelImpl(
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
              as String?,
      userID: freezed == userID
          ? _value.userID
          : userID // ignore: cast_nullable_to_non_nullable
              as int?,
      user: freezed == user
          ? _value.user
          : user // ignore: cast_nullable_to_non_nullable
              as User?,
      brandID: freezed == brandID
          ? _value.brandID
          : brandID // ignore: cast_nullable_to_non_nullable
              as int?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as Brand?,
      subCategoryID: freezed == subCategoryID
          ? _value.subCategoryID
          : subCategoryID // ignore: cast_nullable_to_non_nullable
              as int?,
      subcategory: freezed == subcategory
          ? _value.subcategory
          : subcategory // ignore: cast_nullable_to_non_nullable
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
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
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
      params: freezed == params
          ? _value._params
          : params // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      document: freezed == document
          ? _value._document
          : document // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      urlFoto: freezed == urlFoto
          ? _value._urlFoto
          : urlFoto // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      urlThumbnail: freezed == urlThumbnail
          ? _value._urlThumbnail
          : urlThumbnail // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      countRate: freezed == countRate
          ? _value.countRate
          : countRate // ignore: cast_nullable_to_non_nullable
              as double?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdServiceModelImpl implements _AdServiceModel {
  const _$AdServiceModelImpl(
      {this.id,
      @JsonKey(name: "created_at") this.createdAt,
      @JsonKey(name: "updated_at") this.updatedAt,
      @JsonKey(name: "deleted_at") this.deletedAt,
      @JsonKey(name: 'user_id') this.userID,
      this.user,
      @JsonKey(name: 'service_brand_id') this.brandID,
      @JsonKey(name: 'service_brand') this.brand,
      @JsonKey(name: 'service_sub_category_id') this.subCategoryID,
      @JsonKey(
          name: 'service_sub_category',
          fromJson: SubCategory.getSubCategoryForSVM)
      this.subcategory,
      @JsonKey(name: 'city_id') this.cityId,
      @JsonKey(name: 'city') this.city,
      this.price,
      this.title,
      this.description,
      this.address,
      this.latitude,
      this.longitude,
      final Map<String, dynamic>? params,
      final List<dynamic>? document,
      @JsonKey(name: 'url_foto') final List<String>? urlFoto,
      @JsonKey(name: 'url_thumbnail') final List<String>? urlThumbnail,
      @JsonKey(name: 'count_rate') this.countRate,
      this.rating})
      : _params = params,
        _document = document,
        _urlFoto = urlFoto,
        _urlThumbnail = urlThumbnail;

  factory _$AdServiceModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdServiceModelImplFromJson(json);

  @override
  final int? id;
  @override
  @JsonKey(name: "created_at")
  final String? createdAt;
  @override
  @JsonKey(name: "updated_at")
  final String? updatedAt;
  @override
  @JsonKey(name: "deleted_at")
  final String? deletedAt;
  @override
  @JsonKey(name: 'user_id')
  final int? userID;
  @override
  final User? user;
  @override
  @JsonKey(name: 'service_brand_id')
  final int? brandID;
  @override
  @JsonKey(name: 'service_brand')
  final Brand? brand;
  @override
  @JsonKey(name: 'service_sub_category_id')
  final int? subCategoryID;
  @override
  @JsonKey(
      name: 'service_sub_category', fromJson: SubCategory.getSubCategoryForSVM)
  final SubCategory? subcategory;
  @override
  @JsonKey(name: 'city_id')
  final int? cityId;
  @override
  @JsonKey(name: 'city')
  final City? city;
  @override
  final int? price;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final String? address;
  @override
  final double? latitude;
  @override
  final double? longitude;
  final Map<String, dynamic>? _params;
  @override
  Map<String, dynamic>? get params {
    final value = _params;
    if (value == null) return null;
    if (_params is EqualUnmodifiableMapView) return _params;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<dynamic>? _document;
  @override
  List<dynamic>? get document {
    final value = _document;
    if (value == null) return null;
    if (_document is EqualUnmodifiableListView) return _document;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

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
  @JsonKey(name: 'count_rate')
  final double? countRate;
  @override
  final double? rating;

  @override
  String toString() {
    return 'AdServiceModel(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, userID: $userID, user: $user, brandID: $brandID, brand: $brand, subCategoryID: $subCategoryID, subcategory: $subcategory, cityId: $cityId, city: $city, price: $price, title: $title, description: $description, address: $address, latitude: $latitude, longitude: $longitude, params: $params, document: $document, urlFoto: $urlFoto, urlThumbnail: $urlThumbnail, countRate: $countRate, rating: $rating)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdServiceModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.deletedAt, deletedAt) ||
                other.deletedAt == deletedAt) &&
            (identical(other.userID, userID) || other.userID == userID) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.brandID, brandID) || other.brandID == brandID) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.subCategoryID, subCategoryID) ||
                other.subCategoryID == subCategoryID) &&
            (identical(other.subcategory, subcategory) ||
                other.subcategory == subcategory) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            const DeepCollectionEquality().equals(other._params, _params) &&
            const DeepCollectionEquality().equals(other._document, _document) &&
            const DeepCollectionEquality().equals(other._urlFoto, _urlFoto) &&
            const DeepCollectionEquality()
                .equals(other._urlThumbnail, _urlThumbnail) &&
            (identical(other.countRate, countRate) ||
                other.countRate == countRate) &&
            (identical(other.rating, rating) || other.rating == rating));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        createdAt,
        updatedAt,
        deletedAt,
        userID,
        user,
        brandID,
        brand,
        subCategoryID,
        subcategory,
        cityId,
        city,
        price,
        title,
        description,
        address,
        latitude,
        longitude,
        const DeepCollectionEquality().hash(_params),
        const DeepCollectionEquality().hash(_document),
        const DeepCollectionEquality().hash(_urlFoto),
        const DeepCollectionEquality().hash(_urlThumbnail),
        countRate,
        rating
      ]);

  /// Create a copy of AdServiceModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdServiceModelImplCopyWith<_$AdServiceModelImpl> get copyWith =>
      __$$AdServiceModelImplCopyWithImpl<_$AdServiceModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdServiceModelImplToJson(
      this,
    );
  }
}

abstract class _AdServiceModel implements AdServiceModel {
  const factory _AdServiceModel(
      {final int? id,
      @JsonKey(name: "created_at") final String? createdAt,
      @JsonKey(name: "updated_at") final String? updatedAt,
      @JsonKey(name: "deleted_at") final String? deletedAt,
      @JsonKey(name: 'user_id') final int? userID,
      final User? user,
      @JsonKey(name: 'service_brand_id') final int? brandID,
      @JsonKey(name: 'service_brand') final Brand? brand,
      @JsonKey(name: 'service_sub_category_id') final int? subCategoryID,
      @JsonKey(
          name: 'service_sub_category',
          fromJson: SubCategory.getSubCategoryForSVM)
      final SubCategory? subcategory,
      @JsonKey(name: 'city_id') final int? cityId,
      @JsonKey(name: 'city') final City? city,
      final int? price,
      final String? title,
      final String? description,
      final String? address,
      final double? latitude,
      final double? longitude,
      final Map<String, dynamic>? params,
      final List<dynamic>? document,
      @JsonKey(name: 'url_foto') final List<String>? urlFoto,
      @JsonKey(name: 'url_thumbnail') final List<String>? urlThumbnail,
      @JsonKey(name: 'count_rate') final double? countRate,
      final double? rating}) = _$AdServiceModelImpl;

  factory _AdServiceModel.fromJson(Map<String, dynamic> json) =
      _$AdServiceModelImpl.fromJson;

  @override
  int? get id;
  @override
  @JsonKey(name: "created_at")
  String? get createdAt;
  @override
  @JsonKey(name: "updated_at")
  String? get updatedAt;
  @override
  @JsonKey(name: "deleted_at")
  String? get deletedAt;
  @override
  @JsonKey(name: 'user_id')
  int? get userID;
  @override
  User? get user;
  @override
  @JsonKey(name: 'service_brand_id')
  int? get brandID;
  @override
  @JsonKey(name: 'service_brand')
  Brand? get brand;
  @override
  @JsonKey(name: 'service_sub_category_id')
  int? get subCategoryID;
  @override
  @JsonKey(
      name: 'service_sub_category', fromJson: SubCategory.getSubCategoryForSVM)
  SubCategory? get subcategory;
  @override
  @JsonKey(name: 'city_id')
  int? get cityId;
  @override
  @JsonKey(name: 'city')
  City? get city;
  @override
  int? get price;
  @override
  String? get title;
  @override
  String? get description;
  @override
  String? get address;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  Map<String, dynamic>? get params;
  @override
  List<dynamic>? get document;
  @override
  @JsonKey(name: 'url_foto')
  List<String>? get urlFoto;
  @override
  @JsonKey(name: 'url_thumbnail')
  List<String>? get urlThumbnail;
  @override
  @JsonKey(name: 'count_rate')
  double? get countRate;
  @override
  double? get rating;

  /// Create a copy of AdServiceModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdServiceModelImplCopyWith<_$AdServiceModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
