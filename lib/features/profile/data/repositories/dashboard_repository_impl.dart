import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/activity.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';

/// Dashboard repository implementation.
///
/// Implements dashboard-related operations by coordinating
/// between remote data source and handling exceptions.
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DashboardStats>> getDashboard() async {
    try {
      final dashboardModel = await remoteDataSource.getDashboard();
      return Right(dashboardModel.toEntity());
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
  Future<Either<Failure, List<Activity>>> getActivity({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final activityModels = await remoteDataSource.getActivity(
        page: page,
        limit: limit,
      );
      return Right(activityModels.map((model) => model.toEntity()).toList());
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
}
