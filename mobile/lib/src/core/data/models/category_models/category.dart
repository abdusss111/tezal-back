import 'package:freezed_annotation/freezed_annotation.dart';

import 'sub_category.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
class Category with _$Category {
  factory Category({
    int? id,
    String? name,
    @JsonKey(name: 'sub_categories') List<SubCategory>? subCategories,
    @JsonKey(name: 'documents') List<dynamic>? documents,
    @JsonKey(name: 'url_foto') List<String>? urlFoto,

  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
