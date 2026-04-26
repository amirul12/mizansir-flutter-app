// File: lib/features/course_browsing/domain/repositories/course_repository.dart
import 'package:dartz/dartz.dart';
import 'package:mizansir/features/course_browsing/data/models/course_model.dart' show CourseModel, Category;
import '../../../../core/error/failures.dart';
 
 
import '../entities/course_filter.dart';
import '../entities/lesson_preview.dart';

/// Course Repository Interface
abstract class CourseRepository {
  /// Get list of courses with optional filters
  Future<Either<Failure, List<CourseModel>>> getCourses({
    CourseFilter? filter,
    int page = 1,
    int limit = 20,
  });

  /// Get featured courses
  Future<Either<Failure, List<CourseModel>>> getFeaturedCourses({
    int limit = 10,
  });

  /// Get course details by ID
  Future<Either<Failure, CourseModel>> getCourseDetails(String courseId);

  /// Search courses by query
  Future<Either<Failure, List<CourseModel>>> searchCourses(
    String query, {
    int page = 1,
    int limit = 20,
  });

  /// Get all categories
  Future<Either<Failure, List<Category>>> getCategories();

  /// Get preview lessons for a course
  Future<Either<Failure, List<LessonPreview>>> getPreviewLessons(
    String courseId,
  );

  /// Check if user is enrolled in a course
  Future<Either<Failure, bool>> isEnrolled(String courseId);
}
