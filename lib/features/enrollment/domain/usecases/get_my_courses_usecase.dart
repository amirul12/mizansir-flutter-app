// File: lib/features/enrollment/domain/usecases/get_my_courses_usecase.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/enrolled_course.dart';
import '../repositories/enrollment_repository.dart';

/// Get My Courses Use Case
class GetMyCoursesUseCase {
  final EnrollmentRepository repository;

  const GetMyCoursesUseCase(this.repository);

  Future<Either<Failure, List<EnrolledCourse>>> call() {
    return repository.getMyCourses();
  }
}
