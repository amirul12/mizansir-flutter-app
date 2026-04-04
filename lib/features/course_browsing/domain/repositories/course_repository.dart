// File: lib/features/course_browsing/domain/repositories/course_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/course.dart';
import '../entities/category.dart';
import '../entities/course_filter.dart';
import '../entities/lesson_preview.dart';

/// Course Repository Interface
abstract class CourseRepository {
  /// Get list of courses with optional filters
  Future<Either<Failure, List<Course>>> getCourses({
    CourseFilter? filter,
    int page = 1,
    int limit = 20,
  });

  /// Get featured courses
  Future<Either<Failure, List<Course>>> getFeaturedCourses({
    int limit = 10,
  });

  /// Get course details by ID
  Future<Either<Failure, Course>> getCourseDetails(String courseId);

  /// Search courses by query
  Future<Either<Failure, List<Course>>> searchCourses(
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
