import '../models/user_profile_model.dart';

/// Profile remote data source interface.
///
/// Defines the contract for profile-related API calls.
abstract class ProfileRemoteDataSource {
  /// Get current user profile from API.
  ///
  /// Returns [UserProfileModel] on success.
  /// Throws [ServerException] on API errors.
  Future<UserProfileModel> getProfile();

  /// Update user profile via API.
  ///
  /// [data] contains the fields to update.
  ///
  /// Returns updated [UserProfileModel] on success.
  /// Throws [ServerException] on API errors.
  Future<UserProfileModel> updateProfile(Map<String, dynamic> data);

  /// Upload user avatar via API.
  ///
  /// [imagePath] is the local path to the image file.
  ///
  /// Returns updated [UserProfileModel] on success.
  /// Throws [ServerException] on API errors.
  Future<UserProfileModel> uploadAvatar(String imagePath);

  /// Change user password via API.
  ///
  /// [currentPassword] is the user's current password.
  /// [newPassword] is the new password to set.
  ///
  /// Returns void on success.
  /// Throws [ServerException] on API errors.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Delete user account via API.
  ///
  /// [password] is required for confirmation.
  ///
  /// Returns void on success.
  /// Throws [ServerException] on API errors.
  Future<void> deleteAccount(String password);
}
