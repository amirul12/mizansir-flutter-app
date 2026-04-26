import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String? message;
  const Failure(this.message, [List properties = const <dynamic>[]]) : super();
}

// General failures
class ServerFailure extends Failure {
  @override
  final String message;

  const ServerFailure({this.message = 'Check your internet connection and try again'}) : super(message);

  @override
  List<Object> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);

  @override
  List<Object> get props => [];
}

class NetworkFailure extends Failure {
  @override
  final String message;

  const NetworkFailure({this.message = ''}) : super(message);

  @override
  List<Object> get props => [];
}

class BadRequestFailure extends Failure {
  const BadRequestFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class UnAuthorizedFailure extends Failure {
  const UnAuthorizedFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure(super.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class ConflictFailure extends Failure {
  const ConflictFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class InternalServerErrorFailure extends Failure {
  const InternalServerErrorFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class ServiceUnavailableFailure extends Failure {
  @override
  final String message;
  const ServiceUnavailableFailure({this.message = ''}) : super(message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class NoInternetFailure extends Failure {
  const NoInternetFailure(super.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class NoServiceFoundFailure extends Failure {
  const NoServiceFoundFailure(super.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

class NoDataFoundFailure extends Failure {
  const NoDataFoundFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class NoInternetConnectionFailure extends Failure {
  const NoInternetConnectionFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class GoogleAuthFailure extends Failure {
  const GoogleAuthFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class CancelledByUserFailure extends Failure {
  const CancelledByUserFailure([super.message = 'Sign in was cancelled']);

  @override
  List<Object?> get props => [message];
}

// Auth-specific failures
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);

  @override
  List<Object?> get props => [message];
}

class ValidationFailure extends Failure {
  final Map<String, dynamic>? errors;

  const ValidationFailure(super.message, [this.errors]);

  @override
  List<Object?> get props => [message, errors];
}

class RateLimitFailure extends Failure {
  final int? retryAfter;

  const RateLimitFailure(super.message, [this.retryAfter]);

  @override
  List<Object?> get props => [message, retryAfter];
}

class TokenFailure extends Failure {
  const TokenFailure(super.message);

  @override
  List<Object?> get props => [message];
}
