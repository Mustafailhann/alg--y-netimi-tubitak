// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'training_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TrainingItem {
  String get id => throw _privateConstructorUsedError;
  String get libraryItemId => throw _privateConstructorUsedError;
  int get orderIndex => throw _privateConstructorUsedError;
  String get libraryItemTitle => throw _privateConstructorUsedError;
  String get libraryItemMediaType => throw _privateConstructorUsedError;

  /// Create a copy of TrainingItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainingItemCopyWith<TrainingItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainingItemCopyWith<$Res> {
  factory $TrainingItemCopyWith(
          TrainingItem value, $Res Function(TrainingItem) then) =
      _$TrainingItemCopyWithImpl<$Res, TrainingItem>;
  @useResult
  $Res call(
      {String id,
      String libraryItemId,
      int orderIndex,
      String libraryItemTitle,
      String libraryItemMediaType});
}

/// @nodoc
class _$TrainingItemCopyWithImpl<$Res, $Val extends TrainingItem>
    implements $TrainingItemCopyWith<$Res> {
  _$TrainingItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrainingItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? libraryItemId = null,
    Object? orderIndex = null,
    Object? libraryItemTitle = null,
    Object? libraryItemMediaType = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      libraryItemId: null == libraryItemId
          ? _value.libraryItemId
          : libraryItemId // ignore: cast_nullable_to_non_nullable
              as String,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
      libraryItemTitle: null == libraryItemTitle
          ? _value.libraryItemTitle
          : libraryItemTitle // ignore: cast_nullable_to_non_nullable
              as String,
      libraryItemMediaType: null == libraryItemMediaType
          ? _value.libraryItemMediaType
          : libraryItemMediaType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrainingItemImplCopyWith<$Res>
    implements $TrainingItemCopyWith<$Res> {
  factory _$$TrainingItemImplCopyWith(
          _$TrainingItemImpl value, $Res Function(_$TrainingItemImpl) then) =
      __$$TrainingItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String libraryItemId,
      int orderIndex,
      String libraryItemTitle,
      String libraryItemMediaType});
}

/// @nodoc
class __$$TrainingItemImplCopyWithImpl<$Res>
    extends _$TrainingItemCopyWithImpl<$Res, _$TrainingItemImpl>
    implements _$$TrainingItemImplCopyWith<$Res> {
  __$$TrainingItemImplCopyWithImpl(
      _$TrainingItemImpl _value, $Res Function(_$TrainingItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrainingItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? libraryItemId = null,
    Object? orderIndex = null,
    Object? libraryItemTitle = null,
    Object? libraryItemMediaType = null,
  }) {
    return _then(_$TrainingItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      libraryItemId: null == libraryItemId
          ? _value.libraryItemId
          : libraryItemId // ignore: cast_nullable_to_non_nullable
              as String,
      orderIndex: null == orderIndex
          ? _value.orderIndex
          : orderIndex // ignore: cast_nullable_to_non_nullable
              as int,
      libraryItemTitle: null == libraryItemTitle
          ? _value.libraryItemTitle
          : libraryItemTitle // ignore: cast_nullable_to_non_nullable
              as String,
      libraryItemMediaType: null == libraryItemMediaType
          ? _value.libraryItemMediaType
          : libraryItemMediaType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$TrainingItemImpl implements _TrainingItem {
  const _$TrainingItemImpl(
      {required this.id,
      required this.libraryItemId,
      required this.orderIndex,
      required this.libraryItemTitle,
      required this.libraryItemMediaType});

  @override
  final String id;
  @override
  final String libraryItemId;
  @override
  final int orderIndex;
  @override
  final String libraryItemTitle;
  @override
  final String libraryItemMediaType;

  @override
  String toString() {
    return 'TrainingItem(id: $id, libraryItemId: $libraryItemId, orderIndex: $orderIndex, libraryItemTitle: $libraryItemTitle, libraryItemMediaType: $libraryItemMediaType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainingItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.libraryItemId, libraryItemId) ||
                other.libraryItemId == libraryItemId) &&
            (identical(other.orderIndex, orderIndex) ||
                other.orderIndex == orderIndex) &&
            (identical(other.libraryItemTitle, libraryItemTitle) ||
                other.libraryItemTitle == libraryItemTitle) &&
            (identical(other.libraryItemMediaType, libraryItemMediaType) ||
                other.libraryItemMediaType == libraryItemMediaType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, libraryItemId, orderIndex,
      libraryItemTitle, libraryItemMediaType);

  /// Create a copy of TrainingItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainingItemImplCopyWith<_$TrainingItemImpl> get copyWith =>
      __$$TrainingItemImplCopyWithImpl<_$TrainingItemImpl>(this, _$identity);
}

abstract class _TrainingItem implements TrainingItem {
  const factory _TrainingItem(
      {required final String id,
      required final String libraryItemId,
      required final int orderIndex,
      required final String libraryItemTitle,
      required final String libraryItemMediaType}) = _$TrainingItemImpl;

  @override
  String get id;
  @override
  String get libraryItemId;
  @override
  int get orderIndex;
  @override
  String get libraryItemTitle;
  @override
  String get libraryItemMediaType;

  /// Create a copy of TrainingItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainingItemImplCopyWith<_$TrainingItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
