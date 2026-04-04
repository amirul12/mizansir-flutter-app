import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

/// Profile repository implementation.
///
/// Implements profile-related operations by coordinating
/// between remote data source and handling exceptions.
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final AuthRepository authRepository;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.authRepository,
  });

  @override
  Future<Either<Failure, UserProfile>> getProfile() async {
    try {
      final profileModel = await remoteDataSource.getProfile();
      return Right(profileModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException {
      return Left(const UnauthorizedFailure());
    } on NotFoundException {
      return Left(const NotFoundFailure('Profile not found'));
    } on NetworkException {
      return Left(const NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile(
      Map<String, dynamic> params) async {
    try {
      final profileModel = await remoteDataSource.updateProfile(params);
      return Right(profileModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException {
      return Left(const UnauthorizedFailure());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException {
      return Left(const NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfile>> uploadAvatar(String imagePath) async {
    try {
      final profileModel = await remoteDataSource.uploadAvatar(imagePath);
      return Right(profileModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException {
      return Left(const UnauthorizedFailure());
    } on NetworkException {
      return Left(const NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException {
      return Left(const UnauthorizedFailure('Incorrect current password'));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException {
      return Left(const NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(String password) async {
    try {
      await remoteDataSource.deleteAccount(password);
      // Also logout locally after successful deletion
      await authRepository.logout();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on UnauthorizedException {
      return Left(const UnauthorizedFailure('Incorrect password'));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on NetworkException {
      return Left(const NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await authRepository.logout();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
