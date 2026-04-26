import 'package:flutter/material.dart';

 

abstract class AppStore {
  Future<void> clearToken();
  Future<void> storeBearerToken(String token);

  Future<String?> retrieveBearerToken();

  Future<void> setLoginStatus(bool status);

  Future<bool> getLoginStatus();

  Future<void> storeFcmToken(String token);

  Future<String?> retrieveFcmToken();

  Future<void> storeUser(String user);

  Future<String?> retrieveUser();

  Future<void> storeUserType(String userType);

  Future<String?> retrieveUserType();

  Future<void> storeUserEmail(String email);

  Future<String?> retrieveUserEmail();

  Future<void> changeLanguage(String languageType);

  Future<String?> retrieveLanguage();

  Future<void> changeTheme(ThemeMode themeMode);

  Future<String?> retrieveTheme();

  Future<Map<String, dynamic>?> retrieveCredentials();

  Future<void> clearCredentials();

  Future<bool> addFavoriteProductId(String productId);

  Future<bool> setSettingNotificationEnable(bool value);

  Future<bool> getSettingNotificationValue();

  Future<List<String>> getFavoriteProductIds();

  Future<void> addSearchTerm(String searchTerm);

  Future<List<String>> getSearchHistory();

 

  Future<bool> has24HoursPassed();
}
