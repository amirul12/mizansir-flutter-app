// File: lib/features/course_browsing/data/datasources/course_remote_datasource.dart
 
import '../models/course_model.dart';
import '../models/category_model.dart';
import '../models/lesson_preview_model.dart';

/// Course Remote Data Source Interface
abstract class CourseRemoteDataSource {
  /// Get list of courses
  Future<List<CourseModel>> getCourses({
    Map<String, dynamic>? queryParams,
    int page = 1,
    int limit = 20,
  });

  /// Get featured courses
  Future<List<CourseModel>> getFeaturedCourses({int limit = 10});

  /// Get course details by ID
  Future<CourseModel> getCourseDetails(String courseId);

  /// Search courses
  Future<List<CourseModel>> searchCourses(
    String query, {
    int page = 1,
    int limit = 20,
  });

  /// Get all categories
  Future<List<CategoryModel>> getCategories();

  /// Get preview lessons for a course
  Future<List<LessonPreviewModel>> getPreviewLessons(String courseId);

  /// Check if user is enrolled in a course
  Future<bool> isEnrolled(String courseId);
}
