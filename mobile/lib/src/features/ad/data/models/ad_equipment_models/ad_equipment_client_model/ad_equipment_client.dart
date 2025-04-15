import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:eqshare_mobile/src/core/data/models/city_detail_model/city.dart';
import 'package:eqshare_mobile/src/core/data/models/document/document.dart';
import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ad_equipment_client.freezed.dart';
part 'ad_equipment_client.g.dart';

@freezed
class AdEquipmentClient with _$AdEquipmentClient {
  const factory AdEquipmentClient({
    int? id,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'deleted_at') dynamic deletedAt,
    @JsonKey(name: 'user_id') int? userId,
    User? user,
    @JsonKey(name: 'city_id') int? cityId,
    City? city,
    @JsonKey(name: 'equipment_sub_category_id') int? equipmentSubcategoryId,
    @JsonKey(
        name: 'equipment_sub_category',
        fromJson: SubCategory.getSubCategoryForEQ)
    SubCategory? equipmentSubcategory,
    String? status,
    String? title,
    String? description,
    double? price,
    @JsonKey(name: 'start_lease_date') String? startLeaseDate,
    @JsonKey(name: 'end_lease_date') String? endLeaseDate,
    String? address,
    double? latitude,
    double? longitude,
    List<Document>? document,
    @JsonKey(name: 'url_foto') List<String>? urlFoto,
    @JsonKey(name: 'url_thumbnail') List<String>? urlThumbnail,
  }) = _AdEquipmentClient;

  factory AdEquipmentClient.fromJson(Map<String, dynamic> json) =>
      _$AdEquipmentClientFromJson(json);

  static AdListRowData getAdListRowDataFromSM(AdEquipmentClient e,
      {bool? isClientType, String? imageUrl}) {
    return AdListRowData(
        address: e.address,
        title: e.title,
        allServiceTypeEnum: AllServiceTypeEnum.EQUIPMENT_CLIENT,
        deletedAt: e.deletedAt,
        id: e.id,
        price: e.price?.toDouble(),
        category: e.equipmentSubcategory?.name,
        city: e.city?.name,
        imageUrls: e.urlFoto,
        status: e.status,
        isClientType: isClientType,
        imageUrl: e.urlFoto != null && e.urlFoto!.isNotEmpty
            ? e.urlFoto?.first
            : imageUrl ?? '',
        createdAt: e.createdAt.toString());
  }
}
