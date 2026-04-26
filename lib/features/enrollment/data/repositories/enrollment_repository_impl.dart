import 'package:dartz/dartz.dart';
import '../../../../core/services/api_exception.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/enrolled_course.dart';
import '../../domain/entities/my_course_entity.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/course_progress.dart';
import '../../domain/repositories/enrollment_repository.dart';
import '../datasources/enrollment_remote_datasource.dart';

/// Enrollment Repository Implementation
class EnrollmentRepositoryImpl implements EnrollmentRepository {
  final EnrollmentRemoteDataSource remoteDataSource;

  EnrollmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MyCourseEntity>>> getMyCourses() async {
    try {
      final courseModels = await remoteDataSource.getMyCourses();
      return Right(courseModels.map((model) => model.toEntity()).toList());
    } on CustomException catch (e) {
      final failure = parseCustomException<List<MyCourseEntity>>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  Future<Either<Failure, EnrolledCourse>> getEnrolledCourseDetails(String courseId) async {
    try {
      final courseModel = await remoteDataSource.getEnrolledCourseDetails(courseId);
      return Right(courseModel.toEntity());
    } on CustomException catch (e) {
      final failure = parseCustomException<EnrolledCourse>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  Future<Either<Failure, List<Lesson>>> getCourseLessons(String courseId) async {
    try {
      final lessonModels = await remoteDataSource.getCourseLessons(courseId);
      return Right(lessonModels.map((model) => model.toEntity()).toList());
    } on CustomException catch (e) {
      final failure = parseCustomException<List<Lesson>>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  Future<Either<Failure, Map<String, Lesson?>>> getLessonDetails({
    required String courseId,
    required String lessonId,
  }) async {
    try {
      final lessonsMap = await remoteDataSource.getLessonDetails(
        courseId: courseId,
        lessonId: lessonId,
      );

      // Convert models to entities
      final result = <String, Lesson?>{
        'lesson': lessonsMap['lesson']?.toEntity(),
        'nextLesson': lessonsMap['nextLesson']?.toEntity(),
        'previousLesson': lessonsMap['previousLesson']?.toEntity(),
      };

      return Right(result);
    } on CustomException catch (e) {
      final failure = parseCustomException<Map<String, Lesson?>>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  Future<Either<Failure, CourseProgress>> getCourseProgress(String courseId) async {
    try {
      final progressModel = await remoteDataSource.getCourseProgress(courseId);
      return Right(progressModel.toEntity());
    } on CustomException catch (e) {
      final failure = parseCustomException<CourseProgress>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  Future<Either<Failure, void>> markLessonComplete({
    required String courseId,
    required String lessonId,
    int? watchTimeSeconds,
    int? progressPercentage,
  }) async {
    try {
      await remoteDataSource.markLessonComplete(
        courseId: courseId,
        lessonId: lessonId,
        watchTimeSeconds: watchTimeSeconds,
        progressPercentage: progressPercentage,
      );
      return const Right(null);
    } on CustomException catch (e) {
      final failure = parseCustomException<void>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  Future<Either<Failure, void>> markLessonIncomplete({
    required String courseId,
    required String lessonId,
  }) async {
    try {
      await remoteDataSource.markLessonIncomplete(
        courseId: courseId,
        lessonId: lessonId,
      );
      return const Right(null);
    } on CustomException catch (e) {
      final failure = parseCustomException<void>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  Future<Either<Failure, void>> updateLessonProgress({
    required String courseId,
    required String lessonId,
    required int progressPercentage,
    required int watchTimeSeconds,
  }) async {
    try {
      await remoteDataSource.updateLessonProgress(
        courseId: courseId,
        lessonId: lessonId,
        progressPercentage: progressPercentage,
        watchTimeSeconds: watchTimeSeconds,
      );
      return const Right(null);
    } on CustomException catch (e) {
      final failure = parseCustomException<void>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> createEnrollment({
    required String courseId,
    String? paymentMethod,
    String? paymentNotes,
    String? transactionId,
  }) async {
    try {
      final enrollmentData = await remoteDataSource.createEnrollment(
        courseId: courseId,
        paymentMethod: paymentMethod,
        paymentNotes: paymentNotes,
        transactionId: transactionId,
      );
      return Right(enrollmentData);
    } on CustomException catch (e) {
      final failure = parseCustomException<Map<String, dynamic>>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }
}
