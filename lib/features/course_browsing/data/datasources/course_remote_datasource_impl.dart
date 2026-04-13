// File: lib/features/course_browsing/data/datasources/course_remote_datasource_impl.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';
import '../models/course_model.dart';
import '../models/category_model.dart';
import '../models/lesson_preview_model.dart';
import 'course_remote_datasource.dart';

/// Course Remote Data Source Implementation
class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  CourseRemoteDataSourceImpl({
    required this.client,
    required this.baseUrl,
  });

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

      // Use Uri.parse to handle full URL correctly
      final uri = Uri.parse('$baseUrl/v1/courses').replace(queryParameters: params);

      // DEBUG: Print API Request
      debugPrint('🔵 GET COURSES REQUEST');
      debugPrint('URL: $uri');
      debugPrint('Headers: {"Content-Type": "application/json"}');

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 30),
      );

      // DEBUG: Print API Response
      debugPrint('🟢 GET COURSES RESPONSE');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        // Handle direct list response
        if (jsonData is List) {
          debugPrint('✅ Successfully parsed ${jsonData.length} courses');
          return jsonData
              .map((course) => CourseModel.fromJson(course))
              .toList();
        }
        
        // Handle wrapped response (CommonResponseModel format)
        if (jsonData is Map && jsonData['data'] is List) {
          debugPrint('✅ Successfully parsed ${jsonData['data'].length} courses');
          return (jsonData['data'] as List)
              .map((course) => CourseModel.fromJson(course))
              .toList();
        }

        throw ServerException(message: 'Invalid data format received');
      } else if (response.statusCode == 401) {
        debugPrint('❌ Unauthorized: 401');
        throw UnauthorizedException();
      } else if (response.statusCode == 404) {
        debugPrint('❌ Not Found: 404');
        throw const NotFoundException(message: 'Courses not found');
      } else {
        debugPrint('❌ Error: ${response.statusCode}');
        throw ServerException(
          message: 'Failed to load courses',
          statusCode: response.statusCode,
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Exception: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CourseModel>> getFeaturedCourses({int limit = 10}) async {
    try {
      // Use Uri.parse to handle full URL correctly
      final uri = Uri.parse('$baseUrl/v1/courses/featured').replace(
        queryParameters: {'limit': limit.toString()},
      );

      // DEBUG: Print API Request
      debugPrint('🔵 GET FEATURED COURSES REQUEST');
      debugPrint('URL: $uri');

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 30),
      );

      // DEBUG: Print API Response
      debugPrint('🟢 GET FEATURED COURSES RESPONSE');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        // Handle direct list response
        if (jsonData is List) {
          return jsonData
              .map((course) => CourseModel.fromJson(course))
              .toList();
        }
        
        // Handle wrapped response
        if (jsonData is Map && jsonData['data'] is List) {
          return (jsonData['data'] as List)
              .map((course) => CourseModel.fromJson(course))
              .toList();
        }
        throw ServerException(message: 'Invalid data format received');
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else {
        throw ServerException(
          message: 'Failed to load featured courses',
          statusCode: response.statusCode,
        );
      }
    } on Exception {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<CourseModel> getCourseDetails(String courseId) async {
    try {
      // Use Uri.parse to handle full URL correctly
      final uri = Uri.parse('$baseUrl/v1/courses/$courseId');

      // DEBUG: Print API Request
      debugPrint('🔵 GET COURSE DETAILS REQUEST');
      debugPrint('URL: $uri');

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 30),
      );

      // DEBUG: Print API Response
      debugPrint('🟢 GET COURSE DETAILS RESPONSE');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['data'] is Map) {
          return CourseModel.fromJson(jsonData['data']);
        }
        throw ServerException(message: 'Invalid data format received');
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else if (response.statusCode == 404) {
        throw const NotFoundException(message: 'Course not found');
      } else {
        throw ServerException(
          message: 'Failed to load course details',
          statusCode: response.statusCode,
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CourseModel>> searchCourses(
    String query, {
    int page = 1,
    int limit = 20,
  }) async {
    try {
      // Use Uri.parse to handle full URL correctly
      final uri = Uri.parse('$baseUrl/v1/courses/search').replace(
        queryParameters: {
          'q': query,
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      // DEBUG: Print API Request
      debugPrint('🔵 SEARCH COURSES REQUEST');
      debugPrint('URL: $uri');

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 30),
      );

      // DEBUG: Print API Response
      debugPrint('🟢 SEARCH COURSES RESPONSE');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['data'] is List) {
          return (jsonData['data'] as List)
              .map((course) => CourseModel.fromJson(course))
              .toList();
        }
        throw ServerException(message: 'Invalid data format received');
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else {
        throw ServerException(
          message: 'Failed to search courses',
          statusCode: response.statusCode,
        );
      }
    } on Exception {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      // Use Uri.parse to handle full URL correctly
      final uri = Uri.parse('$baseUrl/v1/courses/categories');

      // DEBUG: Print API Request
      debugPrint('🔵 GET CATEGORIES REQUEST');
      debugPrint('URL: $uri');

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 30),
      );

      // DEBUG: Print API Response
      debugPrint('🟢 GET CATEGORIES RESPONSE');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['data'] is List) {
          return (jsonData['data'] as List)
              .map((category) => CategoryModel.fromJson(category))
              .toList();
        }
        throw ServerException(message: 'Invalid data format received');
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else {
        throw ServerException(
          message: 'Failed to load categories',
          statusCode: response.statusCode,
        );
      }
    } on Exception {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<List<LessonPreviewModel>> getPreviewLessons(String courseId) async {
    try {
      // Use Uri.parse to handle full URL correctly
      final uri = Uri.parse('$baseUrl/v1/courses/$courseId/lessons');

      // DEBUG: Print API Request
      debugPrint('🔵 GET PREVIEW LESSONS REQUEST');
      debugPrint('URL: $uri');

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 30),
      );

      // DEBUG: Print API Response
      debugPrint('🟢 GET PREVIEW LESSONS RESPONSE');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['data'] is List) {
          return (jsonData['data'] as List)
              .map((lesson) => LessonPreviewModel.fromJson(lesson))
              .toList();
        }
        throw ServerException(message: 'Invalid data format received');
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else if (response.statusCode == 404) {
        throw const NotFoundException(message: 'Lessons not found');
      } else {
        throw ServerException(
          message: 'Failed to load preview lessons',
          statusCode: response.statusCode,
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> isEnrolled(String courseId) async {
    try {
      final uri = Uri.https(
        baseUrl.replaceAll('https://', '').replaceAll('http://', ''),
        '/courses/$courseId/check-enrollment',
      );

      final response = await client.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 30),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData['enrolled'] ?? false;
      } else if (response.statusCode == 401) {
        throw UnauthorizedException();
      } else {
        return false;
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
