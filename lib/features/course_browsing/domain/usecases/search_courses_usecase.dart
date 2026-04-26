// File: lib/features/course_browsing/domain/usecases/search_courses_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mizansir/features/course_browsing/data/models/course_model.dart' show CourseModel;
import '../../../../core/error/failures.dart';
 
import '../repositories/course_repository.dart';

/// Parameters for searching courses
class SearchCoursesParams extends Equatable {
  final String query;
  final int page;
  final int limit;

  const SearchCoursesParams({
    required this.query,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [query, page, limit];
}

/// Search Courses Use Case
class SearchCoursesUseCase {
  final CourseRepository repository;

  const SearchCoursesUseCase(this.repository);

  Future<Either<Failure, List<CourseModel>>> call(SearchCoursesParams params) {
    return repository.searchCourses(
      params.query,
      page: params.page,
      limit: params.limit,
    );
  }
}
