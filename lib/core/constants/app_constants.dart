// File: lib/core/constants/app_constants.dart
/// Application-wide constants
class AppConstants {
  // App Information
  static const String appName = 'PrivateTutor';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Student Course Management System';

  // Pagination
  static const int defaultPageSize = 20;
  static const int searchPageSize = 20;

  // Course
  static const int defaultCourseDuration = 60; // in minutes
  static const int maxLessonDuration = 7200; // 2 hours in seconds

  // Progress
  static const double minProgressPercentage = 0.0;
  static const double maxProgressPercentage = 100.0;

  // Image
  static const double maxImageFileSizeMB = 5.0;
  static const List<String> supportedImageFormats = ['jpg', 'jpeg', 'png'];

  // Video
  static const int defaultVideoQuality = 720; // 720p

  // Session
  static const int sessionTimeoutMinutes = 30;

  // Date Formats
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String dateFormat = 'yyyy-MM-dd';
  static const String timeFormat = 'HH:mm:ss';
  static const String monthYearFormat = 'MMMM yyyy';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 100;
  static const int maxPhoneLength = 20;

  // Default Values
  static const String defaultCourseImage = 'assets/images/default_course.png';
  static const String defaultAvatar = 'assets/images/default_avatar.png';

  // Animation Duration
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);

  // Debounce Times
  static const Duration searchDebounceTime = Duration(milliseconds: 500);
  static const Duration apiDebounceTime = Duration(milliseconds: 300);

  // Cache Duration
  static const Duration courseCacheDuration = Duration(hours: 24);
  static const Duration userCacheDuration = Duration(hours: 1);
}
