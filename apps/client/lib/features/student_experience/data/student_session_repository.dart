import 'package:dio/dio.dart';
import '../domain/participant_token.dart';
import 'models/student_dto.dart';

class StudentSessionRepository {
  final Dio _dio;

  StudentSessionRepository(this._dio);

  Future<ParticipantToken> joinSession(String joinCode, String studentIdentifier) async {
    final response = await _dio.post('/v1/training-sessions/participants', data: {
      'joinCode': joinCode,
      'studentIdentifier': studentIdentifier,
    });
    return ParticipantToken.fromJson(response.data);
  }

  Future<StudentSessionStateDto> getStudentState(String sessionId, String participantId) async {
    final response = await _dio.get(
      '/v1/training-sessions/$sessionId/student-state',
      queryParameters: {'participantId': participantId},
    );
    return StudentSessionStateDto.fromJson(response.data);
  }

  Future<StudentQuestionDto> getCurrentQuestion(String sessionId) async {
    final response = await _dio.get('/v1/training-sessions/$sessionId/current-question');
    return StudentQuestionDto.fromJson(response.data);
  }

  Future<void> submitAnswer({
    required String sessionId,
    required String participantId,
    required String judgment,
    required int timeTakenMilliseconds,
    String? annotationId,
  }) async {
    await _dio.post('/v1/training-sessions/$sessionId/answers', data: {
      'participantId': participantId,
      'judgment': judgment,
      'timeTakenMilliseconds': timeTakenMilliseconds,
      'annotationId': annotationId,
    });
  }

  Future<StudentSessionResultDto> getResults(String sessionId, String participantId) async {
    final response = await _dio.get(
      '/v1/training-sessions/$sessionId/results',
      queryParameters: {'participantId': participantId},
    );
    return StudentSessionResultDto.fromJson(response.data);
  }

  Future<List<QuestionHistoryDto>> getQuestionHistory(String sessionId) async {
    final response = await _dio.get('/v1/training-sessions/$sessionId/question-history');
    return (response.data as List).map((e) => QuestionHistoryDto.fromJson(e)).toList();
  }

  Future<QuestionReviewDto> getQuestionReview(String sessionId, String trainingItemId) async {
    final response = await _dio.get('/v1/training-sessions/$sessionId/question-history/$trainingItemId/review');
    return QuestionReviewDto.fromJson(response.data);
  }

  Future<void> leaveSession(String sessionId, String participantId) async {
    await _dio.post('/v1/training-sessions/$sessionId/leave', data: {
      'participantId': participantId,
    });
  }
}
