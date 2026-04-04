// File: lib/features/auth/domain/usecases/get_current_user_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/no_params.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// Get current user use case
class GetCurrentUserUseCase extends Equatable {
  final AuthRepository repository;

  const GetCurrentUserUseCase(this.repository);

  @override
  List<Object?> get props => [repository];

  Future<Either<Failure, AuthUser>> call(NoParams params) {
    return repository.getCurrentUser();
  }
}
