// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'library_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LibraryItemSummaryDto _$LibraryItemSummaryDtoFromJson(
    Map<String, dynamic> json) {
  return _LibraryItemSummaryDto.fromJson(json);
}

/// @nodoc
mixin _$LibraryItemSummaryDto {
  String get id => throw _privateConstructorUsedError;
  String get assessmentId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get mediaType => throw _privateConstructorUsedError;
  DateTime get publishedAt => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;

  /// Serializes this LibraryItemSummaryDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LibraryItemSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LibraryItemSummaryDtoCopyWith<LibraryItemSummaryDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LibraryItemSummaryDtoCopyWith<$Res> {
  factory $LibraryItemSummaryDtoCopyWith(LibraryItemSummaryDto value,
          $Res Function(LibraryItemSummaryDto) then) =
      _$LibraryItemSummaryDtoCopyWithImpl<$Res, LibraryItemSummaryDto>;
  @useResult
  $Res call(
      {String id,
      String assessmentId,
      String title,
      String mediaType,
      DateTime publishedAt,
      String version});
}

/// @nodoc
class _$LibraryItemSummaryDtoCopyWithImpl<$Res,
        $Val extends LibraryItemSummaryDto>
    implements $LibraryItemSummaryDtoCopyWith<$Res> {
  _$LibraryItemSummaryDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LibraryItemSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? assessmentId = null,
    Object? title = null,
    Object? mediaType = null,
    Object? publishedAt = null,
    Object? version = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      assessmentId: null == assessmentId
          ? _value.assessmentId
          : assessmentId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      mediaType: null == mediaType
          ? _value.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as String,
      publishedAt: null == publishedAt
          ? _value.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LibraryItemSummaryDtoImplCopyWith<$Res>
    implements $LibraryItemSummaryDtoCopyWith<$Res> {
  factory _$$LibraryItemSummaryDtoImplCopyWith(
          _$LibraryItemSummaryDtoImpl value,
          $Res Function(_$LibraryItemSummaryDtoImpl) then) =
      __$$LibraryItemSummaryDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String assessmentId,
      String title,
      String mediaType,
      DateTime publishedAt,
      String version});
}

/// @nodoc
class __$$LibraryItemSummaryDtoImplCopyWithImpl<$Res>
    extends _$LibraryItemSummaryDtoCopyWithImpl<$Res,
        _$LibraryItemSummaryDtoImpl>
    implements _$$LibraryItemSummaryDtoImplCopyWith<$Res> {
  __$$LibraryItemSummaryDtoImplCopyWithImpl(_$LibraryItemSummaryDtoImpl _value,
      $Res Function(_$LibraryItemSummaryDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of LibraryItemSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? assessmentId = null,
    Object? title = null,
    Object? mediaType = null,
    Object? publishedAt = null,
    Object? version = null,
  }) {
    return _then(_$LibraryItemSummaryDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      assessmentId: null == assessmentId
          ? _value.assessmentId
          : assessmentId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      mediaType: null == mediaType
          ? _value.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as String,
      publishedAt: null == publishedAt
          ? _value.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LibraryItemSummaryDtoImpl implements _LibraryItemSummaryDto {
  const _$LibraryItemSummaryDtoImpl(
      {required this.id,
      required this.assessmentId,
      required this.title,
      required this.mediaType,
      required this.publishedAt,
      required this.version});

  factory _$LibraryItemSummaryDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LibraryItemSummaryDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String assessmentId;
  @override
  final String title;
  @override
  final String mediaType;
  @override
  final DateTime publishedAt;
  @override
  final String version;

  @override
  String toString() {
    return 'LibraryItemSummaryDto(id: $id, assessmentId: $assessmentId, title: $title, mediaType: $mediaType, publishedAt: $publishedAt, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LibraryItemSummaryDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.assessmentId, assessmentId) ||
                other.assessmentId == assessmentId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, assessmentId, title, mediaType, publishedAt, version);

  /// Create a copy of LibraryItemSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LibraryItemSummaryDtoImplCopyWith<_$LibraryItemSummaryDtoImpl>
      get copyWith => __$$LibraryItemSummaryDtoImplCopyWithImpl<
          _$LibraryItemSummaryDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LibraryItemSummaryDtoImplToJson(
      this,
    );
  }
}

abstract class _LibraryItemSummaryDto implements LibraryItemSummaryDto {
  const factory _LibraryItemSummaryDto(
      {required final String id,
      required final String assessmentId,
      required final String title,
      required final String mediaType,
      required final DateTime publishedAt,
      required final String version}) = _$LibraryItemSummaryDtoImpl;

  factory _LibraryItemSummaryDto.fromJson(Map<String, dynamic> json) =
      _$LibraryItemSummaryDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get assessmentId;
  @override
  String get title;
  @override
  String get mediaType;
  @override
  DateTime get publishedAt;
  @override
  String get version;

  /// Create a copy of LibraryItemSummaryDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LibraryItemSummaryDtoImplCopyWith<_$LibraryItemSummaryDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

LibraryItemDetailDto _$LibraryItemDetailDtoFromJson(Map<String, dynamic> json) {
  return _LibraryItemDetailDto.fromJson(json);
}

/// @nodoc
mixin _$LibraryItemDetailDto {
  String get id => throw _privateConstructorUsedError;
  String get assessmentId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get mediaType => throw _privateConstructorUsedError;
  String? get groundTruthSnapshot => throw _privateConstructorUsedError;
  DateTime get publishedAt => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;

  /// Serializes this LibraryItemDetailDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LibraryItemDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LibraryItemDetailDtoCopyWith<LibraryItemDetailDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LibraryItemDetailDtoCopyWith<$Res> {
  factory $LibraryItemDetailDtoCopyWith(LibraryItemDetailDto value,
          $Res Function(LibraryItemDetailDto) then) =
      _$LibraryItemDetailDtoCopyWithImpl<$Res, LibraryItemDetailDto>;
  @useResult
  $Res call(
      {String id,
      String assessmentId,
      String title,
      String mediaType,
      String? groundTruthSnapshot,
      DateTime publishedAt,
      String version});
}

/// @nodoc
class _$LibraryItemDetailDtoCopyWithImpl<$Res,
        $Val extends LibraryItemDetailDto>
    implements $LibraryItemDetailDtoCopyWith<$Res> {
  _$LibraryItemDetailDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LibraryItemDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? assessmentId = null,
    Object? title = null,
    Object? mediaType = null,
    Object? groundTruthSnapshot = freezed,
    Object? publishedAt = null,
    Object? version = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      assessmentId: null == assessmentId
          ? _value.assessmentId
          : assessmentId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      mediaType: null == mediaType
          ? _value.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as String,
      groundTruthSnapshot: freezed == groundTruthSnapshot
          ? _value.groundTruthSnapshot
          : groundTruthSnapshot // ignore: cast_nullable_to_non_nullable
              as String?,
      publishedAt: null == publishedAt
          ? _value.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LibraryItemDetailDtoImplCopyWith<$Res>
    implements $LibraryItemDetailDtoCopyWith<$Res> {
  factory _$$LibraryItemDetailDtoImplCopyWith(_$LibraryItemDetailDtoImpl value,
          $Res Function(_$LibraryItemDetailDtoImpl) then) =
      __$$LibraryItemDetailDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String assessmentId,
      String title,
      String mediaType,
      String? groundTruthSnapshot,
      DateTime publishedAt,
      String version});
}

/// @nodoc
class __$$LibraryItemDetailDtoImplCopyWithImpl<$Res>
    extends _$LibraryItemDetailDtoCopyWithImpl<$Res, _$LibraryItemDetailDtoImpl>
    implements _$$LibraryItemDetailDtoImplCopyWith<$Res> {
  __$$LibraryItemDetailDtoImplCopyWithImpl(_$LibraryItemDetailDtoImpl _value,
      $Res Function(_$LibraryItemDetailDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of LibraryItemDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? assessmentId = null,
    Object? title = null,
    Object? mediaType = null,
    Object? groundTruthSnapshot = freezed,
    Object? publishedAt = null,
    Object? version = null,
  }) {
    return _then(_$LibraryItemDetailDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      assessmentId: null == assessmentId
          ? _value.assessmentId
          : assessmentId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      mediaType: null == mediaType
          ? _value.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as String,
      groundTruthSnapshot: freezed == groundTruthSnapshot
          ? _value.groundTruthSnapshot
          : groundTruthSnapshot // ignore: cast_nullable_to_non_nullable
              as String?,
      publishedAt: null == publishedAt
          ? _value.publishedAt
          : publishedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LibraryItemDetailDtoImpl implements _LibraryItemDetailDto {
  const _$LibraryItemDetailDtoImpl(
      {required this.id,
      required this.assessmentId,
      required this.title,
      required this.mediaType,
      this.groundTruthSnapshot,
      required this.publishedAt,
      required this.version});

  factory _$LibraryItemDetailDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$LibraryItemDetailDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String assessmentId;
  @override
  final String title;
  @override
  final String mediaType;
  @override
  final String? groundTruthSnapshot;
  @override
  final DateTime publishedAt;
  @override
  final String version;

  @override
  String toString() {
    return 'LibraryItemDetailDto(id: $id, assessmentId: $assessmentId, title: $title, mediaType: $mediaType, groundTruthSnapshot: $groundTruthSnapshot, publishedAt: $publishedAt, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LibraryItemDetailDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.assessmentId, assessmentId) ||
                other.assessmentId == assessmentId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.mediaType, mediaType) ||
                other.mediaType == mediaType) &&
            (identical(other.groundTruthSnapshot, groundTruthSnapshot) ||
                other.groundTruthSnapshot == groundTruthSnapshot) &&
            (identical(other.publishedAt, publishedAt) ||
                other.publishedAt == publishedAt) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, assessmentId, title,
      mediaType, groundTruthSnapshot, publishedAt, version);

  /// Create a copy of LibraryItemDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LibraryItemDetailDtoImplCopyWith<_$LibraryItemDetailDtoImpl>
      get copyWith =>
          __$$LibraryItemDetailDtoImplCopyWithImpl<_$LibraryItemDetailDtoImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LibraryItemDetailDtoImplToJson(
      this,
    );
  }
}

abstract class _LibraryItemDetailDto implements LibraryItemDetailDto {
  const factory _LibraryItemDetailDto(
      {required final String id,
      required final String assessmentId,
      required final String title,
      required final String mediaType,
      final String? groundTruthSnapshot,
      required final DateTime publishedAt,
      required final String version}) = _$LibraryItemDetailDtoImpl;

  factory _LibraryItemDetailDto.fromJson(Map<String, dynamic> json) =
      _$LibraryItemDetailDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get assessmentId;
  @override
  String get title;
  @override
  String get mediaType;
  @override
  String? get groundTruthSnapshot;
  @override
  DateTime get publishedAt;
  @override
  String get version;

  /// Create a copy of LibraryItemDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LibraryItemDetailDtoImplCopyWith<_$LibraryItemDetailDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
