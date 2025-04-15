import 'package:freezed_annotation/freezed_annotation.dart';
part 'city.freezed.dart';
part 'city.g.dart';

@freezed
class City with _$City {
  factory City({
    int? id,
    String? name,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'deleted_at') dynamic deletedAt,
    double? latitude,
    double? longitude,
  }) = _City;


  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}
