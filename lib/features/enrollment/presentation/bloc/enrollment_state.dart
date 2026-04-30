// File: lib/features/enrollment/presentation/bloc/enrollment_state.dart
import 'package:equatable/equatable.dart';
import 'package:mizansir/features/enrollment/data/models/course_lession_model.dart'
    show
        CourseLessonModel,
        Lesson;
import 'package:mizansir/features/enrollment/data/models/course_lesson_details_model.dart'
    show CourseLessonDetailsModel;
import 'package:mizansir/features/enrollment/data/models/enrollments_create_model.dart' show EnrollmentsCreateModel;
 
 
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
  final List<dynamic> courses; // Can be List<MyCourseEntity> or List<EnrolledCourse>

  const MyCoursesLoaded({required this.courses});

  @override
  List<Object?> get props => [courses];
}

/// Enrolled Course Details Loaded State
// class EnrolledCourseDetailsLoaded extends EnrollmentState {
//   final EnrolledCourse course;

//   const EnrolledCourseDetailsLoaded({required this.course});

//   @override
//   List<Object?> get props => [course];
// }

/// Course Lessons Loaded State
class CourseLessonsLoaded extends EnrollmentState {
  final CourseLessonModel courseLessons;
  final String courseId;

  const CourseLessonsLoaded({
    required this.courseLessons,
    required this.courseId,
  });

  @override
  List<Object?> get props => [courseLessons, courseId];
}

/// Lesson Details Loaded State (with navigation)
class LessonDetailsLoaded extends EnrollmentState {
  final CourseLessonDetailsModel lesson;
  final String? nextLessonId;
  final String? nextLessonTitle;
  final String? previousLessonId;
  final String? previousLessonTitle;

  const LessonDetailsLoaded({
    required this.lesson,
    this.nextLessonId,
    this.nextLessonTitle,
    this.previousLessonId,
    this.previousLessonTitle,
  });

  @override
  List<Object?> get props => [lesson, nextLessonId, nextLessonTitle, previousLessonId, previousLessonTitle];
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

/// Enrollment Created State
class EnrollmentCreated extends EnrollmentState {
  final EnrollmentsCreateModel enrollmentData;

  const EnrollmentCreated({required this.enrollmentData});

  @override
  List<Object?> get props => [enrollmentData];
}

/// Already Enrolled State
class AlreadyEnrolled extends EnrollmentState {
  final String message;

  const AlreadyEnrolled({this.message = 'You already have an active enrollment for this course'});

  @override
  List<Object?> get props => [message];
}
