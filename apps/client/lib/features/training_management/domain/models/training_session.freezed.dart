// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'training_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TrainingSession {
  String get id => throw _privateConstructorUsedError;
  String get trainingPackId => throw _privateConstructorUsedError;
  String get joinCode => throw _privateConstructorUsedError;
  TrainingSessionStatus get status => throw _privateConstructorUsedError;
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

  /// Create a copy of TrainingSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TrainingSessionCopyWith<TrainingSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TrainingSessionCopyWith<$Res> {
  factory $TrainingSessionCopyWith(
          TrainingSession value, $Res Function(TrainingSession) then) =
      _$TrainingSessionCopyWithImpl<$Res, TrainingSession>;
  @useResult
  $Res call(
      {String id,
      String trainingPackId,
      String joinCode,
      TrainingSessionStatus status,
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
class _$TrainingSessionCopyWithImpl<$Res, $Val extends TrainingSession>
    implements $TrainingSessionCopyWith<$Res> {
  _$TrainingSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TrainingSession
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
              as TrainingSessionStatus,
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
abstract class _$$TrainingSessionImplCopyWith<$Res>
    implements $TrainingSessionCopyWith<$Res> {
  factory _$$TrainingSessionImplCopyWith(_$TrainingSessionImpl value,
          $Res Function(_$TrainingSessionImpl) then) =
      __$$TrainingSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String trainingPackId,
      String joinCode,
      TrainingSessionStatus status,
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
class __$$TrainingSessionImplCopyWithImpl<$Res>
    extends _$TrainingSessionCopyWithImpl<$Res, _$TrainingSessionImpl>
    implements _$$TrainingSessionImplCopyWith<$Res> {
  __$$TrainingSessionImplCopyWithImpl(
      _$TrainingSessionImpl _value, $Res Function(_$TrainingSessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of TrainingSession
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
    return _then(_$TrainingSessionImpl(
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
              as TrainingSessionStatus,
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

class _$TrainingSessionImpl implements _TrainingSession {
  const _$TrainingSessionImpl(
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

  @override
  final String id;
  @override
  final String trainingPackId;
  @override
  final String joinCode;
  @override
  final TrainingSessionStatus status;
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
    return 'TrainingSession(id: $id, trainingPackId: $trainingPackId, joinCode: $joinCode, status: $status, participantCount: $participantCount, timeLimitMinutes: $timeLimitMinutes, randomQuestionOrder: $randomQuestionOrder, allowRetry: $allowRetry, showImmediateFeedback: $showImmediateFeedback, leaderboardEnabled: $leaderboardEnabled, canvasRequired: $canvasRequired, maximumAttempts: $maximumAttempts, createdAt: $createdAt, version: $version)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TrainingSessionImpl &&
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

  /// Create a copy of TrainingSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TrainingSessionImplCopyWith<_$TrainingSessionImpl> get copyWith =>
      __$$TrainingSessionImplCopyWithImpl<_$TrainingSessionImpl>(
          this, _$identity);
}

abstract class _TrainingSession implements TrainingSession {
  const factory _TrainingSession(
      {required final String id,
      required final String trainingPackId,
      required final String joinCode,
      required final TrainingSessionStatus status,
      required final int participantCount,
      final int? timeLimitMinutes,
      final bool randomQuestionOrder,
      final bool allowRetry,
      final bool showImmediateFeedback,
      final bool leaderboardEnabled,
      final bool canvasRequired,
      final int? maximumAttempts,
      required final DateTime createdAt,
      required final String version}) = _$TrainingSessionImpl;

  @override
  String get id;
  @override
  String get trainingPackId;
  @override
  String get joinCode;
  @override
  TrainingSessionStatus get status;
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

  /// Create a copy of TrainingSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TrainingSessionImplCopyWith<_$TrainingSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
