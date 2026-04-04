import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/profile_repository.dart';

/// Delete account use case parameters.
class DeleteAccountParams extends Equatable {
  final String password;

  const DeleteAccountParams({required this.password});

  @override
  List<Object?> get props => [password];
}

/// Delete account use case.
///
/// Permanently deletes the user's account.
class DeleteAccountUseCase {
  final ProfileRepository repository;

  DeleteAccountUseCase(this.repository);

  /// Execute the use case.
  ///
  /// [params] contains the password for confirmation.
  ///
  /// Returns [Right] with void on success.
  /// Returns [Left] with [Failure] on failure.
  Future<Either<Failure, void>> call(DeleteAccountParams params) {
    return repository.deleteAccount(params.password);
  }
}
