import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service_method.dart';
import '../../../../core/services/token_service.dart';
import '../../../../core/utils/common_json.dart';
import '../../../../core/errors/exceptions.dart';
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
        throw const ServerException(message: 'No data received');
      }

      final dataMap = CommonToJson.getMap(mapResponse);
      if (dataMap == null) {
        throw const ServerException(message: 'Invalid data format');
      }

      return AuthUserModel.fromJson(dataMap);
    } on RateLimitException {
      rethrow;
    } on ValidationException {
      rethrow;
    } on AppException {
      rethrow;
    } catch (e) {
      debugPrint('Error in register: $e');
      throw NetworkException(message: e.toString());
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
        throw const ServerException(message: 'No data received');
      }

      final dataMap = CommonToJson.getMap(mapResponse);
      if (dataMap == null) {
        throw const ServerException(message: 'Invalid data format');
      }

      // Save token
      if (dataMap['token'] is String) {
        await tokenService.saveTokens(
          accessToken: dataMap['token'] as String,
          refreshToken: dataMap['refresh_token'] as String?,
        );
        debugPrint('✅ Login successful! Token saved.');
      }

      return AuthResponseModel.fromJson(dataMap);
    } on RateLimitException {
      rethrow;
    } on ValidationException {
      rethrow;
    } on AppException {
      rethrow;
    } catch (e) {
      debugPrint('Error in login: $e');
      throw NetworkException(message: e.toString());
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
        throw const ServerException(message: 'No data received');
      }

      final dataMap = CommonToJson.getMap(mapResponse);
      if (dataMap == null) {
        throw const ServerException(message: 'Invalid data format');
      }

      debugPrint('✅ User data loaded successfully');
      return AuthUserModel.fromJson(dataMap);
    } on AppException {
      rethrow;
    } catch (e) {
      debugPrint('Error in getCurrentUser: $e');
      throw NetworkException(message: e.toString());
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
        throw const ServerException(message: 'No data received');
      }

      // Clear tokens
      await tokenService.clearTokens();
      debugPrint('✅ Logout successful');
    } on AppException {
      rethrow;
    } catch (e) {
      debugPrint('Error in logout: $e');
      throw NetworkException(message: e.toString());
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
        throw const ServerException(message: 'No data received');
      }

      await tokenService.clearTokens();
      debugPrint('✅ Logout all successful');
    } on AppException {
      rethrow;
    } catch (e) {
      debugPrint('Error in logoutAll: $e');
      throw NetworkException(message: e.toString());
    }
  }

  @override
  Future<String> refreshToken() async {
    Map<String, dynamic>? mapResponse;

    try {
      final refreshToken = await tokenService.getRefreshToken();
      if (refreshToken == null) {
        throw const TokenException(message: 'No refresh token available');
      }

      mapResponse = await ApiMethod(isBasic: true).post(
        '${ApiConstants.baseUrl}${ApiConstants.buildEndpoint(ApiConstants.refreshTokenEndpoint)}',
        {},
        showResult: true,
      );

      if (mapResponse == null) {
        throw const ServerException(message: 'No data received');
      }

      final dataMap = CommonToJson.getMap(mapResponse);
      if (dataMap == null) {
        throw const ServerException(message: 'Invalid data format');
      }

      // Extract new token
      final newToken = dataMap['token'] as String?;
      if (newToken == null) {
        throw const TokenException(message: 'No token in response');
      }

      await tokenService.saveAccessToken(newToken);

      // Extract and cache user data
      if (dataMap['user'] is Map) {
        final userMap = dataMap['user'] as Map<String, dynamic>;
        final userModel = AuthUserModel.fromJson(userMap);

        // Cache the updated user data locally
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cached_user', jsonEncode(userModel.toJson()));

        debugPrint('✅ Token refreshed and user data cached');
        debugPrint('📊 User: ${userModel.name} (is_student: ${userModel.isStudent})');
      }

      return newToken;
    } on TokenException {
      rethrow;
    } on AppException {
      rethrow;
    } catch (e) {
      debugPrint('Error in refreshToken: $e');
      throw NetworkException(message: e.toString());
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
        throw const ServerException(message: 'No data received');
      }

      debugPrint('✅ Password changed successfully');
    } on ValidationException {
      rethrow;
    } on AppException {
      rethrow;
    } catch (e) {
      debugPrint('Error in changePassword: $e');
      throw NetworkException(message: e.toString());
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
        throw const ServerException(message: 'No data received');
      }

      final dataList = CommonToJson.getList(mapResponse);
      if (dataList == null) {
        throw const ServerException(message: 'Invalid data format');
      }

      return dataList
          .map((session) => SessionModel.fromJson(session as Map<String, dynamic>))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      debugPrint('Error in getActiveSessions: $e');
      throw NetworkException(message: e.toString());
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
        throw const ServerException(message: 'No data received');
      }

      await tokenService.clearTokens();
      debugPrint('✅ Account deleted successfully');
    } on AppException {
      rethrow;
    } catch (e) {
      debugPrint('Error in deleteAccount: $e');
      throw NetworkException(message: e.toString());
    }
  }
}
