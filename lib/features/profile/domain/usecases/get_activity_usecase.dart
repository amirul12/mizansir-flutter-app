import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/activity.dart';
import '../repositories/dashboard_repository.dart';

/// Get activity use case parameters.
class GetActivityParams extends Equatable {
  final int page;
  final int limit;

  const GetActivityParams({
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [page, limit];
}

/// Get activity use case.
///
/// Retrieves user activity history.
class GetActivityUseCase {
  final DashboardRepository repository;

  GetActivityUseCase(this.repository);

  /// Execute the use case.
  ///
  /// [params] contains pagination parameters.
  ///
  /// Returns [Right] with List of [Activity] on success.
  /// Returns [Left] with [Failure] on failure.
  Future<Either<Failure, List<Activity>>> call(GetActivityParams params) {
    return repository.getActivity(
      page: params.page,
      limit: params.limit,
    );
  }
}
