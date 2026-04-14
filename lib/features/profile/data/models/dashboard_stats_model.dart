import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/dashboard_stats.dart';
import 'activity_model.dart';

part 'dashboard_stats_model.g.dart';

/// Dashboard statistics model for JSON serialization.
@JsonSerializable()
class DashboardStatsModel {
  // User information
  @JsonKey(name: 'user')
  final Map<String, dynamic>? user;

  // Enrollment statistics
  @JsonKey(name: 'enrollment_stats')
  final Map<String, dynamic>? enrollmentStats;

  // Recent enrollments
  @JsonKey(name: 'recent_enrollments')
  final List<dynamic>? recentEnrollments;

  // Expiring soon courses
  @JsonKey(name: 'expiring_soon')
  final List<dynamic>? expiringSoon;

  // Notifications
  @JsonKey(name: 'notifications')
  final Map<String, dynamic>? notifications;

  // Recent activities (for activity feed)
  @JsonKey(name: 'recent_activities')
  final List<ActivityModel>? recentActivities;

  DashboardStatsModel({
    this.user,
    this.enrollmentStats,
    this.recentEnrollments,
    this.expiringSoon,
    this.notifications,
    this.recentActivities,
  });

  /// Create DashboardStatsModel from JSON.
  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsModelFromJson(json);

  /// Convert DashboardStatsModel to JSON.
  Map<String, dynamic> toJson() => _$DashboardStatsModelToJson(this);

  /// Convert to DashboardStats entity.
  DashboardStats toEntity() {
    // Extract enrollment stats
    final stats = enrollmentStats;
    final totalEnroll = stats?['total'] ?? 0;
    final activeEnroll = stats?['active'] ?? 0;
    final pendingEnroll = stats?['pending'] ?? 0;
    final expiredEnroll = stats?['expired'] ?? 0;

    return DashboardStats(
      totalEnrollments: totalEnroll,
      activeEnrollments: activeEnroll,
      pendingEnrollments: pendingEnroll,
      expiredEnrollments: expiredEnroll,
      completedLessons: 0,
      totalLessons: 0,
      overallProgress: 0.0,
      recentActivities: recentActivities?.map((a) => a.toEntity()).toList() ??
          [],
      recentEnrollments: recentEnrollments ?? [],
      expiringSoon: expiringSoon ?? [],
      notifications: notifications ?? {},
    );
  }

  /// Create DashboardStatsModel from DashboardStats entity.
  factory DashboardStatsModel.fromEntity(DashboardStats entity) {
    return DashboardStatsModel(
      recentActivities: entity.recentActivities
          .map((a) => ActivityModel.fromEntity(a))
          .toList(),
    );
  }
}
