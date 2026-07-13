import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import '../../../../lib/features/student_experience/data/student_session_repository.dart';

void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late StudentSessionRepository repository;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://api.example.com'));
    dioAdapter = DioAdapter(dio: dio);
    repository = StudentSessionRepository(dio);
  });

  test('joinSession returns ParticipantToken on success', () async {
    const responseData = {'id': '123', 'token': 'abc'};
    dioAdapter.onPost(
      '/v1/training-sessions/join',
      (server) => server.reply(200, responseData),
      data: {'joinCode': 'CODE123', 'studentIdentifier': 'Nick'},
    );

    final result = await repository.joinSession('CODE123', 'Nick');

    expect(result.participantId, '123');
    expect(result.token, 'abc');
  });

  test('getStudentState returns StudentSessionStateDto', () async {
    const responseData = {
      'sessionId': 'session1',
      'joinCode': 'CODE123',
      'status': 'Waiting',
      'currentQuestionIndex': null,
    };

    dioAdapter.onGet(
      '/v1/training-sessions/session1/student-state',
      (server) => server.reply(200, responseData),
      queryParameters: {'participantId': '123'},
    );

    final result = await repository.getStudentState('session1', '123');

    expect(result.sessionId, 'session1');
    expect(result.status, 'Waiting');
    expect(result.currentQuestionIndex, isNull);
  });
}
