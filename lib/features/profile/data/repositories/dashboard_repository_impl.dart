import 'package:dartz/dartz.dart';
import '../../../../core/services/api_exception.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/error/failures.dart';
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
  final ConnectivityService connectivityService;

  DashboardRepositoryImpl({
    required this.remoteDataSource,
    required this.connectivityService,
  });

  @override
  Future<Either<Failure, DashboardStats>> getDashboard() async {
    try {
      if (!await connectivityService.isConnected) {
        throw NoInternetException();
      }

      final dashboardModel = await remoteDataSource.getDashboard();
      return Right(dashboardModel.toEntity());
    } on CustomException catch (e) {
      final failure = parseCustomException<DashboardStats>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  Future<Either<Failure, List<Activity>>> getActivity({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      if (!await connectivityService.isConnected) {
        throw NoInternetException();
      }

      final activityModels = await remoteDataSource.getActivity(
        page: page,
        limit: limit,
      );
      return Right(activityModels.map((model) => model.toEntity()).toList());
    } on CustomException catch (e) {
      final failure = parseCustomException<List<Activity>>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }
}
