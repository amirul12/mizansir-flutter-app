// File: lib/features/enrollment/presentation/bloc/enrollment_event.dart
import 'package:equatable/equatable.dart';

/// Base Enrollment Event
abstract class EnrollmentEvent extends Equatable {
  const EnrollmentEvent();

  @override
  List<Object?> get props => [];
}

/// Load My Courses Event
class LoadMyCoursesEvent extends EnrollmentEvent {
  const LoadMyCoursesEvent();
}

/// Load Enrolled Course Details Event
class LoadEnrolledCourseDetailsEvent extends EnrollmentEvent {
  final String courseId;

  const LoadEnrolledCourseDetailsEvent({required this.courseId});

  @override
  List<Object?> get props => [courseId];
}

/// Load Course Lessons Event
class LoadCourseLessonsEvent extends EnrollmentEvent {
  final String courseId;

  const LoadCourseLessonsEvent({required this.courseId});

  @override
  List<Object?> get props => [courseId];
}

/// Load Course Progress Event
class LoadCourseProgressEvent extends EnrollmentEvent {
  final String courseId;

  const LoadCourseProgressEvent({required this.courseId});

  @override
  List<Object?> get props => [courseId];
}

/// Mark Lesson Complete Event
class MarkLessonCompleteEvent extends EnrollmentEvent {
  final String courseId;
  final String lessonId;
  final int? watchTimeSeconds;
  final int? progressPercentage;

  const MarkLessonCompleteEvent({
    required this.courseId,
    required this.lessonId,
    this.watchTimeSeconds,
    this.progressPercentage,
  });

  @override
  List<Object?> get props => [courseId, lessonId, watchTimeSeconds, progressPercentage];
}

/// Mark Lesson Incomplete Event
class MarkLessonIncompleteEvent extends EnrollmentEvent {
  final String courseId;
  final String lessonId;

  const MarkLessonIncompleteEvent({
    required this.courseId,
    required this.lessonId,
  });

  @override
  List<Object?> get props => [courseId, lessonId];
}

/// Clear Error Event
class ClearEnrollmentErrorEvent extends EnrollmentEvent {
  const ClearEnrollmentErrorEvent();
}
