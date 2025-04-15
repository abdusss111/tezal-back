import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:eqshare_mobile/src/features/ad/data/models/ad_equipment_models/ad_equipment_client_model/ad_equipment_client.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'request_ad_equipment_client.freezed.dart';
part 'request_ad_equipment_client.g.dart';

@freezed
class RequestAdEquipmentClient with _$RequestAdEquipmentClient {
  factory RequestAdEquipmentClient({
    int? id,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'deleted_at') dynamic? deletedAt,
    @JsonKey(name: 'ad_equipment_client_id') int? adEquipmentClientId,
    @JsonKey(name: 'ad_equipment_client') AdEquipmentClient? adEquipmentClient,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'executor_id') int? executorId,
    @JsonKey(name: 'executor') User? executor,
    @JsonKey(name: 'user') User? user,
    String? status,
    String? description,
  }) = _RequestAdEquipmentClient;

  factory RequestAdEquipmentClient.fromJson(Map<String, dynamic> json) =>
      _$RequestAdEquipmentClientFromJson(json);
}
