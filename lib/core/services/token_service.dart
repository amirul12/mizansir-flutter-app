// File: lib/core/services/token_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/storage_constants.dart';
import '../errors/exceptions.dart';

/// Service for managing authentication tokens
class TokenService {
  final FlutterSecureStorage _secureStorage;

  TokenService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Save access token
  Future<void> saveAccessToken(String token) async {
    try {
      await _secureStorage.write(
        key: StorageConstants.accessTokenKey,
        value: token,
      );
    } catch (e) {
      throw const CacheException(message: 'Failed to save access token');
    }
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    try {
      return await _secureStorage.read(key: StorageConstants.accessTokenKey);
    } catch (e) {
      throw const CacheException(message: 'Failed to get access token');
    }
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    try {
      await _secureStorage.write(
        key: StorageConstants.refreshTokenKey,
        value: token,
      );
    } catch (e) {
      throw const CacheException(message: 'Failed to save refresh token');
    }
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    try {
      return await _secureStorage.read(
        key: StorageConstants.refreshTokenKey,
      );
    } catch (e) {
      throw const CacheException(message: 'Failed to get refresh token');
    }
  }

  /// Save both access and refresh tokens
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    try {
      await saveAccessToken(accessToken);
      if (refreshToken != null) {
        await saveRefreshToken(refreshToken);
      }
    } catch (e) {
      throw const CacheException(message: 'Failed to save tokens');
    }
  }

  /// Clear access token
  Future<void> clearAccessToken() async {
    try {
      await _secureStorage.delete(key: StorageConstants.accessTokenKey);
    } catch (e) {
      throw const CacheException(message: 'Failed to clear access token');
    }
  }

  /// Clear refresh token
  Future<void> clearRefreshToken() async {
    try {
      await _secureStorage.delete(key: StorageConstants.refreshTokenKey);
    } catch (e) {
      throw const CacheException(message: 'Failed to clear refresh token');
    }
  }

  /// Clear all tokens
  Future<void> clearTokens() async {
    try {
      await clearAccessToken();
      await clearRefreshToken();
    } catch (e) {
      throw const CacheException(message: 'Failed to clear tokens');
    }
  }

  /// Check if access token exists
  Future<bool> hasAccessToken() async {
    try {
      final token = await getAccessToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Check if tokens are valid
  Future<bool> areTokensValid() async {
    try {
      final accessToken = await getAccessToken();
      return accessToken != null && accessToken.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Get Authorization header value
  Future<String> getAuthHeader() async {
    final token = await getAccessToken();
    if (token == null || token.isEmpty) {
      throw const TokenException(message: 'No access token available');
    }
    return 'Bearer $token';
  }
}
