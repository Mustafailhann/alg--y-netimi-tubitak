import '../../domain/models/training_session.dart';
import '../../domain/models/participant.dart';
import '../../domain/repositories/training_session_repository.dart';
import '../datasources/training_session_remote_datasource.dart';
import '../mappers/training_session_mapper.dart';
import '../mappers/participant_mapper.dart';

class TrainingSessionRepositoryImpl implements TrainingSessionRepository {
  final TrainingSessionRemoteDataSource remoteDataSource;

  TrainingSessionRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<TrainingSession>> getMySessions(String teacherId) async {
    final dtos = await remoteDataSource.getMySessions(teacherId);
    return dtos.map((dto) => TrainingSessionMapper.fromDto(dto)).toList();
  }

  @override
  Future<TrainingSession> getById(String sessionId, String teacherId) async {
    final dto = await remoteDataSource.getById(sessionId, teacherId);
    return TrainingSessionMapper.fromDetailDto(dto);
  }

  @override
  Future<List<Participant>> getParticipants(String sessionId, String teacherId) async {
    final dtos = await remoteDataSource.getParticipants(sessionId, teacherId);
    return dtos.map((dto) => ParticipantMapper.fromDto(dto)).toList();
  }

  @override
  Future<String> createSession(
    String teacherId, 
    String packId, 
    int? timeLimitMinutes,
    bool randomQuestionOrder,
    bool allowRetry,
    bool showImmediateFeedback,
    bool leaderboardEnabled,
    bool canvasRequired,
    int? maximumAttempts,
    bool autoAdvance,
  ) {
    return remoteDataSource.createSession(
      teacherId, 
      packId, 
      timeLimitMinutes,
      randomQuestionOrder,
      allowRetry,
      showImmediateFeedback,
      leaderboardEnabled,
      canvasRequired,
      maximumAttempts,
      autoAdvance,
    );
  }

  @override
  Future<void> startSession(String sessionId, String teacherId, String version) {
    return remoteDataSource.startSession(sessionId, teacherId, version);
  }

  @override
  Future<void> completeSession(String sessionId, String teacherId, String version) {
    return remoteDataSource.completeSession(sessionId, teacherId, version);
  }

  @override
  Future<void> cancelSession(String sessionId, String teacherId, String version) {
    return remoteDataSource.cancelSession(sessionId, teacherId, version);
  }

  @override
  Future<void> nextQuestion(String sessionId, String teacherId) {
    return remoteDataSource.nextQuestion(sessionId, teacherId);
  }
}
