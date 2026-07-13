import '../models/training_session_dto.dart';
import '../../domain/models/training_session.dart';

class TrainingSessionMapper {
  static TrainingSession fromDto(TrainingSessionDto dto) {
    return TrainingSession(
      id: dto.id,
      trainingPackId: dto.trainingPackId,
      joinCode: dto.joinCode,
      status: _mapStatus(dto.status),
      participantCount: dto.participantCount,
      createdAt: dto.createdAt,
      version: '', // Version not provided in summary DTO, defaults to empty or need to handle nullable
    );
  }

  static TrainingSession fromDetailDto(TrainingSessionDetailDto dto) {
    return TrainingSession(
      id: dto.id,
      trainingPackId: dto.trainingPackId,
      joinCode: dto.joinCode,
      status: _mapStatus(dto.status),
      participantCount: dto.participantCount,
      timeLimitMinutes: dto.timeLimitMinutes,
      randomQuestionOrder: dto.randomQuestionOrder,
      allowRetry: dto.allowRetry,
      showImmediateFeedback: dto.showImmediateFeedback,
      leaderboardEnabled: dto.leaderboardEnabled,
      canvasRequired: dto.canvasRequired,
      maximumAttempts: dto.maximumAttempts,
      createdAt: dto.createdAt,
      version: dto.version,
    );
  }

  static TrainingSessionStatus _mapStatus(String status) {
    switch (status) {
      case 'Scheduled':
        return TrainingSessionStatus.created;
      case 'Active':
      case 'Paused':
        return TrainingSessionStatus.active;
      case 'Finished':
        return TrainingSessionStatus.completed;
      case 'Cancelled':
        return TrainingSessionStatus.cancelled;
      default:
        return TrainingSessionStatus.created;
    }
  }
}
