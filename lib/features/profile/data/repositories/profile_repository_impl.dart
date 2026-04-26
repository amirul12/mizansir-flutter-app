import 'package:dartz/dartz.dart';
import 'package:mizansir/features/profile/data/models/user_profile_model.dart' show UserProfileModel;
import '../../../../core/services/api_exception.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

/// Profile repository implementation.
///
/// Implements profile-related operations by coordinating
/// between remote data source and handling exceptions.
class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final AuthRepository authRepository;
  final ConnectivityService connectivityService;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.authRepository,
    required this.connectivityService,
  });

  @override
  Future<Either<Failure, UserProfileModel>> getProfile() async {
    try {
      if (!await connectivityService.isConnected) {
        throw NoInternetException();
      }

      final profileModel = await remoteDataSource.getProfile();
      return Right(profileModel);
    } on CustomException catch (e) {
      final failure = parseCustomException<UserProfileModel>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  Future<Either<Failure, UserProfileModel>> updateProfile(
      Map<String, dynamic> params) async {
    try {
      if (!await connectivityService.isConnected) {
        throw NoInternetException();
      }

      final profileModel = await remoteDataSource.updateProfile(params);
      return Right(profileModel);
    } on CustomException catch (e) {
      final failure = parseCustomException<UserProfileModel>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  Future<Either<Failure, UserProfileModel>> uploadAvatar(String imagePath) async {
    try {
      if (!await connectivityService.isConnected) {
        throw NoInternetException();
      }

      final profileModel = await remoteDataSource.uploadAvatar(imagePath);
      return Right(profileModel);
    } on CustomException catch (e) {
      final failure = parseCustomException<UserProfileModel>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      if (!await connectivityService.isConnected) {
        throw NoInternetException();
      }

      await remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      return const Right(null);
    } on CustomException catch (e) {
      final failure = parseCustomException<void>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(String password) async {
    try {
      if (!await connectivityService.isConnected) {
        throw NoInternetException();
      }

      await remoteDataSource.deleteAccount(password);
      // Also logout locally after successful deletion
      final logoutResult = await authRepository.logout();
      return logoutResult.fold(
        (failure) => Left(failure),
        (_) => const Right(null),
      );
    } on CustomException catch (e) {
      final failure = parseCustomException<void>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return authRepository.logout();
  }
}
