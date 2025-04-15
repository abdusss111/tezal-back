import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';

import 'package:eqshare_mobile/src/features/ad/data/models/ad_sm_models/ad_sm_client_model/ad_client.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'specialized_machinery_request_client.freezed.dart';
part 'specialized_machinery_request_client.g.dart';

@freezed
class SpecializedMachineryRequestClient
    with _$SpecializedMachineryRequestClient {
  factory SpecializedMachineryRequestClient({
    int? id,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
    @JsonKey(name: 'deleted_at') dynamic deletedAt,
    @JsonKey(name: 'ad_client_id') int? adClientId,
    @JsonKey(name: 'ad_client') AdClient? adSm,
    @JsonKey(name: 'user_id') userId,
    User? user,
    int? assigned,
    @JsonKey(name: 'user_assigned') User? executorUser,
    String? comment,
    String? status,
  }) = _SpecializedMachineryRequestClient;

  factory SpecializedMachineryRequestClient.fromJson(
          Map<String, dynamic> json) =>
      _$SpecializedMachineryRequestClientFromJson(json);
}
