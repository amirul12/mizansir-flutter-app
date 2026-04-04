// File: lib/features/enrollment/data/repositories/enrollment_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/enrolled_course.dart';
import '../../domain/entities/lesson.dart';
import '../../domain/entities/course_progress.dart';
import '../../domain/repositories/enrollment_repository.dart';
import '../datasources/enrollment_remote_datasource.dart';

/// Enrollment Repository Implementation
class EnrollmentRepositoryImpl implements EnrollmentRepository {
  final EnrollmentRemoteDataSource remoteDataSource;

  EnrollmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<EnrolledCourse>>> getMyCourses() async {
    try {
      final courseModels = await remoteDataSource.getMyCourses();
      return Right(courseModels.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on UnauthorizedException {
      return Left(UnauthorizedFailure());
    } on NotFoundException {
      return Left(NotFoundFailure('No enrolled courses found'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, EnrolledCourse>> getEnrolledCourseDetails(String courseId) async {
    try {
      final courseModel = await remoteDataSource.getEnrolledCourseDetails(courseId);
      return Right(courseModel.toEntity());
    } on ServerException {
      return Left(ServerFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on UnauthorizedException {
      return Left(UnauthorizedFailure());
    } on NotFoundException {
      return Left(NotFoundFailure('Course not found'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Lesson>>> getCourseLessons(String courseId) async {
    try {
      final lessonModels = await remoteDataSource.getCourseLessons(courseId);
      return Right(lessonModels.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on UnauthorizedException {
      return Left(UnauthorizedFailure());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Lesson>> getLessonDetails(String courseId, String lessonId) async {
    try {
      final lessonModel = await remoteDataSource.getLessonDetails(courseId, lessonId);
      return Right(lessonModel.toEntity());
    } on ServerException {
      return Left(ServerFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on UnauthorizedException {
      return Left(UnauthorizedFailure());
    } on NotFoundException {
      return Left(NotFoundFailure('Lesson not found'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, CourseProgress>> getCourseProgress(String courseId) async {
    try {
      final progressModel = await remoteDataSource.getCourseProgress(courseId);
      return Right(progressModel.toEntity());
    } on ServerException {
      return Left(ServerFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on UnauthorizedException {
      return Left(UnauthorizedFailure());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
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
    } on ServerException {
      return Left(ServerFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on UnauthorizedException {
      return Left(UnauthorizedFailure());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
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
    } on ServerException {
      return Left(ServerFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on UnauthorizedException {
      return Left(UnauthorizedFailure());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
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
    } on ServerException {
      return Left(ServerFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on UnauthorizedException {
      return Left(UnauthorizedFailure());
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
