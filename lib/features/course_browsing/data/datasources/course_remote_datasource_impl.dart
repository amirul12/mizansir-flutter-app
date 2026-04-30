import 'package:flutter/foundation.dart';
import 'package:mizansir/core/utils/common_json.dart';
import 'package:mizansir/features/course_browsing/data/models/course_list_response.dart';
import '../../../../core/services/api_service_method.dart';
import '../../../../core/services/api_exception.dart';
import '../../../../core/constants/api_constants.dart';

import '../models/lesson_preview_model.dart';
import 'course_remote_datasource.dart';

/// Course Remote Data Source Implementation using ApiMethod
class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  CourseRemoteDataSourceImpl();

  @override
  Future<CourseListResponse> getCourses({
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

      final dataMap = CommonToJson().getString(mapResponse);
      if (dataMap == null) {
        throw ServerException('Invalid data format');
      }

      return courseListResponseFromJson(dataMap);
    } catch (e) {
      debugPrint('Error in getCourses: $e');
      rethrow;
    }
  }

  @override
  Future<CourseListResponse> getFeaturedCourses({int limit = 10}) async {
    try {
      final mapResponse = await ApiMethod(isBasic: false).get(
        '${ApiConstants.baseUrl}${ApiConstants.featuredCoursesEndpoint}',
        query: {'limit': limit.toString()},
        showResult: true,
      );

      if (mapResponse == null) {
        throw ServerException('No data received');
      }

      final dataMap = CommonToJson().getString(mapResponse);
      if (dataMap == null) {
        throw ServerException('Invalid data format');
      }

      return courseListResponseFromJson(dataMap);
    } catch (e) {
      debugPrint('Error in getFeaturedCourses: $e');
      rethrow;
    }
  }

  @override
  Future<dynamic> getCourseDetails(String courseId) async {
    try {
      final mapResponse = await ApiMethod(isBasic: false).get(
        '${ApiConstants.baseUrl}${ApiConstants.coursesPath}/$courseId',
        showResult: true,
      );

      if (mapResponse == null) {
        throw ServerException('No data received');
      }

      final dataMap = CommonToJson().getString(mapResponse);
      if (dataMap == null) {
        throw ServerException('Invalid data format');
      }

      return courseListResponseFromJson(dataMap);
    } catch (e) {
      debugPrint('Error in getCourseDetails: $e');
      rethrow;
    }
  }

  @override
  Future<CourseListResponse> searchCourses(
    String query, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final mapResponse = await ApiMethod(isBasic: false).get(
        '${ApiConstants.baseUrl}${ApiConstants.searchCoursesEndpoint}',
        query: {'q': query, 'page': page.toString(), 'limit': limit.toString()},
        showResult: true,
      );

      if (mapResponse == null) {
        throw ServerException('No data received');
      }

      final dataMap = CommonToJson().getString(mapResponse);
      if (dataMap == null) {
        throw ServerException('Invalid data format');
      }

      return courseListResponseFromJson(dataMap);
    } catch (e) {
      debugPrint('Error in searchCourses: $e');
      rethrow;
    }
  }

  @override
  Future<List<dynamic>> getCategories() async {
    try {
      final mapResponse = await ApiMethod(isBasic: false).get(
        '${ApiConstants.baseUrl}${ApiConstants.categoriesEndpoint}',
        showResult: true,
      );

      if (mapResponse == null) {
        throw ServerException('No data received');
      }

      final dataMap = CommonToJson().getString(mapResponse);
      if (dataMap == null) {
        throw ServerException('Invalid data format');
      }

      return [];

      //  return categoryListResponseFromJson(dataMap);
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
        return data
            .map((lesson) => LessonPreviewModel.fromJson(lesson))
            .toList();
      } else if (data is Map && data.containsKey('lessons')) {
        final lessons = data['lessons'] as List;
        return lessons
            .map((lesson) => LessonPreviewModel.fromJson(lesson))
            .toList();
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
