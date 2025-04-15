import 'package:eqshare_mobile/src/core/data/models/brand/brand.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:eqshare_mobile/src/core/data/models/city_detail_model/city.dart';
import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'ad_service_model.freezed.dart';
part 'ad_service_model.g.dart';

@freezed
class AdServiceModel with _$AdServiceModel {
  const factory AdServiceModel({
    int? id,
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

    double? rating,
  }) = _AdServiceModel;

  factory AdServiceModel.fromJson(Map<String, dynamic> json) =>
      _$AdServiceModelFromJson(json);
  static AdListRowData getAdListRowDataFromSM(AdServiceModel e,
      {bool? isClientType}) {
    return AdListRowData(
        address: e.address,
        title: e.title,
        allServiceTypeEnum: AllServiceTypeEnum.SVM,
        deletedAt: e.deletedAt,
        id: e.id,
        price: e.price?.toDouble(),
        category: e.subcategory?.name,
        city: e.city?.name,
        imageUrls: e.urlFoto,
        imageUrl:
            e.urlFoto != null && e.urlFoto!.isNotEmpty ? e.urlFoto?.first : '',
        createdAt: e.createdAt.toString());
  }
}
