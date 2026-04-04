// File: lib/features/enrollment/data/datasources/enrollment_remote_datasource_impl.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../../core/errors/exceptions.dart';
import '../../../../core/services/token_service.dart';
import '../models/enrolled_course_model.dart';
import '../models/lesson_model.dart';
import '../models/course_progress_model.dart';
import 'enrollment_remote_datasource.dart';

/// Enrollment Remote Data Source Implementation
class EnrollmentRemoteDataSourceImpl implements EnrollmentRemoteDataSource {
  final http.Client client;
  final TokenService tokenService;
  final String baseUrl;

  EnrollmentRemoteDataSourceImpl({
    required this.client,
    required this.tokenService,
    required this.baseUrl,
  });

  String _getAuthorizationHeader() {
    final token = tokenService.getAccessToken();
    if (token == null) {
      throw const UnauthorizedException(message: 'No authentication token found');
    }
    return 'Bearer $token';
  }

  @override
  Future<List<EnrolledCourseModel>> getMyCourses() async {
    try {
      final token = await tokenService.getAuthHeader();
      final uri = Uri.parse('$baseUrl/v1/my-courses');

      // DEBUG: Print API Request
      debugPrint('🔵 GET MY COURSES REQUEST');
      debugPrint('URL: $uri');
      debugPrint('Authorization: $token');

      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      ).timeout(const Duration(seconds: 30));

      // DEBUG: Print API Response
      debugPrint('🟢 GET MY COURSES RESPONSE');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['data'] is List) {
          debugPrint('✅ Successfully parsed ${(jsonData['data'] as List).length} enrolled courses');
          return (jsonData['data'] as List)
              .map((course) => EnrolledCourseModel.fromJson(course))
              .toList();
        }
        throw ServerException(message: 'Invalid data format received');
      } else if (response.statusCode == 401) {
        debugPrint('❌ Unauthorized: 401');
        throw const UnauthorizedException();
      } else {
        debugPrint('❌ Error: ${response.statusCode}');
        throw ServerException(
          message: 'Failed to load enrolled courses',
          statusCode: response.statusCode,
        );
      }
    } on UnauthorizedException {
      rethrow;
    } on AppException {
      rethrow;
    } catch (e) {
      debugPrint('❌ Exception: $e');
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<EnrolledCourseModel> getEnrolledCourseDetails(String courseId) async {
    try {
      final token = await tokenService.getAuthHeader();
      final uri = Uri.parse('$baseUrl/v1/my-courses/$courseId');

      debugPrint('🔵 GET ENROLLED COURSE DETAILS REQUEST');
      debugPrint('URL: $uri');

      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      ).timeout(const Duration(seconds: 30));

      debugPrint('🟢 GET ENROLLED COURSE DETAILS RESPONSE');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['data'] is Map) {
          return EnrolledCourseModel.fromJson(jsonData['data']);
        }
        throw ServerException(message: 'Invalid data format received');
      } else if (response.statusCode == 401) {
        throw const UnauthorizedException();
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
  Future<List<LessonModel>> getCourseLessons(String courseId) async {
    try {
      final token = await tokenService.getAuthHeader();
      final uri = Uri.parse('$baseUrl/v1/my-courses/$courseId/lessons');

      debugPrint('🔵 GET COURSE LESSONS REQUEST');
      debugPrint('URL: $uri');

      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      ).timeout(const Duration(seconds: 30));

      debugPrint('🟢 GET COURSE LESSONS RESPONSE');
      debugPrint('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['data'] is List) {
          return (jsonData['data'] as List)
              .map((lesson) => LessonModel.fromJson(lesson))
              .toList();
        }
        throw ServerException(message: 'Invalid data format received');
      } else if (response.statusCode == 401) {
        throw const UnauthorizedException();
      } else {
        throw ServerException(
          message: 'Failed to load lessons',
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
  Future<LessonModel> getLessonDetails(String courseId, String lessonId) async {
    try {
      final token = await tokenService.getAuthHeader();
      final uri = Uri.parse('$baseUrl/v1/my-courses/$courseId/lessons/$lessonId');

      debugPrint('🔵 GET LESSON DETAILS REQUEST');
      debugPrint('URL: $uri');

      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['data'] is Map) {
          return LessonModel.fromJson(jsonData['data']);
        }
        throw ServerException(message: 'Invalid data format received');
      } else if (response.statusCode == 401) {
        throw const UnauthorizedException();
      } else {
        throw ServerException(
          message: 'Failed to load lesson details',
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
  Future<CourseProgressModel> getCourseProgress(String courseId) async {
    try {
      final token = await tokenService.getAuthHeader();
      final uri = Uri.parse('$baseUrl/v1/my-courses/$courseId/progress');

      debugPrint('🔵 GET COURSE PROGRESS REQUEST');
      debugPrint('URL: $uri');

      final response = await client.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      ).timeout(const Duration(seconds: 30));

      debugPrint('🟢 GET COURSE PROGRESS RESPONSE');
      debugPrint('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['data'] is Map) {
          return CourseProgressModel.fromJson(jsonData['data']);
        }
        throw ServerException(message: 'Invalid data format received');
      } else if (response.statusCode == 401) {
        throw const UnauthorizedException();
      } else {
        throw ServerException(
          message: 'Failed to load progress',
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
  Future<void> markLessonComplete({
    required String courseId,
    required String lessonId,
    int? watchTimeSeconds,
    int? progressPercentage,
  }) async {
    try {
      final token = await tokenService.getAuthHeader();
      final uri = Uri.parse('$baseUrl/v1/my-courses/$courseId/lessons/$lessonId/complete');

      final body = {};
      if (watchTimeSeconds != null) {
        body['watch_time_seconds'] = watchTimeSeconds;
      }
      if (progressPercentage != null) {
        body['progress_percentage'] = progressPercentage;
      }

      debugPrint('🔵 MARK LESSON COMPLETE REQUEST');
      debugPrint('URL: $uri');
      debugPrint('Body: $body');

      final response = await client.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 30));

      debugPrint('🟢 MARK LESSON COMPLETE RESPONSE');
      debugPrint('Status Code: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Lesson marked as complete');
        return;
      } else if (response.statusCode == 401) {
        throw const UnauthorizedException();
      } else {
        throw ServerException(
          message: 'Failed to mark lesson complete',
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
  Future<void> markLessonIncomplete({
    required String courseId,
    required String lessonId,
  }) async {
    try {
      final token = await tokenService.getAuthHeader();
      final uri = Uri.parse('$baseUrl/v1/my-courses/$courseId/lessons/$lessonId/incomplete');

      debugPrint('🔵 MARK LESSON INCOMPLETE REQUEST');
      debugPrint('URL: $uri');

      final response = await client.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
      ).timeout(const Duration(seconds: 30));

      debugPrint('🟢 MARK LESSON INCOMPLETE RESPONSE');
      debugPrint('Status Code: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Lesson marked as incomplete');
        return;
      } else if (response.statusCode == 401) {
        throw const UnauthorizedException();
      } else {
        throw ServerException(
          message: 'Failed to mark lesson incomplete',
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
  Future<void> updateLessonProgress({
    required String courseId,
    required String lessonId,
    required int progressPercentage,
    required int watchTimeSeconds,
  }) async {
    try {
      final token = await tokenService.getAuthHeader();
      final uri = Uri.parse('$baseUrl/v1/my-courses/$courseId/lessons/$lessonId/progress');

      final body = {
        'progress_percentage': progressPercentage,
        'watch_time_seconds': watchTimeSeconds,
      };

      debugPrint('🔵 UPDATE LESSON PROGRESS REQUEST');
      debugPrint('URL: $uri');
      debugPrint('Body: $body');

      final response = await client.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 30));

      debugPrint('🟢 UPDATE LESSON PROGRESS RESPONSE');
      debugPrint('Status Code: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('✅ Progress updated');
        return;
      } else if (response.statusCode == 401) {
        throw const UnauthorizedException();
      } else {
        throw ServerException(
          message: 'Failed to update progress',
          statusCode: response.statusCode,
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
