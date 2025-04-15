import 'package:eqshare_mobile/src/global_widgets/global_values.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'ad_list_row_data.freezed.dart';
part 'ad_list_row_data.g.dart';

@freezed
class AdListRowData with _$AdListRowData {
  factory AdListRowData(
      {int? id,
      String? city,
      String? title,
      String? createdAt,
      String? imageUrl,
      String? thumbnailUrl,
      List<String>? imageUrls,
      List<String>? thumbnailUrls,
      String? address,
      String? status,
      bool? isClientType,
      String? category,
      dynamic deletedAt,
      double? price,
      AllServiceTypeEnum? allServiceTypeEnum,
      double? rating}) = _AdListRowData;

  factory AdListRowData.fromJson(Map<String, dynamic> json) =>
      _$AdListRowDataFromJson(json);
}
