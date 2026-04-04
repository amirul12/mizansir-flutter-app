// File: lib/features/auth/presentation/bloc/auth_event.dart
import 'package:equatable/equatable.dart';

/// Base authentication event
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// App started - check authentication status
class AppStartedEvent extends AuthEvent {}

/// Login requested
class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

/// Register requested
class RegisterEvent extends AuthEvent {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;

  const RegisterEvent({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        phone,
        password,
        passwordConfirmation,
      ];
}

/// Logout requested
class LogoutEvent extends AuthEvent {}

/// Get current user requested
class GetCurrentUserEvent extends AuthEvent {}

/// Check authentication status
class CheckAuthStatusEvent extends AuthEvent {}

/// Clear error message
class ClearErrorEvent extends AuthEvent {}
