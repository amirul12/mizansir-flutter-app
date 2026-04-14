import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/token_service.dart';
import '../models/user_profile_model.dart';
import 'profile_remote_datasource.dart';

/// Profile remote data source implementation.
///
/// Implements profile-related API calls using http package.
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final http.Client client;
  final String baseUrl;
  final TokenService tokenService;

  ProfileRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
    required this.tokenService,
  });

  @override
  Future<UserProfileModel> getProfile() async {
    final headers = await _buildHeaders();
    final response = await client.get(
      Uri.parse('$baseUrl/v1/user/profile'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final responseData = jsonData['data'] as Map<String, dynamic>;
      return UserProfileModel.fromApiResponse(responseData);
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
    final headers = await _buildHeaders();
    final response = await client.put(
      Uri.parse('$baseUrl/v1/user/profile'),
      headers: headers,
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      final responseData = jsonData['data'] as Map<String, dynamic>;
      return UserProfileModel.fromApiResponse(responseData);
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
    final headers = await _buildHeaders();
    final response = await client.post(
      Uri.parse('$baseUrl/v1/user/change-password'),
      headers: headers,
      body: jsonEncode({
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPassword,
      }),
    );

    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 401) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      throw UnauthorizedException(
        message: jsonData['message'] ?? 'Current password is incorrect',
      );
    } else if (response.statusCode == 422) {
      final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
      throw ValidationException(
        message: jsonData['message'] ?? 'Validation failed',
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
    final headers = await _buildHeaders();
    final response = await client.delete(
      Uri.parse('$baseUrl/v1/user/profile'),
      headers: headers,
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
  Future<Map<String, String>> _buildHeaders() async {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add Authorization header if token exists
    final token = await tokenService.getAccessToken();
    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }
}
