import 'package:freezed_annotation/freezed_annotation.dart';

part 'statistic.freezed.dart';
part 'statistic.g.dart';

@freezed
class Statistic with _$Statistic {
  factory Statistic({
    @JsonKey(name: 'awaits_start') int? awaitsStart,
    int? working,
    int? pause,
    int? finished,
    @JsonKey(name: 'on_road') int? onRoad,
    @JsonKey(name: 'total_work') int? totalWork,
    int? total,
  }) = _Statistic;

  factory Statistic.fromJson(Map<String, dynamic> json) =>
      _$StatisticFromJson(json);
}
