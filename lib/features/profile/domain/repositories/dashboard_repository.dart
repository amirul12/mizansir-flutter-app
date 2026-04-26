import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/activity.dart';
import '../entities/dashboard_stats.dart';

/// Dashboard repository interface.
///
/// Defines the contract for dashboard-related operations.
abstract class DashboardRepository {
  /// Get dashboard statistics and data.
  ///
  /// Returns [Right] with [DashboardStats] on success.
  /// Returns [Left] with [Failure] on failure.
  Future<Either<Failure, DashboardStats>> getDashboard();

  /// Get user activity history.
  ///
  /// [page] is the page number (default: 1).
  /// [limit] is the number of items per page (default: 20).
  ///
  /// Returns [Right] with List of activities on success.
  /// Returns [Left] with [Failure] on failure.
  Future<Either<Failure, List<Activity>>> getActivity({
    int page = 1,
    int limit = 20,
  });
}
