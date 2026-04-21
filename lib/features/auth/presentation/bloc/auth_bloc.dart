// File: lib/features/auth/presentation/bloc/auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/no_params.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Authentication BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LogoutUseCase logoutUseCase;

  AuthBloc({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.getCurrentUserUseCase,
    required this.logoutUseCase,
  }) : super(AuthInitial()) {
    on<AppStartedEvent>(_onAppStarted);
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<GetCurrentUserEvent>(_onGetCurrentUser);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<ClearErrorEvent>(_onClearError);
  }

  Future<void> _onAppStarted(
    AppStartedEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await getCurrentUserUseCase(NoParams());

    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (user) {
        // Check if user is a student
        if (user.isStudent) {
          emit(AuthAuthenticated(user));
        } else {
          // Not a student - logout and show error
          logoutUseCase(NoParams());
          emit(const AuthError('Access denied. Only students can access this app.'));
        }
      },
    );
  }

  Future<void> _onLogin(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    // Get device name
    final deviceName = _getDeviceName();

    final result = await loginUseCase(
      LoginParams(
        email: event.email,
        password: event.password,
        deviceName: deviceName,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(_getErrorMessage(failure))),
      (user) {
        // Check if user is a student
        if (user.isStudent) {
          emit(const AuthLoginSuccess('Login successful'));
        } else {
          // Not a student - logout and show error
          logoutUseCase(NoParams());
          emit(const AuthError('Access denied. Only students can access this app.'));
        }
      },
    );
  }

  Future<void> _onRegister(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());

    final result = await registerUseCase(
      RegisterParams(
        name: event.name,
        email: event.email,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
        phone: event.phone,
      ),
    );

    result.fold(
      (failure) => emit(AuthError(_getErrorMessage(failure))),
      (user) {
        // Check if user is a student
        if (user.isStudent) {
          emit(const AuthRegisterSuccess('Registration successful'));
        } else {
          // Not a student - logout and show error
          logoutUseCase(NoParams());
          emit(const AuthError('Access denied. Only students can access this app.'));
        }
      },
    );
  }

  Future<void> _onLogout(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await logoutUseCase(NoParams());

    result.fold(
      (failure) => emit(AuthError(_getErrorMessage(failure))),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  Future<void> _onGetCurrentUser(
    GetCurrentUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await getCurrentUserUseCase(NoParams());

    result.fold(
      (failure) => emit(AuthError(_getErrorMessage(failure))),
      (user) {
        // Check if user is a student
        if (user.isStudent) {
          emit(AuthAuthenticated(user));
        } else {
          // Not a student - logout and show error
          logoutUseCase(NoParams());
          emit(const AuthError('Access denied. Only students can access this app.'));
        }
      },
    );
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    final result = await getCurrentUserUseCase(NoParams());

    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (user) {
        // Check if user is a student
        if (user.isStudent) {
          emit(AuthAuthenticated(user));
        } else {
          // Not a student - logout and show error
          logoutUseCase(NoParams());
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onClearError(
    ClearErrorEvent event,
    Emitter<AuthState> emit,
  ) async {
    // Keep current state but clear any error
    if (state is AuthError) {
      emit(const AuthInitial());
    }
  }

  String _getDeviceName() {
    // In a real app, you would get this from device_info_plus
    // For now, return a placeholder
    return 'Student Device';
  }

  String _getErrorMessage(dynamic failure) {
    // Map failure types to user-friendly messages
    switch (failure.runtimeType.toString()) {
      case 'NetworkFailure':
        return 'Please check your internet connection and try again.';
      case 'UnauthorizedFailure':
        return 'Invalid email or password.';
      case 'ValidationFailure':
        // Validation failures may have detailed field errors
        return failure.message;
      case 'ServerFailure':
        return 'Server error. Please try again later.';
      case 'CacheFailure':
        return 'Local storage error. Please restart the app.';
      case 'RateLimitFailure':
        // Show rate limit message with retry time if available
        final retryAfter = (failure as dynamic).retryAfter;
        if (retryAfter != null) {
          return 'Too many login attempts. Please try again in $retryAfter seconds.';
        }
        return failure.message;
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
