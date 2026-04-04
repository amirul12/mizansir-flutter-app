import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/dashboard_stats.dart';
import 'activity_model.dart';

part 'dashboard_stats_model.g.dart';

/// Dashboard statistics model for JSON serialization.
@JsonSerializable()
class DashboardStatsModel {
  @JsonKey(name: 'total_enrollments')
  final int totalEnrollments;
  @JsonKey(name: 'active_enrollments')
  final int activeEnrollments;
  @JsonKey(name: 'completed_lessons')
  final int completedLessons;
  @JsonKey(name: 'total_lessons')
  final int totalLessons;
  @JsonKey(name: 'overall_progress')
  final double overallProgress;
  @JsonKey(name: 'recent_activities')
  final List<ActivityModel> recentActivities;

  DashboardStatsModel({
    required this.totalEnrollments,
    required this.activeEnrollments,
    required this.completedLessons,
    required this.totalLessons,
    required this.overallProgress,
    required this.recentActivities,
  });

  /// Create DashboardStatsModel from JSON.
  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardStatsModelFromJson(json);

  /// Convert DashboardStatsModel to JSON.
  Map<String, dynamic> toJson() => _$DashboardStatsModelToJson(this);

  /// Convert to DashboardStats entity.
  DashboardStats toEntity() {
    return DashboardStats(
      totalEnrollments: totalEnrollments,
      activeEnrollments: activeEnrollments,
      completedLessons: completedLessons,
      totalLessons: totalLessons,
      overallProgress: overallProgress,
      recentActivities: recentActivities.map((a) => a.toEntity()).toList(),
    );
  }

  /// Create DashboardStatsModel from DashboardStats entity.
  factory DashboardStatsModel.fromEntity(DashboardStats entity) {
    return DashboardStatsModel(
      totalEnrollments: entity.totalEnrollments,
      activeEnrollments: entity.activeEnrollments,
      completedLessons: entity.completedLessons,
      totalLessons: entity.totalLessons,
      overallProgress: entity.overallProgress,
      recentActivities: entity.recentActivities
          .map((a) => ActivityModel.fromEntity(a))
          .toList(),
    );
  }
}
