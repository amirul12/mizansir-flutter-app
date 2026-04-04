// File: lib/core/errors/failures.dart
import 'package:equatable/equatable.dart';

/// Base class for all failures
/// Failures are used to represent errors in the domain layer
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Failure representing a server error
class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error occurred'])
      : super(message);
}

/// Failure representing a network error
class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'Network error occurred'])
      : super(message);
}

/// Failure representing an unauthorized access error
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([String message = 'Unauthorized access'])
      : super(message);
}

/// Failure representing a not found error
class NotFoundFailure extends Failure {
  const NotFoundFailure([String message = 'Resource not found'])
    : super(message);
}

/// Failure representing a validation error
class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;

  const ValidationFailure([
    String message = 'Validation failed',
    this.errors,
  ]) : super(message);

  @override
  List<Object> get props => [message, errors ?? {}];
}

/// Failure representing a cache error
class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache error']) : super(message);
}

/// Failure representing a token error
class TokenFailure extends Failure {
  const TokenFailure([String message = 'Token is expired or invalid'])
      : super(message);
}

/// Failure representing a session expiry error
class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure([String message = 'Session has expired'])
      : super(message);
}

/// Failure representing a file upload error
class FileUploadFailure extends Failure {
  const FileUploadFailure([String message = 'File upload failed'])
      : super(message);
}

/// Failure representing a timeout error
class TimeoutFailure extends Failure {
  const TimeoutFailure([String message = 'Request timeout']) : super(message);
}

/// Failure representing an unknown error
class UnknownFailure extends Failure {
  const UnknownFailure([String message = 'An unknown error occurred'])
      : super(message);
}
