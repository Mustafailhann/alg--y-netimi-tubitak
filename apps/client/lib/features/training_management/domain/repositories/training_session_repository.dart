import '../models/training_session.dart';
import '../models/participant.dart';

abstract class TrainingSessionRepository {
  Future<List<TrainingSession>> getMySessions(String teacherId);
  Future<TrainingSession> getById(String sessionId, String teacherId);
  Future<List<Participant>> getParticipants(String sessionId, String teacherId);
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
  );
  Future<void> startSession(String sessionId, String teacherId, String version);
  Future<void> completeSession(String sessionId, String teacherId, String version);
  Future<void> cancelSession(String sessionId, String teacherId, String version);
  Future<void> nextQuestion(String sessionId, String teacherId);
}
