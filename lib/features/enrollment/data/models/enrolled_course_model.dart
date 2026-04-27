// File: lib/features/enrollment/data/models/enrolled_course_model.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/enrolled_course.dart';
import 'lesson_model.dart';
import 'enrollment_model.dart';

/// Enrolled Course Model
class EnrolledCourseModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? thumbnail;
  final String status;
  final String? level;
  final int totalLessons;
  final int completedLessons;
  final double progressPercentage;
  final int totalWatchTimeMinutes;
  final String? nextLessonId; // ID of the next lesson to continue
  final EnrollmentModel? enrollment;
  final List<LessonModel> lessons;
  final DateTime enrolledAt;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EnrolledCourseModel({
    required this.id,
    required this.title,
    required this.description,
    this.thumbnail,
    required this.status,
    this.level,
    required this.totalLessons,
    required this.completedLessons,
    required this.progressPercentage,
    required this.totalWatchTimeMinutes,
    this.nextLessonId,
    this.enrollment,
    this.lessons = const [],
    required this.enrolledAt,
    this.expiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EnrolledCourseModel.fromJson(Map<String, dynamic> json) {
    // Handle lessons array
    List<LessonModel> lessonsList = [];
    if (json['lessons'] != null && json['lessons'] is List) {
      lessonsList = (json['lessons'] as List)
          .map((lesson) => LessonModel.fromJson(lesson as Map<String, dynamic>))
          .toList();
    }

    // Handle nested structure from API response
    // API returns: { id, course: { id, title, description, ... }, status, enrolled_at, expires_at, ... }
    final course = json['course'] is Map ? json['course'] as Map<String, dynamic> : json;
    final courseId = course['id']?.toString() ?? json['course_id']?.toString() ?? '';

    return EnrolledCourseModel(
      id: courseId,
      title: course['title'] ?? json['title'] ?? '',
      description: course['description'] ?? json['description'] ?? '',
      thumbnail: course['thumbnail'] ?? json['thumbnail'],
      status: json['status'] ?? 'active',
      level: course['level'] ?? json['level'],
      totalLessons: json['total_lessons'] is num
          ? (json['total_lessons'] as num).toInt()
          : (course['total_lessons'] is num ? (course['total_lessons'] as num).toInt() : 0),
      completedLessons: json['completed_lessons'] is num
          ? (json['completed_lessons'] as num).toInt()
          : 0,
      progressPercentage: json['progress_percentage'] is num
          ? (json['progress_percentage'] as num).toDouble()
          : 0.0,
      totalWatchTimeMinutes: json['total_watch_time_minutes'] is num
          ? (json['total_watch_time_minutes'] as num).toInt()
          : 0,
      nextLessonId: json['progress'] is Map
          ? json['progress']['next_lesson_id']?.toString()
          : null,
      enrollment: json['enrollment'] != null
          ? EnrollmentModel.fromJson(json['enrollment'] as Map<String, dynamic>)
          : null, // Don't create enrollment from my-courses response structure
      lessons: lessonsList,
      enrolledAt: json['enrolled_at'] != null
          ? DateTime.tryParse(json['enrolled_at']) ?? DateTime.now()
          : DateTime.tryParse(course['created_at'] ?? '') ?? DateTime.now(),
      expiresAt: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'])
          : null,
      createdAt: course['created_at'] != null
          ? DateTime.tryParse(course['created_at'] ?? '') ?? DateTime.now()
          : DateTime.now(),
      updatedAt: course['updated_at'] != null
          ? DateTime.tryParse(course['updated_at'] ?? '') ?? DateTime.now()
          : DateTime.now(),
    );
  }

  EnrolledCourse toEntity() {
    return EnrolledCourse(
      id: id,
      title: title,
      description: description,
      thumbnail: thumbnail,
      status: status,
      level: level,
      totalLessons: totalLessons,
      completedLessons: completedLessons,
      progressPercentage: progressPercentage,
      totalWatchTimeMinutes: totalWatchTimeMinutes,
      nextLessonId: nextLessonId,
      enrollment: enrollment?.toEntity(),
      lessons: lessons,
      enrolledAt: enrolledAt,
      expiresAt: expiresAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        thumbnail,
        status,
        level,
        totalLessons,
        completedLessons,
        progressPercentage,
        totalWatchTimeMinutes,
        nextLessonId,
        enrollment,
        lessons,
        enrolledAt,
        expiresAt,
        createdAt,
        updatedAt,
      ];
}
