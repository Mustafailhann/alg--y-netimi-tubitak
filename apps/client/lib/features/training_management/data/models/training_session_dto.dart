import 'package:freezed_annotation/freezed_annotation.dart';

part 'training_session_dto.freezed.dart';
part 'training_session_dto.g.dart';

@freezed
class TrainingSessionDto with _$TrainingSessionDto {
  const factory TrainingSessionDto({
    required String id,
    required String trainingPackId,
    required String joinCode,
    required String status, // mapped from enum
    required int participantCount,
    required DateTime createdAt,
  }) = _TrainingSessionDto;

  factory TrainingSessionDto.fromJson(Map<String, dynamic> json) => _$TrainingSessionDtoFromJson(json);
}

@freezed
class TrainingSessionDetailDto with _$TrainingSessionDetailDto {
  const factory TrainingSessionDetailDto({
    required String id,
    required String trainingPackId,
    required String joinCode,
    required String status,
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
  }) = _TrainingSessionDetailDto;

  factory TrainingSessionDetailDto.fromJson(Map<String, dynamic> json) => _$TrainingSessionDetailDtoFromJson(json);
}
