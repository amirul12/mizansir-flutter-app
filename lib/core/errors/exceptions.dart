// File: lib/core/errors/exceptions.dart
import 'package:equatable/equatable.dart';

/// Base class for all exceptions
/// Exceptions are runtime errors that occur during execution
abstract class AppException extends Equatable implements Exception {
  final String message;
  final int? statusCode;

  const AppException({
    required this.message,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

/// Exception thrown when server returns an error response
class ServerException extends AppException {
  const ServerException({
    required String message,
    int? statusCode,
  }) : super(
          message: message,
          statusCode: statusCode,
        );
}

/// Exception thrown when network connection fails
class NetworkException extends AppException {
  const NetworkException({
    String message = 'Network connection failed',
  }) : super(message: message);
}

/// Exception thrown when authentication fails (401)
class UnauthorizedException extends AppException {
  const UnauthorizedException({
    String message = 'Unauthorized access',
    int statusCode = 401,
  }) : super(
          message: message,
          statusCode: statusCode,
        );
}

/// Exception thrown when resource is not found (404)
class NotFoundException extends AppException {
  const NotFoundException({
    String message = 'Resource not found',
    int statusCode = 404,
  }) : super(
          message: message,
          statusCode: statusCode,
        );
}

/// Exception thrown when input validation fails
class ValidationException extends AppException {
  final Map<String, dynamic>? errors;

  const ValidationException({
    required String message,
    this.errors,
    int statusCode = 422,
  }) : super(
          message: message,
          statusCode: statusCode,
        );

  @override
  List<Object?> get props => [message, statusCode, errors];
}

/// Exception thrown when cache operation fails
class CacheException extends AppException {
  const CacheException({
    String message = 'Cache operation failed',
  }) : super(message: message);
}

/// Exception thrown when token is expired or invalid
class TokenException extends AppException {
  const TokenException({
    String message = 'Token is expired or invalid',
    int statusCode = 401,
  }) : super(
          message: message,
          statusCode: statusCode,
        );
}

/// Exception thrown when session is expired
class SessionExpiredException extends AppException {
  const SessionExpiredException({
    String message = 'Session has expired',
  }) : super(message: message);
}

/// Exception thrown when file upload fails
class FileUploadException extends AppException {
  const FileUploadException({
    String message = 'File upload failed',
  }) : super(message: message);
}

/// Exception thrown when timeout occurs
class TimeoutException extends AppException {
  const TimeoutException({
    String message = 'Request timeout',
  }) : super(message: message);
}
