// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'training_session_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TrainingSessionDto _$TrainingSessionDtoFromJson(Map<String, dynamic> json) {
  return _TrainingSessionDto.fromJson(json);
}

/// @nodoc
mixin _$TrainingSessionDto {
  String get id => throw _privateConstructorUsedError;
  String get trainingPackId => throw _privateConstructorUsedError;
  String get joinCode => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError; // mapped from enum
  int get participantCount => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TrainingSessionDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrainingSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainingSessionDtoCopyWith<TrainingSessionDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainingSessionDtoCopyWith<$Res> {
  factory $TrainingSessionDtoCopyWith(
          TrainingSessionDto value, $Res Function(TrainingSessionDto) then) =
      _$TrainingSessionDtoCopyWithImpl<$Res, TrainingSessionDto>;
  @useResult
  $Res call(
      {String id,
      String trainingPackId,
      String joinCode,
      String status,
      int participantCount,
      DateTime createdAt});
}

/// @nodoc
class _$TrainingSessionDtoCopyWithImpl<$Res, $Val extends TrainingSessionDto>
    implements $TrainingSessionDtoCopyWith<$Res> {
  _$TrainingSessionDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrainingSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trainingPackId = null,
    Object? joinCode = null,
    Object? status = null,
    Object? participantCount = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      trainingPackId: null == trainingPackId
          ? _value.trainingPackId
          : trainingPackId // ignore: cast_nullable_to_non_nullable
              as String,
      joinCode: null == joinCode
          ? _value.joinCode
          : joinCode // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      participantCount: null == participantCount
          ? _value.participantCount
          : participantCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrainingSessionDtoImplCopyWith<$Res>
    implements $TrainingSessionDtoCopyWith<$Res> {
  factory _$$TrainingSessionDtoImplCopyWith(_$TrainingSessionDtoImpl value,
          $Res Function(_$TrainingSessionDtoImpl) then) =
      __$$TrainingSessionDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String trainingPackId,
      String joinCode,
      String status,
      int participantCount,
      DateTime createdAt});
}

/// @nodoc
class __$$TrainingSessionDtoImplCopyWithImpl<$Res>
    extends _$TrainingSessionDtoCopyWithImpl<$Res, _$TrainingSessionDtoImpl>
    implements _$$TrainingSessionDtoImplCopyWith<$Res> {
  __$$TrainingSessionDtoImplCopyWithImpl(_$TrainingSessionDtoImpl _value,
      $Res Function(_$TrainingSessionDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrainingSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trainingPackId = null,
    Object? joinCode = null,
    Object? status = null,
    Object? participantCount = null,
    Object? createdAt = null,
  }) {
    return _then(_$TrainingSessionDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      trainingPackId: null == trainingPackId
          ? _value.trainingPackId
          : trainingPackId // ignore: cast_nullable_to_non_nullable
              as String,
      joinCode: null == joinCode
          ? _value.joinCode
          : joinCode // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      participantCount: null == participantCount
          ? _value.participantCount
          : participantCount // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TrainingSessionDtoImpl implements _TrainingSessionDto {
  const _$TrainingSessionDtoImpl(
      {required this.id,
      required this.trainingPackId,
      required this.joinCode,
      required this.status,
      required this.participantCount,
      required this.createdAt});

  factory _$TrainingSessionDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrainingSessionDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String trainingPackId;
  @override
  final String joinCode;
  @override
  final String status;
// mapped from enum
  @override
  final int participantCount;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'TrainingSessionDto(id: $id, trainingPackId: $trainingPackId, joinCode: $joinCode, status: $status, participantCount: $participantCount, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainingSessionDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.trainingPackId, trainingPackId) ||
                other.trainingPackId == trainingPackId) &&
            (identical(other.joinCode, joinCode) ||
                other.joinCode == joinCode) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.participantCount, participantCount) ||
                other.participantCount == participantCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, trainingPackId, joinCode,
      status, participantCount, createdAt);

  /// Create a copy of TrainingSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainingSessionDtoImplCopyWith<_$TrainingSessionDtoImpl> get copyWith =>
      __$$TrainingSessionDtoImplCopyWithImpl<_$TrainingSessionDtoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrainingSessionDtoImplToJson(
      this,
    );
  }
}

abstract class _TrainingSessionDto implements TrainingSessionDto {
  const factory _TrainingSessionDto(
      {required final String id,
      required final String trainingPackId,
      required final String joinCode,
      required final String status,
      required final int participantCount,
      required final DateTime createdAt}) = _$TrainingSessionDtoImpl;

  factory _TrainingSessionDto.fromJson(Map<String, dynamic> json) =
      _$TrainingSessionDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get trainingPackId;
  @override
  String get joinCode;
  @override
  String get status; // mapped from enum
  @override
  int get participantCount;
  @override
  DateTime get createdAt;

  /// Create a copy of TrainingSessionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainingSessionDtoImplCopyWith<_$TrainingSessionDtoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TrainingSessionDetailDto _$TrainingSessionDetailDtoFromJson(
    Map<String, dynamic> json) {
  return _TrainingSessionDetailDto.fromJson(json);
}

/// @nodoc
mixin _$TrainingSessionDetailDto {
  String get id => throw _privateConstructorUsedError;
  String get trainingPackId => throw _privateConstructorUsedError;
  String get joinCode => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int get participantCount => throw _privateConstructorUsedError;
  int? get timeLimitMinutes => throw _privateConstructorUsedError;
  bool get randomQuestionOrder => throw _privateConstructorUsedError;
  bool get allowRetry => throw _privateConstructorUsedError;
  bool get showImmediateFeedback => throw _privateConstructorUsedError;
  bool get leaderboardEnabled => throw _privateConstructorUsedError;
  bool get canvasRequired => throw _privateConstructorUsedError;
  int? get maximumAttempts => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  String get version => throw _privateConstructorUsedError;

  /// Serializes this TrainingSessionDetailDto to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TrainingSessionDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainingSessionDetailDtoCopyWith<TrainingSessionDetailDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainingSessionDetailDtoCopyWith<$Res> {
  factory $TrainingSessionDetailDtoCopyWith(TrainingSessionDetailDto value,
          $Res Function(TrainingSessionDetailDto) then) =
      _$TrainingSessionDetailDtoCopyWithImpl<$Res, TrainingSessionDetailDto>;
  @useResult
  $Res call(
      {String id,
      String trainingPackId,
      String joinCode,
      String status,
      int participantCount,
      int? timeLimitMinutes,
      bool randomQuestionOrder,
      bool allowRetry,
      bool showImmediateFeedback,
      bool leaderboardEnabled,
      bool canvasRequired,
      int? maximumAttempts,
      DateTime createdAt,
      String version});
}

/// @nodoc
class _$TrainingSessionDetailDtoCopyWithImpl<$Res,
        $Val extends TrainingSessionDetailDto>
    implements $TrainingSessionDetailDtoCopyWith<$Res> {
  _$TrainingSessionDetailDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrainingSessionDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trainingPackId = null,
    Object? joinCode = null,
    Object? status = null,
    Object? participantCount = null,
    Object? timeLimitMinutes = freezed,
    Object? randomQuestionOrder = null,
    Object? allowRetry = null,
    Object? showImmediateFeedback = null,
    Object? leaderboardEnabled = null,
    Object? canvasRequired = null,
    Object? maximumAttempts = freezed,
    Object? createdAt = null,
    Object? version = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      trainingPackId: null == trainingPackId
          ? _value.trainingPackId
          : trainingPackId // ignore: cast_nullable_to_non_nullable
              as String,
      joinCode: null == joinCode
          ? _value.joinCode
          : joinCode // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      participantCount: null == participantCount
          ? _value.participantCount
          : participantCount // ignore: cast_nullable_to_non_nullable
              as int,
      timeLimitMinutes: freezed == timeLimitMinutes
          ? _value.timeLimitMinutes
          : timeLimitMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      randomQuestionOrder: null == randomQuestionOrder
          ? _value.randomQuestionOrder
          : randomQuestionOrder // ignore: cast_nullable_to_non_nullable
              as bool,
      allowRetry: null == allowRetry
          ? _value.allowRetry
          : allowRetry // ignore: cast_nullable_to_non_nullable
              as bool,
      showImmediateFeedback: null == showImmediateFeedback
          ? _value.showImmediateFeedback
          : showImmediateFeedback // ignore: cast_nullable_to_non_nullable
              as bool,
      leaderboardEnabled: null == leaderboardEnabled
          ? _value.leaderboardEnabled
          : leaderboardEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      canvasRequired: null == canvasRequired
          ? _value.canvasRequired
          : canvasRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      maximumAttempts: freezed == maximumAttempts
          ? _value.maximumAttempts
          : maximumAttempts // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      version: null == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TrainingSessionDetailDtoImplCopyWith<$Res>
    implements $TrainingSessionDetailDtoCopyWith<$Res> {
  factory _$$TrainingSessionDetailDtoImplCopyWith(
          _$TrainingSessionDetailDtoImpl value,
          $Res Function(_$TrainingSessionDetailDtoImpl) then) =
      __$$TrainingSessionDetailDtoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String trainingPackId,
      String joinCode,
      String status,
      int participantCount,
      int? timeLimitMinutes,
      bool randomQuestionOrder,
      bool allowRetry,
      bool showImmediateFeedback,
      bool leaderboardEnabled,
      bool canvasRequired,
      int? maximumAttempts,
      DateTime createdAt,
      String version});
}

/// @nodoc
class __$$TrainingSessionDetailDtoImplCopyWithImpl<$Res>
    extends _$TrainingSessionDetailDtoCopyWithImpl<$Res,
        _$TrainingSessionDetailDtoImpl>
    implements _$$TrainingSessionDetailDtoImplCopyWith<$Res> {
  __$$TrainingSessionDetailDtoImplCopyWithImpl(
      _$TrainingSessionDetailDtoImpl _value,
      $Res Function(_$TrainingSessionDetailDtoImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrainingSessionDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? trainingPackId = null,
    Object? joinCode = null,
    Object? status = null,
    Object? participantCount = null,
    Object? timeLimitMinutes = freezed,
    Object? randomQuestionOrder = null,
    Object? allowRetry = null,
    Object? showImmediateFeedback = null,
    Object? leaderboardEnabled = null,
    Object? canvasRequired = null,
    Object? maximumAttempts = freezed,
    Object? createdAt = null,
    Object? version = null,
  }) {
    return _then(_$TrainingSessionDetailDtoImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      trainingPackId: null == trainingPackId
          ? _value.trainingPackId
          : trainingPackId // ignore: cast_nullable_to_non_nullable
              as String,
      joinCode: null == joinCode
          ? _value.joinCode
          : joinCode // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      participantCount: null == participantCount
          ? _value.participantCount
          : participantCount // ignore: cast_nullable_to_non_nullable
              as int,
      timeLimitMinutes: freezed == timeLimitMinutes
          ? _value.timeLimitMinutes
          : timeLimitMinutes // ignore: cast_nullable_to_non_nullable
              as int?,
      randomQuestionOrder: null == randomQuestionOrder
          ? _value.randomQuestionOrder
          : randomQuestionOrder // ignore: cast_nullable_to_non_nullable
              as bool,
      allowRetry: null == allowRetry
          ? _value.allowRetry
          : allowRetry // ignore: cast_nullable_to_non_nullable
              as bool,
      showImmediateFeedback: null == showImmediateFeedback
          ? _value.showImmediateFeedback
          : showImmediateFeedback // ignore: cast_nullable_to_non_nullable
              as bool,
      leaderboardEnabled: null == leaderboardEnabled
          ? _value.leaderboardEnabled
          : leaderboardEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      canvasRequired: null == canvasRequired
          ? _value.canvasRequired
          : canvasRequired // ignore: cast_nullable_to_non_nullable
              as bool,
      maximumAttempts: freezed == maximumAttempts
          ? _value.maximumAttempts
          : maximumAttempts // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
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
class _$TrainingSessionDetailDtoImpl implements _TrainingSessionDetailDto {
  const _$TrainingSessionDetailDtoImpl(
      {required this.id,
      required this.trainingPackId,
      required this.joinCode,
      required this.status,
      required this.participantCount,
      this.timeLimitMinutes,
      this.randomQuestionOrder = false,
      this.allowRetry = false,
      this.showImmediateFeedback = false,
      this.leaderboardEnabled = false,
      this.canvasRequired = false,
      this.maximumAttempts,
      required this.createdAt,
      required this.version});

  factory _$TrainingSessionDetailDtoImpl.fromJson(Map<String, dynamic> json) =>
      _$$TrainingSessionDetailDtoImplFromJson(json);

  @override
  final String id;
  @override
  final String trainingPackId;
  @override
  final String joinCode;
  @override
  final String status;
  @override
  final int participantCount;
  @override
  final int? timeLimitMinutes;
  @override
  @JsonKey()
  final bool randomQuestionOrder;
  @override
  @JsonKey()
  final bool allowRetry;
  @override
  @JsonKey()
  final bool showImmediateFeedback;
  @override
  @JsonKey()
  final bool leaderboardEnabled;
  @override
  @JsonKey()
  final bool canvasRequired;
  @override
  final int? maximumAttempts;
  @override
  final DateTime createdAt;
  @override
  final String version;

  @override
  String toString() {
    return 'TrainingSessionDetailDto(id: $id, trainingPackId: $trainingPackId, joinCode: $joinCode, status: $status, participantCount: $participantCount, timeLimitMinutes: $timeLimitMinutes, randomQuestionOrder: $randomQuestionOrder, allowRetry: $allowRetry, showImmediateFeedback: $showImmediateFeedback, leaderboardEnabled: $leaderboardEnabled, canvasRequired: $canvasRequired, maximumAttempts: $maximumAttempts, createdAt: $createdAt, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainingSessionDetailDtoImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.trainingPackId, trainingPackId) ||
                other.trainingPackId == trainingPackId) &&
            (identical(other.joinCode, joinCode) ||
                other.joinCode == joinCode) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.participantCount, participantCount) ||
                other.participantCount == participantCount) &&
            (identical(other.timeLimitMinutes, timeLimitMinutes) ||
                other.timeLimitMinutes == timeLimitMinutes) &&
            (identical(other.randomQuestionOrder, randomQuestionOrder) ||
                other.randomQuestionOrder == randomQuestionOrder) &&
            (identical(other.allowRetry, allowRetry) ||
                other.allowRetry == allowRetry) &&
            (identical(other.showImmediateFeedback, showImmediateFeedback) ||
                other.showImmediateFeedback == showImmediateFeedback) &&
            (identical(other.leaderboardEnabled, leaderboardEnabled) ||
                other.leaderboardEnabled == leaderboardEnabled) &&
            (identical(other.canvasRequired, canvasRequired) ||
                other.canvasRequired == canvasRequired) &&
            (identical(other.maximumAttempts, maximumAttempts) ||
                other.maximumAttempts == maximumAttempts) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.version, version) || other.version == version));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      trainingPackId,
      joinCode,
      status,
      participantCount,
      timeLimitMinutes,
      randomQuestionOrder,
      allowRetry,
      showImmediateFeedback,
      leaderboardEnabled,
      canvasRequired,
      maximumAttempts,
      createdAt,
      version);

  /// Create a copy of TrainingSessionDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainingSessionDetailDtoImplCopyWith<_$TrainingSessionDetailDtoImpl>
      get copyWith => __$$TrainingSessionDetailDtoImplCopyWithImpl<
          _$TrainingSessionDetailDtoImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TrainingSessionDetailDtoImplToJson(
      this,
    );
  }
}

abstract class _TrainingSessionDetailDto implements TrainingSessionDetailDto {
  const factory _TrainingSessionDetailDto(
      {required final String id,
      required final String trainingPackId,
      required final String joinCode,
      required final String status,
      required final int participantCount,
      final int? timeLimitMinutes,
      final bool randomQuestionOrder,
      final bool allowRetry,
      final bool showImmediateFeedback,
      final bool leaderboardEnabled,
      final bool canvasRequired,
      final int? maximumAttempts,
      required final DateTime createdAt,
      required final String version}) = _$TrainingSessionDetailDtoImpl;

  factory _TrainingSessionDetailDto.fromJson(Map<String, dynamic> json) =
      _$TrainingSessionDetailDtoImpl.fromJson;

  @override
  String get id;
  @override
  String get trainingPackId;
  @override
  String get joinCode;
  @override
  String get status;
  @override
  int get participantCount;
  @override
  int? get timeLimitMinutes;
  @override
  bool get randomQuestionOrder;
  @override
  bool get allowRetry;
  @override
  bool get showImmediateFeedback;
  @override
  bool get leaderboardEnabled;
  @override
  bool get canvasRequired;
  @override
  int? get maximumAttempts;
  @override
  DateTime get createdAt;
  @override
  String get version;

  /// Create a copy of TrainingSessionDetailDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainingSessionDetailDtoImplCopyWith<_$TrainingSessionDetailDtoImpl>
      get copyWith => throw _privateConstructorUsedError;
}
