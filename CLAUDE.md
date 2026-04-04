# PrivateTutor - Architecture & Development Guide

> **Last Updated:** 2026-04-04
> **Project:** PrivateTutor - Student Course Management System
> **Architecture Pattern:** Feature-First + Clean Architecture + BLoC

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture Principles](#architecture-principles)
3. [Folder Structure](#folder-structure)
4. [BLoC Pattern Rules](#bloc-pattern-rules)
5. [Layer Separation Rules](#layer-separation-rules)
6. [Dependency Injection](#dependency-injection)
7. [Routing & Navigation](#routing--navigation)
8. [Networking & API](#networking--api)
9. [State Management](#state-management)
10. [Error Handling](#error-handling)
11. [Naming Conventions](#naming-conventions)
12. [Development Rules](#development-rules)
13. [Phase-by-Phase Development](#phase-by-phase-development)

---

## Project Overview

**PrivateTutor** is a cross-platform Flutter application for student course management with the following core features:

- Authentication (register, login, session management)
- Public course browsing (search, filters, categories, featured)
- Course enrollment management
- Protected lesson access for enrolled students
- Lesson progress tracking
- User profile and dashboard
- Enrollment lifecycle management

---

## Architecture Principles

### Core Principles

1. **Feature-First Structure**: All code organized by feature, not by layer
2. **Clean Architecture**: Clear separation between presentation, domain, and data layers
3. **SOLID Principles**: Single responsibility, dependency inversion, etc.
4. **DRY**: Don't repeat yourself - use shared widgets and utilities
5. **Testability**: All layers can be tested in isolation

### Three-Layer Architecture

```
┌─────────────────────────────────────────┐
│          Presentation Layer             │
│  (Pages, Widgets, BLoCs, States/Events) │
└─────────────────────────────────────────┘
                   ↕
┌─────────────────────────────────────────┐
│            Domain Layer                 │
│  (Entities, Use Cases, Repositories)    │
└─────────────────────────────────────────┘
                   ↕
┌─────────────────────────────────────────┐
│             Data Layer                  │
│  (Models, Data Sources, Repositories)   │
└─────────────────────────────────────────┘
```

---

## Folder Structure

### Root Structure

```
lib/
├── core/                   # Shared, cross-cutting concerns
│   ├── constants/          # App constants
│   ├── data/               # Core data models (if any)
│   ├── di/                 # Dependency injection setup
│   ├── errors/             # Error/failure classes
│   ├── extensions/         # Dart extensions
│   ├── router/             # App router configuration
│   ├── services/           # Global services (network, storage, etc.)
│   ├── theme/              # App themes, colors, styles
│   ├── usecases/           # Global use cases (NoParams, etc.)
│   ├── utils/              # Utility functions
│   └── widgets/            # Shared widgets
├── features/               # Feature modules
│   ├── auth/              # Authentication feature
│   ├── course_browsing/   # Public course browsing
│   ├── enrollment/        # Enrollment management
│   ├── lesson/            # Lesson access & progress
│   ├── profile/           # User profile & dashboard
│   └── ...                # Other features
└── main.dart              # App entry point
```

### Feature Structure

Each feature MUST follow this structure:

```
features/feature_name/
├── data/                  # Data layer implementation
│   ├── models/            # API DTOs, JSON serialization
│   ├── datasources/       # Remote/local data sources
│   └── repositories/      # Repository implementations
├── domain/                # Business logic layer
│   ├── entities/          # Pure business objects
│   ├── repositories/      # Repository interfaces (abstract)
│   └── usecases/          # Use case implementations
└── presentation/          # UI layer
    ├── bloc/              # BLoC (event, state, bloc)
    ├── pages/             # Full-screen pages
    └── widgets/           # Feature-specific widgets
```

### Example: auth feature

```
features/auth/
├── data/
│   ├── models/
│   │   ├── auth_user_model.dart
│   │   └── auth_response_model.dart
│   ├── datasources/
│   │   ├── auth_remote_datasource.dart
│   │   └── auth_local_datasource.dart
│   └── repositories/
│       └── auth_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── auth_user.dart
│   ├── repositories/
│   │   └── auth_repository.dart
│   └── usecases/
│       ├── login_usecase.dart
│       ├── register_usecase.dart
│       └── get_current_user_usecase.dart
└── presentation/
    ├── bloc/
    │   ├── auth_event.dart
    │   ├── auth_state.dart
    │   └── auth_bloc.dart
    ├── pages/
    │   ├── login_page.dart
    │   └── register_page.dart
    └── widgets/
        ├── login_form.dart
        └── social_login_button.dart
```

---

## BLoC Pattern Rules

### BLoC File Organization

Each BLoC MUST consist of THREE files:

1. **`feature_event.dart`** - All events (user actions, system events)
2. **`feature_state.dart`** - All states (loading, loaded, error, etc.)
3. **`feature_bloc.dart`** - BLoC implementation with event handlers

### Event Rules

```dart
// ✅ GOOD: Clear, descriptive event names
abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

// ❌ BAD: Generic, unclear event names
class DoAuth extends AuthEvent {}  // What does this do?
```

### State Rules

```dart
// ✅ GOOD: Specific, actionable states
abstract class AuthState extends Equatable {
  const AuthState();
}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final User user;
  const AuthAuthenticated(this.user);
  @override
  List<Object> get props => [user];
}
class AuthUnauthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object> get props => [message];
}

// ❌ BAD: Single state with flags
class AuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final User? user;
  final String? error;
}
```

### BLoC Rules

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<CheckAuthStatus>(_onCheckAuthStatus);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final result = await loginUseCase(
      LoginParams(email: event.email, password: event.password),
    );

    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }
}
```

### BLoC Usage in Widgets

```dart
// � GOOD: Using BlocProvider and BlocBuilder
BlocProvider(
  create: (context) => sl<AuthBloc>(),
  child: Scaffold(
    body: BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return CircularProgressIndicator();
        }
        if (state is AuthError) {
          return Text('Error: ${state.message}');
        }
        if (state is AuthAuthenticated) {
          return WelcomeWidget(user: state.user);
        }
        return LoginForm();
      },
    ),
  ),
);

// ❌ BAD: Using setState and manual BLoC calls
class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(CheckAuthStatus());
  }
}
```

---

## Layer Separation Rules

### Data Layer Rules

- **Models**: Must be simple DTOs with JSON serialization
- **Data Sources**: Only handle API calls or local storage
- **Repository Implementation**: Implements repository interface from domain
- **NEVER**: Add business logic to data layer

### Domain Layer Rules

- **Entities**: Pure Dart classes with NO dependencies on Flutter or external packages
- **Repository Interfaces**: Abstract classes defining contracts
- **Use Cases**: Single-responsibility business logic operations
- **NEVER**: Depend on data layer implementation details

### Presentation Layer Rules

- **Pages**: Full-screen widgets, should be dumb as possible
- **BLoCs**: State management only, no business logic (delegate to use cases)
- **Widgets**: Reusable UI components
- **NEVER**: Call API directly or access local storage from presentation

### Dependency Direction

```
Presentation → Domain → Data
     ↑            ↑         ↑
     └────────────┴─────────┘
          NO reverse dependencies!
```

**CRITICAL RULES:**

1. Domain layer **MUST NOT** know about Data layer
2. Presentation layer **MUST NOT** know about Data layer
3. Data layer **MUST NOT** know about Presentation layer
4. Only use case classes can call repositories
5. Only BLoCs can call use cases
6. Only widgets can use BLoCs

---

## Dependency Injection

### Using GetIt Service Locator

```dart
// File: lib/core/di/injection_container.dart
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await _initCore();
  await _initFeatures();
}

Future<void> _initCore() async {
  // Register core services
  sl.registerLazySingleton<ApiService>(() => ApiService());
  sl.registerLazySingleton<TokenService>(() => TokenService());
}

Future<void> _initAuth() async {
  // BLoC - Factory (new instance each time)
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      getCurrentUserUseCase: sl(),
    ),
  );

  // Use Cases - LazySingleton (single instance)
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiService: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
}
```

### Service Locator Rules

- **BLoCs**: Register as `factory` (new instance each time)
- **Use Cases**: Register as `lazySingleton` (single instance)
- **Repositories**: Register as `lazySingleton`
- **Data Sources**: Register as `lazySingleton`
- **Services**: Register as `lazySingleton`

---

## Routing & Navigation

### Using go_router

```dart
// File: lib/core/router/app_router.dart
import 'package:go_router/go_router.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => LoginPage(),
      ),
      GoRoute(
        path: '/courses',
        name: 'courses',
        builder: (context, state) => CoursesPage(),
      ),
      GoRoute(
        path: '/courses/:id',
        name: 'course_details',
        builder: (context, state) {
          final courseId = state.pathParameters['id']!;
          return CourseDetailsPage(courseId: courseId);
        },
      ),
    ],
  );
}
```

### Navigation Rules

- Always use `context.go()` for navigation
- Use path parameters for required data (`/courses/:id`)
- Use query parameters for optional filters (`/courses?category=math`)
- Protect authenticated routes using redirect logic in go_router
- Never use `Navigator.push()` directly (use go_router methods)

---

## Networking & API

### Centralized API Service

```dart
// File: lib/core/services/api_service.dart
import 'package:http/http.dart' as http;

class ApiService {
  final http.Client client;
  final String baseUrl;

  ApiService({
    required this.baseUrl,
    http.Client? client,
  }) : client = client ?? http.Client();

  Future<http.Response> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint').replace(
      queryParameters: queryParameters?.map(
        (key, value) => MapEntry(key, value.toString()),
      ),
    );

    final response = await client.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (headers != null) ...headers,
      },
    );

    return response;
  }

  Future<http.Response> post(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');

    final response = await client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (headers != null) ...headers,
      },
      body: jsonEncode(body),
    );

    return response;
  }
}
```

### Token Management

```dart
// File: lib/core/services/token_service.dart
class TokenService {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    // Save to secure storage
  }

  Future<String?> getAccessToken() async {
    // Get from secure storage
  }

  Future<void> clearTokens() async {
    // Clear from secure storage
  }

  Future<bool> isTokenValid() async {
    // Check token expiry
  }
}
```

### API Response Handling

All API calls should follow this pattern:

```dart
// Remote data source
@override
Future<AuthResponseModel> login({
  required String email,
  required String password,
}) async {
  try {
    final response = await apiService.post(
      '/v1/auth/login',
      body: {
        'email': email,
        'password': password,
        'device_name': 'Flutter App',
      },
    );

    if (response.statusCode == 200) {
      return AuthResponseModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw UnauthorizedException();
    } else {
      throw ServerException();
    }
  } on ServerException {
    rethrow;
  } catch (e) {
    throw NetworkException();
  }
}
```

---

## State Management

### When to Use BLoC

- Authentication state (logged in/out, user data)
- API data loading (courses, lessons, enrollments)
- Form validation and submission
- Any state that affects multiple widgets

### When NOT to Use BLoC

- Simple UI state (show/hide password, checkbox state)
- One-time events (snackbar, dialog)
- Animation state
- Local widget state

### Alternative: setState for Local State

```dart
// ✅ GOOD: Using setState for simple local state
class PasswordField extends StatefulWidget {
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _obscureText,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        ),
      ),
    );
  }
}
```

---

## Error Handling

### Failure Classes

```dart
// File: lib/core/errors/failures.dart
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error occurred']) : super(message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([String message = 'Unauthorized access']) : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Validation failed']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error']) : super(message);
}
```

### Exception to Failure Mapping

```dart
// Repository implementation
@override
Future<Either<Failure, AuthResponse>> login(LoginParams params) async {
  try {
    final authResponseModel = await remoteDataSource.login(
      email: params.email,
      password: params.password,
    );

    // Save token locally
    await localDataSource.saveToken(authResponseModel.token);

    return Right(authResponseModel.toEntity());
  } on ServerException {
    return Left(const ServerFailure());
  } on NetworkException {
    return Left(const NetworkFailure());
  } on UnauthorizedException {
    return Left(const UnauthorizedFailure());
  } catch (e) {
    return Left(const ServerFailure('Unknown error occurred'));
  }
}
```

### User-Facing Error Messages

```dart
// In BLoC
result.fold(
  (failure) => emit(AuthError(
    message: _getErrorMessage(failure),
  )),
  (user) => emit(AuthAuthenticated(user: user)),
);

String _getErrorMessage(Failure failure) {
  switch (failure.runtimeType) {
    case NetworkFailure:
      return 'Please check your internet connection';
    case UnauthorizedFailure:
      return 'Invalid email or password';
    case ServerFailure:
      return 'Server error. Please try again later';
    default:
      return 'An unexpected error occurred';
  }
}
```

---

## Naming Conventions

### Files

- Use `snake_case` for file names
- File name should match the main class name
- Group related files in folders

```
✅ GOOD:
auth_bloc.dart
auth_event.dart
auth_state.dart
login_page.dart
login_form.dart

❌ BAD:
authBloc.dart
AuthBloc.dart
loginPage.dart
Login-Page.dart
```

### Classes

- Use `PascalCase` for class names
- Prefix BLoC events with the feature name
- Suffix BLoC states with `State`

```
✅ GOOD:
class AuthBloc {}
class LoginRequested extends AuthEvent {}
class AuthAuthenticated extends AuthState {}
class LoginPage extends StatelessWidget {}

❌ BAD:
class authBloc {}
class login_requested {}
class authenticated {}
class login_page {}
```

### Variables/Methods

- Use `camelCase` for variables and methods
- Use descriptive names
- Boolean variables should start with `is`, `has`, `should`

```
✅ GOOD:
final String userEmail;
final bool isAuthenticated;
void loadCourses();
bool hasEnrollments();

❌ BAD:
final String email;
final bool authenticated;
void getData();
bool enrollments;
```

### Constants

- Use `lowerCamelCase` for local constants
- Use `UPPER_SNAKE_CASE` for global/app-level constants

```
// Local constant
final String apiUrl = 'https://api.example.com';

// Global constant
// File: lib/core/constants/api_constants.dart
class ApiConstants {
  static const String baseUrl = 'https://api.example.com';
  static const String apiVersion = '/v1';
  static const int timeoutDuration = 30000;
}
```

---

## Development Rules

### Code Organization Rules

1. **One public class per file** - Each file should have one main exportable class
2. **Max 200 lines per file** - Break down into smaller files if exceeded
3. **Max 5 parameters per function** - Use parameter objects for more
4. **Nest depth max 4** - Refactor complex nested logic into separate functions
5. **No commented-out code** - Delete unused code, git has history

### Import Organization

```dart
// 1. Dart SDK imports
import 'dart:async';

// 2. Flutter framework imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 3. Third-party package imports
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

// 4. Project imports - core
import '../../core/errors/failures.dart';
import '../../core/utils/constants.dart';

// 5. Project imports - feature domain
import '../domain/entities/auth_user.dart';
import '../domain/repositories/auth_repository.dart';

// 6. Project imports - feature data/presentation
import '../../features/course/presentation/bloc/course_bloc.dart';
```

### Documentation Rules

1. **Every public class MUST have a doc comment**
2. **Complex methods MUST have inline comments**
3. **Use TODO/FIXME/HACK comments for temporary code**

```dart
/// Repository for handling authentication operations.
///
/// Provides methods for user authentication, registration, and
/// session management.
abstract class AuthRepository {
  /// Authenticates a user with email and password.
  ///
  /// Returns [Right] with [AuthUser] on success.
  /// Returns [Left] with [Failure] on failure.
  Future<Either<Failure, AuthUser>> login(LoginParams params);
}
```

---

## Phase-by-Phase Development

### Phase 0: Analysis & Planning ✅

- Inspect reference project structure
- Analyze Postman API collection
- Define features
- Create documentation (CLAUDE.md, PROJECT_PLAN.md, PHASE_CHECKLIST.md)

### Phase 1: Foundation

**Goals:** Set up project infrastructure

- [ ] Update pubspec.yaml with dependencies
- [ ] Set up folder structure (core/, features/)
- [ ] Configure go_router
- [ ] Set up GetIt DI container
- [ ] Create theme system
- [ ] Implement ApiService
- [ ] Implement TokenService
- [ ] Create error handling classes
- [ ] Set up shared widgets
- [ ] Create utility functions

**Definition of Done:**
- All core services initialized
- Router configured with basic routes
- DI container set up
- Can build and run the app

### Phase 2: Authentication

**Goals:** Complete auth flow

**Features:**
- Registration
- Login
- Get current user
- Logout
- Logout all devices
- Refresh token
- Change password
- Active sessions

**Definition of Done:**
- User can register
- User can login
- Token stored securely
- Protected routes work
- Auto logout on token expiry
- Auth state persists across app restarts

### Phase 3: Public Course Browsing

**Goals:** Browse courses without auth

**Features:**
- List all courses
- Filter/search courses
- Get featured courses
- Get categories
- Course details
- Preview lessons

**Definition of Done:**
- User can browse courses
- Search and filter work
- Course details display correctly
- Preview lessons accessible
- Pagination works

### Phase 4: Student Learning Area

**Goals:** Access enrolled courses

**Features:**
- My courses list
- Protected lessons
- Lesson details
- Mark lesson complete/incomplete
- Update progress
- Course progress tracking

**Definition of Done:**
- Enrolled students can access lessons
- Progress tracking works
- Completion status updates
- Progress percentage accurate

### Phase 5: Enrollments

**Goals:** Manage course enrollments

**Features:**
- Enrollment list
- Create enrollment
- Enrollment details
- Enrollment statistics
- Renew enrollment
- Cancel enrollment

**Definition of Done:**
- User can enroll in courses
- Enrollment history visible
- Renewal flow works
- Cancellation works
- Statistics accurate

### Phase 6: Profile & Dashboard

**Goals:** User profile management

**Features:**
- Get profile
- Update profile
- Upload avatar
- Dashboard
- Activity history
- Change password
- Delete account

**Definition of Done:**
- Profile data displays correctly
- Updates work
- Avatar upload works
- Dashboard shows relevant data
- Activity log works

### Phase 7: Polish

**Goals:** Improve UX/UI

**Features:**
- Loading states
- Empty states
- Error states
- Retry handling
- Session expiry UX
- Consistent styling
- Form validation
- Input masks

**Definition of Done:**
- No missing states
- Consistent UI/UX
- Good error messages
- Smooth loading
- Form validation works

### Phase 8: QA & Documentation

**Goals:** Final review

**Tasks:**
- Architecture consistency check
- API coverage verification
- Dead code removal
- Documentation updates
- Performance review
- Security review
- Final testing

**Definition of Done:**
- All documented features work
- No dead code
- Documentation up to date
- No critical bugs
- Performance acceptable

---

## Critical Rules Summary

### DO's ✅

1. Follow feature-first structure
2. Use BLoC for state management
3. Keep layers separated (presentation → domain → data)
4. Use dependency injection (GetIt)
5. Use go_router for navigation
6. Handle errors properly with Failure classes
7. Write descriptive names
8. Document public APIs
9. Keep files small and focused
10. Follow naming conventions

### DON'Ts ❌

1. Don't mix layers (e.g., API calls in widgets)
2. Don't skip repository pattern
3. Don't put business logic in presentation
4. Don't use setState for app-wide state
5. Don't use hardcoded strings
6. Don't leave commented code
7. Don't create god classes/files
8. Don't skip error handling
9. Don't access services directly from widgets
10. Don't skip documentation

---

## Getting Started

### First Development Task

1. Read this entire document
2. Review the reference project structure
3. Check PHASE_CHECKLIST.md for current phase
4. Update dependencies in pubspec.yaml
5. Set up folder structure
6. Implement core services
7. Start with Phase 1: Foundation

### Questions?

- Check PROJECT_PLAN.md for detailed feature breakdown
- Check API_MAPPING.md for API endpoints
- Check PHASE_CHECKLIST.md for current progress
- Check CHANGELOG.md for recent changes

---

**Remember:** Clean architecture is not about perfection, it's about maintainability. Keep it simple, follow the patterns, and build incrementally.
