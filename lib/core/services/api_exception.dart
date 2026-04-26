import 'package:dartz/dartz.dart';

import '../error/failures.dart';

class CustomException implements Exception {
  final _message;
  final _prefix;

  CustomException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }

  String? get message => _message;
}

//422 Unprocessable Entity
class UnprocessableEntityException extends CustomException {
  UnprocessableEntityException([String? message]) : super(message, " ");
}

class ServerException extends CustomException {
  ServerException([String? message])
      : super(message, "Failed to connect to server: ");
}

class NoInternetException extends CustomException {
  NoInternetException([String? message])
      : super("", "No Internet Connection: ");
}

class FetchDataException extends CustomException {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

class UnauthorizedException extends CustomException {
  UnauthorizedException([String super.message = "Unauthorized"]);
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

class TimeoutException extends CustomException {
  TimeoutException([String super.message = "Request Timed out! Try again"]);
}

class NetworkException extends CustomException {
  NetworkException(
      [String super.message = "Check your Internet Connection and try again!"]);
}

class ForbiddenException extends CustomException {
  ForbiddenException([String super.message = "Forbidden"]);
}

class NotFoundException extends CustomException {
  NotFoundException([String super.message = "Not Found"]);
}

class ConflictException extends CustomException {
  ConflictException([String super.message = "Conflict"]);
}

class ClientException extends CustomException {
  ClientException([String super.message = "Client Error"]);
}

class UnprocessableEntityFailure extends Failure {
  const UnprocessableEntityFailure(super.message);

  @override
  // TODO: implement props
  List<Object?> get props => [message];
}

Either<Failure, T> parseCustomException<T>(CustomException exception) {
  if (exception is BadRequestException) {
    return Left(BadRequestFailure(exception.message ?? 'Bad request error'));
  } else if (exception is ServerException) {
    return const Left(ServiceUnavailableFailure(
        message: "Failed to connect to server: Please try again later"));
  } else if (exception is NoInternetException) {
    return const Left(NetworkFailure(message: "No Internet Connection"));
  } else if (exception is UnauthorisedException) {
    return Left(UnAuthorizedFailure(exception.message ?? 'Unauthorised'));
  } else if (exception is ForbiddenException) {
    return Left(ForbiddenFailure(exception.message ?? 'Forbidden'));
  } else if (exception is NotFoundException) {
    return Left(NotFoundFailure(exception.message ?? 'Not Found'));
  } else if (exception is ConflictException) {
    return Left(ConflictFailure(exception.message ?? 'Conflict'));
  } else if (exception is UnprocessableEntityException) {
    return Left(UnprocessableEntityFailure(exception.message));
  } else if (exception is FetchDataException) {
    return const Left(ServerFailure());
  } else if (exception is TimeoutException) {
    return const Left(ServerFailure());
  } else if (exception is NetworkException) {
    return const Left(NetworkFailure());
  } else if (exception is ClientException) {
    return const Left(ServerFailure());
  } else {
    return const Left(ServerFailure()); // Fallback for any other exceptions
  }
}
