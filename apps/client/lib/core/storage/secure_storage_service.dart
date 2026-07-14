import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage;
  SharedPreferences? _prefs;

  SecureStorageService(this._storage);

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  Future<SharedPreferences> get _getPrefs async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<void> _write(String key, String value) async {
    if (kIsWeb) {
      final prefs = await _getPrefs;
      await prefs.setString(key, value);
    } else {
      await _storage.write(key: key, value: value);
    }
  }

  Future<String?> _read(String key) async {
    if (kIsWeb) {
      final prefs = await _getPrefs;
      return prefs.getString(key);
    } else {
      return await _storage.read(key: key);
    }
  }

  Future<void> _delete(String key) async {
    if (kIsWeb) {
      final prefs = await _getPrefs;
      await prefs.remove(key);
    } else {
      await _storage.delete(key: key);
    }
  }

  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await _write(_accessTokenKey, accessToken);
    await _write(_refreshTokenKey, refreshToken);
  }

  Future<String?> getAccessToken() async {
    return await _read(_accessTokenKey);
  }

  Future<String?> getRefreshToken() async {
    return await _read(_refreshTokenKey);
  }

  Future<String?> getUserId() async {
    // BYPASS LOGIN: Return hardcoded test TeacherId
    return "55555555-5555-5555-5555-555555555555";
  }

  Future<void> clearTokens() async {
    await _delete(_accessTokenKey);
    await _delete(_refreshTokenKey);
  }

  // --- Student Participant Token ---
  static const String _participantTokenKey = 'participant_token';
  static const String _participantIdKey = 'participant_id';

  Future<void> saveParticipantToken({required String participantId, required String token}) async {
    await _write(_participantIdKey, participantId);
    await _write(_participantTokenKey, token);
  }

  Future<Map<String, String>?> getParticipantToken() async {
    final participantId = await _read(_participantIdKey);
    final token = await _read(_participantTokenKey);
    if (participantId != null && token != null) {
      return {'participantId': participantId, 'token': token};
    }
    return null;
  }

  Future<void> clearParticipantToken() async {
    await _delete(_participantIdKey);
    await _delete(_participantTokenKey);
  }
}

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService(const FlutterSecureStorage());
});
