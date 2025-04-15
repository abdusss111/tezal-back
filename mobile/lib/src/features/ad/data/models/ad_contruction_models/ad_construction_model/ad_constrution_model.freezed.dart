// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ad_constrution_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AdConstrutionModel _$AdConstrutionModelFromJson(Map<String, dynamic> json) {
  return _AdConstrutionModel.fromJson(json);
}

/// @nodoc
mixin _$AdConstrutionModel {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  dynamic get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int? get userId => throw _privateConstructorUsedError;
  User? get user => throw _privateConstructorUsedError;
  @JsonKey(name: 'city_id')
  int? get cityId => throw _privateConstructorUsedError;
  City? get city => throw _privateConstructorUsedError;
  @JsonKey(name: 'construction_material_brand_id')
  int? get constructionMaterialBrandId => throw _privateConstructorUsedError;
  @JsonKey(name: 'construction_material_brand')
  Brand? get constructionMaterialBrand => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'construction_material_sub_category',
      fromJson: SubCategory.getSubCategoryForCM)
  SubCategory? get constructionMaterialSubCategory =>
      throw _privateConstructorUsedError;
  @JsonKey(name: 'construction_material_sub_category_id')
  int? get constructionMaterialSubCategoryID =>
      throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int? get price => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  Map<String, dynamic>? get params => throw _privateConstructorUsedError;
  List<dynamic>? get document => throw _privateConstructorUsedError;
  double? get countRate => throw _privateConstructorUsedError;
  @JsonKey(name: 'url_foto')
  List<String>? get urlFoto => throw _privateConstructorUsedError;
  @JsonKey(name: 'url_thumbnail')
  List<String>? get urlThumbnail => throw _privateConstructorUsedError;

  /// Serializes this AdConstrutionModel to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdConstrutionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdConstrutionModelCopyWith<AdConstrutionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdConstrutionModelCopyWith<$Res> {
  factory $AdConstrutionModelCopyWith(
          AdConstrutionModel value, $Res Function(AdConstrutionModel) then) =
      _$AdConstrutionModelCopyWithImpl<$Res, AdConstrutionModel>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') dynamic deletedAt,
      @JsonKey(name: 'user_id') int? userId,
      User? user,
      @JsonKey(name: 'city_id') int? cityId,
      City? city,
      @JsonKey(name: 'construction_material_brand_id')
      int? constructionMaterialBrandId,
      @JsonKey(name: 'construction_material_brand')
      Brand? constructionMaterialBrand,
      @JsonKey(
          name: 'construction_material_sub_category',
          fromJson: SubCategory.getSubCategoryForCM)
      SubCategory? constructionMaterialSubCategory,
      @JsonKey(name: 'construction_material_sub_category_id')
      int? constructionMaterialSubCategoryID,
      String? title,
      String? description,
      int? price,
      String? address,
      double? latitude,
      double? longitude,
      double? rating,
      Map<String, dynamic>? params,
      List<dynamic>? document,
      double? countRate,
      @JsonKey(name: 'url_foto') List<String>? urlFoto,
      @JsonKey(name: 'url_thumbnail') List<String>? urlThumbnail});

  $UserCopyWith<$Res>? get user;
  $CityCopyWith<$Res>? get city;
  $BrandCopyWith<$Res>? get constructionMaterialBrand;
  $SubCategoryCopyWith<$Res>? get constructionMaterialSubCategory;
}

/// @nodoc
class _$AdConstrutionModelCopyWithImpl<$Res, $Val extends AdConstrutionModel>
    implements $AdConstrutionModelCopyWith<$Res> {
  _$AdConstrutionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdConstrutionModel
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
    Object? cityId = freezed,
    Object? city = freezed,
    Object? constructionMaterialBrandId = freezed,
    Object? constructionMaterialBrand = freezed,
    Object? constructionMaterialSubCategory = freezed,
    Object? constructionMaterialSubCategoryID = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? price = freezed,
    Object? address = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? rating = freezed,
    Object? params = freezed,
    Object? document = freezed,
    Object? countRate = freezed,
    Object? urlFoto = freezed,
    Object? urlThumbnail = freezed,
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
      cityId: freezed == cityId
          ? _value.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as int?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as City?,
      constructionMaterialBrandId: freezed == constructionMaterialBrandId
          ? _value.constructionMaterialBrandId
          : constructionMaterialBrandId // ignore: cast_nullable_to_non_nullable
              as int?,
      constructionMaterialBrand: freezed == constructionMaterialBrand
          ? _value.constructionMaterialBrand
          : constructionMaterialBrand // ignore: cast_nullable_to_non_nullable
              as Brand?,
      constructionMaterialSubCategory: freezed ==
              constructionMaterialSubCategory
          ? _value.constructionMaterialSubCategory
          : constructionMaterialSubCategory // ignore: cast_nullable_to_non_nullable
              as SubCategory?,
      constructionMaterialSubCategoryID: freezed ==
              constructionMaterialSubCategoryID
          ? _value.constructionMaterialSubCategoryID
          : constructionMaterialSubCategoryID // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
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
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      params: freezed == params
          ? _value.params
          : params // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      document: freezed == document
          ? _value.document
          : document // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      countRate: freezed == countRate
          ? _value.countRate
          : countRate // ignore: cast_nullable_to_non_nullable
              as double?,
      urlFoto: freezed == urlFoto
          ? _value.urlFoto
          : urlFoto // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      urlThumbnail: freezed == urlThumbnail
          ? _value.urlThumbnail
          : urlThumbnail // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }

  /// Create a copy of AdConstrutionModel
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

  /// Create a copy of AdConstrutionModel
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

  /// Create a copy of AdConstrutionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $BrandCopyWith<$Res>? get constructionMaterialBrand {
    if (_value.constructionMaterialBrand == null) {
      return null;
    }

    return $BrandCopyWith<$Res>(_value.constructionMaterialBrand!, (value) {
      return _then(_value.copyWith(constructionMaterialBrand: value) as $Val);
    });
  }

  /// Create a copy of AdConstrutionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SubCategoryCopyWith<$Res>? get constructionMaterialSubCategory {
    if (_value.constructionMaterialSubCategory == null) {
      return null;
    }

    return $SubCategoryCopyWith<$Res>(_value.constructionMaterialSubCategory!,
        (value) {
      return _then(
          _value.copyWith(constructionMaterialSubCategory: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AdConstrutionModelImplCopyWith<$Res>
    implements $AdConstrutionModelCopyWith<$Res> {
  factory _$$AdConstrutionModelImplCopyWith(_$AdConstrutionModelImpl value,
          $Res Function(_$AdConstrutionModelImpl) then) =
      __$$AdConstrutionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') dynamic deletedAt,
      @JsonKey(name: 'user_id') int? userId,
      User? user,
      @JsonKey(name: 'city_id') int? cityId,
      City? city,
      @JsonKey(name: 'construction_material_brand_id')
      int? constructionMaterialBrandId,
      @JsonKey(name: 'construction_material_brand')
      Brand? constructionMaterialBrand,
      @JsonKey(
          name: 'construction_material_sub_category',
          fromJson: SubCategory.getSubCategoryForCM)
      SubCategory? constructionMaterialSubCategory,
      @JsonKey(name: 'construction_material_sub_category_id')
      int? constructionMaterialSubCategoryID,
      String? title,
      String? description,
      int? price,
      String? address,
      double? latitude,
      double? longitude,
      double? rating,
      Map<String, dynamic>? params,
      List<dynamic>? document,
      double? countRate,
      @JsonKey(name: 'url_foto') List<String>? urlFoto,
      @JsonKey(name: 'url_thumbnail') List<String>? urlThumbnail});

  @override
  $UserCopyWith<$Res>? get user;
  @override
  $CityCopyWith<$Res>? get city;
  @override
  $BrandCopyWith<$Res>? get constructionMaterialBrand;
  @override
  $SubCategoryCopyWith<$Res>? get constructionMaterialSubCategory;
}

/// @nodoc
class __$$AdConstrutionModelImplCopyWithImpl<$Res>
    extends _$AdConstrutionModelCopyWithImpl<$Res, _$AdConstrutionModelImpl>
    implements _$$AdConstrutionModelImplCopyWith<$Res> {
  __$$AdConstrutionModelImplCopyWithImpl(_$AdConstrutionModelImpl _value,
      $Res Function(_$AdConstrutionModelImpl) _then)
      : super(_value, _then);

  /// Create a copy of AdConstrutionModel
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
    Object? cityId = freezed,
    Object? city = freezed,
    Object? constructionMaterialBrandId = freezed,
    Object? constructionMaterialBrand = freezed,
    Object? constructionMaterialSubCategory = freezed,
    Object? constructionMaterialSubCategoryID = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? price = freezed,
    Object? address = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? rating = freezed,
    Object? params = freezed,
    Object? document = freezed,
    Object? countRate = freezed,
    Object? urlFoto = freezed,
    Object? urlThumbnail = freezed,
  }) {
    return _then(_$AdConstrutionModelImpl(
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
      cityId: freezed == cityId
          ? _value.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as int?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as City?,
      constructionMaterialBrandId: freezed == constructionMaterialBrandId
          ? _value.constructionMaterialBrandId
          : constructionMaterialBrandId // ignore: cast_nullable_to_non_nullable
              as int?,
      constructionMaterialBrand: freezed == constructionMaterialBrand
          ? _value.constructionMaterialBrand
          : constructionMaterialBrand // ignore: cast_nullable_to_non_nullable
              as Brand?,
      constructionMaterialSubCategory: freezed ==
              constructionMaterialSubCategory
          ? _value.constructionMaterialSubCategory
          : constructionMaterialSubCategory // ignore: cast_nullable_to_non_nullable
              as SubCategory?,
      constructionMaterialSubCategoryID: freezed ==
              constructionMaterialSubCategoryID
          ? _value.constructionMaterialSubCategoryID
          : constructionMaterialSubCategoryID // ignore: cast_nullable_to_non_nullable
              as int?,
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      price: freezed == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as int?,
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
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      params: freezed == params
          ? _value._params
          : params // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      document: freezed == document
          ? _value._document
          : document // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      countRate: freezed == countRate
          ? _value.countRate
          : countRate // ignore: cast_nullable_to_non_nullable
              as double?,
      urlFoto: freezed == urlFoto
          ? _value._urlFoto
          : urlFoto // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      urlThumbnail: freezed == urlThumbnail
          ? _value._urlThumbnail
          : urlThumbnail // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdConstrutionModelImpl implements _AdConstrutionModel {
  _$AdConstrutionModelImpl(
      {this.id,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'deleted_at') this.deletedAt,
      @JsonKey(name: 'user_id') this.userId,
      this.user,
      @JsonKey(name: 'city_id') this.cityId,
      this.city,
      @JsonKey(name: 'construction_material_brand_id')
      this.constructionMaterialBrandId,
      @JsonKey(name: 'construction_material_brand')
      this.constructionMaterialBrand,
      @JsonKey(
          name: 'construction_material_sub_category',
          fromJson: SubCategory.getSubCategoryForCM)
      this.constructionMaterialSubCategory,
      @JsonKey(name: 'construction_material_sub_category_id')
      this.constructionMaterialSubCategoryID,
      this.title,
      this.description,
      this.price,
      this.address,
      this.latitude,
      this.longitude,
      this.rating,
      final Map<String, dynamic>? params,
      final List<dynamic>? document,
      this.countRate,
      @JsonKey(name: 'url_foto') final List<String>? urlFoto,
      @JsonKey(name: 'url_thumbnail') final List<String>? urlThumbnail})
      : _params = params,
        _document = document,
        _urlFoto = urlFoto,
        _urlThumbnail = urlThumbnail;

  factory _$AdConstrutionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdConstrutionModelImplFromJson(json);

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
  final User? user;
  @override
  @JsonKey(name: 'city_id')
  final int? cityId;
  @override
  final City? city;
  @override
  @JsonKey(name: 'construction_material_brand_id')
  final int? constructionMaterialBrandId;
  @override
  @JsonKey(name: 'construction_material_brand')
  final Brand? constructionMaterialBrand;
  @override
  @JsonKey(
      name: 'construction_material_sub_category',
      fromJson: SubCategory.getSubCategoryForCM)
  final SubCategory? constructionMaterialSubCategory;
  @override
  @JsonKey(name: 'construction_material_sub_category_id')
  final int? constructionMaterialSubCategoryID;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final int? price;
  @override
  final String? address;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final double? rating;
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

  @override
  final double? countRate;
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
  String toString() {
    return 'AdConstrutionModel(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, userId: $userId, user: $user, cityId: $cityId, city: $city, constructionMaterialBrandId: $constructionMaterialBrandId, constructionMaterialBrand: $constructionMaterialBrand, constructionMaterialSubCategory: $constructionMaterialSubCategory, constructionMaterialSubCategoryID: $constructionMaterialSubCategoryID, title: $title, description: $description, price: $price, address: $address, latitude: $latitude, longitude: $longitude, rating: $rating, params: $params, document: $document, countRate: $countRate, urlFoto: $urlFoto, urlThumbnail: $urlThumbnail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdConstrutionModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.deletedAt, deletedAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.constructionMaterialBrandId,
                    constructionMaterialBrandId) ||
                other.constructionMaterialBrandId ==
                    constructionMaterialBrandId) &&
            (identical(other.constructionMaterialBrand,
                    constructionMaterialBrand) ||
                other.constructionMaterialBrand == constructionMaterialBrand) &&
            (identical(other.constructionMaterialSubCategory,
                    constructionMaterialSubCategory) ||
                other.constructionMaterialSubCategory ==
                    constructionMaterialSubCategory) &&
            (identical(other.constructionMaterialSubCategoryID,
                    constructionMaterialSubCategoryID) ||
                other.constructionMaterialSubCategoryID ==
                    constructionMaterialSubCategoryID) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            const DeepCollectionEquality().equals(other._params, _params) &&
            const DeepCollectionEquality().equals(other._document, _document) &&
            (identical(other.countRate, countRate) ||
                other.countRate == countRate) &&
            const DeepCollectionEquality().equals(other._urlFoto, _urlFoto) &&
            const DeepCollectionEquality()
                .equals(other._urlThumbnail, _urlThumbnail));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(deletedAt),
        userId,
        user,
        cityId,
        city,
        constructionMaterialBrandId,
        constructionMaterialBrand,
        constructionMaterialSubCategory,
        constructionMaterialSubCategoryID,
        title,
        description,
        price,
        address,
        latitude,
        longitude,
        rating,
        const DeepCollectionEquality().hash(_params),
        const DeepCollectionEquality().hash(_document),
        countRate,
        const DeepCollectionEquality().hash(_urlFoto),
        const DeepCollectionEquality().hash(_urlThumbnail)
      ]);

  /// Create a copy of AdConstrutionModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdConstrutionModelImplCopyWith<_$AdConstrutionModelImpl> get copyWith =>
      __$$AdConstrutionModelImplCopyWithImpl<_$AdConstrutionModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdConstrutionModelImplToJson(
      this,
    );
  }
}

abstract class _AdConstrutionModel implements AdConstrutionModel {
  factory _AdConstrutionModel(
          {final int? id,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt,
          @JsonKey(name: 'deleted_at') final dynamic deletedAt,
          @JsonKey(name: 'user_id') final int? userId,
          final User? user,
          @JsonKey(name: 'city_id') final int? cityId,
          final City? city,
          @JsonKey(name: 'construction_material_brand_id')
          final int? constructionMaterialBrandId,
          @JsonKey(name: 'construction_material_brand')
          final Brand? constructionMaterialBrand,
          @JsonKey(
              name: 'construction_material_sub_category',
              fromJson: SubCategory.getSubCategoryForCM)
          final SubCategory? constructionMaterialSubCategory,
          @JsonKey(name: 'construction_material_sub_category_id')
          final int? constructionMaterialSubCategoryID,
          final String? title,
          final String? description,
          final int? price,
          final String? address,
          final double? latitude,
          final double? longitude,
          final double? rating,
          final Map<String, dynamic>? params,
          final List<dynamic>? document,
          final double? countRate,
          @JsonKey(name: 'url_foto') final List<String>? urlFoto,
          @JsonKey(name: 'url_thumbnail') final List<String>? urlThumbnail}) =
      _$AdConstrutionModelImpl;

  factory _AdConstrutionModel.fromJson(Map<String, dynamic> json) =
      _$AdConstrutionModelImpl.fromJson;

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
  User? get user;
  @override
  @JsonKey(name: 'city_id')
  int? get cityId;
  @override
  City? get city;
  @override
  @JsonKey(name: 'construction_material_brand_id')
  int? get constructionMaterialBrandId;
  @override
  @JsonKey(name: 'construction_material_brand')
  Brand? get constructionMaterialBrand;
  @override
  @JsonKey(
      name: 'construction_material_sub_category',
      fromJson: SubCategory.getSubCategoryForCM)
  SubCategory? get constructionMaterialSubCategory;
  @override
  @JsonKey(name: 'construction_material_sub_category_id')
  int? get constructionMaterialSubCategoryID;
  @override
  String? get title;
  @override
  String? get description;
  @override
  int? get price;
  @override
  String? get address;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  double? get rating;
  @override
  Map<String, dynamic>? get params;
  @override
  List<dynamic>? get document;
  @override
  double? get countRate;
  @override
  @JsonKey(name: 'url_foto')
  List<String>? get urlFoto;
  @override
  @JsonKey(name: 'url_thumbnail')
  List<String>? get urlThumbnail;

  /// Create a copy of AdConstrutionModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdConstrutionModelImplCopyWith<_$AdConstrutionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
