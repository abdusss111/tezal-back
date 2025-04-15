import 'package:freezed_annotation/freezed_annotation.dart';

import 'statistic.dart';

part 'request_history.freezed.dart';
part 'request_history.g.dart';

@freezed
class RequestHistory with _$RequestHistory {
  factory RequestHistory({
    List<Statistic>? statistic,
  }) = _RequestHistory;

  factory RequestHistory.fromJson(Map<String, dynamic> json) =>
      _$RequestHistoryFromJson(json);
}
