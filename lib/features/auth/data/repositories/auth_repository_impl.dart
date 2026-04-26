import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_user_model.dart';

/// Authentication repository implementation
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AuthUser>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String phone,
  }) async {
    try {
      final user = await remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        phone: phone,
      );

      // Cache complete user data locally
      await localDataSource.cacheUser(user.toJson());
      await localDataSource.saveAuthState(true);

      return Right(user.toEntity());
    } on AppException catch (e) {
      return _mapExceptionToFailure(e);
    }
  }

  @override
  Future<Either<Failure, AuthUser>> login({
    required String email,
    required String password,
    required String deviceName,
  }) async {
    try {
      final authResponse = await remoteDataSource.login(
        email: email,
        password: password,
        deviceName: deviceName,
      );

      // Cache complete user data locally
      await localDataSource.cacheUser(authResponse.user.toJson());
      await localDataSource.saveAuthState(true);

      return Right(authResponse.user.toEntity());
    } on AppException catch (e) {
      return _mapExceptionToFailure(e);
    }
  }

  @override
  Future<Either<Failure, AuthUser>> getCurrentUser() async {
    try {
      // Try to get from cache first
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Right(AuthUserModel.fromJson(cachedUser).toEntity());
      }

      // If not in cache, fetch from API
      final user = await remoteDataSource.getCurrentUser();
      await localDataSource.cacheUser(user.toJson());

      return Right(user.toEntity());
    } on AppException catch (e) {
      return _mapExceptionToFailure(e);
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearCachedUser();
      await localDataSource.clearAuthState();
      return const Right(null);
    } on AppException catch (e) {
      return _mapExceptionToFailure(e);
    }
  }

  @override
  Future<Either<Failure, void>> logoutAll() async {
    try {
      await remoteDataSource.logoutAll();
      await localDataSource.clearCachedUser();
      await localDataSource.clearAuthState();
      return const Right(null);
    } on AppException catch (e) {
      return _mapExceptionToFailure(e);
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken() async {
    try {
      final token = await remoteDataSource.refreshToken();
      return Right(token);
    } on AppException catch (e) {
      return _mapExceptionToFailure(e);
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      await remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );
      return const Right(null);
    } on AppException catch (e) {
      return _mapExceptionToFailure(e);
    }
  }

  @override
  Future<Either<Failure, List<Session>>> getActiveSessions() async {
    try {
      final sessions = await remoteDataSource.getActiveSessions();
      return Right(
        sessions.map((model) => model.toEntity()).toList(),
      );
    } on AppException catch (e) {
      return _mapExceptionToFailure(e);
    }
  }

  @override
  Future<Either<Failure, bool>> isAuthenticated() async {
    try {
      final authState = await localDataSource.getAuthState();
      return Right(authState);
    } on AppException catch (e) {
      return _mapExceptionToFailure(e);
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      await remoteDataSource.deleteAccount();
      await localDataSource.clearCachedUser();
      await localDataSource.clearAuthState();
      return const Right(null);
    } on AppException catch (e) {
      return _mapExceptionToFailure(e);
    }
  }

  /// Map AppException to Failure
  Either<Failure, T> _mapExceptionToFailure<T>(AppException exception) {
    if (exception is ServerException) {
      return Left(ServerFailure(message: exception.message));
    } else if (exception is NetworkException) {
      return Left(NetworkFailure(message: exception.message));
    } else if (exception is UnauthorizedException) {
      return Left(UnauthorizedFailure(exception.message));
    } else if (exception is ValidationException) {
      return Left(ValidationFailure(exception.message, exception.errors));
    } else if (exception is RateLimitException) {
      return Left(RateLimitFailure(exception.message, exception.retryAfter));
    } else if (exception is TokenException) {
      return Left(TokenFailure(exception.message));
    } else if (exception is CacheException) {
      return Left(CacheFailure(exception.message));
    } else {
      return Left(UnknownFailure(exception.message));
    }
  }
}
