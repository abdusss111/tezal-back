import 'package:eqshare_mobile/src/core/data/models/user_model/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';



part 'ad_client_interacted.freezed.dart';
part 'ad_client_interacted.g.dart';

@freezed
class AdClientInteracted with _$AdClientInteracted {
  factory AdClientInteracted({
    int? id,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'deleted_at') dynamic deletedAt,
    @JsonKey(name: 'ad_client_id') int? adClientId,
    @JsonKey(name: 'user_id') int? userId,
    @JsonKey(name: 'user_rating') int? userRating,
    User? user,
  }) = _AdClientInteracted;

  factory AdClientInteracted.fromJson(Map<String, dynamic> json) =>
      _$AdClientInteractedFromJson(json);
}
