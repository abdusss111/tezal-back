// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ad_equipment_client.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AdEquipmentClient _$AdEquipmentClientFromJson(Map<String, dynamic> json) {
  return _AdEquipmentClient.fromJson(json);
}

/// @nodoc
mixin _$AdEquipmentClient {
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
  @JsonKey(name: 'equipment_sub_category_id')
  int? get equipmentSubcategoryId => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'equipment_sub_category', fromJson: SubCategory.getSubCategoryForEQ)
  SubCategory? get equipmentSubcategory => throw _privateConstructorUsedError;
  String? get status => throw _privateConstructorUsedError;
  String? get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double? get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_lease_date')
  String? get startLeaseDate => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_lease_date')
  String? get endLeaseDate => throw _privateConstructorUsedError;
  String? get address => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  List<Document>? get document => throw _privateConstructorUsedError;
  @JsonKey(name: 'url_foto')
  List<String>? get urlFoto => throw _privateConstructorUsedError;
  @JsonKey(name: 'url_thumbnail')
  List<String>? get urlThumbnail => throw _privateConstructorUsedError;

  /// Serializes this AdEquipmentClient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdEquipmentClient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdEquipmentClientCopyWith<AdEquipmentClient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdEquipmentClientCopyWith<$Res> {
  factory $AdEquipmentClientCopyWith(
          AdEquipmentClient value, $Res Function(AdEquipmentClient) then) =
      _$AdEquipmentClientCopyWithImpl<$Res, AdEquipmentClient>;
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
      @JsonKey(name: 'equipment_sub_category_id') int? equipmentSubcategoryId,
      @JsonKey(
          name: 'equipment_sub_category',
          fromJson: SubCategory.getSubCategoryForEQ)
      SubCategory? equipmentSubcategory,
      String? status,
      String? title,
      String? description,
      double? price,
      @JsonKey(name: 'start_lease_date') String? startLeaseDate,
      @JsonKey(name: 'end_lease_date') String? endLeaseDate,
      String? address,
      double? latitude,
      double? longitude,
      List<Document>? document,
      @JsonKey(name: 'url_foto') List<String>? urlFoto,
      @JsonKey(name: 'url_thumbnail') List<String>? urlThumbnail});

  $UserCopyWith<$Res>? get user;
  $CityCopyWith<$Res>? get city;
  $SubCategoryCopyWith<$Res>? get equipmentSubcategory;
}

/// @nodoc
class _$AdEquipmentClientCopyWithImpl<$Res, $Val extends AdEquipmentClient>
    implements $AdEquipmentClientCopyWith<$Res> {
  _$AdEquipmentClientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdEquipmentClient
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
    Object? equipmentSubcategoryId = freezed,
    Object? equipmentSubcategory = freezed,
    Object? status = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? price = freezed,
    Object? startLeaseDate = freezed,
    Object? endLeaseDate = freezed,
    Object? address = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? document = freezed,
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
      equipmentSubcategoryId: freezed == equipmentSubcategoryId
          ? _value.equipmentSubcategoryId
          : equipmentSubcategoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      equipmentSubcategory: freezed == equipmentSubcategory
          ? _value.equipmentSubcategory
          : equipmentSubcategory // ignore: cast_nullable_to_non_nullable
              as SubCategory?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
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
              as double?,
      startLeaseDate: freezed == startLeaseDate
          ? _value.startLeaseDate
          : startLeaseDate // ignore: cast_nullable_to_non_nullable
              as String?,
      endLeaseDate: freezed == endLeaseDate
          ? _value.endLeaseDate
          : endLeaseDate // ignore: cast_nullable_to_non_nullable
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
      document: freezed == document
          ? _value.document
          : document // ignore: cast_nullable_to_non_nullable
              as List<Document>?,
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

  /// Create a copy of AdEquipmentClient
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

  /// Create a copy of AdEquipmentClient
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

  /// Create a copy of AdEquipmentClient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SubCategoryCopyWith<$Res>? get equipmentSubcategory {
    if (_value.equipmentSubcategory == null) {
      return null;
    }

    return $SubCategoryCopyWith<$Res>(_value.equipmentSubcategory!, (value) {
      return _then(_value.copyWith(equipmentSubcategory: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AdEquipmentClientImplCopyWith<$Res>
    implements $AdEquipmentClientCopyWith<$Res> {
  factory _$$AdEquipmentClientImplCopyWith(_$AdEquipmentClientImpl value,
          $Res Function(_$AdEquipmentClientImpl) then) =
      __$$AdEquipmentClientImplCopyWithImpl<$Res>;
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
      @JsonKey(name: 'equipment_sub_category_id') int? equipmentSubcategoryId,
      @JsonKey(
          name: 'equipment_sub_category',
          fromJson: SubCategory.getSubCategoryForEQ)
      SubCategory? equipmentSubcategory,
      String? status,
      String? title,
      String? description,
      double? price,
      @JsonKey(name: 'start_lease_date') String? startLeaseDate,
      @JsonKey(name: 'end_lease_date') String? endLeaseDate,
      String? address,
      double? latitude,
      double? longitude,
      List<Document>? document,
      @JsonKey(name: 'url_foto') List<String>? urlFoto,
      @JsonKey(name: 'url_thumbnail') List<String>? urlThumbnail});

  @override
  $UserCopyWith<$Res>? get user;
  @override
  $CityCopyWith<$Res>? get city;
  @override
  $SubCategoryCopyWith<$Res>? get equipmentSubcategory;
}

/// @nodoc
class __$$AdEquipmentClientImplCopyWithImpl<$Res>
    extends _$AdEquipmentClientCopyWithImpl<$Res, _$AdEquipmentClientImpl>
    implements _$$AdEquipmentClientImplCopyWith<$Res> {
  __$$AdEquipmentClientImplCopyWithImpl(_$AdEquipmentClientImpl _value,
      $Res Function(_$AdEquipmentClientImpl) _then)
      : super(_value, _then);

  /// Create a copy of AdEquipmentClient
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
    Object? equipmentSubcategoryId = freezed,
    Object? equipmentSubcategory = freezed,
    Object? status = freezed,
    Object? title = freezed,
    Object? description = freezed,
    Object? price = freezed,
    Object? startLeaseDate = freezed,
    Object? endLeaseDate = freezed,
    Object? address = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? document = freezed,
    Object? urlFoto = freezed,
    Object? urlThumbnail = freezed,
  }) {
    return _then(_$AdEquipmentClientImpl(
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
      equipmentSubcategoryId: freezed == equipmentSubcategoryId
          ? _value.equipmentSubcategoryId
          : equipmentSubcategoryId // ignore: cast_nullable_to_non_nullable
              as int?,
      equipmentSubcategory: freezed == equipmentSubcategory
          ? _value.equipmentSubcategory
          : equipmentSubcategory // ignore: cast_nullable_to_non_nullable
              as SubCategory?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
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
              as double?,
      startLeaseDate: freezed == startLeaseDate
          ? _value.startLeaseDate
          : startLeaseDate // ignore: cast_nullable_to_non_nullable
              as String?,
      endLeaseDate: freezed == endLeaseDate
          ? _value.endLeaseDate
          : endLeaseDate // ignore: cast_nullable_to_non_nullable
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
      document: freezed == document
          ? _value._document
          : document // ignore: cast_nullable_to_non_nullable
              as List<Document>?,
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
class _$AdEquipmentClientImpl implements _AdEquipmentClient {
  const _$AdEquipmentClientImpl(
      {this.id,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'deleted_at') this.deletedAt,
      @JsonKey(name: 'user_id') this.userId,
      this.user,
      @JsonKey(name: 'city_id') this.cityId,
      this.city,
      @JsonKey(name: 'equipment_sub_category_id') this.equipmentSubcategoryId,
      @JsonKey(
          name: 'equipment_sub_category',
          fromJson: SubCategory.getSubCategoryForEQ)
      this.equipmentSubcategory,
      this.status,
      this.title,
      this.description,
      this.price,
      @JsonKey(name: 'start_lease_date') this.startLeaseDate,
      @JsonKey(name: 'end_lease_date') this.endLeaseDate,
      this.address,
      this.latitude,
      this.longitude,
      final List<Document>? document,
      @JsonKey(name: 'url_foto') final List<String>? urlFoto,
      @JsonKey(name: 'url_thumbnail') final List<String>? urlThumbnail})
      : _document = document,
        _urlFoto = urlFoto,
        _urlThumbnail = urlThumbnail;

  factory _$AdEquipmentClientImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdEquipmentClientImplFromJson(json);

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
  @JsonKey(name: 'equipment_sub_category_id')
  final int? equipmentSubcategoryId;
  @override
  @JsonKey(
      name: 'equipment_sub_category', fromJson: SubCategory.getSubCategoryForEQ)
  final SubCategory? equipmentSubcategory;
  @override
  final String? status;
  @override
  final String? title;
  @override
  final String? description;
  @override
  final double? price;
  @override
  @JsonKey(name: 'start_lease_date')
  final String? startLeaseDate;
  @override
  @JsonKey(name: 'end_lease_date')
  final String? endLeaseDate;
  @override
  final String? address;
  @override
  final double? latitude;
  @override
  final double? longitude;
  final List<Document>? _document;
  @override
  List<Document>? get document {
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
  String toString() {
    return 'AdEquipmentClient(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, userId: $userId, user: $user, cityId: $cityId, city: $city, equipmentSubcategoryId: $equipmentSubcategoryId, equipmentSubcategory: $equipmentSubcategory, status: $status, title: $title, description: $description, price: $price, startLeaseDate: $startLeaseDate, endLeaseDate: $endLeaseDate, address: $address, latitude: $latitude, longitude: $longitude, document: $document, urlFoto: $urlFoto, urlThumbnail: $urlThumbnail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdEquipmentClientImpl &&
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
            (identical(other.equipmentSubcategoryId, equipmentSubcategoryId) ||
                other.equipmentSubcategoryId == equipmentSubcategoryId) &&
            (identical(other.equipmentSubcategory, equipmentSubcategory) ||
                other.equipmentSubcategory == equipmentSubcategory) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.startLeaseDate, startLeaseDate) ||
                other.startLeaseDate == startLeaseDate) &&
            (identical(other.endLeaseDate, endLeaseDate) ||
                other.endLeaseDate == endLeaseDate) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            const DeepCollectionEquality().equals(other._document, _document) &&
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
        equipmentSubcategoryId,
        equipmentSubcategory,
        status,
        title,
        description,
        price,
        startLeaseDate,
        endLeaseDate,
        address,
        latitude,
        longitude,
        const DeepCollectionEquality().hash(_document),
        const DeepCollectionEquality().hash(_urlFoto),
        const DeepCollectionEquality().hash(_urlThumbnail)
      ]);

  /// Create a copy of AdEquipmentClient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdEquipmentClientImplCopyWith<_$AdEquipmentClientImpl> get copyWith =>
      __$$AdEquipmentClientImplCopyWithImpl<_$AdEquipmentClientImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdEquipmentClientImplToJson(
      this,
    );
  }
}

abstract class _AdEquipmentClient implements AdEquipmentClient {
  const factory _AdEquipmentClient(
          {final int? id,
          @JsonKey(name: 'created_at') final DateTime? createdAt,
          @JsonKey(name: 'updated_at') final DateTime? updatedAt,
          @JsonKey(name: 'deleted_at') final dynamic deletedAt,
          @JsonKey(name: 'user_id') final int? userId,
          final User? user,
          @JsonKey(name: 'city_id') final int? cityId,
          final City? city,
          @JsonKey(name: 'equipment_sub_category_id')
          final int? equipmentSubcategoryId,
          @JsonKey(
              name: 'equipment_sub_category',
              fromJson: SubCategory.getSubCategoryForEQ)
          final SubCategory? equipmentSubcategory,
          final String? status,
          final String? title,
          final String? description,
          final double? price,
          @JsonKey(name: 'start_lease_date') final String? startLeaseDate,
          @JsonKey(name: 'end_lease_date') final String? endLeaseDate,
          final String? address,
          final double? latitude,
          final double? longitude,
          final List<Document>? document,
          @JsonKey(name: 'url_foto') final List<String>? urlFoto,
          @JsonKey(name: 'url_thumbnail') final List<String>? urlThumbnail}) =
      _$AdEquipmentClientImpl;

  factory _AdEquipmentClient.fromJson(Map<String, dynamic> json) =
      _$AdEquipmentClientImpl.fromJson;

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
  @JsonKey(name: 'equipment_sub_category_id')
  int? get equipmentSubcategoryId;
  @override
  @JsonKey(
      name: 'equipment_sub_category', fromJson: SubCategory.getSubCategoryForEQ)
  SubCategory? get equipmentSubcategory;
  @override
  String? get status;
  @override
  String? get title;
  @override
  String? get description;
  @override
  double? get price;
  @override
  @JsonKey(name: 'start_lease_date')
  String? get startLeaseDate;
  @override
  @JsonKey(name: 'end_lease_date')
  String? get endLeaseDate;
  @override
  String? get address;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  List<Document>? get document;
  @override
  @JsonKey(name: 'url_foto')
  List<String>? get urlFoto;
  @override
  @JsonKey(name: 'url_thumbnail')
  List<String>? get urlThumbnail;

  /// Create a copy of AdEquipmentClient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdEquipmentClientImplCopyWith<_$AdEquipmentClientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
