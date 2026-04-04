// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardStatsModel _$DashboardStatsModelFromJson(Map<String, dynamic> json) =>
    DashboardStatsModel(
      totalEnrollments: (json['total_enrollments'] as num).toInt(),
      activeEnrollments: (json['active_enrollments'] as num).toInt(),
      completedLessons: (json['completed_lessons'] as num).toInt(),
      totalLessons: (json['total_lessons'] as num).toInt(),
      overallProgress: (json['overall_progress'] as num).toDouble(),
      recentActivities: (json['recent_activities'] as List<dynamic>)
          .map((e) => ActivityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DashboardStatsModelToJson(
  DashboardStatsModel instance,
) => <String, dynamic>{
  'total_enrollments': instance.totalEnrollments,
  'active_enrollments': instance.activeEnrollments,
  'completed_lessons': instance.completedLessons,
  'total_lessons': instance.totalLessons,
  'overall_progress': instance.overallProgress,
  'recent_activities': instance.recentActivities,
};
