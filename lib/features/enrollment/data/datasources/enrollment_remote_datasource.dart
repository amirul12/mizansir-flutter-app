// File: lib/features/enrollment/data/datasources/enrollment_remote_datasource.dart
import '../models/enrolled_course_model.dart';
import '../models/my_course_model.dart';
import '../models/lesson_model.dart';
import '../models/course_progress_model.dart';

/// Enrollment Remote Data Source Interface
abstract class EnrollmentRemoteDataSource {
  /// Get user's enrolled courses
  Future<List<MyCourseModel>> getMyCourses();

  /// Get enrolled course details with lessons
  Future<EnrolledCourseModel> getEnrolledCourseDetails(String courseId);

  /// Get lessons for an enrolled course
  Future<List<LessonModel>> getCourseLessons(String courseId);

  /// Get lesson details with navigation
  ///
  /// Returns a map containing:
  /// - 'lesson': The current lesson
  /// - 'nextLesson': The next lesson (nullable)
  /// - 'previousLesson': The previous lesson (nullable)
  Future<Map<String, LessonModel?>> getLessonDetails({
    required String courseId,
    required String lessonId,
  });

  /// Get course progress
  Future<CourseProgressModel> getCourseProgress(String courseId);

  /// Mark lesson as complete
  Future<void> markLessonComplete({
    required String courseId,
    required String lessonId,
    int? watchTimeSeconds,
    int? progressPercentage,
  });

  /// Mark lesson as incomplete
  Future<void> markLessonIncomplete({
    required String courseId,
    required String lessonId,
  });

  /// Update lesson progress
  Future<void> updateLessonProgress({
    required String courseId,
    required String lessonId,
    required int progressPercentage,
    required int watchTimeSeconds,
  });

  /// Create enrollment for a course
  Future<Map<String, dynamic>> createEnrollment({
    required String courseId,
    String? paymentMethod,
    String? paymentNotes,
    String? transactionId,
  });
}
