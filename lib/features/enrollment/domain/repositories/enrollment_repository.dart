// File: lib/features/enrollment/domain/repositories/enrollment_repository.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/enrolled_course.dart';
import '../entities/my_course_entity.dart';
import '../entities/lesson.dart';
import '../entities/course_progress.dart';

/// Enrollment Repository Interface
abstract class EnrollmentRepository {
  /// Get user's enrolled courses
  Future<Either<Failure, List<MyCourseEntity>>> getMyCourses();

  /// Get enrolled course details with lessons
  Future<Either<Failure, EnrolledCourse>> getEnrolledCourseDetails(String courseId);

  /// Get lessons for an enrolled course
  Future<Either<Failure, List<Lesson>>> getCourseLessons(String courseId);

  /// Get lesson details with navigation
  ///
  /// Returns a map containing:
  /// - 'lesson': The current lesson
  /// - 'nextLesson': The next lesson (nullable)
  /// - 'previousLesson': The previous lesson (nullable)
  Future<Either<Failure, Map<String, Lesson?>>> getLessonDetails({
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
  Future<Either<Failure, Map<String, dynamic>>> createEnrollment({
    required String courseId,
    required String paymentMethod,
    String? paymentNotes,
    String? transactionId,
  });
}
