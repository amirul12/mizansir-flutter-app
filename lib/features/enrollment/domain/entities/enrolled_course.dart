// File: lib/features/enrollment/domain/entities/enrolled_course.dart
import 'package:equatable/equatable.dart';
import 'package:mizansir/features/enrollment/data/models/lesson_model.dart' show LessonModel;
import 'lesson.dart';
import 'enrollment.dart';

/// Enrolled Course Entity
class EnrolledCourse extends Equatable {
  final String id;
  final String title;
  final String description;
  final String? thumbnail;
  final String status; // active, completed, expired, pending
  final String? level;
  final int totalLessons;
  final int completedLessons;
  final double progressPercentage;
  final int totalWatchTimeMinutes;
  final String? nextLessonId; // ID of the next lesson to continue
  final Enrollment? enrollment;
  final List<LessonModel> lessons;
  final DateTime enrolledAt;
  final DateTime? expiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EnrolledCourse({
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

  // Getters
  bool get isActive => status == 'active';
  bool get isCompleted => status == 'completed' || progressPercentage >= 100;
  bool get isExpired => status == 'expired';
  bool get isPending => status == 'pending';
  bool get hasThumbnail => thumbnail != null && thumbnail!.isNotEmpty;
  bool get hasLevel => level != null && level!.isNotEmpty;
  bool get hasEnrollment => enrollment != null;

  String get progressLabel {
    if (isCompleted) return 'Completed';
    if (progressPercentage >= 75) return 'Almost Done';
    if (progressPercentage >= 50) return 'Halfway';
    if (progressPercentage >= 25) return 'Started';
    return 'Just Started';
  }

  String get formattedWatchTime {
    final hours = totalWatchTimeMinutes ~/ 60;
    final minutes = totalWatchTimeMinutes % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get statusLabel {
    switch (status) {
      case 'active':
        return 'Active';
      case 'completed':
        return 'Completed';
      case 'expired':
        return 'Expired';
      case 'pending':
        return 'Pending';
      default:
        return status;
    }
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
