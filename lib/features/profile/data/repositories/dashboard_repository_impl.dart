import 'package:dartz/dartz.dart';
import 'package:mizansir/features/profile/data/models/activity_model.dart' show ActivityModel;
import 'package:mizansir/features/profile/data/models/dashboard_stats_model.dart' show DashboardStatsModel;
import '../../../../core/services/api_exception.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/error/failures.dart';
 
 
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
  Future<Either<Failure, DashboardStatsModel>> getDashboard() async {
    try {
      if (!await connectivityService.isConnected) {
        throw NoInternetException();
      }

      final dashboardModel = await remoteDataSource.getDashboard();
      return Right(dashboardModel);
    } on CustomException catch (e) {
      final failure = parseCustomException<DashboardStatsModel>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  Future<Either<Failure, List<ActivityModel>>> getActivity({
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
      return Right(activityModels);
    } on CustomException catch (e) {
      final failure = parseCustomException<List<ActivityModel>>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }
}
