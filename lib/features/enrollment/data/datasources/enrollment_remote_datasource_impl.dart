import 'package:flutter/foundation.dart';
import '../../../../core/services/api_service_method.dart';
import '../../../../core/services/api_exception.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/utils/common_json.dart';
import '../models/enrolled_course_model.dart';
import '../models/my_course_model.dart';
import '../models/lesson_model.dart';
import '../models/course_progress_model.dart';
import 'enrollment_remote_datasource.dart';

/// Enrollment Remote Data Source Implementation using ApiMethod
class EnrollmentRemoteDataSourceImpl implements EnrollmentRemoteDataSource {
  EnrollmentRemoteDataSourceImpl();

  @override
  Future<List<MyCourseModel>> getMyCourses() async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        '${ApiConstants.baseUrl}${ApiConstants.myCoursesEndpoint}',
        showResult: true,
      );

      if (mapResponse == null) {
        throw ServerException('No data received');
      }

      final dataList = CommonToJson().getString(mapResponse);
      if (dataList == null) {
        throw ServerException('Invalid data format');
      }

      return myCourseModelFromJson(dataList);
    } catch (e) {
      debugPrint('Error in getMyCourses: $e');
      rethrow;
    }
  }

  @override
  Future<EnrolledCourseModel> getEnrolledCourseDetails(String courseId) async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        '${ApiConstants.baseUrl}${ApiConstants.myCoursesEndpoint}/$courseId',
        showResult: true,
      );

      if (mapResponse == null) {
        throw ServerException('No data received');
      }

      final dataMap = CommonToJson().getString(mapResponse);
      if (dataMap == null) {
        throw ServerException('Invalid data format');
      }

      return EnrolledCourseModel.fromJson(dataMap);
    } catch (e) {
      debugPrint('Error in getEnrolledCourseDetails: $e');
      rethrow;
    }
  }

  @override
  Future<List<LessonModel>> getCourseLessons(String courseId) async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        '${ApiConstants.baseUrl}${ApiConstants.myCoursesEndpoint}/$courseId/lessons',
        showResult: true,
      );

      if (mapResponse == null) {
        throw ServerException('No data received');
      }

      final dataMap = CommonToJson().getString(mapResponse);
      if (dataMap == null) {
        throw ServerException('Invalid data format');
      }

      // Handle modules structure
      // API returns: { course, enrollment, modules: [...], progress, navigation }
      if (dataMap['modules'] is List) {
        final modules = dataMap['modules'] as List;
        final List<LessonModel> allLessons = [];

        // Flatten lessons from all modules
        for (var module in modules) {
          if (module is Map && module['lessons'] is List) {
            final lessons = module['lessons'] as List;
            for (var lesson in lessons) {
              if (lesson is Map) {
                // Add module_name and course_id to lesson data
                final lessonMap = lesson as Map<String, dynamic>;
                lessonMap['module_name'] = module['module_name'];
                lessonMap['course_id'] = courseId;
                allLessons.add(LessonModel.fromJson(lessonMap));
              }
            }
          }
        }

        debugPrint(
          '✅ Successfully parsed ${allLessons.length} lessons from modules',
        );
        return allLessons;
      }

      throw ServerException('Invalid data format');
    } catch (e) {
      debugPrint('Error in getCourseLessons: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, LessonModel?>> getLessonDetails({
    required String courseId,
    required String lessonId,
  }) async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        '${ApiConstants.baseUrl}${ApiConstants.myCoursesEndpoint}/$courseId/lessons/$lessonId',
        showResult: true,
      );

      if (mapResponse == null) {
        throw ServerException('No data received');
      }

      final dataMap = CommonToJson().getString(mapResponse);
      if (dataMap == null) {
        throw ServerException('Invalid data format');
      }

      // Parse current lesson
      final lesson = LessonModel.fromJson(dataMap);

      // Parse navigation
      LessonModel? nextLesson;
      LessonModel? previousLesson;

      if (dataMap['navigation'] is Map) {
        final navigation = dataMap['navigation'] as Map<String, dynamic>;

        // Parse next lesson
        if (navigation['next_lesson'] is Map) {
          nextLesson = LessonModel.fromJson(navigation['next_lesson']);
        }

        // Parse previous lesson
        if (navigation['previous_lesson'] is Map) {
          previousLesson = LessonModel.fromJson(navigation['previous_lesson']);
        }
      }

      debugPrint('✅ Lesson details loaded: ${lesson.title}');

      return {
        'lesson': lesson,
        'nextLesson': nextLesson,
        'previousLesson': previousLesson,
      };
    } catch (e) {
      debugPrint('Error in getLessonDetails: $e');
      rethrow;
    }
  }

  @override
  Future<CourseProgressModel> getCourseProgress(String courseId) async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        '${ApiConstants.baseUrl}${ApiConstants.myCoursesEndpoint}/$courseId/progress',
        showResult: true,
      );

      if (mapResponse == null) {
        throw ServerException('No data received');
      }

      final dataMap = CommonToJson().getString(mapResponse);
      if (dataMap == null) {
        throw ServerException('Invalid data format');
      }

      return CourseProgressModel.fromJson(dataMap);
    } catch (e) {
      debugPrint('Error in getCourseProgress: $e');
      rethrow;
    }
  }

  @override
  Future<void> markLessonComplete({
    required String courseId,
    required String lessonId,
    int? watchTimeSeconds,
    int? progressPercentage,
  }) async {
    Map<String, dynamic>? mapResponse;

    try {
      final body = <String, dynamic>{};
      if (watchTimeSeconds != null) {
        body['watch_time_seconds'] = watchTimeSeconds;
      }
      if (progressPercentage != null) {
        body['progress_percentage'] = progressPercentage;
      }

      mapResponse = await ApiMethod(isBasic: false).post(
        '${ApiConstants.baseUrl}${ApiConstants.myCoursesEndpoint}/$courseId/lessons/$lessonId/complete',
        body,
        showResult: true,
      );

      if (mapResponse == null) {
        throw ServerException('No data received');
      }

      debugPrint('✅ Lesson marked as complete');
    } catch (e) {
      debugPrint('Error in markLessonComplete: $e');
      rethrow;
    }
  }

  @override
  Future<void> markLessonIncomplete({
    required String courseId,
    required String lessonId,
  }) async {
    Map<String, dynamic>? mapResponse;

    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        '${ApiConstants.baseUrl}${ApiConstants.myCoursesEndpoint}/$courseId/lessons/$lessonId/incomplete',
        {},
        showResult: true,
      );

      if (mapResponse == null) {
        throw ServerException('No data received');
      }

      debugPrint('✅ Lesson marked as incomplete');
    } catch (e) {
      debugPrint('Error in markLessonIncomplete: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateLessonProgress({
    required String courseId,
    required String lessonId,
    required int progressPercentage,
    required int watchTimeSeconds,
  }) async {
    Map<String, dynamic>? mapResponse;

    try {
      final body = {
        'progress_percentage': progressPercentage,
        'watch_time_seconds': watchTimeSeconds,
      };

      mapResponse = await ApiMethod(isBasic: false).post(
        '${ApiConstants.baseUrl}${ApiConstants.myCoursesEndpoint}/$courseId/lessons/$lessonId/progress',
        body,
        showResult: true,
      );

      if (mapResponse == null) {
        throw ServerException('No data received');
      }

      debugPrint('✅ Progress updated');
    } catch (e) {
      debugPrint('Error in updateLessonProgress: $e');
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> createEnrollment({
    required String courseId,
    String? paymentMethod,
    String? paymentNotes,
    String? transactionId,
  }) async {
    Map<String, dynamic>? mapResponse;

    try {
      final body = <String, dynamic>{
        'course_id': courseId,
        if (paymentMethod != null) 'payment_method': paymentMethod,
        if (paymentNotes != null) 'payment_notes': paymentNotes,
        if (transactionId != null) 'transaction_id': transactionId,
      };

      mapResponse = await ApiMethod(isBasic: false).post(
        '${ApiConstants.baseUrl}${ApiConstants.enrollmentsPath}',
        body,
        showResult: true,
      );

      if (mapResponse == null) {
        throw ServerException('No data received');
      }

      if (mapResponse['success'] == true) {
        debugPrint('✅ Enrollment created successfully');
        return mapResponse;
      }

      throw ServerException('Invalid response format');
    } catch (e) {
      debugPrint('Error in createEnrollment: $e');
      rethrow;
    }
  }
}
