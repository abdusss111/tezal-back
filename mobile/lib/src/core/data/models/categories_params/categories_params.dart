import 'package:freezed_annotation/freezed_annotation.dart';



part 'categories_params.freezed.dart';
part 'categories_params.g.dart';

@freezed
class CategoriesParams with _$CategoriesParams {
  factory CategoriesParams({
    int? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'name_eng') String? nameEng,
  }) = _CategoriesParams;

  factory CategoriesParams.fromJson(Map<String, dynamic> json) =>
      _$CategoriesParamsFromJson(json);
}
