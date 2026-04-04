// File: lib/features/enrollment/presentation/bloc/enrollment_state.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/enrolled_course.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/course_progress.dart';

/// Base Enrollment State
abstract class EnrollmentState extends Equatable {
  const EnrollmentState();

  @override
  List<Object?> get props => [];
}

/// Initial State
class EnrollmentInitial extends EnrollmentState {
  const EnrollmentInitial();
}

/// Loading State
class EnrollmentLoading extends EnrollmentState {
  const EnrollmentLoading();
}

/// My Courses Loaded State
class MyCoursesLoaded extends EnrollmentState {
  final List<EnrolledCourse> courses;

  const MyCoursesLoaded({required this.courses});

  @override
  List<Object?> get props => [courses];
}

/// Enrolled Course Details Loaded State
class EnrolledCourseDetailsLoaded extends EnrollmentState {
  final EnrolledCourse course;

  const EnrolledCourseDetailsLoaded({required this.course});

  @override
  List<Object?> get props => [course];
}

/// Course Lessons Loaded State
class CourseLessonsLoaded extends EnrollmentState {
  final List<Lesson> lessons;
  final String courseId;

  const CourseLessonsLoaded({required this.lessons, required this.courseId});

  @override
  List<Object?> get props => [lessons, courseId];
}

/// Lesson Details Loaded State (with navigation)
class LessonDetailsLoaded extends EnrollmentState {
  final Lesson lesson;
  final Lesson? nextLesson;
  final Lesson? previousLesson;

  const LessonDetailsLoaded({
    required this.lesson,
    this.nextLesson,
    this.previousLesson,
  });

  @override
  List<Object?> get props => [lesson, nextLesson, previousLesson];
}

/// Lesson Loading State
class LessonLoading extends EnrollmentState {
  const LessonLoading();
}

/// Course Progress Loaded State
class CourseProgressLoaded extends EnrollmentState {
  final CourseProgress progress;

  const CourseProgressLoaded({required this.progress});

  @override
  List<Object?> get props => [progress];
}

/// Lesson Completed State
class LessonCompleted extends EnrollmentState {
  final String courseId;
  final String lessonId;

  const LessonCompleted({required this.courseId, required this.lessonId});

  @override
  List<Object?> get props => [courseId, lessonId];
}

/// Error State
class EnrollmentError extends EnrollmentState {
  final String message;

  const EnrollmentError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Empty State
class EnrollmentEmpty extends EnrollmentState {
  final String message;

  const EnrollmentEmpty({this.message = 'No enrolled courses found'});

  @override
  List<Object?> get props => [message];
}
