// File: lib/features/auth/domain/usecases/logout_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/no_params.dart';
import '../repositories/auth_repository.dart';

/// Logout use case
class LogoutUseCase extends Equatable {
  final AuthRepository repository;

  const LogoutUseCase(this.repository);

  @override
  List<Object?> get props => [repository];

  Future<Either<Failure, void>> call(NoParams params) {
    return repository.logout();
  }
}
