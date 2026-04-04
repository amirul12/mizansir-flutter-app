// File: lib/core/constants/storage_constants.dart
/// Storage key constants for local data persistence
class StorageConstants {
  // Authentication Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String tokenExpiryKey = 'token_expiry';

  // User Data Keys
  static const String userIdKey = 'user_id';
  static const String userDataKey = 'user_data';
  static const String isLoggedInKey = 'is_logged_in';

  // Settings Keys
  static const String themeKey = 'theme_mode';
  static const String languageKey = 'language';
  static const String notificationsEnabledKey = 'notifications_enabled';

  // Onboarding Keys
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String appVersionKey = 'app_version';

  // Cache Keys
  static const String coursesCacheKey = 'courses_cache';
  static const String categoriesCacheKey = 'categories_cache';
  static const String featuredCoursesCacheKey = 'featured_courses_cache';

  // Session Keys
  static const String lastActiveTimeKey = 'last_active_time';
  static const String deviceIdKey = 'device_id';

  // Pagination Keys
  static const String currentPageKey = 'current_page';
  static const String lastPageKey = 'last_page';
}
