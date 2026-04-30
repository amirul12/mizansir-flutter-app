// File: lib/features/enrollment/domain/repositories/enrollment_repository.dart
import 'package:dartz/dartz.dart';
import 'package:mizansir/features/enrollment/data/models/course_lession_model.dart' show CourseLessonModel;
import 'package:mizansir/features/enrollment/data/models/course_lesson_details_model.dart' show CourseLessonDetailsModel;
import 'package:mizansir/features/enrollment/data/models/my_course_model.dart' show MyCourseModel;
import '../../../../core/error/failures.dart';
import '../../data/models/enrollments_create_model.dart';
import '../../data/models/lesson_model.dart';
 
 
import '../entities/lesson.dart';
import '../entities/course_progress.dart';

/// Enrollment Repository Interface
abstract class EnrollmentRepository {
  /// Get user's enrolled courses
  Future<Either<Failure, List<MyCourseModel>>> getMyCourses();

  /// Get enrolled course details with lessons
  // Future<Either<Failure, EnrolledCourse>> getEnrolledCourseDetails(String courseId);

  /// Get lessons for an enrolled course
  Future<Either<Failure, CourseLessonModel>> getCourseLessons(String courseId);

  /// Get lesson details with navigation
  ///
  /// Returns a map containing:
  /// - 'lesson': The current lesson
  /// - 'nextLessonId': The next lesson ID (nullable)
  /// - 'nextLessonTitle': The next lesson title (nullable)
  Future<Either<Failure, Map<String, dynamic>>> getLessonDetails({
    required String courseId,
    required String lessonId,
  });

  /// Get course progress
  Future<Either<Failure, CourseProgress>> getCourseProgress(String courseId);

  /// Mark lesson as complete
  Future<Either<Failure, void>> markLessonComplete({
    required String courseId,
    required String lessonId,
    int? watchTimeSeconds,
    int? progressPercentage,
  });

  /// Mark lesson as incomplete
  Future<Either<Failure, void>> markLessonIncomplete({
    required String courseId,
    required String lessonId,
  });

  /// Update lesson progress
  Future<Either<Failure, void>> updateLessonProgress({
    required String courseId,
    required String lessonId,
    required int progressPercentage,
    required int watchTimeSeconds,
  });

  /// Create enrollment for a course
  ///
  /// Returns [Right] with enrollment data (success, message, data) on success.
  /// Returns [Left] with [Failure] on failure.
  Future<Either<Failure, EnrollmentsCreateModel>> createEnrollment({
    required String courseId,
    String? paymentMethod,
    String? paymentNotes,
    String? transactionId,
  });
}
