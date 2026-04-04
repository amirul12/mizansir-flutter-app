// File: lib/features/course_browsing/presentation/bloc/course_event.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/course_filter.dart';

/// Base Course Event
abstract class CourseEvent extends Equatable {
  const CourseEvent();

  @override
  List<Object?> get props => [];
}

/// Load Courses Event
class LoadCoursesEvent extends CourseEvent {
  final CourseFilter? filter;
  final int page;
  final int limit;

  const LoadCoursesEvent({
    this.filter,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [filter, page, limit];
}

/// Load Featured Courses Event
class LoadFeaturedCoursesEvent extends CourseEvent {
  final int limit;

  const LoadFeaturedCoursesEvent({this.limit = 10});

  @override
  List<Object?> get props => [limit];
}

/// Load Course Details Event
class LoadCourseDetailsEvent extends CourseEvent {
  final String courseId;

  const LoadCourseDetailsEvent({required this.courseId});

  @override
  List<Object?> get props => [courseId];
}

/// Search Courses Event
class SearchCoursesEvent extends CourseEvent {
  final String query;
  final int page;
  final int limit;

  const SearchCoursesEvent({
    required this.query,
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [query, page, limit];
}

/// Load Categories Event
class LoadCategoriesEvent extends CourseEvent {
  const LoadCategoriesEvent();
}

/// Load Preview Lessons Event
class LoadPreviewLessonsEvent extends CourseEvent {
  final String courseId;

  const LoadPreviewLessonsEvent({required this.courseId});

  @override
  List<Object?> get props => [courseId];
}

/// Clear Error Event
class ClearCourseErrorEvent extends CourseEvent {
  const ClearCourseErrorEvent();
}
