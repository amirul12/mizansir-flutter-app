import 'package:flutter/foundation.dart';
import '../../../../core/services/api_service_method.dart';
import '../../../../core/services/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import '../models/course_model.dart';
import '../models/category_model.dart';
import '../models/lesson_preview_model.dart';
import 'course_remote_datasource.dart';

/// Course Remote Data Source Implementation using ApiMethod
class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  CourseRemoteDataSourceImpl();

  @override
  Future<List<CourseModel>> getCourses({
    Map<String, dynamic>? queryParams,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final params = queryParams ?? {};
      params['page'] = page.toString();
      params['limit'] = limit.toString();

      final mapResponse = await ApiMethod(isBasic: false).get(
        '${ApiConstants.baseUrl}${ApiConstants.coursesPath}',
        query: params,
        showResult: true,
      );

      if (mapResponse == null) {
        throw ServerException('No data received');
      }

      final data = mapResponse['data'] ?? mapResponse;
      
      if (data is Map && data.containsKey('items')) {
        final items = data['items'] as List;
        return items.map((course) => CourseModel.fromJson(course)).toList();
      } else if (data is List) {
        return data.map((course) => CourseModel.fromJson(course)).toList();
      }

      throw ServerException('Invalid data format');
    } catch (e) {
      debugPrint('Error in getCourses: $e');
      rethrow;
    }
  }

  @override
  Future<List<CourseModel>> getFeaturedCourses({int limit = 10}) async {
    try {
      final mapResponse = await ApiMethod(isBasic: false).get(
        '${ApiConstants.baseUrl}${ApiConstants.featuredCoursesEndpoint}',
        query: {'limit': limit.toString()},
        showResult: true,
      );

      if (mapResponse == null) {
        throw ServerException('No data received');
      }

      final data = mapResponse['data'] ?? mapResponse;
      
      if (data is Map && data.containsKey('items')) {
        final items = data['items'] as List;
        return items.map((course) => CourseModel.fromJson(course)).toList();
      } else if (data is List) {
        return data.map((course) => CourseModel.fromJson(course)).toList();
      }

      throw ServerException('Invalid data format');
    } catch (e) {
      debugPrint('Error in getFeaturedCourses: $e');
      rethrow;
    }
  }

  @override
  Future<CourseModel> getCourseDetails(String courseId) async {
    try {
      final mapResponse = await ApiMethod(isBasic: false).get(
        '${ApiConstants.baseUrl}${ApiConstants.coursesPath}/$courseId',
        showResult: true,
      );

      if (mapResponse == null) {
        throw ServerException('No data received');
      }

      final data = mapResponse['data'] ?? mapResponse;
      
      if (data is Map && data.containsKey('course')) {
        return CourseModel.fromJson(data['course'] as Map<String, dynamic>);
      } else if (data is Map<String, dynamic>) {
        return CourseModel.fromJson(data);
      }

      throw ServerException('Invalid data format');
    } catch (e) {
      debugPrint('Error in getCourseDetails: $e');
      rethrow;
    }
  }

  @override
  Future<List<CourseModel>> searchCourses(
    String query, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final mapResponse = await ApiMethod(isBasic: false).get(
        '${ApiConstants.baseUrl}${ApiConstants.searchCoursesEndpoint}',
        query: {
          'q': query,
          'page': page.toString(),
          'limit': limit.toString(),
        },
        showResult: true,
      );

      if (mapResponse == null) {
        throw ServerException('No data received');
      }

      final data = mapResponse['data'] ?? mapResponse;
      
      if (data is Map && data.containsKey('items')) {
        final items = data['items'] as List;
        return items.map((course) => CourseModel.fromJson(course)).toList();
      } else if (data is List) {
        return data.map((course) => CourseModel.fromJson(course)).toList();
      }

      throw ServerException('Invalid data format');
    } catch (e) {
      debugPrint('Error in searchCourses: $e');
      rethrow;
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final mapResponse = await ApiMethod(isBasic: false).get(
        '${ApiConstants.baseUrl}${ApiConstants.categoriesEndpoint}',
        showResult: true,
      );

      if (mapResponse == null) {
        throw ServerException('No data received');
      }

      final data = mapResponse['data'] ?? mapResponse;
      
      if (data is List) {
        return data.map((category) => CategoryModel.fromJson(category)).toList();
      } else if (data is Map && data.containsKey('categories')) {
        final categories = data['categories'] as List;
        return categories.map((category) => CategoryModel.fromJson(category)).toList();
      }

      throw ServerException('Invalid data format');
    } catch (e) {
      debugPrint('Error in getCategories: $e');
      rethrow;
    }
  }

  @override
  Future<List<LessonPreviewModel>> getPreviewLessons(String courseId) async {
    try {
      final mapResponse = await ApiMethod(isBasic: false).get(
        '${ApiConstants.baseUrl}${ApiConstants.coursesPath}/$courseId/lessons',
        showResult: true,
      );

      if (mapResponse == null) {
        throw ServerException('No data received');
      }

      final data = mapResponse['data'] ?? mapResponse;
      
      if (data is List) {
        return data.map((lesson) => LessonPreviewModel.fromJson(lesson)).toList();
      } else if (data is Map && data.containsKey('lessons')) {
        final lessons = data['lessons'] as List;
        return lessons.map((lesson) => LessonPreviewModel.fromJson(lesson)).toList();
      }

      throw ServerException('Invalid data format');
    } catch (e) {
      debugPrint('Error in getPreviewLessons: $e');
      rethrow;
    }
  }

  @override
  Future<bool> isEnrolled(String courseId) async {
    try {
      final mapResponse = await ApiMethod(isBasic: false).get(
        '${ApiConstants.baseUrl}${ApiConstants.coursesPath}/$courseId/check-enrollment',
        showResult: true,
      );

      if (mapResponse == null) {
        return false;
      }

      final data = mapResponse['data'] ?? mapResponse;
      if (data is Map) {
        return data['enrolled'] ?? false;
      }

      return false;
    } catch (e) {
      debugPrint('Error in isEnrolled: $e');
      return false;
    }
  }
}
