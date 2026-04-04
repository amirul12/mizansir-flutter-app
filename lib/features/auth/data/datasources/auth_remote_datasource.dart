// File: lib/features/auth/data/datasources/auth_remote_datasource.dart
import '../models/auth_response_model.dart';
import '../models/auth_user_model.dart';
import '../models/session_model.dart';

/// Authentication remote data source interface
abstract class AuthRemoteDataSource {
  /// Register a new student
  Future<AuthUserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
  });

  /// Login with email and password
  Future<AuthResponseModel> login({
    required String email,
    required String password,
    required String deviceName,
  });

  /// Get current user
  Future<AuthUserModel> getCurrentUser();

  /// Logout
  Future<void> logout();

  /// Logout from all devices
  Future<void> logoutAll();

  /// Refresh token
  Future<String> refreshToken();

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  });

  /// Get active sessions
  Future<List<SessionModel>> getActiveSessions();

  /// Delete account
  Future<void> deleteAccount();
}
