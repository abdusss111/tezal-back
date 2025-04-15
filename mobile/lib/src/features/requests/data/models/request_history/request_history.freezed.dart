// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'request_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RequestHistory _$RequestHistoryFromJson(Map<String, dynamic> json) {
  return _RequestHistory.fromJson(json);
}

/// @nodoc
mixin _$RequestHistory {
  List<Statistic>? get statistic => throw _privateConstructorUsedError;

  /// Serializes this RequestHistory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RequestHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RequestHistoryCopyWith<RequestHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RequestHistoryCopyWith<$Res> {
  factory $RequestHistoryCopyWith(
          RequestHistory value, $Res Function(RequestHistory) then) =
      _$RequestHistoryCopyWithImpl<$Res, RequestHistory>;
  @useResult
  $Res call({List<Statistic>? statistic});
}

/// @nodoc
class _$RequestHistoryCopyWithImpl<$Res, $Val extends RequestHistory>
    implements $RequestHistoryCopyWith<$Res> {
  _$RequestHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RequestHistory
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
              as List<Statistic>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RequestHistoryImplCopyWith<$Res>
    implements $RequestHistoryCopyWith<$Res> {
  factory _$$RequestHistoryImplCopyWith(_$RequestHistoryImpl value,
          $Res Function(_$RequestHistoryImpl) then) =
      __$$RequestHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<Statistic>? statistic});
}

/// @nodoc
class __$$RequestHistoryImplCopyWithImpl<$Res>
    extends _$RequestHistoryCopyWithImpl<$Res, _$RequestHistoryImpl>
    implements _$$RequestHistoryImplCopyWith<$Res> {
  __$$RequestHistoryImplCopyWithImpl(
      _$RequestHistoryImpl _value, $Res Function(_$RequestHistoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of RequestHistory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statistic = freezed,
  }) {
    return _then(_$RequestHistoryImpl(
      statistic: freezed == statistic
          ? _value._statistic
          : statistic // ignore: cast_nullable_to_non_nullable
              as List<Statistic>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RequestHistoryImpl implements _RequestHistory {
  _$RequestHistoryImpl({final List<Statistic>? statistic})
      : _statistic = statistic;

  factory _$RequestHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$RequestHistoryImplFromJson(json);

  final List<Statistic>? _statistic;
  @override
  List<Statistic>? get statistic {
    final value = _statistic;
    if (value == null) return null;
    if (_statistic is EqualUnmodifiableListView) return _statistic;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'RequestHistory(statistic: $statistic)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RequestHistoryImpl &&
            const DeepCollectionEquality()
                .equals(other._statistic, _statistic));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_statistic));

  /// Create a copy of RequestHistory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RequestHistoryImplCopyWith<_$RequestHistoryImpl> get copyWith =>
      __$$RequestHistoryImplCopyWithImpl<_$RequestHistoryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RequestHistoryImplToJson(
      this,
    );
  }
}

abstract class _RequestHistory implements RequestHistory {
  factory _RequestHistory({final List<Statistic>? statistic}) =
      _$RequestHistoryImpl;

  factory _RequestHistory.fromJson(Map<String, dynamic> json) =
      _$RequestHistoryImpl.fromJson;

  @override
  List<Statistic>? get statistic;

  /// Create a copy of RequestHistory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RequestHistoryImplCopyWith<_$RequestHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
