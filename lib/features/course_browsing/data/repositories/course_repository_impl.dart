// File: lib/features/course_browsing/data/repositories/course_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/course_filter.dart';
import '../../domain/entities/lesson_preview.dart';
import '../../domain/repositories/course_repository.dart';
import '../datasources/course_remote_datasource.dart';
import '../models/course_model.dart';
import '../models/category_model.dart';
import '../models/lesson_preview_model.dart';

/// Course Repository Implementation
class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource remoteDataSource;

  CourseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Course>>> getCourses({
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
      return Right(courseModels.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on UnauthorizedException {
      return Left(UnauthorizedFailure());
    } on NotFoundException {
      return Left(NotFoundFailure('No courses found'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Course>>> getFeaturedCourses({
    int limit = 10,
  }) async {
    try {
      final courseModels = await remoteDataSource.getFeaturedCourses(
        limit: limit,
      );
      return Right(courseModels.map((model) => model.toEntity()).toList());
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
  Future<Either<Failure, Course>> getCourseDetails(String courseId) async {
    try {
      final courseModel = await remoteDataSource.getCourseDetails(courseId);
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
  Future<Either<Failure, List<Course>>> searchCourses(
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
      return Right(courseModels.map((model) => model.toEntity()).toList());
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
  Future<Either<Failure, List<Category>>> getCategories() async {
    try {
      final categoryModels = await remoteDataSource.getCategories();
      return Right(categoryModels.map((model) => model.toEntity()).toList());
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
  Future<Either<Failure, List<LessonPreview>>> getPreviewLessons(
    String courseId,
  ) async {
    try {
      final lessonModels = await remoteDataSource.getPreviewLessons(courseId);
      return Right(lessonModels.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure());
    } on NetworkException {
      return Left(NetworkFailure());
    } on UnauthorizedException {
      return Left(UnauthorizedFailure());
    } on NotFoundException {
      return Left(NotFoundFailure('Lessons not found'));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isEnrolled(String courseId) async {
    try {
      final isEnrolled = await remoteDataSource.isEnrolled(courseId);
      return Right(isEnrolled);
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
