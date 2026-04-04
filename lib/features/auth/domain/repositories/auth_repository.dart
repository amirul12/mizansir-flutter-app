// File: lib/features/auth/domain/repositories/auth_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/auth_user.dart';
import '../entities/session.dart';

/// Authentication repository interface
abstract class AuthRepository {
  /// Register a new student
  Future<Either<Failure, AuthUser>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
  });

  /// Login with email and password
  Future<Either<Failure, AuthUser>> login({
    required String email,
    required String password,
    required String deviceName,
  });

  /// Get currently authenticated user
  Future<Either<Failure, AuthUser>> getCurrentUser();

  /// Logout from current device
  Future<Either<Failure, void>> logout();

  /// Logout from all devices
  Future<Either<Failure, void>> logoutAll();

  /// Refresh access token
  Future<Either<Failure, String>> refreshToken();

  /// Change password
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  });

  /// Get all active sessions
  Future<Either<Failure, List<Session>>> getActiveSessions();

  /// Check if user is authenticated
  Future<Either<Failure, bool>> isAuthenticated();

  /// Delete account
  Future<Either<Failure, void>> deleteAccount();
}
