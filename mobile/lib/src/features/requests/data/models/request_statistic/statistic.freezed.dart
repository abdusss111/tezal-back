// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statistic.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Statistic _$StatisticFromJson(Map<String, dynamic> json) {
  return _Statistic.fromJson(json);
}

/// @nodoc
mixin _$Statistic {
  @JsonKey(name: 'awaits_start')
  int? get awaitsStart => throw _privateConstructorUsedError;
  int? get working => throw _privateConstructorUsedError;
  int? get pause => throw _privateConstructorUsedError;
  int? get finished => throw _privateConstructorUsedError;
  @JsonKey(name: 'on_road')
  int? get onRoad => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_work')
  int? get totalWork => throw _privateConstructorUsedError;
  int? get total => throw _privateConstructorUsedError;

  /// Serializes this Statistic to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Statistic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StatisticCopyWith<Statistic> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatisticCopyWith<$Res> {
  factory $StatisticCopyWith(Statistic value, $Res Function(Statistic) then) =
      _$StatisticCopyWithImpl<$Res, Statistic>;
  @useResult
  $Res call(
      {@JsonKey(name: 'awaits_start') int? awaitsStart,
      int? working,
      int? pause,
      int? finished,
      @JsonKey(name: 'on_road') int? onRoad,
      @JsonKey(name: 'total_work') int? totalWork,
      int? total});
}

/// @nodoc
class _$StatisticCopyWithImpl<$Res, $Val extends Statistic>
    implements $StatisticCopyWith<$Res> {
  _$StatisticCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Statistic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? awaitsStart = freezed,
    Object? working = freezed,
    Object? pause = freezed,
    Object? finished = freezed,
    Object? onRoad = freezed,
    Object? totalWork = freezed,
    Object? total = freezed,
  }) {
    return _then(_value.copyWith(
      awaitsStart: freezed == awaitsStart
          ? _value.awaitsStart
          : awaitsStart // ignore: cast_nullable_to_non_nullable
              as int?,
      working: freezed == working
          ? _value.working
          : working // ignore: cast_nullable_to_non_nullable
              as int?,
      pause: freezed == pause
          ? _value.pause
          : pause // ignore: cast_nullable_to_non_nullable
              as int?,
      finished: freezed == finished
          ? _value.finished
          : finished // ignore: cast_nullable_to_non_nullable
              as int?,
      onRoad: freezed == onRoad
          ? _value.onRoad
          : onRoad // ignore: cast_nullable_to_non_nullable
              as int?,
      totalWork: freezed == totalWork
          ? _value.totalWork
          : totalWork // ignore: cast_nullable_to_non_nullable
              as int?,
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StatisticImplCopyWith<$Res>
    implements $StatisticCopyWith<$Res> {
  factory _$$StatisticImplCopyWith(
          _$StatisticImpl value, $Res Function(_$StatisticImpl) then) =
      __$$StatisticImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'awaits_start') int? awaitsStart,
      int? working,
      int? pause,
      int? finished,
      @JsonKey(name: 'on_road') int? onRoad,
      @JsonKey(name: 'total_work') int? totalWork,
      int? total});
}

/// @nodoc
class __$$StatisticImplCopyWithImpl<$Res>
    extends _$StatisticCopyWithImpl<$Res, _$StatisticImpl>
    implements _$$StatisticImplCopyWith<$Res> {
  __$$StatisticImplCopyWithImpl(
      _$StatisticImpl _value, $Res Function(_$StatisticImpl) _then)
      : super(_value, _then);

  /// Create a copy of Statistic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? awaitsStart = freezed,
    Object? working = freezed,
    Object? pause = freezed,
    Object? finished = freezed,
    Object? onRoad = freezed,
    Object? totalWork = freezed,
    Object? total = freezed,
  }) {
    return _then(_$StatisticImpl(
      awaitsStart: freezed == awaitsStart
          ? _value.awaitsStart
          : awaitsStart // ignore: cast_nullable_to_non_nullable
              as int?,
      working: freezed == working
          ? _value.working
          : working // ignore: cast_nullable_to_non_nullable
              as int?,
      pause: freezed == pause
          ? _value.pause
          : pause // ignore: cast_nullable_to_non_nullable
              as int?,
      finished: freezed == finished
          ? _value.finished
          : finished // ignore: cast_nullable_to_non_nullable
              as int?,
      onRoad: freezed == onRoad
          ? _value.onRoad
          : onRoad // ignore: cast_nullable_to_non_nullable
              as int?,
      totalWork: freezed == totalWork
          ? _value.totalWork
          : totalWork // ignore: cast_nullable_to_non_nullable
              as int?,
      total: freezed == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StatisticImpl implements _Statistic {
  _$StatisticImpl(
      {@JsonKey(name: 'awaits_start') this.awaitsStart,
      this.working,
      this.pause,
      this.finished,
      @JsonKey(name: 'on_road') this.onRoad,
      @JsonKey(name: 'total_work') this.totalWork,
      this.total});

  factory _$StatisticImpl.fromJson(Map<String, dynamic> json) =>
      _$$StatisticImplFromJson(json);

  @override
  @JsonKey(name: 'awaits_start')
  final int? awaitsStart;
  @override
  final int? working;
  @override
  final int? pause;
  @override
  final int? finished;
  @override
  @JsonKey(name: 'on_road')
  final int? onRoad;
  @override
  @JsonKey(name: 'total_work')
  final int? totalWork;
  @override
  final int? total;

  @override
  String toString() {
    return 'Statistic(awaitsStart: $awaitsStart, working: $working, pause: $pause, finished: $finished, onRoad: $onRoad, totalWork: $totalWork, total: $total)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatisticImpl &&
            (identical(other.awaitsStart, awaitsStart) ||
                other.awaitsStart == awaitsStart) &&
            (identical(other.working, working) || other.working == working) &&
            (identical(other.pause, pause) || other.pause == pause) &&
            (identical(other.finished, finished) ||
                other.finished == finished) &&
            (identical(other.onRoad, onRoad) || other.onRoad == onRoad) &&
            (identical(other.totalWork, totalWork) ||
                other.totalWork == totalWork) &&
            (identical(other.total, total) || other.total == total));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, awaitsStart, working, pause,
      finished, onRoad, totalWork, total);

  /// Create a copy of Statistic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StatisticImplCopyWith<_$StatisticImpl> get copyWith =>
      __$$StatisticImplCopyWithImpl<_$StatisticImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StatisticImplToJson(
      this,
    );
  }
}

abstract class _Statistic implements Statistic {
  factory _Statistic(
      {@JsonKey(name: 'awaits_start') final int? awaitsStart,
      final int? working,
      final int? pause,
      final int? finished,
      @JsonKey(name: 'on_road') final int? onRoad,
      @JsonKey(name: 'total_work') final int? totalWork,
      final int? total}) = _$StatisticImpl;

  factory _Statistic.fromJson(Map<String, dynamic> json) =
      _$StatisticImpl.fromJson;

  @override
  @JsonKey(name: 'awaits_start')
  int? get awaitsStart;
  @override
  int? get working;
  @override
  int? get pause;
  @override
  int? get finished;
  @override
  @JsonKey(name: 'on_road')
  int? get onRoad;
  @override
  @JsonKey(name: 'total_work')
  int? get totalWork;
  @override
  int? get total;

  /// Create a copy of Statistic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatisticImplCopyWith<_$StatisticImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
