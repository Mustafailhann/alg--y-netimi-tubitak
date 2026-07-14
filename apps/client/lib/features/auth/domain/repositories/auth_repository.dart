import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../data/datasources/auth_remote_data_source.dart';

abstract class AuthRepository {
  Future<void> login(String email, String password);
  Future<void> devLogin(String role);
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorageService;

  AuthRepositoryImpl(this._remoteDataSource, this._secureStorageService);

  @override
  Future<void> login(String email, String password) async {
    final data = await _remoteDataSource.login(email, password);
    final accessToken = data['accessToken'] as String;
    final refreshToken = data['refreshToken'] as String;
    
    await _secureStorageService.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  Future<void> devLogin(String role) async {
    final data = await _remoteDataSource.devLogin(role);
    final accessToken = data['accessToken'] as String;
    final refreshToken = data['refreshToken'] as String;
    
    await _secureStorageService.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  @override
  Future<void> logout() async {
    await _secureStorageService.clearTokens();
    await _remoteDataSource.logout();
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final secureStorageService = ref.watch(secureStorageServiceProvider);
  return AuthRepositoryImpl(remoteDataSource, secureStorageService);
});
