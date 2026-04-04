// File: lib/features/auth/data/datasources/auth_local_datasource_impl.dart
import 'dart:convert';
import '../../../../core/services/storage_service.dart';
import '../../../../core/constants/storage_constants.dart';
import '../../../../core/errors/exceptions.dart';
import 'auth_local_datasource.dart';

/// Authentication local data source implementation
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final StorageService storageService;

  AuthLocalDataSourceImpl({required this.storageService});

  @override
  Future<void> cacheUser(Map<String, dynamic> userJson) async {
    try {
      await storageService.setString(
        StorageConstants.userDataKey,
        jsonEncode(userJson),
      );
    } catch (e) {
      throw const CacheException(message: 'Failed to cache user');
    }
  }

  @override
  Future<Map<String, dynamic>?> getCachedUser() async {
    try {
      final userString = storageService.getString(StorageConstants.userDataKey);
      if (userString == null || userString.isEmpty) {
        return null;
      }
      return jsonDecode(userString) as Map<String, dynamic>;
    } catch (e) {
      throw const CacheException(message: 'Failed to get cached user');
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      await storageService.remove(StorageConstants.userDataKey);
    } catch (e) {
      throw const CacheException(message: 'Failed to clear cached user');
    }
  }

  @override
  Future<void> saveAuthState(bool isAuthenticated) async {
    try {
      await storageService.setBool(
        StorageConstants.isLoggedInKey,
        isAuthenticated,
      );
    } catch (e) {
      throw const CacheException(message: 'Failed to save auth state');
    }
  }

  @override
  Future<bool> getAuthState() async {
    try {
      return storageService.getBool(StorageConstants.isLoggedInKey) ?? false;
    } catch (e) {
      throw const CacheException(message: 'Failed to get auth state');
    }
  }

  @override
  Future<void> clearAuthState() async {
    try {
      await storageService.remove(StorageConstants.isLoggedInKey);
    } catch (e) {
      throw const CacheException(message: 'Failed to clear auth state');
    }
  }
}
