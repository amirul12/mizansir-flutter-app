import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/profile_repository.dart';

/// Change password use case parameters.
class ChangePasswordParams extends Equatable {
  final String currentPassword;
  final String newPassword;

  const ChangePasswordParams({
    required this.currentPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [currentPassword, newPassword];
}

/// Change password use case.
///
/// Changes the user's password.
class ChangePasswordUseCase {
  final ProfileRepository repository;

  ChangePasswordUseCase(this.repository);

  /// Execute the use case.
  ///
  /// [params] contains the current and new passwords.
  ///
  /// Returns [Right] with void on success.
  /// Returns [Left] with [Failure] on failure.
  Future<Either<Failure, void>> call(ChangePasswordParams params) {
    return repository.changePassword(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
    );
  }
}
