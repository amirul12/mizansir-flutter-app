import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_profile.dart';

/// Profile repository interface.
///
/// Defines the contract for profile-related operations.
abstract class ProfileRepository {
  /// Get current user profile.
  ///
  /// Returns [Right] with [UserProfile] on success.
  /// Returns [Left] with [Failure] on failure.
  Future<Either<Failure, UserProfile>> getProfile();

  /// Update user profile.
  ///
  /// [params] contains the fields to update:
  /// - name: String (optional)
  /// - phone: String? (optional)
  /// - collegeName: String? (optional)
  /// - address: String? (optional)
  ///
  /// Returns [Right] with updated [UserProfile] on success.
  /// Returns [Left] with [Failure] on failure.
  Future<Either<Failure, UserProfile>> updateProfile(Map<String, dynamic> params);

  /// Upload user avatar.
  ///
  /// [imagePath] is the local path to the image file.
  ///
  /// Returns [Right] with updated [UserProfile] on success.
  /// Returns [Left] with [Failure] on failure.
  Future<Either<Failure, UserProfile>> uploadAvatar(String imagePath);

  /// Change user password.
  ///
  /// [currentPassword] is the user's current password.
  /// [newPassword] is the new password to set.
  ///
  /// Returns [Right] with void on success.
  /// Returns [Left] with [Failure] on failure.
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Delete user account.
  ///
  /// [password] is required for confirmation.
  ///
  /// Returns [Right] with void on success.
  /// Returns [Left] with [Failure] on failure.
  Future<Either<Failure, void>> deleteAccount(String password);

  /// Log out user from profile context.
  ///
  /// Returns [Right] with void on success.
  /// Returns [Left] with [Failure] on failure.
  Future<Either<Failure, void>> logout();
}
