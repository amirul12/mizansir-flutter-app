import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/no_params.dart';
import '../entities/dashboard_stats.dart';
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
  Future<Either<Failure, DashboardStats>> call(NoParams params) {
    return repository.getDashboard();
  }
}
