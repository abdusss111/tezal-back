import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_model/ad_constrution_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'construction_request_model.freezed.dart';
part 'construction_request_model.g.dart';

@freezed
class ConstructionRequestModel with _$ConstructionRequestModel {
  factory ConstructionRequestModel({
    int? id,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'deleted_at') dynamic deletedAt,
    @JsonKey(name: 'ad_construction_material_id')int? adConstructionMaterialId,
    @JsonKey(name: 'ad_construction_material') AdConstrutionModel? adConstructionModel,
    @JsonKey(name: 'user_id') userId,
    User? user,
    @JsonKey(name: 'executor_id') int? executorId,
    @JsonKey(name: 'executor') User? executorUser,
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








    

  }) = _ConstructionRequestModel;

  factory ConstructionRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ConstructionRequestModelFromJson(json);
}