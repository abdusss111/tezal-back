import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_model/ad_constrution_model.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_model/ad_service_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_request_model.freezed.dart';
part 'service_request_model.g.dart';

@freezed
class ServiceRequestModel with _$ServiceRequestModel {
  factory ServiceRequestModel({
    int? id,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'deleted_at') dynamic deletedAt,
    @JsonKey(name: 'ad_service_id')int? adID,
    @JsonKey(name: 'ad_service') AdServiceModel? ad,
    @JsonKey(name: 'user_id') userId,
    User? user,
    @JsonKey(name: 'executor_id') int? executorId,
    @JsonKey(name: 'executor') User? executor,
    String? description,
    String? status,
    @JsonKey(name: 'start_lease_at') String? startLeaseAt,
    @JsonKey(name: 'end_lease_at') String? endLeaseAt,
    @JsonKey(name: 'count_hour') int? countHour,
    int? latitude,
    int? longitude, 
    @JsonKey(name: 'order_amount') int? orderAmount,
    String? address,
    @JsonKey(name: 'url_foto') List<String>? imagesUrl,








    

  }) = _ServiceRequestModel;

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceRequestModelFromJson(json);
}