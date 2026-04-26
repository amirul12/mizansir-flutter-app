import 'package:flutter/material.dart';

import 'package:nb_utils/nb_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_store.dart';
 

class AppStoreImp implements AppStore {
  static Future<SharedPreferences> get _instance async =>
      await SharedPreferences.getInstance();

  final ValueNotifier<List<String>> searchHistoryNotifier =
      ValueNotifier<List<String>>([]);

  @override
  Future<void> changeLanguage(String languageType) async {
    (await _instance).setString(_KeyLanguage, languageType);
  }

  static const String _KeyAccessToken = 'accessToken';
  static const String _KeyLoginStatus = 'loginStatus';
  static const String _KeyThemeMode = 'themeMode';
  static const String _KeyLanguage = 'language';

  static const String _keyUserEmail = 'user_email';
  static const String _keyPassword = 'password';
  static const String _keyFcmToken = 'fcm-token';
  static const String _keyTheme = 'theme';
  static const String _keyLanguage = 'language';
  static const String _keyFavoriteProductIds = 'favorite_product_ids';
  static const String _keyNotificationEnable = 'notification_enable';
  static const String _keySearchHistory = 'searchHistory';

  @override
  Future<void> changeTheme(ThemeMode themeMode) async {
    (await _instance).setString(_KeyThemeMode, themeMode.name);
  }

  @override
  Future<void> clearCredentials() async {
    (await _instance).remove(_keyUserEmail);
    (await _instance).remove(_keyPassword);
  }

  @override
  Future<void> clearToken() async {
    (await _instance).remove(_KeyAccessToken);
    {
      (await _instance).remove(_KeyLoginStatus);

      (await _instance).remove(_keyUserEmail);

      (await _instance).remove(_keyPassword);

      (await _instance).remove(_keyFcmToken);
    }
  }

  @override
  Future<String?> retrieveBearerToken() async {
    return (await _instance).getString(_KeyAccessToken);
  }

  @override
  Future<Map<String, dynamic>?> retrieveCredentials() async {
    return {
      'email': (await _instance).getString(_keyUserEmail),
      'password': (await _instance).getString(_keyPassword),
    };
  }

  @override
  Future<String?> retrieveFcmToken() async {
    return (await _instance).getString(_keyFcmToken);
  }

  @override
  Future<String?> retrieveLanguage() async {
    return (await _instance).getString(_keyLanguage);
  }

  @override
  Future<String?> retrieveTheme() async {
    return (await _instance).getString(_keyTheme);
  }

  @override
  Future<String?> retrieveUser() async {
    return (await _instance).getString(_keyUserEmail);
  }

  @override
  Future<String?> retrieveUserEmail() async {
    return (await _instance).getString(_keyUserEmail);
  }

  @override
  Future<String?> retrieveUserType() async {
    //TODO implement retrieveUserType

    return "";
  }

  @override
  Future<void> storeFcmToken(String token) async {
    (await _instance).setString(_keyFcmToken, token);
  }

  @override
  Future<void> storeUser(String user) async {
    (await _instance).setString(_keyUserEmail, user);
  }

  @override
  Future<void> storeUserEmail(String email) async {
    (await _instance).setString(_keyUserEmail, email);
  }

  @override
  Future<void> storeUserType(String userType) async {
    //TODO implement storeUserType
  }

  @override
  Future<bool> getLoginStatus() async {
    return (await _instance).getBool(_KeyLoginStatus) ?? false;
  }

  @override
  Future<void> setLoginStatus(bool status) async {
    (await _instance).setBool(_KeyLoginStatus, status);
  }

  @override
  Future<void> storeBearerToken(String token) async {
    (await _instance).setString(_KeyAccessToken, token);
  }

  @override
  Future<bool> addFavoriteProductId(String productId) async {
    final prefs = await _instance;
    final favoriteIds = prefs.getStringList(_keyFavoriteProductIds) ?? [];

    if (!favoriteIds.contains(productId)) {
      favoriteIds.add(productId);
      await prefs.setStringList(_keyFavoriteProductIds, favoriteIds);
      return true;
    }
    return false;
  }

  @override
  Future<List<String>> getFavoriteProductIds() async {
    final prefs = await _instance;
    return prefs.getStringList(_keyFavoriteProductIds) ?? [];
  }

  @override
  Future<bool> setSettingNotificationEnable(bool value) async {
    final prefs = await _instance;
    return prefs.setBool(_keyNotificationEnable, value);
  }

  @override
  Future<bool> getSettingNotificationValue() async {
    final prefs = await _instance;

    return prefs.getBool(_keyNotificationEnable) ?? false;
  }

  @override
  Future<void> addSearchTerm(String searchTerm) async {
    final prefs = await _instance;

    List<String> searchHistory = prefs.getStringList(_keySearchHistory) ?? [];

    if (!searchHistory.contains(searchTerm)) {
      if (searchHistory.length >= 10) {
        searchHistory.removeAt(0);
      }
      searchHistory.add(searchTerm);
      searchHistoryNotifier.value = searchHistory;

      await prefs.setStringList(_keySearchHistory, searchHistory);
    }
  }

  @override
  Future<List<String>> getSearchHistory() async {
    final prefs = await _instance;
    return prefs.getStringList(_keySearchHistory) ?? [];
  }

  Future<void> loadSearchHistory() async {
    searchHistoryNotifier.value = await getSearchHistory();
  }

  Future<void> clearSearchHistory() async {
    final prefs = await _instance;
    await prefs.remove(_keySearchHistory);
    searchHistoryNotifier.value = [];
  }

  Future<void> removeSearchTerm(String query) async {
    final prefs = await _instance;

    List<String> searchHistory = prefs.getStringList(_keySearchHistory) ?? [];

    if (searchHistory.contains(query)) {
      searchHistory.remove(query);
    }

    await prefs.setStringList(_keySearchHistory, searchHistory);

    searchHistoryNotifier.value = searchHistory;
  }

 

 
  @override
  Future<bool> has24HoursPassed() async {
    final prefs = await SharedPreferences.getInstance();

    // Retrieve the stored timestamp
    int? storedTime = prefs.getInt('filter_cat_brand_response_timestamp');

    if (storedTime != null) {
      int currentTime = DateTime.now().millisecondsSinceEpoch;

      // Check if 24 hours (86400000 milliseconds) have passed
      if ((currentTime - storedTime) > 86400000) {
        // If 24 hours have passed, return true
        return true;
      } else {
        // If 24 hours have not passed, return false
        return false;
      }
    }

    // If there is no timestamp, consider it expired
    return true;
  }

  Future<void> setFilterCatBrandResponseTimestamp() async {
    final prefs = await SharedPreferences.getInstance();
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    await prefs.setInt('filter_cat_brand_response_timestamp', currentTime);
  }

  Future<void> setOneSignalPlayerId(String onesignalId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('onesignal_player_id', onesignalId);
  }

  Future<String?> getOneSignalPlayerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('onesignal_player_id');
  }
}
