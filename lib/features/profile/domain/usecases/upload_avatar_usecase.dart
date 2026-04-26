import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Upload avatar use case parameters.
class UploadAvatarParams extends Equatable {
  final String imagePath;

  const UploadAvatarParams({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

/// Upload avatar use case.
///
/// Uploads a new avatar image for the user.
class UploadAvatarUseCase {
  final ProfileRepository repository;

  UploadAvatarUseCase(this.repository);

  /// Execute the use case.
  ///
  /// [params] contains the local path to the image file.
  ///
  /// Returns [Right] with updated [UserProfile] on success.
  /// Returns [Left] with [Failure] on failure.
  Future<Either<Failure, UserProfile>> call(UploadAvatarParams params) {
    return repository.uploadAvatar(params.imagePath);
  }
}
