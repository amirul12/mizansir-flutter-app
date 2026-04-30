// File: lib/features/course_browsing/domain/repositories/course_repository.dart
import 'package:dartz/dartz.dart';
import 'package:mizansir/features/course_browsing/data/models/course_details_response.dart';

import '../../../../core/error/failures.dart';

import '../entities/course_filter.dart';
import '../entities/lesson_preview.dart';
import 'package:mizansir/features/course_browsing/data/models/course_list_response.dart'
    hide Category;

/// Course Repository Interface
abstract class CourseRepository {
  /// Get list of courses with optional filters
  Future<Either<Failure, CourseListResponse>> getCourses({
    CourseFilter? filter,
    int page = 1,
    int limit = 20,
  });

  /// Get featured courses
  Future<Either<Failure, CourseListResponse>> getFeaturedCourses({
    int limit = 10,
  });

  /// Get course details by ID
  Future<Either<Failure, CourseDetailsResponse>> getCourseDetails(String courseId);

  /// Search courses by query
  Future<Either<Failure, CourseListResponse>> searchCourses(
    String query, {
    int page = 1,
    int limit = 20,
  });

  /// Get all categories
  Future<Either<Failure, List<dynamic>>> getCategories();

  /// Get preview lessons for a course
  Future<Either<Failure, List<LessonPreview>>> getPreviewLessons(
    String courseId,
  );

  /// Check if user is enrolled in a course
  Future<Either<Failure, bool>> isEnrolled(String courseId);
}
