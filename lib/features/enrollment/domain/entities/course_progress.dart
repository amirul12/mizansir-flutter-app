// File: lib/features/enrollment/domain/entities/course_progress.dart
import 'package:equatable/equatable.dart';

/// Course Progress Entity
class CourseProgress extends Equatable {
  final String courseId;
  final String courseTitle;
  final int totalLessons;
  final int completedLessons;
  final double progressPercentage;
  final int totalWatchTimeSeconds;
  final int totalWatchTimeMinutes;
  final DateTime? lastAccessedAt;
  final List<LessonProgress> lessonProgress;

  const CourseProgress({
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

  // Getters
  bool get isCompleted => progressPercentage >= 100;
  bool get hasStarted => completedLessons > 0;
  double get progressDecimal => progressPercentage / 100;

  String get formattedWatchTime {
    final hours = totalWatchTimeMinutes ~/ 60;
    final minutes = totalWatchTimeMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get progressLabel {
    if (isCompleted) return 'Completed';
    if (progressPercentage >= 75) return 'Almost Done';
    if (progressPercentage >= 50) return 'Halfway';
    if (progressPercentage >= 25) return 'Making Progress';
    if (hasStarted) return 'Just Started';
    return 'Not Started';
  }

  LessonProgress? getProgressForLesson(String lessonId) {
    try {
      return lessonProgress.firstWhere((p) => p.lessonId == lessonId);
    } catch (e) {
      return null;
    }
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

/// Lesson Progress Entity
class LessonProgress extends Equatable {
  final String lessonId;
  final String lessonTitle;
  final bool isCompleted;
  final int watchTimeSeconds;
  final int progressPercentage;
  final DateTime? completedAt;
  final DateTime? lastAccessedAt;

  const LessonProgress({
    required this.lessonId,
    required this.lessonTitle,
    required this.isCompleted,
    required this.watchTimeSeconds,
    required this.progressPercentage,
    this.completedAt,
    this.lastAccessedAt,
  });

  String get formattedWatchTime {
    final minutes = (watchTimeSeconds / 60).floor();
    if (minutes > 0) return '${minutes}m';
    return '${watchTimeSeconds}s';
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
