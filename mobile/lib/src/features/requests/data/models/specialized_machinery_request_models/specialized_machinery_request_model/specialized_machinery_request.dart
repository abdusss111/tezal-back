import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_model/ad_specialized_machinery.dart';
import 'package:freezed_annotation/freezed_annotation.dart';



part 'specialized_machinery_request.freezed.dart';
part 'specialized_machinery_request.g.dart';

@freezed
class SpecializedMachineryRequest with _$SpecializedMachineryRequest {
  factory SpecializedMachineryRequest({
    int? id,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'deleted_at') dynamic deletedAt,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'user') User? user,
    @JsonKey(name: 'ad_specialized_machinery_id') int? adSpecializedMachineryId,
    @JsonKey(name: 'ad_specialized_machinery')
    AdSpecializedMachinery? adSpecializedMachinery,
    @JsonKey(name: 'start_lease_at') DateTime? startLeaseAt,
    @JsonKey(name: 'end_lease_at') DateTime? endLeaseAt,
    @JsonKey(name: 'count_hour') int? countHour,
    String? address,
    @JsonKey(name: 'order_amount') double? orderAmount,
    String? description,
    String? status,
    @JsonKey(name: 'url_foto') List<String>? urlFoto,
    double? latitude,
    double? longitude,
  }) = _SpecializedMachineryRequest;

  factory SpecializedMachineryRequest.fromJson(Map<String, dynamic> json) =>
      _$SpecializedMachineryRequestFromJson(json);
}
