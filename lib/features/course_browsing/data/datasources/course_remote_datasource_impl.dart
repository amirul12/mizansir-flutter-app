import 'package:flutter/foundation.dart';
import '../../../../core/services/api_service_method.dart';
import '../../../../core/services/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/common_json.dart';
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
    Map<String, dynamic>? mapResponse;

    try {
      // Build query parameters
      final params = queryParams ?? {};
      params['page'] = page.toString();
      params['limit'] = limit.toString();

      mapResponse = await ApiMethod(isBasic: true).get(
        '${ApiConstants.baseUrl}${ApiConstants.coursesPath}',
        query: params,
        showResult: true,
      );

      if (mapResponse == null) {
        throw ServerException('No data received');
      }

      // Extract data from response
      final dataList = CommonToJson.getList(mapResponse);
      if (dataList == null) {
        throw ServerException('Invalid data format');
      }

      return dataList.map((course) => CourseModel.fromJson(course)).toList();
    } catch (e) {
      debugPrint('Error in getCourses: $e');
      rethrow;
    }
  }

  @override
  Future<List<CourseModel>> getFeaturedCourses({int limit = 10}) async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: true).get(
        '${ApiConstants.baseUrl}${ApiConstants.featuredCoursesEndpoint}',
        query: {'limit': limit.toString()},
        showResult: true,
      );

      if (mapResponse == null) {
        throw ServerException('No data received');
      }

      final dataList = CommonToJson.getList(mapResponse);
      if (dataList == null) {
        throw ServerException('Invalid data format');
      }

      return dataList.map((course) => CourseModel.fromJson(course)).toList();
    } catch (e) {
      debugPrint('Error in getFeaturedCourses: $e');
      rethrow;
    }
  }

  @override
  Future<CourseModel> getCourseDetails(String courseId) async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: true).get(
        '${ApiConstants.baseUrl}${ApiConstants.coursesPath}/$courseId',
        showResult: true,
      );

      if (mapResponse == null) {
        throw ServerException('No data received');
      }

      final dataMap = CommonToJson.getMap(mapResponse);
      if (dataMap == null) {
        throw ServerException('Invalid data format');
      }

      // Handle nested course object
      if (dataMap['course'] is Map) {
        return CourseModel.fromJson(dataMap['course'] as Map<String, dynamic>);
      }

      return CourseModel.fromJson(dataMap);
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
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: true).get(
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

      final dataList = CommonToJson.getList(mapResponse);
      if (dataList == null) {
        throw ServerException('Invalid data format');
      }

      return dataList.map((course) => CourseModel.fromJson(course)).toList();
    } catch (e) {
      debugPrint('Error in searchCourses: $e');
      rethrow;
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: true).get(
        '${ApiConstants.baseUrl}${ApiConstants.categoriesEndpoint}',
        showResult: true,
      );

      if (mapResponse == null) {
        throw ServerException('No data received');
      }

      final dataList = CommonToJson.getList(mapResponse);
      if (dataList == null) {
        throw ServerException('Invalid data format');
      }

      return dataList
          .map((category) => CategoryModel.fromJson(category))
          .toList();
    } catch (e) {
      debugPrint('Error in getCategories: $e');
      rethrow;
    }
  }

  @override
  Future<List<LessonPreviewModel>> getPreviewLessons(String courseId) async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: true).get(
        '${ApiConstants.baseUrl}${ApiConstants.coursesPath}/$courseId/lessons',
        showResult: true,
      );

      if (mapResponse == null) {
        throw ServerException('No data received');
      }

      final dataList = CommonToJson.getList(mapResponse);
      if (dataList == null) {
        throw ServerException('Invalid data format');
      }

      return dataList
          .map((lesson) => LessonPreviewModel.fromJson(lesson))
          .toList();
    } catch (e) {
      debugPrint('Error in getPreviewLessons: $e');
      rethrow;
    }
  }

  @override
  Future<bool> isEnrolled(String courseId) async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        '${ApiConstants.baseUrl}${ApiConstants.coursesPath}/$courseId/check-enrollment',
        showResult: true,
      );

      if (mapResponse == null) {
        return false;
      }

      return mapResponse['enrolled'] ?? false;
    } catch (e) {
      debugPrint('Error in isEnrolled: $e');
      return false;
    }
  }
}
