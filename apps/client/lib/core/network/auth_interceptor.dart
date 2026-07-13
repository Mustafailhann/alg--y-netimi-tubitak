import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/secure_storage_service.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../config/environment_config.dart';

class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final SecureStorageService _secureStorageService;
  final Ref _ref;
  
  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  AuthInterceptor(this._dio, this._secureStorageService, this._ref);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Exclude login and refresh endpoints from attaching token
    if (options.path.contains('/auth/login') || options.path.contains('/auth/refresh')) {
      return super.onRequest(options, handler);
    }

    final accessToken = await _secureStorageService.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    } else {
      final participantData = await _secureStorageService.getParticipantToken();
      if (participantData != null && participantData['token'] != null) {
        options.headers['Authorization'] = 'Bearer ${participantData['token']}';
        // Add a custom header to identify that this request was made with a participant token
        options.headers['X-Is-Participant'] = 'true';
      }
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !err.requestOptions.path.contains('/auth/login') && !err.requestOptions.path.contains('/auth/refresh')) {
      
      // If the request was made with a participant token, there is no refresh token logic.
      if (err.requestOptions.headers['X-Is-Participant'] == 'true') {
         await _secureStorageService.clearParticipantToken();
         // Can't refresh participant tokens, just propagate the error so the UI can redirect
         return handler.next(err);
      }

      if (_isRefreshing) {
        try {
          // Wait for the active refresh to finish
          await _refreshCompleter!.future;
          
          // Retry original request with new token
          final newAccessToken = await _secureStorageService.getAccessToken();
          err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          final retryResponse = await _dio.fetch(err.requestOptions);
          return handler.resolve(retryResponse);
        } catch (e) {
          // If refresh failed, reject this queued request as well
          return handler.next(err);
        }
      }

      _isRefreshing = true;
      _refreshCompleter = Completer<void>();

      final refreshToken = await _secureStorageService.getRefreshToken();
      if (refreshToken == null) {
        _isRefreshing = false;
        _refreshCompleter!.completeError('No refresh token');
        _ref.read(authProvider.notifier).logoutLocal();
        return handler.next(err);
      }

      try {
        // Create a new dio instance to avoid interceptor loop
        final refreshDio = Dio(BaseOptions(baseUrl: EnvironmentConfig.baseUrl));
        final response = await refreshDio.post(
          '/auth/refresh',
          data: {'refreshToken': refreshToken},
        );

        final newAccessToken = response.data['accessToken'];
        final newRefreshToken = response.data['refreshToken'];

        await _secureStorageService.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );

        _isRefreshing = false;
        _refreshCompleter!.complete();

        // Update authorization header for original request
        err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

        // Retry the original request
        final retryResponse = await _dio.fetch(err.requestOptions);
        return handler.resolve(retryResponse);
      } catch (e) {
        _isRefreshing = false;
        _refreshCompleter!.completeError(e);
        await _secureStorageService.clearTokens();
        _ref.read(authProvider.notifier).logoutLocal();
        return handler.next(err);
      }
    }

    super.onError(err, handler);
  }
}
