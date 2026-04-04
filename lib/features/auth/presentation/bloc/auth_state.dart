// File: lib/features/auth/presentation/bloc/auth_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/auth_user.dart';

/// Base authentication state
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Loading state
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Authenticated state
class AuthAuthenticated extends AuthState {
  final AuthUser user;

  const AuthAuthenticated(this.user);

  @override
  List<Object?> get props => [user];
}

/// Unauthenticated state
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Error state
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Login success message (for navigation)
class AuthLoginSuccess extends AuthState {
  final String message;

  const AuthLoginSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

/// Registration success message
class AuthRegisterSuccess extends AuthState {
  final String message;

  const AuthRegisterSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
