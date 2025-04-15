import 'package:freezed_annotation/freezed_annotation.dart';

import '../city_detail_model/city.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  factory User(
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
      @JsonKey(name: 'is_location_enabled') bool? isLocationEnabled}) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  @override
  String toString() {
    return '$firstName $lastName';
  }
}
