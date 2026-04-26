// File: lib/features/enrollment/domain/usecases/get_enrolled_course_details_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/enrolled_course.dart';
import '../repositories/enrollment_repository.dart';

/// Parameters for getting enrolled course details
class GetEnrolledCourseDetailsParams extends Equatable {
  final String courseId;

  const GetEnrolledCourseDetailsParams({required this.courseId});

  @override
  List<Object?> get props => [courseId];
}

/// Get Enrolled Course Details Use Case
class GetEnrolledCourseDetailsUseCase {
  final EnrollmentRepository repository;

  const GetEnrolledCourseDetailsUseCase(this.repository);

  Future<Either<Failure, EnrolledCourse>> call(GetEnrolledCourseDetailsParams params) {
    return repository.getEnrolledCourseDetails(params.courseId);
  }
}
