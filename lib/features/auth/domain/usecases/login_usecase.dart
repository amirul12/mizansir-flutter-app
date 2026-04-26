// File: lib/features/auth/domain/usecases/login_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

/// Login use case
class LoginUseCase extends Equatable {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  @override
  List<Object?> get props => [repository];

  Future<Either<Failure, AuthUser>> call(LoginParams params) {
    return repository.login(
      email: params.email,
      password: params.password,
      deviceName: params.deviceName,
    );
  }
}

/// Login parameters
class LoginParams extends Equatable {
  final String email;
  final String password;
  final String deviceName;

  const LoginParams({
    required this.email,
    required this.password,
    required this.deviceName,
  });

  @override
  List<Object?> get props => [email, password, deviceName];
}
