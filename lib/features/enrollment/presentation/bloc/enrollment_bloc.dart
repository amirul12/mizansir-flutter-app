// File: lib/features/enrollment/presentation/bloc/enrollment_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_my_courses_usecase.dart';
import '../../domain/usecases/get_enrolled_course_details_usecase.dart';
import '../../domain/usecases/get_course_lessons_usecase.dart';
import '../../domain/usecases/get_course_progress_usecase.dart';
import '../../domain/usecases/mark_lesson_complete_usecase.dart';
import '../../domain/usecases/get_lesson_details_usecase.dart';
import 'enrollment_event.dart';
import 'enrollment_state.dart';

/// Enrollment BLoC
class EnrollmentBloc extends Bloc<EnrollmentEvent, EnrollmentState> {
  final GetMyCoursesUseCase getMyCoursesUseCase;
  final GetEnrolledCourseDetailsUseCase getEnrolledCourseDetailsUseCase;
  final GetCourseLessonsUseCase getCourseLessonsUseCase;
  final GetCourseProgressUseCase getCourseProgressUseCase;
  final MarkLessonCompleteUseCase markLessonCompleteUseCase;
  final GetLessonDetailsUseCase getLessonDetailsUseCase;

  EnrollmentBloc({
    required this.getMyCoursesUseCase,
    required this.getEnrolledCourseDetailsUseCase,
    required this.getCourseLessonsUseCase,
    required this.getCourseProgressUseCase,
    required this.markLessonCompleteUseCase,
    required this.getLessonDetailsUseCase,
  }) : super(EnrollmentInitial()) {
    on<LoadMyCoursesEvent>(_onLoadMyCourses);
    on<LoadEnrolledCourseDetailsEvent>(_onLoadCourseDetails);
    on<LoadCourseLessonsEvent>(_onLoadCourseLessons);
    on<LoadCourseProgressEvent>(_onLoadCourseProgress);
    on<MarkLessonCompleteEvent>(_onMarkLessonComplete);
    on<MarkLessonIncompleteEvent>(_onMarkLessonIncomplete);
    on<GetLessonDetailsEvent>(_onGetLessonDetails);
    on<ClearEnrollmentErrorEvent>(_onClearError);
  }

  Future<void> _onLoadMyCourses(
    LoadMyCoursesEvent event,
    Emitter<EnrollmentState> emit,
  ) async {
    emit(const EnrollmentLoading());

    final result = await getMyCoursesUseCase();

    result.fold(
      (failure) => emit(EnrollmentError(message: _getErrorMessage(failure))),
      (courses) {
        if (courses.isEmpty) {
          return emit(
            const EnrollmentEmpty(message: 'No enrolled courses yet'),
          );
        }
        return emit(MyCoursesLoaded(courses: courses));
      },
    );
  }

  Future<void> _onLoadCourseDetails(
    LoadEnrolledCourseDetailsEvent event,
    Emitter<EnrollmentState> emit,
  ) async {
    emit(const EnrollmentLoading());

    final result = await getEnrolledCourseDetailsUseCase(
      GetEnrolledCourseDetailsParams(courseId: event.courseId),
    );

    result.fold(
      (failure) => emit(EnrollmentError(message: _getErrorMessage(failure))),
      (course) => emit(EnrolledCourseDetailsLoaded(course: course)),
    );
  }

  Future<void> _onLoadCourseLessons(
    LoadCourseLessonsEvent event,
    Emitter<EnrollmentState> emit,
  ) async {
    emit(const EnrollmentLoading());

    final result = await getCourseLessonsUseCase(
      GetCourseLessonsParams(courseId: event.courseId),
    );

    result.fold(
      (failure) => emit(EnrollmentError(message: _getErrorMessage(failure))),
      (lessons) {
        if (lessons.isEmpty) {
          return emit(const EnrollmentEmpty(message: 'No lessons found'));
        }
        return emit(
          CourseLessonsLoaded(lessons: lessons, courseId: event.courseId),
        );
      },
    );
  }

  Future<void> _onLoadCourseProgress(
    LoadCourseProgressEvent event,
    Emitter<EnrollmentState> emit,
  ) async {
    emit(const EnrollmentLoading());

    final result = await getCourseProgressUseCase(
      GetCourseProgressParams(courseId: event.courseId),
    );

    result.fold(
      (failure) => emit(EnrollmentError(message: _getErrorMessage(failure))),
      (progress) => emit(CourseProgressLoaded(progress: progress)),
    );
  }

  Future<void> _onMarkLessonComplete(
    MarkLessonCompleteEvent event,
    Emitter<EnrollmentState> emit,
  ) async {
    emit(const EnrollmentLoading());

    final result = await markLessonCompleteUseCase(
      MarkLessonCompleteParams(
        courseId: event.courseId,
        lessonId: event.lessonId,
        watchTimeSeconds: event.watchTimeSeconds,
        progressPercentage: event.progressPercentage,
      ),
    );

    result.fold(
      (failure) => emit(EnrollmentError(message: _getErrorMessage(failure))),
      (_) => emit(
        LessonCompleted(courseId: event.courseId, lessonId: event.lessonId),
      ),
    );
  }

  Future<void> _onMarkLessonIncomplete(
    MarkLessonIncompleteEvent event,
    Emitter<EnrollmentState> emit,
  ) async {
    // For now, we'll treat marking incomplete as loading the course details again
    // You could implement a separate use case if needed
    add(LoadEnrolledCourseDetailsEvent(courseId: event.courseId));
  }

  Future<void> _onGetLessonDetails(
    GetLessonDetailsEvent event,
    Emitter<EnrollmentState> emit,
  ) async {
    emit(const LessonLoading());

    final result = await getLessonDetailsUseCase(
      GetLessonDetailsParams(
        courseId: event.courseId,
        lessonId: event.lessonId,
      ),
    );

    result.fold(
      (failure) => emit(EnrollmentError(message: _getErrorMessage(failure))),
      (lessonsMap) => emit(
        LessonDetailsLoaded(
          lesson: lessonsMap['lesson']!,
          nextLesson: lessonsMap['nextLesson'],
          previousLesson: lessonsMap['previousLesson'],
        ),
      ),
    );
  }

  Future<void> _onClearError(
    ClearEnrollmentErrorEvent event,
    Emitter<EnrollmentState> emit,
  ) async {
    if (state is EnrollmentError) {
      emit(const EnrollmentInitial());
    }
  }

  String _getErrorMessage(dynamic failure) {
    switch (failure.runtimeType.toString()) {
      case 'NetworkFailure':
        return 'Please check your internet connection and try again.';
      case 'UnauthorizedFailure':
        return 'Please login to access this feature.';
      case 'NotFoundFailure':
        return 'The requested resource was not found.';
      case 'ServerFailure':
        return 'Server error. Please try again later.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
