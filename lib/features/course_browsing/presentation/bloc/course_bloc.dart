// File: lib/features/course_browsing/presentation/bloc/course_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/no_params.dart';
import '../../domain/usecases/get_courses_usecase.dart';
import '../../domain/usecases/get_featured_courses_usecase.dart';
import '../../domain/usecases/get_course_details_usecase.dart';
import '../../domain/usecases/search_courses_usecase.dart';
import '../../domain/usecases/get_categories_usecase.dart';
import '../../domain/usecases/get_preview_lessons_usecase.dart';
import 'course_event.dart';
import 'course_state.dart';

/// Course BLoC
class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final GetCoursesUseCase getCoursesUseCase;
  final GetFeaturedCoursesUseCase getFeaturedCoursesUseCase;
  final GetCourseDetailsUseCase getCourseDetailsUseCase;
  final SearchCoursesUseCase searchCoursesUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetPreviewLessonsUseCase getPreviewLessonsUseCase;

  CourseBloc({
    required this.getCoursesUseCase,
    required this.getFeaturedCoursesUseCase,
    required this.getCourseDetailsUseCase,
    required this.searchCoursesUseCase,
    required this.getCategoriesUseCase,
    required this.getPreviewLessonsUseCase,
  }) : super(CourseInitial()) {
    on<LoadCoursesEvent>(_onLoadCourses);
    on<LoadFeaturedCoursesEvent>(_onLoadFeaturedCourses);
    on<LoadCourseDetailsEvent>(_onLoadCourseDetails);
    on<SearchCoursesEvent>(_onSearchCourses);
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<LoadPreviewLessonsEvent>(_onLoadPreviewLessons);
    on<ClearCourseErrorEvent>(_onClearError);
  }

  Future<void> _onLoadCourses(
    LoadCoursesEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(const CourseLoading());

    final result = await getCoursesUseCase(
      GetCoursesParams(
        filter: event.filter,
        page: event.page,
        limit: event.limit,
      ),
    );

    result.fold(
      (failure) => emit(CourseError(message: _getErrorMessage(failure))),
      (courses) {
        if (courses.isEmpty) {
          return emit(const CourseEmpty(message: 'No courses found'));
        }
        // Check if there might be more courses
        final hasMore = courses.length >= event.limit;
        return emit(CoursesLoaded(courses: courses, hasMore: hasMore));
      },
    );
  }

  Future<void> _onLoadFeaturedCourses(
    LoadFeaturedCoursesEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(const CourseLoading());

    final result = await getFeaturedCoursesUseCase(
      GetFeaturedCoursesParams(limit: event.limit),
    );

    result.fold(
      (failure) => emit(CourseError(message: _getErrorMessage(failure))),
      (courses) {
        if (courses.isEmpty) {
          return emit(const CourseEmpty(message: 'No featured courses available'));
        }
        return emit(FeaturedCoursesLoaded(courses: courses));
      },
    );
  }

  Future<void> _onLoadCourseDetails(
    LoadCourseDetailsEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(const CourseLoading());

    final result = await getCourseDetailsUseCase(
      GetCourseDetailsParams(courseId: event.courseId),
    );

    result.fold(
      (failure) => emit(CourseError(message: _getErrorMessage(failure))),
      (course) => emit(CourseDetailsLoaded(course: course)),
    );
  }

  Future<void> _onSearchCourses(
    SearchCoursesEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(const CourseLoading());

    final result = await searchCoursesUseCase(
      SearchCoursesParams(
        query: event.query,
        page: event.page,
        limit: event.limit,
      ),
    );

    result.fold(
      (failure) => emit(CourseError(message: _getErrorMessage(failure))),
      (courses) {
        if (courses.isEmpty) {
          return emit(CourseEmpty(
            message: 'No results found for "${event.query}"',
          ));
        }
        return emit(SearchResultsLoaded(courses: courses, query: event.query));
      },
    );
  }

  Future<void> _onLoadCategories(
    LoadCategoriesEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(const CourseLoading());

    final result = await getCategoriesUseCase(NoParams());

    result.fold(
      (failure) => emit(CourseError(message: _getErrorMessage(failure))),
      (categories) {
        if (categories.isEmpty) {
          return emit(const CourseEmpty(message: 'No categories available'));
        }
        return emit(CategoriesLoaded(categories: categories));
      },
    );
  }

  Future<void> _onLoadPreviewLessons(
    LoadPreviewLessonsEvent event,
    Emitter<CourseState> emit,
  ) async {
    emit(const CourseLoading());

    final result = await getPreviewLessonsUseCase(
      GetPreviewLessonsParams(courseId: event.courseId),
    );

    result.fold(
      (failure) => emit(CourseError(message: _getErrorMessage(failure))),
      (lessons) {
        if (lessons.isEmpty) {
          return emit(const CourseEmpty(message: 'No preview lessons available'));
        }
        return emit(PreviewLessonsLoaded(lessons: lessons));
      },
    );
  }

  Future<void> _onClearError(
    ClearCourseErrorEvent event,
    Emitter<CourseState> emit,
  ) async {
    if (state is CourseError) {
      emit(const CourseInitial());
    }
  }

  String _getErrorMessage(dynamic failure) {
    // Map failure types to user-friendly messages
    switch (failure.runtimeType.toString()) {
      case 'NetworkFailure':
        return 'Please check your internet connection and try again.';
      case 'UnauthorizedFailure':
        return 'Please login to access this feature.';
      case 'NotFoundFailure':
        return 'The requested resource was not found.';
      case 'ServerFailure':
        return 'Server error. Please try again later.';
      case 'CacheFailure':
        return 'Local storage error. Please restart the app.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
