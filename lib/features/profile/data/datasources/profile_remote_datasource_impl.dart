import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';
import '../models/user_profile_model.dart';
import 'profile_remote_datasource.dart';

/// Profile remote data source implementation.
///
/// Implements profile-related API calls using http package.
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  ProfileRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

  @override
  Future<UserProfileModel> getProfile() async {
    final response = await client.get(
      Uri.parse('$baseUrl/v1/profile'),
      headers: _buildHeaders(),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final userData = jsonData['data'] as Map<String, dynamic>;
      return UserProfileModel.fromJson(userData);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 404) {
      throw NotFoundException();
    } else {
      throw ServerException(
        message: 'Failed to get profile',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<UserProfileModel> updateProfile(Map<String, dynamic> data) async {
    final response = await client.put(
      Uri.parse('$baseUrl/v1/profile'),
      headers: _buildHeaders(),
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final userData = jsonData['data'] as Map<String, dynamic>;
      return UserProfileModel.fromJson(userData);
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 422) {
      throw ValidationException(
        message: 'Validation failed',
        statusCode: response.statusCode,
      );
    } else {
      throw ServerException(
        message: 'Failed to update profile',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<UserProfileModel> uploadAvatar(String imagePath) async {
    // TODO: Implement multipart file upload
    // This will require using http.MultipartRequest
    // For now, throw UnimplementedError
    throw UnimplementedError('Avatar upload not yet implemented');

    /*
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/v1/profile/avatar'),
    );

    request.headers.addAll(_buildHeaders());
    request.files.add(
      await http.MultipartFile.fromPath('avatar', imagePath),
    );

    final http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final jsonData = jsonDecode(responseBody) as Map<String, dynamic>;
      final userData = jsonData['data'] as Map<String, dynamic>;
      return UserProfileModel.fromJson(userData);
    } else {
      throw ServerException(
        message: 'Failed to upload avatar',
        statusCode: response.statusCode,
      );
    }
    */
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await client.post(
      Uri.parse('$baseUrl/v1/profile/change-password'),
      headers: _buildHeaders(),
      body: jsonEncode({
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 422) {
      throw ValidationException(
        message: 'Current password is incorrect',
        statusCode: response.statusCode,
      );
    } else {
      throw ServerException(
        message: 'Failed to change password',
        statusCode: response.statusCode,
      );
    }
  }

  @override
  Future<void> deleteAccount(String password) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/v1/profile'),
      headers: _buildHeaders(),
      body: jsonEncode({'password': password}),
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else if (response.statusCode == 422) {
      throw ValidationException(
        message: 'Incorrect password',
        statusCode: response.statusCode,
      );
    } else {
      throw ServerException(
        message: 'Failed to delete account',
        statusCode: response.statusCode,
      );
    }
  }

  /// Build request headers with authentication.
  Map<String, String> _buildHeaders() {
    // TODO: Get token from TokenService
    // For now, return basic headers
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // 'Authorization': 'Bearer $token',
    };
  }
}
