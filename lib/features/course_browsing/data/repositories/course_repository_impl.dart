import 'package:dartz/dartz.dart';
import 'package:mizansir/features/course_browsing/data/models/course_details_response.dart';
import 'package:mizansir/features/course_browsing/data/models/course_list_response.dart';
 
import '../../../../core/services/api_exception.dart';
import '../../../../core/error/failures.dart';
 
 
import '../../domain/entities/course_filter.dart';
import '../../domain/entities/lesson_preview.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_remote_datasource.dart';

/// Course Repository Implementation
class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remoteDataSource;

  CourseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CourseListResponse>> getCourses({
    CourseFilter? filter,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final queryParams = filter?.toQueryParameters();
      final courseModels = await remoteDataSource.getCourses(
        queryParams: queryParams,
        page: page,
        limit: limit,
      );
      return Right(courseModels);
    } on CustomException catch (e) {
      final failure = parseCustomException<CourseListResponse>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  Future<Either<Failure, CourseListResponse>> getFeaturedCourses({
    int limit = 10,
  }) async {
    try {
      final courseModels = await remoteDataSource.getFeaturedCourses(limit: limit);
      return Right(courseModels);
    } on CustomException catch (e) {
      final failure = parseCustomException<CourseListResponse>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  Future<Either<Failure, CourseDetailsResponse>> getCourseDetails(String courseId) async {
    try {
      final courseModel = await remoteDataSource.getCourseDetails(courseId);
      return Right(courseModel);
    } on CustomException catch (e) {
      final failure = parseCustomException<CourseDetailsResponse>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  Future<Either<Failure, CourseListResponse>> searchCourses(
    String query, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final courseModels = await remoteDataSource.searchCourses(
        query,
        page: page,
        limit: limit,
      );
      return Right(courseModels);
    } on CustomException catch (e) {
      final failure = parseCustomException<CourseListResponse>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  Future<Either<Failure, List<dynamic>>> getCategories() async {
    try {
      final categoryModels = await remoteDataSource.getCategories();
      return Right(categoryModels.map((model) => model.toEntity()).toList());
    } on CustomException catch (e) {
      final failure = parseCustomException<List<Category>>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  Future<Either<Failure, List<LessonPreview>>> getPreviewLessons(
    String courseId,
  ) async {
    try {
      final lessonModels = await remoteDataSource.getPreviewLessons(courseId);
      return Right(lessonModels.map((model) => model.toEntity()).toList());
    } on CustomException catch (e) {
      final failure = parseCustomException<List<LessonPreview>>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }

  @override
  Future<Either<Failure, bool>> isEnrolled(String courseId) async {
    try {
      final isEnrolled = await remoteDataSource.isEnrolled(courseId);
      return Right(isEnrolled);
    } on CustomException catch (e) {
      final failure = parseCustomException<bool>(e);
      return failure.fold((failure) => Left(failure), (_) => throw e);
    }
  }
}
