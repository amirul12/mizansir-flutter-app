import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:mizansir/features/profile/data/models/activity_model.dart' show ActivityModel, activityModelFromJson;
import 'package:mizansir/features/profile/data/models/dashboard_stats_model.dart' show DashboardStatsModel, dashboardStatsModelFromJson;
import '../../../../core/services/api_exception.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/hive_service.dart';
import '../../../../core/error/failures.dart';


import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_datasource.dart';

/// Dashboard repository implementation.
///
/// Implements dashboard-related operations by coordinating
/// between remote data source, cache and handling exceptions.
class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  final ConnectivityService connectivityService;
  final HiveService hiveService;

  DashboardRepositoryImpl({
    required this.remoteDataSource,
    required this.connectivityService,
    required this.hiveService,
  });

  @override
  Future<Either<Failure, DashboardStatsModel>> getDashboard() async {
    try {
      if (!await connectivityService.isConnected) {
        final cachedJson = await hiveService.getDashboard();
        if (cachedJson != null) {
          final cachedDashboard = dashboardStatsModelFromJson(cachedJson);
          return Right(cachedDashboard);
        }
        throw NoInternetException();
      }

      final dashboardModel = await remoteDataSource.getDashboard();
      await hiveService.saveDashboard(jsonEncode(dashboardModel.toJson()));
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
        final cachedJson = await hiveService.getActivities();
        if (cachedJson != null && page == 1) {
          final cachedActivities = activityModelFromJson(cachedJson);
          return Right(cachedActivities);
        }
        throw NoInternetException();
      }

      final activityModels = await remoteDataSource.getActivity(
        page: page,
        limit: limit,
      );

      if (page == 1) {
        await hiveService.saveActivities(jsonEncode(activityModels.map((e) => e.toJson()).toList()));
      }

      return Right(activityModels);
    } on CustomException catch (e) {
      final failure = parseCustomException<List<ActivityModel>>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }
}
