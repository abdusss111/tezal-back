import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';


part 'ad_service_interacted.freezed.dart';
part 'ad_service_interacted.g.dart';

@freezed
class AdServiceInteracted with _$AdServiceInteracted {
  factory AdServiceInteracted({
    int? id,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'deleted_at') dynamic deletedAt,
    @JsonKey(name: 'ad_service_id') int? adServiceId,
    @JsonKey(name: 'user_id') int? userId,
    User? user,
  }) = _AdServiceInteracted;

  factory AdServiceInteracted.fromJson(Map<String, dynamic> json) =>
      _$AdServiceInteractedFromJson(json);
}
