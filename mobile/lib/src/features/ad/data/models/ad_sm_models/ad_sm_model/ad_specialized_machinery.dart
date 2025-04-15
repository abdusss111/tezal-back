import 'package:eqshare_mobile/src/core/data/models/brand/brand.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:eqshare_mobile/src/core/data/models/city_detail_model/city.dart';
import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'params.dart';

part 'ad_specialized_machinery.freezed.dart';
part 'ad_specialized_machinery.g.dart';

@freezed
class AdSpecializedMachinery with _$AdSpecializedMachinery {
  factory AdSpecializedMachinery({
    int? id,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    @JsonKey(name: 'user_id') int? userId,
    User? user,
    @JsonKey(name: 'brand_id') int? brandId,
    Brand? brand,
    @JsonKey(name: 'type_id') int? typeId,
    SubCategory? type,
    @JsonKey(name: 'city_id') int? cityId,
    City? city,
    int? price,
    String? name,
    String? description,
    @JsonKey(name: 'count_rate') int? countRate,
    double? rating,
    @JsonKey(name: 'url_foto') List<String>? urlFoto,
    @JsonKey(name: 'url_thumbnail') List<String>? urlThumbnail,
    String? address,
    double? latitude,
    double? longitude,
    Params? params,
  }) = _AdSpecializedMachinery;

  factory AdSpecializedMachinery.fromJson(Map<String, dynamic> json) =>
      _$AdSpecializedMachineryFromJson(json);

  static AdListRowData getAdListRowDataFromSM(AdSpecializedMachinery e,{String? status,bool? isClientType}) {
    return AdListRowData(
        address: e.address,
        title: e.name,
        allServiceTypeEnum: AllServiceTypeEnum.MACHINARY,
        deletedAt: e.deletedAt,
        id: e.id,
        price: e.price?.toDouble(),
        category: e.type?.name,
        city: e.city?.name,
        status: status,
        isClientType: isClientType,
        imageUrl:
            e.urlFoto != null && e.urlFoto!.isNotEmpty ? e.urlFoto?.first : '',
        imageUrls: e.urlFoto,
        createdAt: e.createdAt.toString());
  }
}
