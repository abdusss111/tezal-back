import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:eqshare_mobile/src/core/data/models/city_detail_model/city.dart';
import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'ad_service_client_model.freezed.dart';
part 'ad_service_client_model.g.dart';

@freezed
class AdServiceClientModel with _$AdServiceClientModel {
  const factory AdServiceClientModel({
    int? id,
    @JsonKey(name: "created_at") String? createdAt,
    @JsonKey(name: "updated_at") String? updatedAt,
    @JsonKey(name: "deleted_at") String? deletedAt,
    @JsonKey(name: 'user_id') int? userID,
    User? user,
    String? status,
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
    List<dynamic>? document,
    @JsonKey(name: "start_lease_date") String? startLeaseDate,
    @JsonKey(name: "end_lease_date") String? endLeaseDate,
    @JsonKey(name: 'url_foto') List<String>? urlFoto,
    @JsonKey(name: 'url_thumbnail') List<String>? urlThumbnail,

    @JsonKey(name: 'count_rate') double? countRate,
    double? rating,
  }) = _AdServiceClientModel;
  factory AdServiceClientModel.fromJson(Map<String, dynamic> json) =>
      _$AdServiceClientModelFromJson(json);

  static AdListRowData getAdListRowDataFromSM(AdServiceClientModel e,{bool? isClientType}) {
    return AdListRowData(
        address: e.address,
        title: e.title,
        allServiceTypeEnum: AllServiceTypeEnum.SVM_CLIENT,
        deletedAt: e.deletedAt,
        id: e.id,
        status: e.status,
        isClientType: isClientType,
        price: e.price?.toDouble(),
        category: e.subcategory?.name,
        city: e.city?.name,
        imageUrls: e.urlFoto,
        imageUrl:
            e.urlFoto != null && e.urlFoto!.isNotEmpty ? e.urlFoto?.first : '',
        createdAt: e.createdAt.toString());
  }
}
