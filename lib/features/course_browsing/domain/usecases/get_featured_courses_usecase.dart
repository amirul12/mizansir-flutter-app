// File: lib/features/course_browsing/domain/usecases/get_featured_courses_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mizansir/features/course_browsing/data/models/course_list_response.dart' show CourseListResponse;
 
import '../../../../core/error/failures.dart';
 
import '../repositories/course_repository.dart';

/// Parameters for getting featured courses
class GetFeaturedCoursesParams extends Equatable {
  final int limit;

  const GetFeaturedCoursesParams({this.limit = 10});

  @override
  List<Object?> get props => [limit];
}

/// Get Featured Courses Use Case
class GetFeaturedCoursesUseCase {
  final CourseRepository repository;

  const GetFeaturedCoursesUseCase(this.repository);

  Future<Either<Failure, CourseListResponse>> call(
      GetFeaturedCoursesParams params) {
    return repository.getFeaturedCourses(limit: params.limit);
  }
}
