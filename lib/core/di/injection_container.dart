// File: lib/core/di/injection_container.dart
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';
import '../services/storage_service.dart';
import '../services/connectivity_service.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource_impl.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_local_datasource_impl.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
// Course Browsing Imports
import '../../features/course_browsing/data/datasources/course_remote_datasource.dart';
import '../../features/course_browsing/data/datasources/course_remote_datasource_impl.dart';
import '../../features/course_browsing/data/repositories/course_repository_impl.dart';
import '../../features/course_browsing/domain/repositories/course_repository.dart';
import '../../features/course_browsing/domain/usecases/get_courses_usecase.dart';
import '../../features/course_browsing/domain/usecases/get_featured_courses_usecase.dart';
import '../../features/course_browsing/domain/usecases/get_course_details_usecase.dart';
import '../../features/course_browsing/domain/usecases/search_courses_usecase.dart';
import '../../features/course_browsing/domain/usecases/get_categories_usecase.dart';
import '../../features/course_browsing/domain/usecases/get_preview_lessons_usecase.dart';
import '../../features/course_browsing/presentation/bloc/course_bloc.dart';
// Enrollment Imports
import '../../features/enrollment/data/datasources/enrollment_remote_datasource.dart';
import '../../features/enrollment/data/datasources/enrollment_remote_datasource_impl.dart';
import '../../features/enrollment/data/repositories/enrollment_repository_impl.dart';
import '../../features/enrollment/domain/repositories/enrollment_repository.dart';
import '../../features/enrollment/domain/usecases/get_my_courses_usecase.dart';
import '../../features/enrollment/domain/usecases/get_enrolled_course_details_usecase.dart';
import '../../features/enrollment/domain/usecases/get_course_lessons_usecase.dart';
import '../../features/enrollment/domain/usecases/get_course_progress_usecase.dart';
import '../../features/enrollment/domain/usecases/mark_lesson_complete_usecase.dart';
import '../../features/enrollment/presentation/bloc/enrollment_bloc.dart';

/// Global service locator instance
final sl = GetIt.instance;

/// Initialize dependency injection
Future<void> init() async {
  // Initialize core services first
  await _initCore();
  // Initialize features
  await _initAuth();
  await _initCourseBrowsing();
  await _initEnrollment();
}

/// Initialize core services
Future<void> _initCore() async {
  // ==================== Services ====================

  // HTTP Client
  sl.registerLazySingleton<http.Client>(
    () => http.Client(),
  );

  // Storage Service - must be initialized first
  sl.registerLazySingleton<StorageService>(
    () => StorageService(),
  );
  // Initialize storage (may fail in test environment)
  try {
    await sl<StorageService>().init();
  } catch (e) {
    // Ignore initialization failures in test environment
    // Storage will still work for basic operations
  }

  // Connectivity Service
  sl.registerLazySingleton<ConnectivityService>(
    () => ConnectivityService(),
  );
  // Initialize connectivity (may fail in test environment)
  try {
    await sl<ConnectivityService>().init();
  } catch (e) {
    // Ignore initialization failures in test environment
  }

  // Token Service
  sl.registerLazySingleton<TokenService>(
    () => TokenService(),
  );

  // API Service
  sl.registerLazySingleton<ApiService>(
    () => ApiService(
      baseUrl: 'https://ict.mizansir.com/api',
      client: sl(), // Uses registered http.Client
    ),
  );

  // ==================== Features ====================
  // Features will be registered in their respective phases
  // Note: Feature registrations are called from the main init() function
}

/// Reset all registrations (useful for testing)
Future<void> reset() async {
  await sl.reset();
}

/// Dispose resources
Future<void> dispose() async {
  // Dispose connectivity service
  if (sl.isRegistered<ConnectivityService>()) {
    sl<ConnectivityService>().dispose();
  }

  // Reset service locator
  await sl.reset();
}

// ========== Feature Registration Methods ==========

/// Initialize authentication feature (Phase 2)
Future<void> _initAuth() async {
  // BLoC - Factory (new instance each time)
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      getCurrentUserUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );

  // Use Cases - LazySingleton (single instance)
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      client: sl(),
      tokenService: sl(),
      baseUrl: 'https://ict.mizansir.com/api',
    ),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      storageService: sl(),
    ),
  );
}

/// Initialize course browsing feature (Phase 3)
Future<void> _initCourseBrowsing() async {
  // ==================== Data Sources ====================

  // Course Remote Data Source
  sl.registerLazySingleton<CourseRemoteDataSource>(
    () => CourseRemoteDataSourceImpl(
      client: sl(),
      baseUrl: 'https://ict.mizansir.com/api',
    ),
  );

  // ==================== Repositories ====================

  // Course Repository
  sl.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // ==================== Use Cases ====================

  // Get Courses Use Case
  sl.registerLazySingleton<GetCoursesUseCase>(
    () => GetCoursesUseCase(sl()),
  );

  // Get Featured Courses Use Case
  sl.registerLazySingleton<GetFeaturedCoursesUseCase>(
    () => GetFeaturedCoursesUseCase(sl()),
  );

  // Get Course Details Use Case
  sl.registerLazySingleton<GetCourseDetailsUseCase>(
    () => GetCourseDetailsUseCase(sl()),
  );

  // Search Courses Use Case
  sl.registerLazySingleton<SearchCoursesUseCase>(
    () => SearchCoursesUseCase(sl()),
  );

  // Get Categories Use Case
  sl.registerLazySingleton<GetCategoriesUseCase>(
    () => GetCategoriesUseCase(sl()),
  );

  // Get Preview Lessons Use Case
  sl.registerLazySingleton<GetPreviewLessonsUseCase>(
    () => GetPreviewLessonsUseCase(sl()),
  );

  // ==================== BLoC ====================

  // Course BLoC - registered as factory since it should be fresh for each scope
  sl.registerFactory<CourseBloc>(
    () => CourseBloc(
      getCoursesUseCase: sl(),
      getFeaturedCoursesUseCase: sl(),
      getCourseDetailsUseCase: sl(),
      searchCoursesUseCase: sl(),
      getCategoriesUseCase: sl(),
      getPreviewLessonsUseCase: sl(),
    ),
  );
}

/// Initialize lesson feature (Phase 4)
Future<void> _initLesson() async {
  // TODO: Implement in Phase 4
}

/// Initialize enrollment feature (Phase 5)
Future<void> _initEnrollment() async {
  // ==================== Data Sources ====================

  // Enrollment Remote Data Source
  sl.registerLazySingleton<EnrollmentRemoteDataSource>(
    () => EnrollmentRemoteDataSourceImpl(
      client: sl(),
      tokenService: sl(),
      baseUrl: 'https://ict.mizansir.com/api',
    ),
  );

  // ==================== Repositories ====================

  // Enrollment Repository
  sl.registerLazySingleton<EnrollmentRepository>(
    () => EnrollmentRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // ==================== Use Cases ====================

  // Get My Courses Use Case
  sl.registerLazySingleton<GetMyCoursesUseCase>(
    () => GetMyCoursesUseCase(sl()),
  );

  // Get Enrolled Course Details Use Case
  sl.registerLazySingleton<GetEnrolledCourseDetailsUseCase>(
    () => GetEnrolledCourseDetailsUseCase(sl()),
  );

  // Get Course Lessons Use Case
  sl.registerLazySingleton<GetCourseLessonsUseCase>(
    () => GetCourseLessonsUseCase(sl()),
  );

  // Get Course Progress Use Case
  sl.registerLazySingleton<GetCourseProgressUseCase>(
    () => GetCourseProgressUseCase(sl()),
  );

  // Mark Lesson Complete Use Case
  sl.registerLazySingleton<MarkLessonCompleteUseCase>(
    () => MarkLessonCompleteUseCase(sl()),
  );

  // ==================== BLoC ====================

  // Enrollment BLoC - registered as factory since it should be fresh for each scope
  sl.registerFactory<EnrollmentBloc>(
    () => EnrollmentBloc(
      getMyCoursesUseCase: sl(),
      getEnrolledCourseDetailsUseCase: sl(),
      getCourseLessonsUseCase: sl(),
      getCourseProgressUseCase: sl(),
      markLessonCompleteUseCase: sl(),
    ),
  );
}

/// Initialize profile feature (Phase 6)
Future<void> _initProfile() async {
  // TODO: Implement in Phase 6
}

/// Initialize dashboard feature (Phase 6)
Future<void> _initDashboard() async {
  // TODO: Implement in Phase 6
}
