// File: lib/features/course_browsing/data/datasources/course_remote_datasource.dart
 
import 'package:mizansir/features/course_browsing/data/models/course_details_response.dart';
import 'package:mizansir/features/course_browsing/data/models/course_list_response.dart';

 
 
import '../models/lesson_preview_model.dart';

/// Course Remote Data Source Interface
abstract class CourseRemoteDataSource {
  /// Get list of courses
  Future<CourseListResponse> getCourses({
    Map<String, dynamic>? queryParams,
    int page = 1,
    int limit = 20,
  });

  /// Get featured courses
  Future<CourseListResponse> getFeaturedCourses({int limit = 10});

  /// Get course details by ID
  Future<CourseDetailsResponse> getCourseDetails(String courseId);

  /// Search courses
  Future<CourseListResponse> searchCourses(
    String query, {
    int page = 1,
    int limit = 20,
  });

  /// Get all categories
  Future<List<dynamic>> getCategories();

  /// Get preview lessons for a course
  Future<List<LessonPreviewModel>> getPreviewLessons(String courseId);

  /// Check if user is enrolled in a course
  Future<bool> isEnrolled(String courseId);
}
