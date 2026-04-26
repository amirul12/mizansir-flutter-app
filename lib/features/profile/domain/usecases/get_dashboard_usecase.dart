import 'package:dartz/dartz.dart';
import 'package:mizansir/features/profile/data/models/dashboard_stats_model.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/no_params.dart';
 
import '../repositories/dashboard_repository.dart';

/// Get dashboard use case.
///
/// Retrieves dashboard statistics and data.
class GetDashboardUseCase {
  final DashboardRepository repository;

  GetDashboardUseCase(this.repository);

  /// Execute the use case.
  ///
  /// Returns [Right] with [DashboardStats] on success.
  /// Returns [Left] with [Failure] on failure.
  Future<Either<Failure, DashboardStatsModel>> call(NoParams params) {
    return repository.getDashboard();
  }
}
