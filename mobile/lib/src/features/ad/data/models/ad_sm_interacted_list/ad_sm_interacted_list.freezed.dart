// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ad_sm_interacted_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AdSmInteractedList _$AdSmInteractedListFromJson(Map<String, dynamic> json) {
  return _AdSmInteractedList.fromJson(json);
}

/// @nodoc
mixin _$AdSmInteractedList {
  @JsonKey(name: 'ad_service_interacted')
  List<AdServiceInteracted>? get adServiceInteracted =>
      throw _privateConstructorUsedError;

  /// Serializes this AdSmInteractedList to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AdSmInteractedList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdSmInteractedListCopyWith<AdSmInteractedList> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdSmInteractedListCopyWith<$Res> {
  factory $AdSmInteractedListCopyWith(
          AdSmInteractedList value, $Res Function(AdSmInteractedList) then) =
      _$AdSmInteractedListCopyWithImpl<$Res, AdSmInteractedList>;
  @useResult
  $Res call(
      {@JsonKey(name: 'ad_service_interacted')
      List<AdServiceInteracted>? adServiceInteracted});
}

/// @nodoc
class _$AdSmInteractedListCopyWithImpl<$Res, $Val extends AdSmInteractedList>
    implements $AdSmInteractedListCopyWith<$Res> {
  _$AdSmInteractedListCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdSmInteractedList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? adServiceInteracted = freezed,
  }) {
    return _then(_value.copyWith(
      adServiceInteracted: freezed == adServiceInteracted
          ? _value.adServiceInteracted
          : adServiceInteracted // ignore: cast_nullable_to_non_nullable
              as List<AdServiceInteracted>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdSmInteractedListImplCopyWith<$Res>
    implements $AdSmInteractedListCopyWith<$Res> {
  factory _$$AdSmInteractedListImplCopyWith(_$AdSmInteractedListImpl value,
          $Res Function(_$AdSmInteractedListImpl) then) =
      __$$AdSmInteractedListImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'ad_service_interacted')
      List<AdServiceInteracted>? adServiceInteracted});
}

/// @nodoc
class __$$AdSmInteractedListImplCopyWithImpl<$Res>
    extends _$AdSmInteractedListCopyWithImpl<$Res, _$AdSmInteractedListImpl>
    implements _$$AdSmInteractedListImplCopyWith<$Res> {
  __$$AdSmInteractedListImplCopyWithImpl(_$AdSmInteractedListImpl _value,
      $Res Function(_$AdSmInteractedListImpl) _then)
      : super(_value, _then);

  /// Create a copy of AdSmInteractedList
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? adServiceInteracted = freezed,
  }) {
    return _then(_$AdSmInteractedListImpl(
      adServiceInteracted: freezed == adServiceInteracted
          ? _value._adServiceInteracted
          : adServiceInteracted // ignore: cast_nullable_to_non_nullable
              as List<AdServiceInteracted>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AdSmInteractedListImpl implements _AdSmInteractedList {
  _$AdSmInteractedListImpl(
      {@JsonKey(name: 'ad_service_interacted')
      final List<AdServiceInteracted>? adServiceInteracted})
      : _adServiceInteracted = adServiceInteracted;

  factory _$AdSmInteractedListImpl.fromJson(Map<String, dynamic> json) =>
      _$$AdSmInteractedListImplFromJson(json);

  final List<AdServiceInteracted>? _adServiceInteracted;
  @override
  @JsonKey(name: 'ad_service_interacted')
  List<AdServiceInteracted>? get adServiceInteracted {
    final value = _adServiceInteracted;
    if (value == null) return null;
    if (_adServiceInteracted is EqualUnmodifiableListView)
      return _adServiceInteracted;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'AdSmInteractedList(adServiceInteracted: $adServiceInteracted)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdSmInteractedListImpl &&
            const DeepCollectionEquality()
                .equals(other._adServiceInteracted, _adServiceInteracted));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_adServiceInteracted));

  /// Create a copy of AdSmInteractedList
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdSmInteractedListImplCopyWith<_$AdSmInteractedListImpl> get copyWith =>
      __$$AdSmInteractedListImplCopyWithImpl<_$AdSmInteractedListImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AdSmInteractedListImplToJson(
      this,
    );
  }
}

abstract class _AdSmInteractedList implements AdSmInteractedList {
  factory _AdSmInteractedList(
          {@JsonKey(name: 'ad_service_interacted')
          final List<AdServiceInteracted>? adServiceInteracted}) =
      _$AdSmInteractedListImpl;

  factory _AdSmInteractedList.fromJson(Map<String, dynamic> json) =
      _$AdSmInteractedListImpl.fromJson;

  @override
  @JsonKey(name: 'ad_service_interacted')
  List<AdServiceInteracted>? get adServiceInteracted;

  /// Create a copy of AdSmInteractedList
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdSmInteractedListImplCopyWith<_$AdSmInteractedListImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
