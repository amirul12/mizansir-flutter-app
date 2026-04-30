// File: lib/core/di/injection_container.dart
import 'package:get_it/get_it.dart';
import '../services/token_service.dart';
import '../services/connectivity_service.dart';
import '../services/hive_service.dart';
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

import '../../features/enrollment/domain/usecases/get_course_lessons_usecase.dart';
import '../../features/enrollment/domain/usecases/get_course_progress_usecase.dart';
import '../../features/enrollment/domain/usecases/mark_lesson_complete_usecase.dart';
import '../../features/enrollment/domain/usecases/get_lesson_details_usecase.dart';
import '../../features/enrollment/domain/usecases/create_enrollment_usecase.dart';
import '../../features/enrollment/presentation/bloc/enrollment_bloc.dart';
// Profile & Dashboard Imports
import '../../features/profile/data/datasources/profile_remote_datasource.dart';
import '../../features/profile/data/datasources/profile_remote_datasource_impl.dart';
import '../../features/profile/data/datasources/dashboard_remote_datasource.dart';
import '../../features/profile/data/datasources/dashboard_remote_datasource_impl.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/data/repositories/dashboard_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/domain/repositories/dashboard_repository.dart';
import '../../features/profile/domain/usecases/get_profile_usecase.dart';
import '../../features/profile/domain/usecases/update_profile_usecase.dart';
import '../../features/profile/domain/usecases/upload_avatar_usecase.dart';
import '../../features/profile/domain/usecases/change_password_usecase.dart';
import '../../features/profile/domain/usecases/delete_account_usecase.dart';
import '../../features/profile/domain/usecases/get_dashboard_usecase.dart';
import '../../features/profile/domain/usecases/get_activity_usecase.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/bloc/dashboard_bloc.dart';
// Home Shell Imports
import '../../features/home/presentation/bloc/home_shell_cubit.dart';

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
  await _initProfile();
  await _initHome();
}

/// Initialize core services
Future<void> _initCore() async {
  // ==================== Services ====================

  // Hive Service
  final hiveService = HiveServiceImpl();
  sl.registerLazySingleton<HiveService>(() => hiveService);
  await hiveService.init();

  // Connectivity Service
  sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
  // Initialize connectivity (may fail in test environment)
  try {
    await sl<ConnectivityService>().init();
  } catch (e) {
    // Ignore initialization failures in test environment
  }

  // Token Service - Singleton (factory pattern)
  sl.registerLazySingleton<TokenService>(() => TokenService());

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
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(tokenService: sl()),
  );

  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );
}

/// Initialize course browsing feature (Phase 3)
Future<void> _initCourseBrowsing() async {
  // ==================== Data Sources ====================

  // Course Remote Data Source
  sl.registerLazySingleton<CourseRemoteDataSource>(
    () => CourseRemoteDataSourceImpl(),
  );

  // ==================== Repositories ====================

  // Course Repository
  sl.registerLazySingleton<CourseRepository>(
    () => CourseRepositoryImpl(remoteDataSource: sl()),
  );

  // ==================== Use Cases ====================

  // Get Courses Use Case
  sl.registerLazySingleton<GetCoursesUseCase>(() => GetCoursesUseCase(sl()));

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
    () => EnrollmentRemoteDataSourceImpl(),
  );

  // ==================== Repositories ====================

  // Enrollment Repository
  sl.registerLazySingleton<EnrollmentRepository>(
    () => EnrollmentRepositoryImpl(
      remoteDataSource: sl(),
      connectivityService: sl(),
      hiveService: sl(),
    ),
  );

  // ==================== Use Cases ====================

  // Get My Courses Use Case
  sl.registerLazySingleton<GetMyCoursesUseCase>(
    () => GetMyCoursesUseCase(sl()),
  );

  // // Get Enrolled Course Details Use Case
  // sl.registerLazySingleton<GetEnrolledCourseDetailsUseCase>(
  //   () => GetEnrolledCourseDetailsUseCase(sl()),
  // );

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

  // Get Lesson Details Use Case
  sl.registerLazySingleton<GetLessonDetailsUseCase>(
    () => GetLessonDetailsUseCase(sl()),
  );

  // Create Enrollment Use Case
  sl.registerLazySingleton<CreateEnrollmentUseCase>(
    () => CreateEnrollmentUseCase(sl()),
  );

  // ==================== BLoC ====================

  // Enrollment BLoC - registered as factory since it should be fresh for each scope
  sl.registerFactory<EnrollmentBloc>(
    () => EnrollmentBloc(
      getMyCoursesUseCase: sl(),

      getCourseLessonsUseCase: sl(),
      getCourseProgressUseCase: sl(),
      markLessonCompleteUseCase: sl(),
      getLessonDetailsUseCase: sl(),
      createEnrollmentUseCase: sl(),
    ),
  );
}

/// Initialize profile feature (Phase 6)
Future<void> _initProfile() async {
  // ==================== Data Sources ====================

  // Profile Remote Data Source
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(),
  );

  // Dashboard Remote Data Source
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(),
  );

  // ==================== Repositories ====================

  // Profile Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: sl(),
      authRepository: sl(),
      connectivityService: sl(),
    ),
  );

  // Dashboard Repository
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      remoteDataSource: sl(),
      connectivityService: sl(),
      hiveService: sl(),
    ),
  );

  // ==================== Use Cases ====================

  // Profile Use Cases
  sl.registerLazySingleton<GetProfileUseCase>(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton<UpdateProfileUseCase>(
    () => UpdateProfileUseCase(sl()),
  );
  sl.registerLazySingleton<UploadAvatarUseCase>(
    () => UploadAvatarUseCase(sl()),
  );
  sl.registerLazySingleton<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(sl()),
  );
  sl.registerLazySingleton<DeleteAccountUseCase>(
    () => DeleteAccountUseCase(sl()),
  );

  // Dashboard Use Cases
  sl.registerLazySingleton<GetDashboardUseCase>(
    () => GetDashboardUseCase(sl()),
  );
  sl.registerLazySingleton<GetActivityUseCase>(() => GetActivityUseCase(sl()));

  // ==================== BLoC ====================

  // Profile BLoC
  sl.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      getProfileUseCase: sl(),
      updateProfileUseCase: sl(),
      uploadAvatarUseCase: sl(),
      changePasswordUseCase: sl(),
      deleteAccountUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );

  // Dashboard BLoC
  sl.registerFactory<DashboardBloc>(
    () => DashboardBloc(getDashboardUseCase: sl(), getActivityUseCase: sl()),
  );
}

/// Initialize home shell feature (Phase 6.5 - App Shell)
Future<void> _initHome() async {
  // ==================== Cubit ====================

  // Home Shell Cubit - Factory (new instance each time)
  sl.registerFactory<HomeShellCubit>(() => HomeShellCubit());
}
