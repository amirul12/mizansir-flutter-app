// File: lib/features/enrollment/domain/usecases/get_course_progress_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/course_progress.dart';
import '../repositories/enrollment_repository.dart';

/// Parameters for getting course progress
class GetCourseProgressParams extends Equatable {
  final String courseId;

  const GetCourseProgressParams({required this.courseId});

  @override
  List<Object?> get props => [courseId];
}

/// Get Course Progress Use Case
class GetCourseProgressUseCase {
  final EnrollmentRepository repository;

  const GetCourseProgressUseCase(this.repository);

  Future<Either<Failure, CourseProgress>> call(GetCourseProgressParams params) {
    return repository.getCourseProgress(params.courseId);
  }
}
