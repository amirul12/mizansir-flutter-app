import 'package:dartz/dartz.dart';
import 'package:mizansir/features/enrollment/data/models/course_lession_model.dart' show CourseLessonModel;
import 'package:mizansir/features/enrollment/data/models/course_lesson_details_model.dart';
import 'package:mizansir/features/enrollment/data/models/enrollments_create_model.dart';
import 'package:mizansir/features/enrollment/data/models/lesson_model.dart' show LessonModel;
import 'package:mizansir/features/enrollment/data/models/my_course_model.dart' show MyCourseModel;
import '../../../../core/services/api_exception.dart';
import '../../../../core/error/failures.dart';
 

import '../../domain/entities/lesson.dart';
import '../../domain/entities/course_progress.dart';
import '../../domain/repositories/enrollment_repository.dart';
import '../datasources/enrollment_remote_datasource.dart';

/// Enrollment Repository Implementation
class EnrollmentRepositoryImpl implements EnrollmentRepository {
  final EnrollmentRemoteDataSource remoteDataSource;

  EnrollmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MyCourseModel>>> getMyCourses() async {
    try {
      final courseModels = await remoteDataSource.getMyCourses();
      return Right(courseModels);
    } on CustomException catch (e) {
      final failure = parseCustomException<List<MyCourseModel>>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  // Future<Either<Failure, EnrolledCourse>> getEnrolledCourseDetails(String courseId) async {
  //   try {
  //     final courseModel = await remoteDataSource.getEnrolledCourseDetails(courseId);
  //     return Right(courseModel.toEntity());
  //   } on CustomException catch (e) {
  //     final failure = parseCustomException<EnrolledCourse>(e);
  //     return failure.fold((failure) => Left(failure), (_) => throw e);
  //   }
  // }

  @override
  Future<Either<Failure, CourseLessonModel>> getCourseLessons(String courseId) async {
    try {
      final lessonModels = await remoteDataSource.getCourseLessons(courseId);
      return Right(lessonModels);
    } on CustomException catch (e) {
      final failure = parseCustomException<CourseLessonModel>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> getLessonDetails({
    required String courseId,
    required String lessonId,
  }) async {
    try {
      final lessonsMap = await remoteDataSource.getLessonDetails(
        courseId: courseId,
        lessonId: lessonId,
      );

      // Return map with lesson and navigation info
      final result = <String, dynamic>{
        'lesson': lessonsMap['lesson'],
        'nextLessonId': lessonsMap['nextLesson']?.id?.toString(),
        'nextLessonTitle': lessonsMap['nextLesson']?.title,
        'previousLessonId': null, // API doesn't provide this yet
        'previousLessonTitle': null,
      };

      return Right(result);
    } on CustomException catch (e) {
      final failure = parseCustomException<Map<String, dynamic>>(e);
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
  Future<Either<Failure, EnrollmentsCreateModel>> createEnrollment({
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

      // Parse JSON string to model
      final enrollmentModel = enrollmentsCreateModelFromJson(enrollmentData);
      return Right(enrollmentModel);
    } on CustomException catch (e) {
      final failure = parseCustomException<EnrollmentsCreateModel>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }
}
