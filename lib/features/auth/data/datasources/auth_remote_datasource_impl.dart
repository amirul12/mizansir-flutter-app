import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service_method.dart';
import '../../../../core/services/token_service.dart';
import '../models/auth_response_model.dart';
import '../models/auth_user_model.dart';
import '../models/session_model.dart';
import 'auth_remote_datasource.dart';

/// Authentication remote data source implementation using ApiMethod
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final TokenService tokenService;

  AuthRemoteDataSourceImpl({required this.tokenService});

  @override
  Future<AuthUserModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
  }) async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: true).post(
        '${ApiConstants.baseUrl}${ApiConstants.buildEndpoint(ApiConstants.registerEndpoint)}',
        {
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'phone': phone,
        },
        showResult: true,
      );

      if (mapResponse == null) {
        throw Exception('No data received');
      }

      // Check if response is wrapped in success/data or direct
      final data = mapResponse.containsKey('data') ? mapResponse['data'] : mapResponse;

      return AuthUserModel.fromJson(data);
    } catch (e) {
      debugPrint('Error in register: $e');
      rethrow;
    }
  }

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
    required String deviceName,
  }) async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: true).post(
        '${ApiConstants.baseUrl}${ApiConstants.buildEndpoint(ApiConstants.loginEndpoint)}',
        {
          'email': email,
          'password': password,
          'device_name': deviceName,
        },
        showResult: true,
      );

      if (mapResponse == null) {
        throw Exception('No data received');
      }

      // Check if response is wrapped in success/data or direct
      final data = mapResponse.containsKey('data') ? mapResponse['data'] : mapResponse;

      // Save token
      if (data['token'] is String) {
        await tokenService.saveTokens(
          accessToken: data['token'] as String,
          refreshToken: data['refresh_token'] as String?,
        );
        debugPrint('✅ Login successful! Token saved.');
      }

      return AuthResponseModel.fromJson(data);
    } catch (e) {
      debugPrint('Error in login: $e');
      rethrow;
    }
  }

  @override
  Future<AuthUserModel> getCurrentUser() async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        '${ApiConstants.baseUrl}${ApiConstants.buildEndpoint(ApiConstants.getUserEndpoint)}',
        showResult: true,
      );

      if (mapResponse == null) {
        throw Exception('No data received');
      }

      final data = mapResponse.containsKey('data') ? mapResponse['data'] : mapResponse;

      debugPrint('✅ User data loaded successfully');
      return AuthUserModel.fromJson(data);
    } catch (e) {
      debugPrint('Error in getCurrentUser: $e');
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        '${ApiConstants.baseUrl}${ApiConstants.buildEndpoint(ApiConstants.logoutEndpoint)}',
        {},
        showResult: true,
      );

      if (mapResponse == null) {
        throw Exception('No data received');
      }

      // Clear tokens
      await tokenService.clearTokens();
      debugPrint('✅ Logout successful');
    } catch (e) {
      debugPrint('Error in logout: $e');
      rethrow;
    }
  }

  @override
  Future<void> logoutAll() async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        '${ApiConstants.baseUrl}${ApiConstants.buildEndpoint(ApiConstants.logoutAllEndpoint)}',
        {},
        showResult: true,
      );

      if (mapResponse == null) {
        throw Exception('No data received');
      }

      await tokenService.clearTokens();
      debugPrint('✅ Logout all successful');
    } catch (e) {
      debugPrint('Error in logoutAll: $e');
      rethrow;
    }
  }

  @override
  Future<String> refreshToken() async {
    Map<String, dynamic>? mapResponse;

    try {
      final refreshToken = await tokenService.getRefreshToken();
      if (refreshToken == null) {
        throw Exception('No refresh token available');
      }

      mapResponse = await ApiMethod(isBasic: true).post(
        '${ApiConstants.baseUrl}${ApiConstants.buildEndpoint(ApiConstants.refreshTokenEndpoint)}',
        {},
        showResult: true,
      );

      if (mapResponse == null) {
        throw Exception('No data received');
      }

      final data = mapResponse.containsKey('data') ? mapResponse['data'] : mapResponse;

      // Extract new token
      final newToken = data['token'] as String?;
      if (newToken == null) {
        throw Exception('No token in response');
      }

      await tokenService.saveAccessToken(newToken);

      // Extract and cache user data
      if (data['user'] is Map) {
        final userMap = data['user'] as Map<String, dynamic>;
        final userModel = AuthUserModel.fromJson(userMap);

        // Cache the updated user data locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cached_user', jsonEncode(userModel.toJson()));

        debugPrint('✅ Token refreshed and user data cached');
      }

      return newToken;
    } catch (e) {
      debugPrint('Error in refreshToken: $e');
      rethrow;
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        '${ApiConstants.baseUrl}${ApiConstants.buildEndpoint(ApiConstants.changePasswordEndpoint)}',
        {
          'current_password': currentPassword,
          'password': newPassword,
          'password_confirmation': newPasswordConfirmation,
        },
        showResult: true,
      );

      if (mapResponse == null) {
        throw Exception('No data received');
      }

      debugPrint('✅ Password changed successfully');
    } catch (e) {
      debugPrint('Error in changePassword: $e');
      rethrow;
    }
  }

  @override
  Future<List<SessionModel>> getActiveSessions() async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        '${ApiConstants.baseUrl}${ApiConstants.buildEndpoint(ApiConstants.activeSessionsEndpoint)}',
        showResult: true,
      );

      if (mapResponse == null) {
        throw Exception('No data received');
      }

      final data = mapResponse.containsKey('data') ? mapResponse['data'] : mapResponse;

      if (data is! List) {
        throw Exception('Invalid data format: Expected a list');
      }

      return data
          .map((session) => SessionModel.fromJson(session as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error in getActiveSessions: $e');
      rethrow;
    }
  }

  @override
  Future<void> deleteAccount() async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: false).delete(
        '${ApiConstants.baseUrl}${ApiConstants.buildEndpoint(ApiConstants.deleteAccountEndpoint)}',
        showResult: true,
      );

      if (mapResponse == null) {
        throw Exception('No data received');
      }

      await tokenService.clearTokens();
      debugPrint('✅ Account deleted successfully');
    } catch (e) {
      debugPrint('Error in deleteAccount: $e');
      rethrow;
    }
  }
}
