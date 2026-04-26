// File: lib/features/enrollment/domain/usecases/get_my_courses_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:mizansir/features/enrollment/data/models/my_course_model.dart' show MyCourseModel;
import '../../../../core/error/failures.dart';
 
import '../repositories/enrollment_repository.dart';

/// Get My Courses Use Case
class GetMyCoursesUseCase {
  final EnrollmentRepository repository;

  const GetMyCoursesUseCase(this.repository);

  Future<Either<Failure, List<MyCourseModel>>> call() {
    return repository.getMyCourses();
  }
}
