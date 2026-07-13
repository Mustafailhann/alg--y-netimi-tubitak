// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'training_pack_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TrainingPackDto _$TrainingPackDtoFromJson(Map<String, dynamic> json) {
  return _TrainingPackDto.fromJson(json);
}

/// @nodoc
mixin _$TrainingPackDto {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get status =>
      throw _privateConstructorUsedError; // "Draft", "Published", "Archived" from backend
  int? get estimatedDuration => throw _privateConstructorUsedError;
  int get itemCount => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;

  /// Serializes this TrainingPackDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrainingPackDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainingPackDtoCopyWith<TrainingPackDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainingPackDtoCopyWith<$Res> {
  factory $TrainingPackDtoCopyWith(
          TrainingPackDto value, $Res Function(TrainingPackDto) then) =
      _$TrainingPackDtoCopyWithImpl<$Res, TrainingPackDto>;
  @useResult
  $Res call(
      {String id,
      String title,
      String status,
      int? estimatedDuration,
      int itemCount,
      String version});
}

/// @nodoc
class _$TrainingPackDtoCopyWithImpl<$Res, $Val extends TrainingPackDto>
    implements $TrainingPackDtoCopyWith<$Res> {
  _$TrainingPackDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrainingPackDto
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
              as String,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrainingPackDtoImplCopyWith<$Res>
    implements $TrainingPackDtoCopyWith<$Res> {
  factory _$$TrainingPackDtoImplCopyWith(_$TrainingPackDtoImpl value,
          $Res Function(_$TrainingPackDtoImpl) then) =
      __$$TrainingPackDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String status,
      int? estimatedDuration,
      int itemCount,
      String version});
}

/// @nodoc
class __$$TrainingPackDtoImplCopyWithImpl<$Res>
    extends _$TrainingPackDtoCopyWithImpl<$Res, _$TrainingPackDtoImpl>
    implements _$$TrainingPackDtoImplCopyWith<$Res> {
  __$$TrainingPackDtoImplCopyWithImpl(
      _$TrainingPackDtoImpl _value, $Res Function(_$TrainingPackDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrainingPackDto
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
  }) {
    return _then(_$TrainingPackDtoImpl(
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
              as String,
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrainingPackDtoImpl implements _TrainingPackDto {
  const _$TrainingPackDtoImpl(
      {required this.id,
      required this.title,
      required this.status,
      this.estimatedDuration,
      required this.itemCount,
      required this.version});

  factory _$TrainingPackDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrainingPackDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String status;
// "Draft", "Published", "Archived" from backend
  @override
  final int? estimatedDuration;
  @override
  final int itemCount;
  @override
  final String version;

  @override
  String toString() {
    return 'TrainingPackDto(id: $id, title: $title, status: $status, estimatedDuration: $estimatedDuration, itemCount: $itemCount, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainingPackDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.estimatedDuration, estimatedDuration) ||
                other.estimatedDuration == estimatedDuration) &&
            (identical(other.itemCount, itemCount) ||
                other.itemCount == itemCount) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, title, status, estimatedDuration, itemCount, version);

  /// Create a copy of TrainingPackDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainingPackDtoImplCopyWith<_$TrainingPackDtoImpl> get copyWith =>
      __$$TrainingPackDtoImplCopyWithImpl<_$TrainingPackDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrainingPackDtoImplToJson(
      this,
    );
  }
}

abstract class _TrainingPackDto implements TrainingPackDto {
  const factory _TrainingPackDto(
      {required final String id,
      required final String title,
      required final String status,
      final int? estimatedDuration,
      required final int itemCount,
      required final String version}) = _$TrainingPackDtoImpl;

  factory _TrainingPackDto.fromJson(Map<String, dynamic> json) =
      _$TrainingPackDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get status; // "Draft", "Published", "Archived" from backend
  @override
  int? get estimatedDuration;
  @override
  int get itemCount;
  @override
  String get version;

  /// Create a copy of TrainingPackDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainingPackDtoImplCopyWith<_$TrainingPackDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TrainingPackDetailDto _$TrainingPackDetailDtoFromJson(
    Map<String, dynamic> json) {
  return _TrainingPackDetailDto.fromJson(json);
}

/// @nodoc
mixin _$TrainingPackDetailDto {
  String get id => throw _privateConstructorUsedError;
  String get teacherId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int? get estimatedDuration => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TrainingPackDetailDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrainingPackDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainingPackDetailDtoCopyWith<TrainingPackDetailDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainingPackDetailDtoCopyWith<$Res> {
  factory $TrainingPackDetailDtoCopyWith(TrainingPackDetailDto value,
          $Res Function(TrainingPackDetailDto) then) =
      _$TrainingPackDetailDtoCopyWithImpl<$Res, TrainingPackDetailDto>;
  @useResult
  $Res call(
      {String id,
      String teacherId,
      String title,
      String status,
      int? estimatedDuration,
      String version,
      DateTime createdAt});
}

/// @nodoc
class _$TrainingPackDetailDtoCopyWithImpl<$Res,
        $Val extends TrainingPackDetailDto>
    implements $TrainingPackDetailDtoCopyWith<$Res> {
  _$TrainingPackDetailDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrainingPackDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? teacherId = null,
    Object? title = null,
    Object? status = null,
    Object? estimatedDuration = freezed,
    Object? version = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      teacherId: null == teacherId
          ? _value.teacherId
          : teacherId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      estimatedDuration: freezed == estimatedDuration
          ? _value.estimatedDuration
          : estimatedDuration // ignore: cast_nullable_to_non_nullable
              as int?,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrainingPackDetailDtoImplCopyWith<$Res>
    implements $TrainingPackDetailDtoCopyWith<$Res> {
  factory _$$TrainingPackDetailDtoImplCopyWith(
          _$TrainingPackDetailDtoImpl value,
          $Res Function(_$TrainingPackDetailDtoImpl) then) =
      __$$TrainingPackDetailDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String teacherId,
      String title,
      String status,
      int? estimatedDuration,
      String version,
      DateTime createdAt});
}

/// @nodoc
class __$$TrainingPackDetailDtoImplCopyWithImpl<$Res>
    extends _$TrainingPackDetailDtoCopyWithImpl<$Res,
        _$TrainingPackDetailDtoImpl>
    implements _$$TrainingPackDetailDtoImplCopyWith<$Res> {
  __$$TrainingPackDetailDtoImplCopyWithImpl(_$TrainingPackDetailDtoImpl _value,
      $Res Function(_$TrainingPackDetailDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrainingPackDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? teacherId = null,
    Object? title = null,
    Object? status = null,
    Object? estimatedDuration = freezed,
    Object? version = null,
    Object? createdAt = null,
  }) {
    return _then(_$TrainingPackDetailDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      teacherId: null == teacherId
          ? _value.teacherId
          : teacherId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      estimatedDuration: freezed == estimatedDuration
          ? _value.estimatedDuration
          : estimatedDuration // ignore: cast_nullable_to_non_nullable
              as int?,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrainingPackDetailDtoImpl implements _TrainingPackDetailDto {
  const _$TrainingPackDetailDtoImpl(
      {required this.id,
      required this.teacherId,
      required this.title,
      required this.status,
      this.estimatedDuration,
      required this.version,
      required this.createdAt});

  factory _$TrainingPackDetailDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrainingPackDetailDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String teacherId;
  @override
  final String title;
  @override
  final String status;
  @override
  final int? estimatedDuration;
  @override
  final String version;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'TrainingPackDetailDto(id: $id, teacherId: $teacherId, title: $title, status: $status, estimatedDuration: $estimatedDuration, version: $version, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainingPackDetailDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.teacherId, teacherId) ||
                other.teacherId == teacherId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.estimatedDuration, estimatedDuration) ||
                other.estimatedDuration == estimatedDuration) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, teacherId, title, status,
      estimatedDuration, version, createdAt);

  /// Create a copy of TrainingPackDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainingPackDetailDtoImplCopyWith<_$TrainingPackDetailDtoImpl>
      get copyWith => __$$TrainingPackDetailDtoImplCopyWithImpl<
          _$TrainingPackDetailDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrainingPackDetailDtoImplToJson(
      this,
    );
  }
}

abstract class _TrainingPackDetailDto implements TrainingPackDetailDto {
  const factory _TrainingPackDetailDto(
      {required final String id,
      required final String teacherId,
      required final String title,
      required final String status,
      final int? estimatedDuration,
      required final String version,
      required final DateTime createdAt}) = _$TrainingPackDetailDtoImpl;

  factory _TrainingPackDetailDto.fromJson(Map<String, dynamic> json) =
      _$TrainingPackDetailDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get teacherId;
  @override
  String get title;
  @override
  String get status;
  @override
  int? get estimatedDuration;
  @override
  String get version;
  @override
  DateTime get createdAt;

  /// Create a copy of TrainingPackDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainingPackDetailDtoImplCopyWith<_$TrainingPackDetailDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}

TrainingItemDto _$TrainingItemDtoFromJson(Map<String, dynamic> json) {
  return _TrainingItemDto.fromJson(json);
}

/// @nodoc
mixin _$TrainingItemDto {
  String get id => throw _privateConstructorUsedError;
  String get libraryItemId => throw _privateConstructorUsedError;
  int get orderIndex => throw _privateConstructorUsedError;
  String get libraryItemTitle => throw _privateConstructorUsedError;
  String get libraryItemMediaType => throw _privateConstructorUsedError;

  /// Serializes this TrainingItemDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrainingItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainingItemDtoCopyWith<TrainingItemDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainingItemDtoCopyWith<$Res> {
  factory $TrainingItemDtoCopyWith(
          TrainingItemDto value, $Res Function(TrainingItemDto) then) =
      _$TrainingItemDtoCopyWithImpl<$Res, TrainingItemDto>;
  @useResult
  $Res call(
      {String id,
      String libraryItemId,
      int orderIndex,
      String libraryItemTitle,
      String libraryItemMediaType});
}

/// @nodoc
class _$TrainingItemDtoCopyWithImpl<$Res, $Val extends TrainingItemDto>
    implements $TrainingItemDtoCopyWith<$Res> {
  _$TrainingItemDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrainingItemDto
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
abstract class _$$TrainingItemDtoImplCopyWith<$Res>
    implements $TrainingItemDtoCopyWith<$Res> {
  factory _$$TrainingItemDtoImplCopyWith(_$TrainingItemDtoImpl value,
          $Res Function(_$TrainingItemDtoImpl) then) =
      __$$TrainingItemDtoImplCopyWithImpl<$Res>;
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
class __$$TrainingItemDtoImplCopyWithImpl<$Res>
    extends _$TrainingItemDtoCopyWithImpl<$Res, _$TrainingItemDtoImpl>
    implements _$$TrainingItemDtoImplCopyWith<$Res> {
  __$$TrainingItemDtoImplCopyWithImpl(
      _$TrainingItemDtoImpl _value, $Res Function(_$TrainingItemDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrainingItemDto
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
    return _then(_$TrainingItemDtoImpl(
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
@JsonSerializable()
class _$TrainingItemDtoImpl implements _TrainingItemDto {
  const _$TrainingItemDtoImpl(
      {required this.id,
      required this.libraryItemId,
      required this.orderIndex,
      required this.libraryItemTitle,
      required this.libraryItemMediaType});

  factory _$TrainingItemDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrainingItemDtoImplFromJson(json);

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
    return 'TrainingItemDto(id: $id, libraryItemId: $libraryItemId, orderIndex: $orderIndex, libraryItemTitle: $libraryItemTitle, libraryItemMediaType: $libraryItemMediaType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainingItemDtoImpl &&
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

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, libraryItemId, orderIndex,
      libraryItemTitle, libraryItemMediaType);

  /// Create a copy of TrainingItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainingItemDtoImplCopyWith<_$TrainingItemDtoImpl> get copyWith =>
      __$$TrainingItemDtoImplCopyWithImpl<_$TrainingItemDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrainingItemDtoImplToJson(
      this,
    );
  }
}

abstract class _TrainingItemDto implements TrainingItemDto {
  const factory _TrainingItemDto(
      {required final String id,
      required final String libraryItemId,
      required final int orderIndex,
      required final String libraryItemTitle,
      required final String libraryItemMediaType}) = _$TrainingItemDtoImpl;

  factory _TrainingItemDto.fromJson(Map<String, dynamic> json) =
      _$TrainingItemDtoImpl.fromJson;

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

  /// Create a copy of TrainingItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainingItemDtoImplCopyWith<_$TrainingItemDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
