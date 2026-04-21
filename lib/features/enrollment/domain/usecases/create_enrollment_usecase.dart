// File: lib/features/enrollment/domain/usecases/create_enrollment_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/enrollment_repository.dart';

/// Parameters for creating enrollment
class CreateEnrollmentParams {
  final String courseId;
  final String paymentMethod;
  final String? paymentNotes;
  final String? transactionId;

  const CreateEnrollmentParams({
    required this.courseId,
    required this.paymentMethod,
    this.paymentNotes,
    this.transactionId,
  });
}

/// Create Enrollment Use Case
class CreateEnrollmentUseCase {
  final EnrollmentRepository repository;

  CreateEnrollmentUseCase(this.repository);

  /// Execute use case
  ///
  /// Returns [Right] with enrollment data on success.
  /// Returns [Left] with [Failure] on failure.
  Future<Either<Failure, Map<String, dynamic>>> call(CreateEnrollmentParams params) {
    return repository.createEnrollment(
      courseId: params.courseId,
      paymentMethod: params.paymentMethod,
      paymentNotes: params.paymentNotes,
      transactionId: params.transactionId,
    );
  }
}
