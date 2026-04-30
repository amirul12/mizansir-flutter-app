import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:mizansir/features/enrollment/data/models/course_lession_model.dart'
    show CourseLessonModel, courseLessonModelFromJson;
import 'package:mizansir/features/enrollment/data/models/course_progress_model.dart';
import 'package:mizansir/features/enrollment/data/models/enrollments_create_model.dart';
import 'package:mizansir/features/enrollment/data/models/my_course_model.dart'
    show MyCourseModel, myCourseModelFromJson;
import '../../../../core/services/api_exception.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/hive_service.dart';
import '../../../../core/error/failures.dart';

import '../../domain/entities/course_progress.dart';
import '../../domain/repositories/enrollment_repository.dart';
import '../datasources/enrollment_remote_datasource.dart';

/// Enrollment Repository Implementation
class EnrollmentRepositoryImpl implements EnrollmentRepository {
  final EnrollmentRemoteDataSource remoteDataSource;
  final ConnectivityService connectivityService;
  final HiveService hiveService;

  EnrollmentRepositoryImpl({
    required this.remoteDataSource,
    required this.connectivityService,
    required this.hiveService,
  });

  @override
  Future<Either<Failure, List<MyCourseModel>>> getMyCourses() async {
    try {
      if (!await connectivityService.isConnected) {
        final cachedJson = await hiveService.getMyCourses();
        if (cachedJson != null) {
          final cachedCourses = myCourseModelFromJson(cachedJson);
          return Right(cachedCourses);
        }
        throw NoInternetException();
      }

      final courseModels = await remoteDataSource.getMyCourses();
      await hiveService.saveMyCourses(
        jsonEncode(courseModels.map((e) => e.toJson()).toList()),
      );
      return Right(courseModels);
    } on CustomException catch (e) {
      final failure = parseCustomException<List<MyCourseModel>>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  Future<Either<Failure, CourseLessonModel>> getCourseLessons(
    String courseId,
  ) async {
    try {
      if (!await connectivityService.isConnected) {
        final cachedJson = await hiveService.getCourseLessons(courseId);
        if (cachedJson != null) {
          final cachedLessons = courseLessonModelFromJson(cachedJson);
          return Right(cachedLessons);
        }
        throw NoInternetException();
      }

      final lessonModels = await remoteDataSource.getCourseLessons(courseId);
      await hiveService.saveCourseLessons(
        courseId,
        jsonEncode(lessonModels.toJson()),
      );
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
      if (!await connectivityService.isConnected) {
        final cachedJson = await hiveService.getLessonDetails(
          courseId,
          lessonId,
        );
        if (cachedJson != null) {
          final cachedDetails = jsonDecode(cachedJson);
          final result = <String, dynamic>{
            'lesson': cachedDetails['lesson'],
            'nextLessonId': cachedDetails['nextLessonId'],
            'nextLessonTitle': cachedDetails['nextLessonTitle'],
            'previousLessonId': cachedDetails['previousLessonId'],
            'previousLessonTitle': cachedDetails['previousLessonTitle'],
          };
          return Right(result);
        }
        throw NoInternetException();
      }

      final lessonsMap = await remoteDataSource.getLessonDetails(
        courseId: courseId,
        lessonId: lessonId,
      );

      final result = <String, dynamic>{
        'lesson': lessonsMap['lesson'],
        'nextLessonId': lessonsMap['nextLesson']?.id?.toString(),
        'nextLessonTitle': lessonsMap['nextLesson']?.title,
        'previousLessonId': null,
        'previousLessonTitle': null,
      };

      await hiveService.saveLessonDetails(
        courseId,
        lessonId,
        jsonEncode(result),
      );
      return Right(result);
    } on CustomException catch (e) {
      final failure = parseCustomException<Map<String, dynamic>>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  Future<Either<Failure, CourseProgress>> getCourseProgress(
    String courseId,
  ) async {
    try {
      if (!await connectivityService.isConnected) {
        final cachedJson = await hiveService.getCourseProgress(courseId);
        if (cachedJson != null) {
          final cachedProgress = CourseProgressModel.fromJson(
            jsonDecode(cachedJson),
          );
          return Right(cachedProgress.toEntity());
        }
        throw NoInternetException();
      }

      final progressModel = await remoteDataSource.getCourseProgress(courseId);
      await hiveService.saveCourseProgress(
        courseId,
        jsonEncode(progressModel.toJson()),
      );
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

      final enrollmentModel = enrollmentsCreateModelFromJson(enrollmentData);
      return Right(enrollmentModel);
    } on CustomException catch (e) {
      final failure = parseCustomException<EnrollmentsCreateModel>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }
}
