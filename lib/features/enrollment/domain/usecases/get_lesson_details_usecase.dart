// File: lib/features/enrollment/domain/usecases/get_lesson_details_usecase.dart
import 'package:dartz/dartz.dart';
import 'package:mizansir/features/enrollment/data/models/lesson_model.dart' show LessonModel;
import '../../../../core/error/failures.dart';
import '../entities/lesson.dart';
import '../repositories/enrollment_repository.dart';

/// Parameters for getting lesson details
class GetLessonDetailsParams {
  final String courseId;
  final String lessonId;

  const GetLessonDetailsParams({
    required this.courseId,
    required this.lessonId,
  });
}

/// Get Lesson Details Use Case
class GetLessonDetailsUseCase {
  final EnrollmentRepository repository;

  GetLessonDetailsUseCase(this.repository);

  /// Execute use case
  ///
  /// Returns [Right] with a map containing:
  /// - 'lesson': The current lesson
  /// - 'nextLesson': The next lesson (nullable)
  /// - 'previousLesson': The previous lesson (nullable)
  Future<Either<Failure, Map<String, LessonModel?>>> call(
    GetLessonDetailsParams params,
  ) async {
    return await repository.getLessonDetails(
      courseId: params.courseId,
      lessonId: params.lessonId,
    );
  }
}
