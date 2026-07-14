import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/storage/secure_storage_service.dart';

enum AuthState {
  initial,
  unauthenticated,
  authenticated,
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final SecureStorageService _secureStorageService;

  AuthNotifier(this._repository, this._secureStorageService) : super(AuthState.initial) {
    checkAuth();
  }

  Future<void> checkAuth() async {
    // Only set authenticated if tokens exist
    final hasToken = await _secureStorageService.getAccessToken() != null;
    if (hasToken) {
      state = AuthState.authenticated;
    } else {
      state = AuthState.unauthenticated;
    }
  }

  Future<void> devLogin(String role) async {
    try {
      await _repository.devLogin(role);
      state = AuthState.authenticated;
    } catch (e) {
      state = AuthState.unauthenticated;
      rethrow;
    }
  }

  Future<void> login(String email, String password) async {
    try {
      await _repository.login(email, password);
      state = AuthState.authenticated;
    } catch (e) {
      state = AuthState.unauthenticated;
      rethrow;
    }
  }

  Future<void> logout() async {
    // 1. Clear authentication state
    // 3. Navigate to Login (automatic via GoRouter observing state)
    state = AuthState.unauthenticated;
    
    // 2. Clear Secure Storage
    // 4. Send Logout API request
    // 5. Ignore network failure
    await _repository.logout();
  }

  // Used by interceptor when refresh fails
  void logoutLocal() {
    state = AuthState.unauthenticated;
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final secureStorage = ref.watch(secureStorageServiceProvider);
  return AuthNotifier(repository, secureStorage);
});
