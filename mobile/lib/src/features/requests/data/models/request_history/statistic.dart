import 'package:freezed_annotation/freezed_annotation.dart';

part 'statistic.freezed.dart';
part 'statistic.g.dart';

@freezed
class Statistic with _$Statistic {
  factory Statistic({
    @JsonKey(name: 'id') int? id,
    @JsonKey(name: 'status') String? status,
    @JsonKey(name: 'start_status_at') DateTime? startStatusAt,
    @JsonKey(name: 'end_status_at') DateTime? endStatusAt,
    @JsonKey(name: 'duration') int? duration,
    @JsonKey(name: 'work_started_at') dynamic workStartedAt,
    @JsonKey(name: 'work_end_at') dynamic workEndAt,
    @JsonKey(name: 'rate') int? rate,
  }) = _Statistic;

  factory Statistic.fromJson(Map<String, dynamic> json) =>
      _$StatisticFromJson(json);
}
