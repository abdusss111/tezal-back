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
  @JsonKey(name: 'id')
  int? get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'status')
  String? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'start_status_at')
  DateTime? get startStatusAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'end_status_at')
  DateTime? get endStatusAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'duration')
  int? get duration => throw _privateConstructorUsedError;
  @JsonKey(name: 'work_started_at')
  dynamic get workStartedAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'work_end_at')
  dynamic get workEndAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'rate')
  int? get rate => throw _privateConstructorUsedError;

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
      {@JsonKey(name: 'id') int? id,
      @JsonKey(name: 'status') String? status,
      @JsonKey(name: 'start_status_at') DateTime? startStatusAt,
      @JsonKey(name: 'end_status_at') DateTime? endStatusAt,
      @JsonKey(name: 'duration') int? duration,
      @JsonKey(name: 'work_started_at') dynamic workStartedAt,
      @JsonKey(name: 'work_end_at') dynamic workEndAt,
      @JsonKey(name: 'rate') int? rate});
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
    Object? id = freezed,
    Object? status = freezed,
    Object? startStatusAt = freezed,
    Object? endStatusAt = freezed,
    Object? duration = freezed,
    Object? workStartedAt = freezed,
    Object? workEndAt = freezed,
    Object? rate = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      startStatusAt: freezed == startStatusAt
          ? _value.startStatusAt
          : startStatusAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endStatusAt: freezed == endStatusAt
          ? _value.endStatusAt
          : endStatusAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
      workStartedAt: freezed == workStartedAt
          ? _value.workStartedAt
          : workStartedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      workEndAt: freezed == workEndAt
          ? _value.workEndAt
          : workEndAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      rate: freezed == rate
          ? _value.rate
          : rate // ignore: cast_nullable_to_non_nullable
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
      {@JsonKey(name: 'id') int? id,
      @JsonKey(name: 'status') String? status,
      @JsonKey(name: 'start_status_at') DateTime? startStatusAt,
      @JsonKey(name: 'end_status_at') DateTime? endStatusAt,
      @JsonKey(name: 'duration') int? duration,
      @JsonKey(name: 'work_started_at') dynamic workStartedAt,
      @JsonKey(name: 'work_end_at') dynamic workEndAt,
      @JsonKey(name: 'rate') int? rate});
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
    Object? id = freezed,
    Object? status = freezed,
    Object? startStatusAt = freezed,
    Object? endStatusAt = freezed,
    Object? duration = freezed,
    Object? workStartedAt = freezed,
    Object? workEndAt = freezed,
    Object? rate = freezed,
  }) {
    return _then(_$StatisticImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int?,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String?,
      startStatusAt: freezed == startStatusAt
          ? _value.startStatusAt
          : startStatusAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      endStatusAt: freezed == endStatusAt
          ? _value.endStatusAt
          : endStatusAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      duration: freezed == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int?,
      workStartedAt: freezed == workStartedAt
          ? _value.workStartedAt
          : workStartedAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      workEndAt: freezed == workEndAt
          ? _value.workEndAt
          : workEndAt // ignore: cast_nullable_to_non_nullable
              as dynamic,
      rate: freezed == rate
          ? _value.rate
          : rate // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StatisticImpl implements _Statistic {
  _$StatisticImpl(
      {@JsonKey(name: 'id') this.id,
      @JsonKey(name: 'status') this.status,
      @JsonKey(name: 'start_status_at') this.startStatusAt,
      @JsonKey(name: 'end_status_at') this.endStatusAt,
      @JsonKey(name: 'duration') this.duration,
      @JsonKey(name: 'work_started_at') this.workStartedAt,
      @JsonKey(name: 'work_end_at') this.workEndAt,
      @JsonKey(name: 'rate') this.rate});

  factory _$StatisticImpl.fromJson(Map<String, dynamic> json) =>
      _$$StatisticImplFromJson(json);

  @override
  @JsonKey(name: 'id')
  final int? id;
  @override
  @JsonKey(name: 'status')
  final String? status;
  @override
  @JsonKey(name: 'start_status_at')
  final DateTime? startStatusAt;
  @override
  @JsonKey(name: 'end_status_at')
  final DateTime? endStatusAt;
  @override
  @JsonKey(name: 'duration')
  final int? duration;
  @override
  @JsonKey(name: 'work_started_at')
  final dynamic workStartedAt;
  @override
  @JsonKey(name: 'work_end_at')
  final dynamic workEndAt;
  @override
  @JsonKey(name: 'rate')
  final int? rate;

  @override
  String toString() {
    return 'Statistic(id: $id, status: $status, startStatusAt: $startStatusAt, endStatusAt: $endStatusAt, duration: $duration, workStartedAt: $workStartedAt, workEndAt: $workEndAt, rate: $rate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatisticImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startStatusAt, startStatusAt) ||
                other.startStatusAt == startStatusAt) &&
            (identical(other.endStatusAt, endStatusAt) ||
                other.endStatusAt == endStatusAt) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality()
                .equals(other.workStartedAt, workStartedAt) &&
            const DeepCollectionEquality().equals(other.workEndAt, workEndAt) &&
            (identical(other.rate, rate) || other.rate == rate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      status,
      startStatusAt,
      endStatusAt,
      duration,
      const DeepCollectionEquality().hash(workStartedAt),
      const DeepCollectionEquality().hash(workEndAt),
      rate);

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
      {@JsonKey(name: 'id') final int? id,
      @JsonKey(name: 'status') final String? status,
      @JsonKey(name: 'start_status_at') final DateTime? startStatusAt,
      @JsonKey(name: 'end_status_at') final DateTime? endStatusAt,
      @JsonKey(name: 'duration') final int? duration,
      @JsonKey(name: 'work_started_at') final dynamic workStartedAt,
      @JsonKey(name: 'work_end_at') final dynamic workEndAt,
      @JsonKey(name: 'rate') final int? rate}) = _$StatisticImpl;

  factory _Statistic.fromJson(Map<String, dynamic> json) =
      _$StatisticImpl.fromJson;

  @override
  @JsonKey(name: 'id')
  int? get id;
  @override
  @JsonKey(name: 'status')
  String? get status;
  @override
  @JsonKey(name: 'start_status_at')
  DateTime? get startStatusAt;
  @override
  @JsonKey(name: 'end_status_at')
  DateTime? get endStatusAt;
  @override
  @JsonKey(name: 'duration')
  int? get duration;
  @override
  @JsonKey(name: 'work_started_at')
  dynamic get workStartedAt;
  @override
  @JsonKey(name: 'work_end_at')
  dynamic get workEndAt;
  @override
  @JsonKey(name: 'rate')
  int? get rate;

  /// Create a copy of Statistic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StatisticImplCopyWith<_$StatisticImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
