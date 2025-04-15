// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_statistic.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RequestStatistic _$RequestStatisticFromJson(Map<String, dynamic> json) {
  return _RequestStatistic.fromJson(json);
}

/// @nodoc
mixin _$RequestStatistic {
  Statistic? get statistic => throw _privateConstructorUsedError;

  /// Serializes this RequestStatistic to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RequestStatistic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RequestStatisticCopyWith<RequestStatistic> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestStatisticCopyWith<$Res> {
  factory $RequestStatisticCopyWith(
          RequestStatistic value, $Res Function(RequestStatistic) then) =
      _$RequestStatisticCopyWithImpl<$Res, RequestStatistic>;
  @useResult
  $Res call({Statistic? statistic});

  $StatisticCopyWith<$Res>? get statistic;
}

/// @nodoc
class _$RequestStatisticCopyWithImpl<$Res, $Val extends RequestStatistic>
    implements $RequestStatisticCopyWith<$Res> {
  _$RequestStatisticCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RequestStatistic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statistic = freezed,
  }) {
    return _then(_value.copyWith(
      statistic: freezed == statistic
          ? _value.statistic
          : statistic // ignore: cast_nullable_to_non_nullable
              as Statistic?,
    ) as $Val);
  }

  /// Create a copy of RequestStatistic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $StatisticCopyWith<$Res>? get statistic {
    if (_value.statistic == null) {
      return null;
    }

    return $StatisticCopyWith<$Res>(_value.statistic!, (value) {
      return _then(_value.copyWith(statistic: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RequestStatisticImplCopyWith<$Res>
    implements $RequestStatisticCopyWith<$Res> {
  factory _$$RequestStatisticImplCopyWith(_$RequestStatisticImpl value,
          $Res Function(_$RequestStatisticImpl) then) =
      __$$RequestStatisticImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Statistic? statistic});

  @override
  $StatisticCopyWith<$Res>? get statistic;
}

/// @nodoc
class __$$RequestStatisticImplCopyWithImpl<$Res>
    extends _$RequestStatisticCopyWithImpl<$Res, _$RequestStatisticImpl>
    implements _$$RequestStatisticImplCopyWith<$Res> {
  __$$RequestStatisticImplCopyWithImpl(_$RequestStatisticImpl _value,
      $Res Function(_$RequestStatisticImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestStatistic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statistic = freezed,
  }) {
    return _then(_$RequestStatisticImpl(
      statistic: freezed == statistic
          ? _value.statistic
          : statistic // ignore: cast_nullable_to_non_nullable
              as Statistic?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RequestStatisticImpl implements _RequestStatistic {
  _$RequestStatisticImpl({this.statistic});

  factory _$RequestStatisticImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequestStatisticImplFromJson(json);

  @override
  final Statistic? statistic;

  @override
  String toString() {
    return 'RequestStatistic(statistic: $statistic)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestStatisticImpl &&
            (identical(other.statistic, statistic) ||
                other.statistic == statistic));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, statistic);

  /// Create a copy of RequestStatistic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestStatisticImplCopyWith<_$RequestStatisticImpl> get copyWith =>
      __$$RequestStatisticImplCopyWithImpl<_$RequestStatisticImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestStatisticImplToJson(
      this,
    );
  }
}

abstract class _RequestStatistic implements RequestStatistic {
  factory _RequestStatistic({final Statistic? statistic}) =
      _$RequestStatisticImpl;

  factory _RequestStatistic.fromJson(Map<String, dynamic> json) =
      _$RequestStatisticImpl.fromJson;

  @override
  Statistic? get statistic;

  /// Create a copy of RequestStatistic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RequestStatisticImplCopyWith<_$RequestStatisticImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
