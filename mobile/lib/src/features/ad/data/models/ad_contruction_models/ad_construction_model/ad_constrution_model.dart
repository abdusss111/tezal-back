import 'package:eqshare_mobile/src/core/data/models/brand/brand.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:eqshare_mobile/src/core/data/models/city_detail_model/city.dart';
import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'ad_constrution_model.freezed.dart';
part 'ad_constrution_model.g.dart';

@freezed
class AdConstrutionModel with _$AdConstrutionModel {
  factory AdConstrutionModel({
    int? id,
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
    @JsonKey(name: 'url_thumbnail') List<String>? urlThumbnail,
  }) = _AdConstrutionModel;
  factory AdConstrutionModel.fromJson(Map<String, dynamic> json) =>
      _$AdConstrutionModelFromJson(json);

  static AdListRowData getAdListRowDataFromSM(AdConstrutionModel e,{bool? isClientType}) {
    return AdListRowData(
        address: e.address,
        title: e.title,
        allServiceTypeEnum: AllServiceTypeEnum.CM,
        deletedAt: e.deletedAt,
        id: e.id,
        
        price: e.price?.toDouble(),
        category: e.constructionMaterialSubCategory?.name,
        city: e.city?.name,
        imageUrls: e.urlFoto,
        imageUrl:
            e.urlFoto != null && e.urlFoto!.isNotEmpty ? e.urlFoto?.first : '',
        createdAt: e.createdAt.toString());
  }
}
