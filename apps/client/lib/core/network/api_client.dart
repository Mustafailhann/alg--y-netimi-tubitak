import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_interceptor.dart';
import '../storage/secure_storage_service.dart';

import '../config/environment_config.dart';
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      baseUrl: EnvironmentConfig.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  final secureStorage = ref.watch(secureStorageServiceProvider);
  
  // We pass ref to the interceptor to trigger logout if refresh fails
  dio.interceptors.add(AuthInterceptor(dio, secureStorage, ref));

  return dio;
});
