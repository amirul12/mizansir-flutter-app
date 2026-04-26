import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/no_params.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Get profile use case.
///
/// Retrieves the current user's profile information.
class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  /// Execute the use case.
  ///
  /// Returns [Right] with [UserProfile] on success.
  /// Returns [Left] with [Failure] on failure.
  Future<Either<Failure, UserProfile>> call(NoParams params) {
    return repository.getProfile();
  }
}
