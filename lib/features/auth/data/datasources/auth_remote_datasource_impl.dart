// File: lib/features/auth/data/datasources/auth_remote_datasource_impl.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/token_service.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/auth_response_model.dart';
import '../models/auth_user_model.dart';
import '../models/session_model.dart';
import 'auth_remote_datasource.dart';

/// Authentication remote data source implementation
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final TokenService tokenService;
  final String baseUrl;

  AuthRemoteDataSourceImpl({
    required this.client,
    required this.tokenService,
    required this.baseUrl,
  });

  @override
  Future<AuthUserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl${ApiConstants.buildEndpoint(ApiConstants.registerEndpoint)}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'phone': phone,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final user = jsonData['data'] as Map<String, dynamic>;
        return AuthUserModel.fromJson(user);
      } else if (response.statusCode == 422) {
        final error = jsonDecode(response.body);
        throw ValidationException(
          message: error['message'] ?? 'Validation failed',
          errors: error['errors'],
        );
      } else {
        throw ServerException(
          message: 'Registration failed',
          statusCode: response.statusCode,
        );
      }
    } on ServerException {
      rethrow;
    } on ValidationException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
    required String deviceName,
  }) async {
    try {
      final response = await client.post(
        Uri.parse('$baseUrl${ApiConstants.buildEndpoint(ApiConstants.loginEndpoint)}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'device_name': deviceName,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final data = jsonData['data'] as Map<String, dynamic>;

        // Save token
        await tokenService.saveTokens(
          accessToken: data['token'] as String,
          refreshToken: data['refresh_token'] as String?,
        );

        return AuthResponseModel.fromJson(data);
      } else if (response.statusCode == 401) {
        throw const UnauthorizedException(message: 'Invalid email or password');
      } else {
        throw ServerException(
          message: 'Login failed',
          statusCode: response.statusCode,
        );
      }
    } on UnauthorizedException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  @override
  Future<AuthUserModel> getCurrentUser() async {
    try {
      final token = await tokenService.getAuthHeader();
      final response = await client.get(
        Uri.parse('$baseUrl${ApiConstants.buildEndpoint(ApiConstants.getUserEndpoint)}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final user = jsonData['data'] as Map<String, dynamic>;
        return AuthUserModel.fromJson(user);
      } else if (response.statusCode == 401) {
        throw const UnauthorizedException();
      } else {
        throw ServerException(
          message: 'Failed to get user',
          statusCode: response.statusCode,
        );
      }
    } on UnauthorizedException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  @override
  Future<void> logout() async {
    try {
      final token = await tokenService.getAuthHeader();
      final response = await client.post(
        Uri.parse('$baseUrl${ApiConstants.buildEndpoint(ApiConstants.logoutEndpoint)}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Logout failed',
          statusCode: response.statusCode,
        );
      }

      // Clear tokens
      await tokenService.clearTokens();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  @override
  Future<void> logoutAll() async {
    try {
      final token = await tokenService.getAuthHeader();
      final response = await client.post(
        Uri.parse('$baseUrl${ApiConstants.buildEndpoint(ApiConstants.logoutAllEndpoint)}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Logout all failed',
          statusCode: response.statusCode,
        );
      }

      await tokenService.clearTokens();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  @override
  Future<String> refreshToken() async {
    try {
      final refreshToken = await tokenService.getRefreshToken();
      if (refreshToken == null) {
        throw const TokenException();
      }

      final response = await client.post(
        Uri.parse('$baseUrl${ApiConstants.buildEndpoint(ApiConstants.refreshTokenEndpoint)}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $refreshToken',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final token = jsonData['data']['token'] as String;
        await tokenService.saveAccessToken(token);
        return token;
      } else {
        throw const TokenException();
      }
    } on TokenException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final token = await tokenService.getAuthHeader();
      final response = await client.post(
        Uri.parse('$baseUrl${ApiConstants.buildEndpoint(ApiConstants.changePasswordEndpoint)}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: jsonEncode({
          'current_password': currentPassword,
          'password': newPassword,
          'password_confirmation': newPasswordConfirmation,
        }),
      );

      if (response.statusCode == 422) {
        final error = jsonDecode(response.body);
        throw ValidationException(
          message: error['message'] ?? 'Validation failed',
          errors: error['errors'],
        );
      } else if (response.statusCode != 200) {
        throw ServerException(
          message: 'Password change failed',
          statusCode: response.statusCode,
        );
      }
    } on ValidationException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  @override
  Future<List<SessionModel>> getActiveSessions() async {
    try {
      final token = await tokenService.getAuthHeader();
      final response = await client.get(
        Uri.parse('$baseUrl${ApiConstants.buildEndpoint(ApiConstants.activeSessionsEndpoint)}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as Map<String, dynamic>;
        final sessions = jsonData['data'] as List;
        return sessions
            .map((session) => SessionModel.fromJson(session as Map<String, dynamic>))
            .toList();
      } else if (response.statusCode == 401) {
        throw const UnauthorizedException();
      } else {
        throw ServerException(
          message: 'Failed to get sessions',
          statusCode: response.statusCode,
        );
      }
    } on UnauthorizedException {
      rethrow;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final token = await tokenService.getAuthHeader();
      final response = await client.delete(
        Uri.parse('$baseUrl${ApiConstants.buildEndpoint(ApiConstants.deleteAccountEndpoint)}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      );

      if (response.statusCode != 200) {
        throw ServerException(
          message: 'Account deletion failed',
          statusCode: response.statusCode,
        );
      }

      await tokenService.clearTokens();
    } on ServerException {
      rethrow;
    } catch (e) {
      throw NetworkException(message: e.toString());
    }
  }
}
