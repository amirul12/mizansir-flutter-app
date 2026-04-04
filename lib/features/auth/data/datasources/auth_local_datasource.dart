// File: lib/features/auth/data/datasources/auth_local_datasource.dart
/// Authentication local data source interface
abstract class AuthLocalDataSource {
  /// Cache user data
  Future<void> cacheUser(Map<String, dynamic> userJson);

  /// Get cached user data
  Future<Map<String, dynamic>?> getCachedUser();

  /// Clear cached user data
  Future<void> clearCachedUser();

  /// Save authentication state
  Future<void> saveAuthState(bool isAuthenticated);

  /// Get authentication state
  Future<bool> getAuthState();

  /// Clear authentication state
  Future<void> clearAuthState();
}
