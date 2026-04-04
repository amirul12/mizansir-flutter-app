// File: lib/core/di/injection_container.dart
import 'package:get_it/get_it.dart';
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

/// Global service locator instance
final sl = GetIt.instance;

/// Initialize dependency injection
Future<void> init() async {
  // Initialize core services first
  await _initCore();
  // Initialize features
  await _initAuth();
}

/// Initialize core services
Future<void> _initCore() async {
  // ==================== Services ====================

  // Storage Service - must be initialized first
  sl.registerLazySingleton<StorageService>(
    () => StorageService(),
  );
  // Initialize storage
  await sl<StorageService>().init();

  // Connectivity Service
  sl.registerLazySingleton<ConnectivityService>(
    () => ConnectivityService(),
  );
  // Initialize connectivity
  await sl<ConnectivityService>().init();

  // Token Service
  sl.registerLazySingleton<TokenService>(
    () => TokenService(),
  );

  // API Service
  sl.registerLazySingleton<ApiService>(
    () => ApiService(
      baseUrl: 'http://your-domain.com/api', // Update with actual base URL
      client: null, // Uses default http.Client
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
      baseUrl: 'http://your-domain.com/api', // Update with actual base URL
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
  // TODO: Implement in Phase 3
}

/// Initialize lesson feature (Phase 4)
Future<void> _initLesson() async {
  // TODO: Implement in Phase 4
}

/// Initialize enrollment feature (Phase 5)
Future<void> _initEnrollment() async {
  // TODO: Implement in Phase 5
}

/// Initialize profile feature (Phase 6)
Future<void> _initProfile() async {
  // TODO: Implement in Phase 6
}

/// Initialize dashboard feature (Phase 6)
Future<void> _initDashboard() async {
  // TODO: Implement in Phase 6
}
