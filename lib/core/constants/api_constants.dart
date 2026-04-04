// File: lib/core/constants/api_constants.dart
/// API-related constants for the PrivateTutor application
class ApiConstants {
  // Base URL
  static const String baseUrl = 'https://ict.mizansir.com/api';

  // API Version
  static const String apiVersion = '/v1';

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Endpoints - Authentication
  static const String authPath = '/auth';
  static const String registerEndpoint = '$authPath/register';
  static const String loginEndpoint = '$authPath/login';
  static const String getUserEndpoint = '$authPath/user';
  static const String logoutEndpoint = '$authPath/logout';
  static const String logoutAllEndpoint = '$authPath/logout-all';
  static const String refreshTokenEndpoint = '$authPath/refresh-token';
  static const String changePasswordEndpoint = '$authPath/change-password';
  static const String activeSessionsEndpoint = '$authPath/active-sessions';

  // Endpoints - Courses
  static const String coursesPath = '/courses';
  static const String featuredCoursesEndpoint = '$coursesPath/featured';
  static const String categoriesEndpoint = '$coursesPath/categories';
  static const String searchCoursesEndpoint = '$coursesPath/search';

  // Endpoints - Lessons
  static const String lessonsPath = '/lessons';
  static const String completeLessonEndpoint = '/complete';
  static const String incompleteLessonEndpoint = '/incomplete';
  static const String progressEndpoint = '/progress';

  // Endpoints - Enrollments
  static const String enrollmentsPath = '/enrollments';
  static const String enrollmentStatsEndpoint = '$enrollmentsPath/stats';

  // Endpoints - User
  static const String userPath = '/user';
  static const String profileEndpoint = '$userPath/profile';
  static const String uploadAvatarEndpoint = '$userPath/upload-avatar';
  static const String dashboardEndpoint = '$userPath/dashboard';
  static const String activityEndpoint = '$userPath/activity';
  static const String changePasswordUserEndpoint = '$userPath/change-password';
  static const String deleteAccountEndpoint = '$userPath/account';

  // Endpoints - System
  static const String healthEndpoint = '/health';
  static const String docsEndpoint = '/docs';

  // Pagination
  static const int defaultPerPage = 20;
  static const int maxPerPage = 100;

  // Helper method to build full URL
  static String buildEndpoint(String endpoint) {
    return '$apiVersion$endpoint';
  }

  // Helper method to build URL with path parameters
  static String buildWithPath(String endpoint, String pathParam) {
    return '$apiVersion$endpoint/$pathParam';
  }

  // Helper method to build URL with multiple path parameters
  static String buildWithMultiplePath(
    String endpoint,
    List<String> pathParams,
  ) {
    final path = pathParams.join('/');
    return '$apiVersion$endpoint/$path';
  }
}
