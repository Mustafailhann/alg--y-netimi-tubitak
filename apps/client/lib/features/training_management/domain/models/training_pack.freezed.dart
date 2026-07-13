// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'training_pack.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TrainingPack {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  TrainingPackStatus get status => throw _privateConstructorUsedError;
  int? get estimatedDuration => throw _privateConstructorUsedError;
  int get itemCount => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Create a copy of TrainingPack
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainingPackCopyWith<TrainingPack> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainingPackCopyWith<$Res> {
  factory $TrainingPackCopyWith(
          TrainingPack value, $Res Function(TrainingPack) then) =
      _$TrainingPackCopyWithImpl<$Res, TrainingPack>;
  @useResult
  $Res call(
      {String id,
      String title,
      TrainingPackStatus status,
      int? estimatedDuration,
      int itemCount,
      String version,
      DateTime? createdAt});
}

/// @nodoc
class _$TrainingPackCopyWithImpl<$Res, $Val extends TrainingPack>
    implements $TrainingPackCopyWith<$Res> {
  _$TrainingPackCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrainingPack
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? status = null,
    Object? estimatedDuration = freezed,
    Object? itemCount = null,
    Object? version = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TrainingPackStatus,
      estimatedDuration: freezed == estimatedDuration
          ? _value.estimatedDuration
          : estimatedDuration // ignore: cast_nullable_to_non_nullable
              as int?,
      itemCount: null == itemCount
          ? _value.itemCount
          : itemCount // ignore: cast_nullable_to_non_nullable
              as int,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrainingPackImplCopyWith<$Res>
    implements $TrainingPackCopyWith<$Res> {
  factory _$$TrainingPackImplCopyWith(
          _$TrainingPackImpl value, $Res Function(_$TrainingPackImpl) then) =
      __$$TrainingPackImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      TrainingPackStatus status,
      int? estimatedDuration,
      int itemCount,
      String version,
      DateTime? createdAt});
}

/// @nodoc
class __$$TrainingPackImplCopyWithImpl<$Res>
    extends _$TrainingPackCopyWithImpl<$Res, _$TrainingPackImpl>
    implements _$$TrainingPackImplCopyWith<$Res> {
  __$$TrainingPackImplCopyWithImpl(
      _$TrainingPackImpl _value, $Res Function(_$TrainingPackImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrainingPack
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? status = null,
    Object? estimatedDuration = freezed,
    Object? itemCount = null,
    Object? version = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$TrainingPackImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as TrainingPackStatus,
      estimatedDuration: freezed == estimatedDuration
          ? _value.estimatedDuration
          : estimatedDuration // ignore: cast_nullable_to_non_nullable
              as int?,
      itemCount: null == itemCount
          ? _value.itemCount
          : itemCount // ignore: cast_nullable_to_non_nullable
              as int,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _$TrainingPackImpl implements _TrainingPack {
  const _$TrainingPackImpl(
      {required this.id,
      required this.title,
      required this.status,
      this.estimatedDuration,
      this.itemCount = 0,
      required this.version,
      this.createdAt});

  @override
  final String id;
  @override
  final String title;
  @override
  final TrainingPackStatus status;
  @override
  final int? estimatedDuration;
  @override
  @JsonKey()
  final int itemCount;
  @override
  final String version;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'TrainingPack(id: $id, title: $title, status: $status, estimatedDuration: $estimatedDuration, itemCount: $itemCount, version: $version, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainingPackImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.estimatedDuration, estimatedDuration) ||
                other.estimatedDuration == estimatedDuration) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, title, status,
      estimatedDuration, itemCount, version, createdAt);

  /// Create a copy of TrainingPack
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainingPackImplCopyWith<_$TrainingPackImpl> get copyWith =>
      __$$TrainingPackImplCopyWithImpl<_$TrainingPackImpl>(this, _$identity);
}

abstract class _TrainingPack implements TrainingPack {
  const factory _TrainingPack(
      {required final String id,
      required final String title,
      required final TrainingPackStatus status,
      final int? estimatedDuration,
      final int itemCount,
      required final String version,
      final DateTime? createdAt}) = _$TrainingPackImpl;

  @override
  String get id;
  @override
  String get title;
  @override
  TrainingPackStatus get status;
  @override
  int? get estimatedDuration;
  @override
  int get itemCount;
  @override
  String get version;
  @override
  DateTime? get createdAt;

  /// Create a copy of TrainingPack
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainingPackImplCopyWith<_$TrainingPackImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
