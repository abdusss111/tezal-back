import 'package:eqshare_mobile/src/core/data/models/brand/brand.dart';
import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:eqshare_mobile/src/core/data/models/cities/city/city_model.dart';
import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ad_equipment.freezed.dart';
part 'ad_equipment.g.dart';

@freezed
class AdEquipment with _$AdEquipment {
  const factory AdEquipment({
    required int id,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    @JsonKey(
        name: 'equipment_sub_category',
        fromJson: SubCategory.getSubCategoryForEQ)
    SubCategory? subcategory,
    City? city,
    User? user,
    @JsonKey(name: 'equipment_brand') Brand? brand,
    required double price,
    required String title,
    String? description,
    required String address,
    double? rating,
    double? latitude,
    double? longitude,
    @JsonKey(name: 'url_foto') List<String>? urlFoto,
    @JsonKey(name: 'url_thumbnail') List<String>? urlThumbnail,
    Map<String, dynamic>? params,
    @JsonKey(name: 'city_id') int? cityId,

  }) = _AdEquipment;
  factory AdEquipment.fromJson(Map<String, dynamic> json) =>
      _$AdEquipmentFromJson(json);

  static AdListRowData getAdListRowDataFromSM(AdEquipment e,
      {String? status, bool? isClienType, String? imageUrl}) {
    return AdListRowData(
        address: e.address,
        title: e.title,
        allServiceTypeEnum: AllServiceTypeEnum.EQUIPMENT_CLIENT,
        deletedAt: e.deletedAt,
        id: e.id,
        status: status,
        isClientType: isClienType,
        rating: e.rating,
        price: e.price.toDouble(),
        category: e.subcategory?.name,
        city: e.city?.name,
        imageUrls: e.urlFoto,
        imageUrl: e.urlFoto != null && e.urlFoto!.isNotEmpty
            ? e.urlFoto?.first
            : imageUrl ?? '',
        createdAt: e.createdAt.toString());
  }
}
