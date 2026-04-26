// File: lib/features/course_browsing/domain/usecases/get_courses_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mizansir/features/course_browsing/data/models/course_model.dart';
import '../../../../core/error/failures.dart';
 
import '../entities/course_filter.dart';
import '../repositories/course_repository.dart';

/// Parameters for getting courses
class GetCoursesParams extends Equatable {
  final CourseFilter? filter;
  final int page;
  final int limit;

  const GetCoursesParams({
    this.filter,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [filter, page, limit];
}

/// Get Courses Use Case
class GetCoursesUseCase {
  final CourseRepository repository;

  const GetCoursesUseCase(this.repository);

  Future<Either<Failure, List<CourseModel>>> call(GetCoursesParams params) {
    return repository.getCourses(
      filter: params.filter,
      page: params.page,
      limit: params.limit,
    );
  }
}
