import 'package:freezed_annotation/freezed_annotation.dart';

part 'sub_category.freezed.dart';
part 'sub_category.g.dart';

@freezed
class SubCategory with _$SubCategory {
  factory SubCategory({
    int? id,
    String? name,
    List<dynamic>? documents,
    @JsonKey(name: 'sub_category_id') int? mainCategoryID,
    @JsonKey(name: 'url_foto') List<String>? urlFoto,
  }) = _SubCategory;

  factory SubCategory.fromJson(Map<String, dynamic> json) =>
      _$SubCategoryFromJson(json);



  static SubCategory getSubCategoryForCM(Map<String,dynamic> data){
    return SubCategory(
      id: data['id'] as int? ?? 0,
      name: data['name'] as String? ?? '',
      mainCategoryID: data['construction_material_categories_id'] as int? ?? 0
    );
  }

   static SubCategory getSubCategoryForSVM(Map<String,dynamic> data){
    return SubCategory(
      id: data['id'] as int? ?? 0,
      name: data['name'] as String? ?? '',
      mainCategoryID: data['service_categories_id'] as int? ?? 0
    );
  }

  static SubCategory getSubCategoryForEQ(Map<String,dynamic> data){
    return SubCategory(
      id: data['id'] as int? ?? 0,
      name: data['name'] as String? ?? '',
      mainCategoryID: data['equipment_categories_id'] as int? ?? 0
    );
  }
}
