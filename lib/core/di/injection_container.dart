// File: lib/core/di/injection_container.dart
import 'package:get_it/get_it.dart';
import '../services/api_service.dart';
import '../services/token_service.dart';
import '../services/storage_service.dart';
import '../services/connectivity_service.dart';

/// Global service locator instance
final sl = GetIt.instance;

/// Initialize dependency injection
Future<void> init() async {
  // Initialize core services first
  await _initCore();
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
  // Example:
  // await _initAuth();
  // await _initCourseBrowsing();
  // etc.

  // Note: Feature registrations will be added as we implement each phase
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

// ========== Feature Registration Methods (Placeholders) ==========

/// Initialize authentication feature (Phase 2)
Future<void> _initAuth() async {
  // TODO: Implement in Phase 2
  // sl.registerFactory(() => AuthBloc(...));
  // sl.registerLazySingleton(() => LoginUseCase(sl()));
  // etc.
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
