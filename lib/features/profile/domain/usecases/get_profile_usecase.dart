import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/no_params.dart';
 
import '../../data/models/user_profile_model.dart';
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
  Future<Either<Failure, UserProfileModel>> call(NoParams params) {
    return repository.getProfile();
  }
}
