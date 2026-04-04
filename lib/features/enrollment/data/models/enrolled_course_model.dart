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

    return EnrolledCourseModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      thumbnail: json['thumbnail'],
      status: json['status'] ?? 'active',
      level: json['level'],
      totalLessons: json['total_lessons'] is num
          ? (json['total_lessons'] as num).toInt()
          : 0,
      completedLessons: json['completed_lessons'] is num
          ? (json['completed_lessons'] as num).toInt()
          : 0,
      progressPercentage: json['progress_percentage'] is num
          ? (json['progress_percentage'] as num).toDouble()
          : 0.0,
      totalWatchTimeMinutes: json['total_watch_time_minutes'] is num
          ? (json['total_watch_time_minutes'] as num).toInt()
          : 0,
      enrollment: json['enrollment'] != null
          ? EnrollmentModel.fromJson(json['enrollment'] as Map<String, dynamic>)
          : null,
      lessons: lessonsList,
      enrolledAt: DateTime.tryParse(json['enrolled_at'] ?? '') ?? DateTime.now(),
      expiresAt: json['expires_at'] != null
          ? DateTime.tryParse(json['expires_at'])
          : null,
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
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
      enrollment: enrollment?.toEntity(),
      lessons: lessons.map((lesson) => lesson.toEntity()).toList(),
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
        enrollment,
        lessons,
        enrolledAt,
        expiresAt,
        createdAt,
        updatedAt,
      ];
}
