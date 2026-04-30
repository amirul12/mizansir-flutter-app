// File: lib/features/course_browsing/presentation/bloc/course_state.dart
import 'package:equatable/equatable.dart';
import 'package:mizansir/features/course_browsing/data/models/course_details_response.dart';
import 'package:mizansir/features/course_browsing/data/models/course_list_response.dart';

import '../../domain/entities/lesson_preview.dart';

/// Base Course State
abstract class CourseState extends Equatable {
  const CourseState();

  @override
  List<Object?> get props => [];
}

/// Initial State
class CourseInitial extends CourseState {
  const CourseInitial();
}

/// Loading State
class CourseLoading extends CourseState {
  const CourseLoading();
}

/// Courses Loaded State
class CoursesLoaded extends CourseState {
  final CourseListResponse courses;
  final bool hasMore;

  const CoursesLoaded({required this.courses, this.hasMore = true});

  @override
  List<Object?> get props => [courses, hasMore];
}

/// Featured Courses Loaded State
class FeaturedCoursesLoaded extends CourseState {
  final CourseListResponse courses;

  const FeaturedCoursesLoaded({required this.courses});

  @override
  List<Object?> get props => [courses];
}

/// Course Details Loaded State
class CourseDetailsLoaded extends CourseState {
  final CourseDetailsResponse course;

  const CourseDetailsLoaded({required this.course});

  @override
  List<Object?> get props => [course];
}

/// Search Results Loaded State
class SearchResultsLoaded extends CourseState {
  final CourseListResponse courses;
  final String query;

  const SearchResultsLoaded({required this.courses, required this.query});

  @override
  List<Object?> get props => [courses, query];
}

/// Categories Loaded State
class CategoriesLoaded extends CourseState {
  final List<dynamic> categories;

  const CategoriesLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

/// Preview Lessons Loaded State
class PreviewLessonsLoaded extends CourseState {
  final List<LessonPreview> lessons;

  const PreviewLessonsLoaded({required this.lessons});

  @override
  List<Object?> get props => [lessons];
}

/// Error State
class CourseError extends CourseState {
  final String message;

  const CourseError({required this.message});

  @override
  List<Object?> get props => [message];
}

/// Empty State
class CourseEmpty extends CourseState {
  final String message;

  const CourseEmpty({this.message = 'No courses found'});

  @override
  List<Object?> get props => [message];
}
