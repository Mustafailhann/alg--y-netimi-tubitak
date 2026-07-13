import 'package:freezed_annotation/freezed_annotation.dart';

part 'training_session.freezed.dart';

enum TrainingSessionStatus {
  created,
  active,
  completed,
  cancelled,
}

@freezed
class TrainingSession with _$TrainingSession {
  const factory TrainingSession({
    required String id,
    required String trainingPackId,
    required String joinCode,
    required TrainingSessionStatus status,
    required int participantCount,
    int? timeLimitMinutes,
    @Default(false) bool randomQuestionOrder,
    @Default(false) bool allowRetry,
    @Default(false) bool showImmediateFeedback,
    @Default(false) bool leaderboardEnabled,
    @Default(false) bool canvasRequired,
    int? maximumAttempts,
    required DateTime createdAt,
    required String version,
  }) = _TrainingSession;
}
