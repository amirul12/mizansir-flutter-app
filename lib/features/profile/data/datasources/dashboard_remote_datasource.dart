import '../models/dashboard_stats_model.dart';
import '../models/activity_model.dart';

/// Dashboard remote data source interface.
///
/// Defines the contract for dashboard-related API calls.
abstract class DashboardRemoteDataSource {
  /// Get dashboard statistics from API.
  ///
  /// Returns [DashboardStatsModel] on success.
  /// Throws [ServerException] on API errors.
  Future<DashboardStatsModel> getDashboard();

  /// Get user activity history from API.
  ///
  /// [page] is the page number (default: 1).
  /// [limit] is the number of items per page (default: 20).
  ///
  /// Returns List of [ActivityModel] on success.
  /// Throws [ServerException] on API errors.
  Future<List<ActivityModel>> getActivity({
    int page = 1,
    int limit = 20,
  });
}
