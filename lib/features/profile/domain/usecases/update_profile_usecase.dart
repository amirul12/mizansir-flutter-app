import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user_profile.dart';
import '../repositories/profile_repository.dart';

/// Update profile use case parameters.
class UpdateProfileParams extends Equatable {
  final String? name;
  final String? phone;
  final String? collegeName;
  final String? address;

  const UpdateProfileParams({
    this.name,
    this.phone,
    this.collegeName,
    this.address,
  });

  @override
  List<Object?> get props => [name, phone, collegeName, address];
}

/// Update profile use case.
///
/// Updates the user's profile information.
class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  /// Execute the use case.
  ///
  /// [params] contains the fields to update.
  ///
  /// Returns [Right] with updated [UserProfile] on success.
  /// Returns [Left] with [Failure] on failure.
  Future<Either<Failure, UserProfile>> call(UpdateProfileParams params) {
    final updateData = <String, dynamic>{};

    if (params.name != null) updateData['name'] = params.name;
    if (params.phone != null) updateData['phone'] = params.phone;
    if (params.collegeName != null) updateData['college_name'] = params.collegeName;
    if (params.address != null) updateData['address'] = params.address;

    return repository.updateProfile(updateData);
  }
}
