import 'package:eqshare_mobile/src/core/data/models/category_models/sub_category.dart';
import 'package:eqshare_mobile/src/core/data/models/city_detail_model/city.dart';
import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_model/ad_equipment.dart';

import 'package:freezed_annotation/freezed_annotation.dart';



part 'request_ad_equipment.freezed.dart';
part 'request_ad_equipment.g.dart';

@freezed
class RequestAdEquipment with _$RequestAdEquipment {
  const factory RequestAdEquipment({
    required int id,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'deleted_at') DateTime? deletedAt,
    String? status,
    @JsonKey(name: 'user_id') int? userId,
    User? user,
    @JsonKey(name: 'executor_id') int? executorId,
    User? executor,
    @JsonKey(name: 'ad_equipment_id') int? adEquipmentId,
    @JsonKey(name: 'ad_equipment') AdEquipment? adEquipment,
    @JsonKey(name: 'start_lease_at') String? startLeaseAt,
    @JsonKey(name: 'end_lease_at') String? endLeaseAt,
    @JsonKey(name: 'count_hour') dynamic countHour,
    @JsonKey(name: 'order_amount') dynamic orderAmount,
    @JsonKey(name: 'equipment_sub_category') SubCategory? subCategory,
    String? description,
    String? address,
    double? latitude,
    double? longitude,
    double? price,
    String? title,
    City? city,
 
    @JsonKey(name: 'url_foto') List<String>? urlFoto,
  }) = _RequestAdEquipment;

  factory RequestAdEquipment.fromJson(Map<String, dynamic> json) =>
      _$RequestAdEquipmentFromJson(json);
}
