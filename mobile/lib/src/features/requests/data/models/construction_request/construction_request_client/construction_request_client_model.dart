import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_contruction_models/ad_construction_client_model.dart/ad_construction_client_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'construction_request_client_model.freezed.dart';
part 'construction_request_client_model.g.dart';

@freezed
class ConstructionRequestClientModel with _$ConstructionRequestClientModel {
  factory ConstructionRequestClientModel({
    int? id,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'deleted_at') dynamic deletedAt,
    @JsonKey(name: 'ad_construction_material_client_id')int? adConstructionMaterialClientId,
    @JsonKey(name: 'ad_construction_material_client') AdConstructionClientModel? adConstructionClientModel,
    @JsonKey(name: 'user_id') userId,
    User? user,
    @JsonKey(name: 'executor_id') int? executorId,
    @JsonKey(name: 'executor') User? executorUser,
    String? description,
    String? status,





    

  }) = _ConstructionRequestClientModel;

  factory ConstructionRequestClientModel.fromJson(Map<String, dynamic> json) =>
      _$ConstructionRequestClientModelFromJson(json);
}