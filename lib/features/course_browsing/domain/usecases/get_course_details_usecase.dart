// File: lib/features/course_browsing/domain/usecases/get_course_details_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mizansir/features/course_browsing/data/models/course_model.dart' show CourseModel;
import '../../../../core/error/failures.dart';
 
import '../repositories/course_repository.dart';

/// Parameters for getting course details
class GetCourseDetailsParams extends Equatable {
  final String courseId;

  const GetCourseDetailsParams({required this.courseId});

  @override
  List<Object?> get props => [courseId];
}

/// Get Course Details Use Case
class GetCourseDetailsUseCase {
  final CourseRepository repository;

  const GetCourseDetailsUseCase(this.repository);

  Future<Either<Failure, CourseModel>> call(GetCourseDetailsParams params) {
    return repository.getCourseDetails(params.courseId);
  }
}
