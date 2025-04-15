// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'deleted_at')
  dynamic get deletedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'first_name')
  String? get firstName => throw _privateConstructorUsedError;
  @JsonKey(name: 'last_name')
  String? get lastName => throw _privateConstructorUsedError;
  @JsonKey(name: 'nick_name')
  String? get nickName => throw _privateConstructorUsedError;
  @JsonKey(name: 'phone_number')
  String? get phoneNumber => throw _privateConstructorUsedError;
  @JsonKey(name: 'access_role')
  String? get accessRole => throw _privateConstructorUsedError;
  @JsonKey(name: 'city_id')
  int? get cityId => throw _privateConstructorUsedError;
  @JsonKey(name: 'birth_date')
  String? get birthDate => throw _privateConstructorUsedError;
  String? get iin => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  City? get city => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_driver')
  bool? get canDriver => throw _privateConstructorUsedError;
  @JsonKey(name: 'owner_id')
  dynamic get ownerId => throw _privateConstructorUsedError;
  dynamic get owner => throw _privateConstructorUsedError;
  @JsonKey(name: 'can_owner')
  bool? get canOwner => throw _privateConstructorUsedError;
  @JsonKey(name: 'url_document')
  String? get urlImage => throw _privateConstructorUsedError;
  @JsonKey(name: 'custom_url_document')
  String? get customUrlImage => throw _privateConstructorUsedError;
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'email')
  String? get email => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_location_enabled')
  bool? get isLocationEnabled => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') dynamic deletedAt,
      @JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      @JsonKey(name: 'nick_name') String? nickName,
      @JsonKey(name: 'phone_number') String? phoneNumber,
      @JsonKey(name: 'access_role') String? accessRole,
      @JsonKey(name: 'city_id') int? cityId,
      @JsonKey(name: 'birth_date') String? birthDate,
      String? iin,
      double? rating,
      City? city,
      @JsonKey(name: 'can_driver') bool? canDriver,
      @JsonKey(name: 'owner_id') dynamic ownerId,
      dynamic owner,
      @JsonKey(name: 'can_owner') bool? canOwner,
      @JsonKey(name: 'url_document') String? urlImage,
      @JsonKey(name: 'custom_url_document') String? customUrlImage,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'email') String? email,
      @JsonKey(name: 'is_location_enabled') bool? isLocationEnabled});

  $CityCopyWith<$Res>? get city;
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? nickName = freezed,
    Object? phoneNumber = freezed,
    Object? accessRole = freezed,
    Object? cityId = freezed,
    Object? birthDate = freezed,
    Object? iin = freezed,
    Object? rating = freezed,
    Object? city = freezed,
    Object? canDriver = freezed,
    Object? ownerId = freezed,
    Object? owner = freezed,
    Object? canOwner = freezed,
    Object? urlImage = freezed,
    Object? customUrlImage = freezed,
    Object? avatarUrl = freezed,
    Object? email = freezed,
    Object? isLocationEnabled = freezed,
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
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      nickName: freezed == nickName
          ? _value.nickName
          : nickName // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      accessRole: freezed == accessRole
          ? _value.accessRole
          : accessRole // ignore: cast_nullable_to_non_nullable
              as String?,
      cityId: freezed == cityId
          ? _value.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as int?,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as String?,
      iin: freezed == iin
          ? _value.iin
          : iin // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as City?,
      canDriver: freezed == canDriver
          ? _value.canDriver
          : canDriver // ignore: cast_nullable_to_non_nullable
              as bool?,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      owner: freezed == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as dynamic,
      canOwner: freezed == canOwner
          ? _value.canOwner
          : canOwner // ignore: cast_nullable_to_non_nullable
              as bool?,
      urlImage: freezed == urlImage
          ? _value.urlImage
          : urlImage // ignore: cast_nullable_to_non_nullable
              as String?,
      customUrlImage: freezed == customUrlImage
          ? _value.customUrlImage
          : customUrlImage // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      isLocationEnabled: freezed == isLocationEnabled
          ? _value.isLocationEnabled
          : isLocationEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }

  /// Create a copy of User
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
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
          _$UserImpl value, $Res Function(_$UserImpl) then) =
      __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? id,
      @JsonKey(name: 'created_at') DateTime? createdAt,
      @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') dynamic deletedAt,
      @JsonKey(name: 'first_name') String? firstName,
      @JsonKey(name: 'last_name') String? lastName,
      @JsonKey(name: 'nick_name') String? nickName,
      @JsonKey(name: 'phone_number') String? phoneNumber,
      @JsonKey(name: 'access_role') String? accessRole,
      @JsonKey(name: 'city_id') int? cityId,
      @JsonKey(name: 'birth_date') String? birthDate,
      String? iin,
      double? rating,
      City? city,
      @JsonKey(name: 'can_driver') bool? canDriver,
      @JsonKey(name: 'owner_id') dynamic ownerId,
      dynamic owner,
      @JsonKey(name: 'can_owner') bool? canOwner,
      @JsonKey(name: 'url_document') String? urlImage,
      @JsonKey(name: 'custom_url_document') String? customUrlImage,
      @JsonKey(name: 'avatar_url') String? avatarUrl,
      @JsonKey(name: 'email') String? email,
      @JsonKey(name: 'is_location_enabled') bool? isLocationEnabled});

  @override
  $CityCopyWith<$Res>? get city;
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
      : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? deletedAt = freezed,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? nickName = freezed,
    Object? phoneNumber = freezed,
    Object? accessRole = freezed,
    Object? cityId = freezed,
    Object? birthDate = freezed,
    Object? iin = freezed,
    Object? rating = freezed,
    Object? city = freezed,
    Object? canDriver = freezed,
    Object? ownerId = freezed,
    Object? owner = freezed,
    Object? canOwner = freezed,
    Object? urlImage = freezed,
    Object? customUrlImage = freezed,
    Object? avatarUrl = freezed,
    Object? email = freezed,
    Object? isLocationEnabled = freezed,
  }) {
    return _then(_$UserImpl(
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
      firstName: freezed == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String?,
      lastName: freezed == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String?,
      nickName: freezed == nickName
          ? _value.nickName
          : nickName // ignore: cast_nullable_to_non_nullable
              as String?,
      phoneNumber: freezed == phoneNumber
          ? _value.phoneNumber
          : phoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      accessRole: freezed == accessRole
          ? _value.accessRole
          : accessRole // ignore: cast_nullable_to_non_nullable
              as String?,
      cityId: freezed == cityId
          ? _value.cityId
          : cityId // ignore: cast_nullable_to_non_nullable
              as int?,
      birthDate: freezed == birthDate
          ? _value.birthDate
          : birthDate // ignore: cast_nullable_to_non_nullable
              as String?,
      iin: freezed == iin
          ? _value.iin
          : iin // ignore: cast_nullable_to_non_nullable
              as String?,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as City?,
      canDriver: freezed == canDriver
          ? _value.canDriver
          : canDriver // ignore: cast_nullable_to_non_nullable
              as bool?,
      ownerId: freezed == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      owner: freezed == owner
          ? _value.owner
          : owner // ignore: cast_nullable_to_non_nullable
              as dynamic,
      canOwner: freezed == canOwner
          ? _value.canOwner
          : canOwner // ignore: cast_nullable_to_non_nullable
              as bool?,
      urlImage: freezed == urlImage
          ? _value.urlImage
          : urlImage // ignore: cast_nullable_to_non_nullable
              as String?,
      customUrlImage: freezed == customUrlImage
          ? _value.customUrlImage
          : customUrlImage // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarUrl: freezed == avatarUrl
          ? _value.avatarUrl
          : avatarUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      isLocationEnabled: freezed == isLocationEnabled
          ? _value.isLocationEnabled
          : isLocationEnabled // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl implements _User {
  _$UserImpl(
      {this.id,
      @JsonKey(name: 'created_at') this.createdAt,
      @JsonKey(name: 'updated_at') this.updatedAt,
      @JsonKey(name: 'deleted_at') this.deletedAt,
      @JsonKey(name: 'first_name') this.firstName,
      @JsonKey(name: 'last_name') this.lastName,
      @JsonKey(name: 'nick_name') this.nickName,
      @JsonKey(name: 'phone_number') this.phoneNumber,
      @JsonKey(name: 'access_role') this.accessRole,
      @JsonKey(name: 'city_id') this.cityId,
      @JsonKey(name: 'birth_date') this.birthDate,
      this.iin,
      this.rating,
      this.city,
      @JsonKey(name: 'can_driver') this.canDriver,
      @JsonKey(name: 'owner_id') this.ownerId,
      this.owner,
      @JsonKey(name: 'can_owner') this.canOwner,
      @JsonKey(name: 'url_document') this.urlImage,
      @JsonKey(name: 'custom_url_document') this.customUrlImage,
      @JsonKey(name: 'avatar_url') this.avatarUrl,
      @JsonKey(name: 'email') this.email,
      @JsonKey(name: 'is_location_enabled') this.isLocationEnabled});

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

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
  @JsonKey(name: 'first_name')
  final String? firstName;
  @override
  @JsonKey(name: 'last_name')
  final String? lastName;
  @override
  @JsonKey(name: 'nick_name')
  final String? nickName;
  @override
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @override
  @JsonKey(name: 'access_role')
  final String? accessRole;
  @override
  @JsonKey(name: 'city_id')
  final int? cityId;
  @override
  @JsonKey(name: 'birth_date')
  final String? birthDate;
  @override
  final String? iin;
  @override
  final double? rating;
  @override
  final City? city;
  @override
  @JsonKey(name: 'can_driver')
  final bool? canDriver;
  @override
  @JsonKey(name: 'owner_id')
  final dynamic ownerId;
  @override
  final dynamic owner;
  @override
  @JsonKey(name: 'can_owner')
  final bool? canOwner;
  @override
  @JsonKey(name: 'url_document')
  final String? urlImage;
  @override
  @JsonKey(name: 'custom_url_document')
  final String? customUrlImage;
  @override
  @JsonKey(name: 'avatar_url')
  final String? avatarUrl;
  @override
  @JsonKey(name: 'email')
  final String? email;
  @override
  @JsonKey(name: 'is_location_enabled')
  final bool? isLocationEnabled;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.deletedAt, deletedAt) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.nickName, nickName) ||
                other.nickName == nickName) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.accessRole, accessRole) ||
                other.accessRole == accessRole) &&
            (identical(other.cityId, cityId) || other.cityId == cityId) &&
            (identical(other.birthDate, birthDate) ||
                other.birthDate == birthDate) &&
            (identical(other.iin, iin) || other.iin == iin) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.canDriver, canDriver) ||
                other.canDriver == canDriver) &&
            const DeepCollectionEquality().equals(other.ownerId, ownerId) &&
            const DeepCollectionEquality().equals(other.owner, owner) &&
            (identical(other.canOwner, canOwner) ||
                other.canOwner == canOwner) &&
            (identical(other.urlImage, urlImage) ||
                other.urlImage == urlImage) &&
            (identical(other.customUrlImage, customUrlImage) ||
                other.customUrlImage == customUrlImage) &&
            (identical(other.avatarUrl, avatarUrl) ||
                other.avatarUrl == avatarUrl) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.isLocationEnabled, isLocationEnabled) ||
                other.isLocationEnabled == isLocationEnabled));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(deletedAt),
        firstName,
        lastName,
        nickName,
        phoneNumber,
        accessRole,
        cityId,
        birthDate,
        iin,
        rating,
        city,
        canDriver,
        const DeepCollectionEquality().hash(ownerId),
        const DeepCollectionEquality().hash(owner),
        canOwner,
        urlImage,
        customUrlImage,
        avatarUrl,
        email,
        isLocationEnabled
      ]);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(
      this,
    );
  }
}

abstract class _User implements User {
  factory _User(
      {final int? id,
      @JsonKey(name: 'created_at') final DateTime? createdAt,
      @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @JsonKey(name: 'deleted_at') final dynamic deletedAt,
      @JsonKey(name: 'first_name') final String? firstName,
      @JsonKey(name: 'last_name') final String? lastName,
      @JsonKey(name: 'nick_name') final String? nickName,
      @JsonKey(name: 'phone_number') final String? phoneNumber,
      @JsonKey(name: 'access_role') final String? accessRole,
      @JsonKey(name: 'city_id') final int? cityId,
      @JsonKey(name: 'birth_date') final String? birthDate,
      final String? iin,
      final double? rating,
      final City? city,
      @JsonKey(name: 'can_driver') final bool? canDriver,
      @JsonKey(name: 'owner_id') final dynamic ownerId,
      final dynamic owner,
      @JsonKey(name: 'can_owner') final bool? canOwner,
      @JsonKey(name: 'url_document') final String? urlImage,
      @JsonKey(name: 'custom_url_document') final String? customUrlImage,
      @JsonKey(name: 'avatar_url') final String? avatarUrl,
      @JsonKey(name: 'email') final String? email,
      @JsonKey(name: 'is_location_enabled')
      final bool? isLocationEnabled}) = _$UserImpl;

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

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
  @JsonKey(name: 'first_name')
  String? get firstName;
  @override
  @JsonKey(name: 'last_name')
  String? get lastName;
  @override
  @JsonKey(name: 'nick_name')
  String? get nickName;
  @override
  @JsonKey(name: 'phone_number')
  String? get phoneNumber;
  @override
  @JsonKey(name: 'access_role')
  String? get accessRole;
  @override
  @JsonKey(name: 'city_id')
  int? get cityId;
  @override
  @JsonKey(name: 'birth_date')
  String? get birthDate;
  @override
  String? get iin;
  @override
  double? get rating;
  @override
  City? get city;
  @override
  @JsonKey(name: 'can_driver')
  bool? get canDriver;
  @override
  @JsonKey(name: 'owner_id')
  dynamic get ownerId;
  @override
  dynamic get owner;
  @override
  @JsonKey(name: 'can_owner')
  bool? get canOwner;
  @override
  @JsonKey(name: 'url_document')
  String? get urlImage;
  @override
  @JsonKey(name: 'custom_url_document')
  String? get customUrlImage;
  @override
  @JsonKey(name: 'avatar_url')
  String? get avatarUrl;
  @override
  @JsonKey(name: 'email')
  String? get email;
  @override
  @JsonKey(name: 'is_location_enabled')
  bool? get isLocationEnabled;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
