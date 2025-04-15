import 'package:freezed_annotation/freezed_annotation.dart';

import 'statistic.dart';

part 'request_statistic.freezed.dart';
part 'request_statistic.g.dart';

@freezed
class RequestStatistic with _$RequestStatistic {
  factory RequestStatistic({
    Statistic? statistic,
  }) = _RequestStatistic;

  factory RequestStatistic.fromJson(Map<String, dynamic> json) =>
      _$RequestStatisticFromJson(json);
}
