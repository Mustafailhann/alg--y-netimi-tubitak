import 'package:dio/dio.dart';
import '../models/training_session_dto.dart';
import '../models/participant_dto.dart';

abstract class TrainingSessionRemoteDataSource {
  Future<List<TrainingSessionDto>> getMySessions(String teacherId);
  Future<TrainingSessionDetailDto> getById(String sessionId, String teacherId);
  Future<List<ParticipantDto>> getParticipants(String sessionId, String teacherId);
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

class TrainingSessionRemoteDataSourceImpl implements TrainingSessionRemoteDataSource {
  final Dio dio;

  TrainingSessionRemoteDataSourceImpl(this.dio);

  @override
  Future<List<TrainingSessionDto>> getMySessions(String teacherId) async {
    final response = await dio.get('/v1/training-sessions', queryParameters: {'teacherId': teacherId});
    final data = response.data as List;
    return data.map((json) => TrainingSessionDto.fromJson(json)).toList();
  }

  @override
  Future<TrainingSessionDetailDto> getById(String sessionId, String teacherId) async {
    final response = await dio.get('/v1/training-sessions/$sessionId', queryParameters: {'teacherId': teacherId});
    return TrainingSessionDetailDto.fromJson(response.data);
  }

  @override
  Future<List<ParticipantDto>> getParticipants(String sessionId, String teacherId) async {
    final response = await dio.get('/v1/training-sessions/$sessionId/participants', queryParameters: {'teacherId': teacherId});
    final data = response.data as List;
    return data.map((json) => ParticipantDto.fromJson(json)).toList();
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
  ) async {
    final response = await dio.post('/v1/training-sessions', data: {
      'teacherId': teacherId,
      'trainingPackId': packId,
      'configuration': {
        'timeLimitMinutes': timeLimitMinutes,
        'randomQuestionOrder': randomQuestionOrder,
        'allowRetry': allowRetry,
        'showImmediateFeedback': showImmediateFeedback,
        'leaderboardEnabled': leaderboardEnabled,
        'canvasRequired': canvasRequired,
        'maximumAttempts': maximumAttempts,
      }
    });
    return response.data['id'];
  }

  @override
  Future<void> startSession(String sessionId, String teacherId, String version) async {
    await dio.post('/v1/training-sessions/$sessionId/start', data: {
      'teacherId': teacherId,
      'version': version,
    });
  }

  @override
  Future<void> completeSession(String sessionId, String teacherId, String version) async {
    await dio.post('/v1/training-sessions/$sessionId/complete', data: {
      'teacherId': teacherId,
      'version': version,
    });
  }

  @override
  Future<void> cancelSession(String sessionId, String teacherId, String version) async {
    await dio.post('/v1/training-sessions/$sessionId/cancel', data: {
      'teacherId': teacherId,
      'version': version,
    });
  }

  @override
  Future<void> nextQuestion(String sessionId, String teacherId) async {
    await dio.post('/v1/training-sessions/$sessionId/next-question', data: {
      'teacherId': teacherId,
    });
  }
}
