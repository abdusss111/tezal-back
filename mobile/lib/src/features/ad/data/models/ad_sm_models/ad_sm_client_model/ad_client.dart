import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:eqshare_mobile/src/core/data/models/cities/city/city_model.dart';
import 'package:eqshare_mobile/src/core/data/models/document/document.dart';
import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/features/ad/data/classes/ad_list_row_data.dart';
import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ad_client.freezed.dart';
part 'ad_client.g.dart';

@freezed
class AdClient with _$AdClient {
  const factory AdClient({
    required int id,
    String? description,
    required String headline,
    double? price,
    @JsonKey(name: 'type_id') int? typeId,
    SubCategory? type,
    List<Document>? documents,
    @JsonKey(name: 'start_date') String? startDate,
    @JsonKey(name: 'end_date') dynamic endDate,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    @JsonKey(name: 'url_thumbnail') List<String>? urlThumbnail,
    User? user,
    required String address,
    double? latitude,
    double? longitude,
    String? status,
    City? city,
    @JsonKey(name: 'city_id') int? cityId,

  }) = _AdClient;
  factory AdClient.fromJson(Map<String, dynamic> json) =>
      _$AdClientFromJson(json);

  static AdListRowData getAdListRowDataFromSM(AdClient e,
      {bool? isClientType, String? imageUrl}) {
    String? imageUrl;

    if (e.documents == null || e.documents?.isEmpty == true) {
      imageUrl = imageUrl ?? '';

    } else {
      imageUrl = e.documents?.first.shareLink ?? imageUrl ?? '';

    }
    
    return AdListRowData(
        address: e.address,
        title: e.headline,
        allServiceTypeEnum: AllServiceTypeEnum.MACHINARY_CLIENT,
        deletedAt: e.deletedAt,
        id: e.id,
        price: e.price?.toDouble(),
        category: e.type?.name,
        city: e.city?.name,
        imageUrl: imageUrl,
        status: e.status,
        isClientType: isClientType,
        imageUrls: e.documents?.map((e) => e.shareLink ?? '').toList(),
        createdAt: e.createdAt.toString());
  }
}
