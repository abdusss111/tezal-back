import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';

import 'package:eqshare_mobile/src/features/ad/data/models/ad_service_models/ad_service_client_model/ad_service_client_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'service_request_client_model.freezed.dart';
part 'service_request_client_model.g.dart';

@freezed
class ServiceRequestClientModel with _$ServiceRequestClientModel {
  factory ServiceRequestClientModel({
    int? id,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'deleted_at') dynamic deletedAt,
    @JsonKey(name: 'ad_service_client_id') int? adClientID,
    @JsonKey(name: 'ad_service_client') AdServiceClientModel? adClient,
    @JsonKey(name: 'user_id') userId,
    User? user,
    @JsonKey(name: 'executor_id') int? executorId,
    @JsonKey(name: 'executor') User? executor,
    String? description,
    String? status,
  }) = _ServiceRequestClientModel;

  factory ServiceRequestClientModel.fromJson(Map<String, dynamic> json) =>
      _$ServiceRequestClientModelFromJson(json);
}
