// File: lib/features/enrollment/domain/usecases/get_course_lessons_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/lesson.dart';
import '../repositories/enrollment_repository.dart';

/// Parameters for getting course lessons
class GetCourseLessonsParams extends Equatable {
  final String courseId;

  const GetCourseLessonsParams({required this.courseId});

  @override
  List<Object?> get props => [courseId];
}

/// Get Course Lessons Use Case
class GetCourseLessonsUseCase {
  final EnrollmentRepository repository;

  const GetCourseLessonsUseCase(this.repository);

  Future<Either<Failure, List<Lesson>>> call(GetCourseLessonsParams params) {
    return repository.getCourseLessons(params.courseId);
  }
}
