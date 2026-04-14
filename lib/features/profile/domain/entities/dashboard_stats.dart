import 'package:equatable/equatable.dart';
import 'activity.dart';

/// Dashboard statistics entity.
class DashboardStats extends Equatable {
  final int totalEnrollments;
  final int activeEnrollments;
  final int pendingEnrollments;
  final int expiredEnrollments;
  final int completedLessons;
  final int totalLessons;
  final double overallProgress; // 0.0 to 1.0
  final List<Activity> recentActivities;
  final List<dynamic> recentEnrollments;
  final List<dynamic> expiringSoon;
  final Map<String, dynamic> notifications;

  const DashboardStats({
    required this.totalEnrollments,
    required this.activeEnrollments,
    this.pendingEnrollments = 0,
    this.expiredEnrollments = 0,
    required this.completedLessons,
    required this.totalLessons,
    required this.overallProgress,
    required this.recentActivities,
    this.recentEnrollments = const [],
    this.expiringSoon = const [],
    this.notifications = const {},
  });

  /// Returns true if user has any enrollments.
  bool get hasEnrollments => totalEnrollments > 0;

  /// Returns true if user has any active enrollments.
  bool get hasActiveEnrollments => activeEnrollments > 0;

  /// Returns true if user has pending enrollments.
  bool get hasPendingEnrollments => pendingEnrollments > 0;

  /// Returns true if user has any expiring soon courses.
  bool get hasExpiringSoon => expiringSoon.isNotEmpty;

  /// Returns completion percentage (0-100).
  double get completionPercentage => overallProgress * 100;

  /// Returns formatted progress string (e.g., "45%").
  String get progressText => '${completionPercentage.toStringAsFixed(0)}%';

  /// Returns number of completed courses (based on progress).
  int get completedCourses {
    return totalEnrollments - activeEnrollments;
  }

  /// Returns true if user has completed any lessons.
  bool get hasCompletedLessons => completedLessons > 0;

  /// Returns time spent learning (estimate: 10 min per lesson).
  int get estimatedLearningMinutes => completedLessons * 10;

  /// Returns formatted learning time (e.g., "2h 30m").
  String get learningTimeText {
    final hours = estimatedLearningMinutes ~/ 60;
    final minutes = estimatedLearningMinutes % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  @override
  List<Object?> get props => [
        totalEnrollments,
        activeEnrollments,
        pendingEnrollments,
        expiredEnrollments,
        completedLessons,
        totalLessons,
        overallProgress,
        recentActivities,
        recentEnrollments,
        expiringSoon,
        notifications,
      ];
}
