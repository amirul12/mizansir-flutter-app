// File: lib/features/enrollment/domain/usecases/mark_lesson_complete_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/enrollment_repository.dart';

/// Parameters for marking lesson complete
class MarkLessonCompleteParams extends Equatable {
  final String courseId;
  final String lessonId;
  final int? watchTimeSeconds;
  final int? progressPercentage;

  const MarkLessonCompleteParams({
    required this.courseId,
    required this.lessonId,
    this.watchTimeSeconds,
    this.progressPercentage,
  });

  @override
  List<Object?> get props => [courseId, lessonId, watchTimeSeconds, progressPercentage];
}

/// Mark Lesson Complete Use Case
class MarkLessonCompleteUseCase {
  final EnrollmentRepository repository;

  const MarkLessonCompleteUseCase(this.repository);

  Future<Either<Failure, void>> call(MarkLessonCompleteParams params) {
    return repository.markLessonComplete(
      courseId: params.courseId,
      lessonId: params.lessonId,
      watchTimeSeconds: params.watchTimeSeconds,
      progressPercentage: params.progressPercentage,
    );
  }
}
