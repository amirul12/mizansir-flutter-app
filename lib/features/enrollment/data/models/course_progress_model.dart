// File: lib/features/enrollment/data/models/course_progress_model.dart
import 'package:equatable/equatable.dart';
import '../../domain/entities/course_progress.dart';
import 'lesson_model.dart';

/// Course Progress Model
class CourseProgressModel extends Equatable {
  final String courseId;
  final String courseTitle;
  final int totalLessons;
  final int completedLessons;
  final double progressPercentage;
  final int totalWatchTimeSeconds;
  final int totalWatchTimeMinutes;
  final DateTime? lastAccessedAt;
  final List<LessonProgressModel> lessonProgress;

  const CourseProgressModel({
    required this.courseId,
    required this.courseTitle,
    required this.totalLessons,
    required this.completedLessons,
    required this.progressPercentage,
    required this.totalWatchTimeSeconds,
    required this.totalWatchTimeMinutes,
    this.lastAccessedAt,
    this.lessonProgress = const [],
  });

  factory CourseProgressModel.fromJson(Map<String, dynamic> json) {
    List<LessonProgressModel> progressList = [];
    if (json['lesson_progress'] != null && json['lesson_progress'] is List) {
      progressList = (json['lesson_progress'] as List)
          .map((p) => LessonProgressModel.fromJson(p as Map<String, dynamic>))
          .toList();
    }

    return CourseProgressModel(
      courseId: json['course_id']?.toString() ?? '',
      courseTitle: json['course_title'] ?? '',
      totalLessons: json['total_lessons'] is num
          ? (json['total_lessons'] as num).toInt()
          : 0,
      completedLessons: json['completed_lessons'] is num
          ? (json['completed_lessons'] as num).toInt()
          : 0,
      progressPercentage: json['progress_percentage'] is num
          ? (json['progress_percentage'] as num).toDouble()
          : 0.0,
      totalWatchTimeSeconds: json['total_watch_time_seconds'] is num
          ? (json['total_watch_time_seconds'] as num).toInt()
          : 0,
      totalWatchTimeMinutes: json['total_watch_time_minutes'] is num
          ? (json['total_watch_time_minutes'] as num).toInt()
          : 0,
      lastAccessedAt: json['last_accessed_at'] != null
          ? DateTime.tryParse(json['last_accessed_at'])
          : null,
      lessonProgress: progressList,
    );
  }

  CourseProgress toEntity() {
    return CourseProgress(
      courseId: courseId,
      courseTitle: courseTitle,
      totalLessons: totalLessons,
      completedLessons: completedLessons,
      progressPercentage: progressPercentage,
      totalWatchTimeSeconds: totalWatchTimeSeconds,
      totalWatchTimeMinutes: totalWatchTimeMinutes,
      lastAccessedAt: lastAccessedAt,
      lessonProgress: lessonProgress.map((p) => p.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [
        courseId,
        courseTitle,
        totalLessons,
        completedLessons,
        progressPercentage,
        totalWatchTimeSeconds,
        totalWatchTimeMinutes,
        lastAccessedAt,
        lessonProgress,
      ];
}

/// Lesson Progress Model
class LessonProgressModel extends Equatable {
  final String lessonId;
  final String lessonTitle;
  final bool isCompleted;
  final int watchTimeSeconds;
  final int progressPercentage;
  final DateTime? completedAt;
  final DateTime? lastAccessedAt;

  const LessonProgressModel({
    required this.lessonId,
    required this.lessonTitle,
    required this.isCompleted,
    required this.watchTimeSeconds,
    required this.progressPercentage,
    this.completedAt,
    this.lastAccessedAt,
  });

  factory LessonProgressModel.fromJson(Map<String, dynamic> json) {
    return LessonProgressModel(
      lessonId: json['lesson_id']?.toString() ?? '',
      lessonTitle: json['lesson_title'] ?? '',
      isCompleted: json['is_completed'] ?? false,
      watchTimeSeconds: json['watch_time_seconds'] is num
          ? (json['watch_time_seconds'] as num).toInt()
          : 0,
      progressPercentage: json['progress_percentage'] is num
          ? (json['progress_percentage'] as num).toInt()
          : 0,
      completedAt: json['completed_at'] != null
          ? DateTime.tryParse(json['completed_at'])
          : null,
      lastAccessedAt: json['last_accessed_at'] != null
          ? DateTime.tryParse(json['last_accessed_at'])
          : null,
    );
  }

  LessonProgress toEntity() {
    return LessonProgress(
      lessonId: lessonId,
      lessonTitle: lessonTitle,
      isCompleted: isCompleted,
      watchTimeSeconds: watchTimeSeconds,
      progressPercentage: progressPercentage,
      completedAt: completedAt,
      lastAccessedAt: lastAccessedAt,
    );
  }

  @override
  List<Object?> get props => [
        lessonId,
        lessonTitle,
        isCompleted,
        watchTimeSeconds,
        progressPercentage,
        completedAt,
        lastAccessedAt,
      ];
}
