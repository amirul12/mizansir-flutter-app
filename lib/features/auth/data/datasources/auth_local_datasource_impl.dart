import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/storage_constants.dart';
import 'auth_local_datasource.dart';

/// Authentication local data source implementation using SharedPreferences directly
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl();

  static Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  @override
  Future<void> cacheUser(Map<String, dynamic> userJson) async {
    (await _prefs).setString(
      StorageConstants.userDataKey,
      jsonEncode(userJson),
    );
  }

  @override
  Future<Map<String, dynamic>?> getCachedUser() async {
    final userString = (await _prefs).getString(StorageConstants.userDataKey);
    if (userString == null || userString.isEmpty) {
      return null;
    }
    return jsonDecode(userString) as Map<String, dynamic>;
  }

  @override
  Future<void> clearCachedUser() async {
    (await _prefs).remove(StorageConstants.userDataKey);
  }

  @override
  Future<void> saveAuthState(bool isAuthenticated) async {
    (await _prefs).setBool(
      StorageConstants.isLoggedInKey,
      isAuthenticated,
    );
  }

  @override
  Future<bool> getAuthState() async {
    return (await _prefs).getBool(StorageConstants.isLoggedInKey) ?? false;
  }

  @override
  Future<void> clearAuthState() async {
    (await _prefs).remove(StorageConstants.isLoggedInKey);
  }
}
