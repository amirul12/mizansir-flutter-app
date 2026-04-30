import 'package:hive_flutter/hive_flutter.dart';
import 'package:mizansir/features/profile/data/models/activity_model.dart';
import 'package:mizansir/features/profile/data/models/dashboard_stats_model.dart';

abstract class HiveService {
  Future<void> init();
  Future<void> saveDashboard(String dashboardJson);
  Future<String?> getDashboard();
  Future<void> saveActivities(String activitiesJson);
  Future<String?> getActivities();
  Future<void> saveMyCourses(String coursesJson);
  Future<String?> getMyCourses();
  Future<void> saveCourseLessons(String courseId, String lessonsJson);
  Future<String?> getCourseLessons(String courseId);
  Future<void> saveLessonDetails(String courseId, String lessonId, String detailsJson);
  Future<String?> getLessonDetails(String courseId, String lessonId);
  Future<void> saveCourseProgress(String courseId, String progressJson);
  Future<String?> getCourseProgress(String courseId);
  Future<void> clearDashboard();
  Future<void> clearActivities();
}

class HiveServiceImpl implements HiveService {
  static const String _dashboardBoxName = 'dashboardBox';
  static const String _activitiesBoxName = 'activitiesBox';
  static const String _enrollmentBoxName = 'enrollmentBox';
  static const String _dashboardKey = 'dashboard';
  static const String _activitiesKey = 'activities';

  late Box _dashboardBox;
  late Box _activitiesBox;
  late Box _enrollmentBox;

  @override
  Future<void> init() async {
    await Hive.initFlutter();
    _dashboardBox = await Hive.openBox(_dashboardBoxName);
    _activitiesBox = await Hive.openBox(_activitiesBoxName);
    _enrollmentBox = await Hive.openBox(_enrollmentBoxName);
  }

  @override
  Future<void> saveDashboard(String dashboardJson) async {
    await _dashboardBox.put(_dashboardKey, dashboardJson);
  }

  @override
  Future<String?> getDashboard() async {
    return _dashboardBox.get(_dashboardKey);
  }

  @override
  Future<void> saveActivities(String activitiesJson) async {
    await _activitiesBox.put(_activitiesKey, activitiesJson);
  }

  @override
  Future<String?> getActivities() async {
    return _activitiesBox.get(_activitiesKey);
  }

  @override
  Future<void> clearDashboard() async {
    await _dashboardBox.delete(_dashboardKey);
  }

  @override
  Future<void> clearActivities() async {
    await _activitiesBox.delete(_activitiesKey);
  }

  @override
  Future<void> saveMyCourses(String coursesJson) async {
    await _enrollmentBox.put('my_courses', coursesJson);
  }

  @override
  Future<String?> getMyCourses() async {
    return _enrollmentBox.get('my_courses');
  }

  @override
  Future<void> saveCourseLessons(String courseId, String lessonsJson) async {
    await _enrollmentBox.put('course_lessons_$courseId', lessonsJson);
  }

  @override
  Future<String?> getCourseLessons(String courseId) async {
    return _enrollmentBox.get('course_lessons_$courseId');
  }

  @override
  Future<void> saveLessonDetails(String courseId, String lessonId, String detailsJson) async {
    await _enrollmentBox.put('lesson_${courseId}_$lessonId', detailsJson);
  }

  @override
  Future<String?> getLessonDetails(String courseId, String lessonId) async {
    return _enrollmentBox.get('lesson_${courseId}_$lessonId');
  }

  @override
  Future<void> saveCourseProgress(String courseId, String progressJson) async {
    await _enrollmentBox.put('course_progress_$courseId', progressJson);
  }

  @override
  Future<String?> getCourseProgress(String courseId) async {
    return _enrollmentBox.get('course_progress_$courseId');
  }
}
