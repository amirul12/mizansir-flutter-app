import 'package:flutter/foundation.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/api_service_method.dart';
import '../../../../core/utils/common_json.dart';
import '../models/user_profile_model.dart';
import 'profile_remote_datasource.dart';

/// Profile remote data source implementation using ApiMethod
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl();

  @override
  Future<UserProfileModel> getProfile() async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        '${ApiConstants.baseUrl}${ApiConstants.profileEndpoint}',
        showResult: true,
      );

      if (mapResponse == null) {
        throw Exception('No data received');
      }

      final dataMap = CommonToJson().getString(mapResponse);
      if (dataMap == null) {
        throw Exception('Invalid data format');
      }

      return UserProfileModel.fromApiResponse(dataMap);
    } catch (e) {
      debugPrint('Error in getProfile: $e');
      rethrow;
    }
  }

  @override
  Future<UserProfileModel> updateProfile(Map<String, dynamic> data) async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: false).put(
        '${ApiConstants.baseUrl}${ApiConstants.profileEndpoint}',
        data,
        showResult: true,
      );

      if (mapResponse == null) {
        throw Exception('No data received');
      }

      final dataMap = CommonToJson().getString(mapResponse);
      if (dataMap == null) {
        throw Exception('Invalid data format');
      }

      return UserProfileModel.fromApiResponse(dataMap);
    } catch (e) {
      debugPrint('Error in updateProfile: $e');
      rethrow;
    }
  }

  @override
  Future<UserProfileModel> uploadAvatar(String imagePath) async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: false).multipart(
        '${ApiConstants.baseUrl}${ApiConstants.uploadAvatarEndpoint}',
        {},
        imagePath,
        'avatar',
        showResult: true,
      );

      if (mapResponse == null) {
        throw Exception('No data received');
      }

      final dataMap = CommonToJson().getString(mapResponse);
      if (dataMap == null) {
        throw Exception('Invalid data format');
      }

      return UserProfileModel.fromApiResponse(dataMap);
    } catch (e) {
      debugPrint('Error in uploadAvatar: $e');
      rethrow;
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        '${ApiConstants.baseUrl}${ApiConstants.changePasswordUserEndpoint}',
        {
          'current_password': currentPassword,
          'new_password': newPassword,
          'new_password_confirmation': newPassword,
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
  Future<void> deleteAccount(String password) async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: false).delete(
        '${ApiConstants.baseUrl}${ApiConstants.deleteAccountEndpoint}',
        showResult: true,
      );

      if (mapResponse == null) {
        throw Exception('No data received');
      }

      debugPrint('✅ Account deleted successfully');
    } catch (e) {
      debugPrint('Error in deleteAccount: $e');
      rethrow;
    }
  }
}
