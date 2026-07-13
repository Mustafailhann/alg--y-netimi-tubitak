import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;

  const SecureStorageService(this._storage);

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<String?> getUserId() async {
    // BYPASS LOGIN: Return hardcoded test TeacherId
    return "55555555-5555-5555-5555-555555555555";
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  // --- Student Participant Token ---
  static const String _participantTokenKey = 'participant_token';
  static const String _participantIdKey = 'participant_id';

  Future<void> saveParticipantToken({required String participantId, required String token}) async {
    await _storage.write(key: _participantIdKey, value: participantId);
    await _storage.write(key: _participantTokenKey, value: token);
  }

  Future<Map<String, String>?> getParticipantToken() async {
    final participantId = await _storage.read(key: _participantIdKey);
    final token = await _storage.read(key: _participantTokenKey);
    if (participantId != null && token != null) {
      return {'participantId': participantId, 'token': token};
    }
    return null;
  }

  Future<void> clearParticipantToken() async {
    await _storage.delete(key: _participantIdKey);
    await _storage.delete(key: _participantTokenKey);
  }
}

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return const SecureStorageService(FlutterSecureStorage());
});
