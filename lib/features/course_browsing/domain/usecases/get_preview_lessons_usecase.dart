// File: lib/features/course_browsing/domain/usecases/get_preview_lessons_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/lesson_preview.dart';
import '../repositories/course_repository.dart';

/// Parameters for getting preview lessons
class GetPreviewLessonsParams extends Equatable {
  final String courseId;

  const GetPreviewLessonsParams({required this.courseId});

  @override
  List<Object?> get props => [courseId];
}

/// Get Preview Lessons Use Case
class GetPreviewLessonsUseCase {
  final CourseRepository repository;

  const GetPreviewLessonsUseCase(this.repository);

  Future<Either<Failure, List<LessonPreview>>> call(
      GetPreviewLessonsParams params) {
    return repository.getPreviewLessons(params.courseId);
  }
}
