import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/config/environment_config.dart';
import 'student_session_repository.dart';
import '../domain/participant_token.dart';

// StateProvider to hold the active participant token in memory
final currentParticipantTokenProvider = StateProvider<ParticipantToken?>((ref) => null);

// A separate Dio instance specifically for the student session (isolated from Teacher Auth)
final studentDioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: EnvironmentConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // Add interceptor to inject ParticipantToken
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = ref.read(currentParticipantTokenProvider)?.token;
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ),
  );

  return dio;
});

final studentSessionRepositoryProvider = Provider<StudentSessionRepository>((ref) {
  return StudentSessionRepository(ref.watch(studentDioProvider));
});
