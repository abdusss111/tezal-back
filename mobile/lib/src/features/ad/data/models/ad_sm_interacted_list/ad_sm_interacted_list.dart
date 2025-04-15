import 'package:freezed_annotation/freezed_annotation.dart';

import 'ad_service_interacted.dart';

part 'ad_sm_interacted_list.freezed.dart';
part 'ad_sm_interacted_list.g.dart';

@freezed
class AdSmInteractedList with _$AdSmInteractedList {
  factory AdSmInteractedList({
    @JsonKey(name: 'ad_service_interacted')
    List<AdServiceInteracted>? adServiceInteracted,
  }) = _AdSmInteractedList;

  factory AdSmInteractedList.fromJson(Map<String, dynamic> json) =>
      _$AdSmInteractedListFromJson(json);
}
