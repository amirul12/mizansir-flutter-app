import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_constants.dart';

/// Service for managing authentication tokens using SharedPreferences
class TokenService {
  TokenService._();

  static final TokenService _instance = TokenService._();
  factory TokenService() => _instance;

  static Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  /// Save access token
  Future<void> saveAccessToken(String token) async {
    (await _prefs).setString(StorageConstants.accessTokenKey, token);
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return (await _prefs).getString(StorageConstants.accessTokenKey);
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    (await _prefs).setString(StorageConstants.refreshTokenKey, token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return (await _prefs).getString(StorageConstants.refreshTokenKey);
  }

  /// Save both access and refresh tokens
  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    await saveAccessToken(accessToken);
    if (refreshToken != null) {
      await saveRefreshToken(refreshToken);
    }
  }

  /// Clear access token
  Future<void> clearAccessToken() async {
    (await _prefs).remove(StorageConstants.accessTokenKey);
  }

  /// Clear refresh token
  Future<void> clearRefreshToken() async {
    (await _prefs).remove(StorageConstants.refreshTokenKey);
  }

  /// Clear all tokens
  Future<void> clearTokens() async {
    await clearAccessToken();
    await clearRefreshToken();
  }

  /// Check if access token exists
  Future<bool> hasAccessToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Get Authorization header value
  Future<String> getAuthHeader() async {
    final token = await getAccessToken();
    if (token == null || token.isEmpty) {
      throw Exception('No access token available');
    }
    return 'Bearer $token';
  }

  /// Alias for retrieveBearerToken (for compatibility with CacheService)
  Future<String?> retrieveBearerToken() async {
    return getAccessToken();
  }

  /// Alias for saveAccessToken (for compatibility)
  Future<void> storeBearerToken(String token) async {
    await saveAccessToken(token);
  }
}
