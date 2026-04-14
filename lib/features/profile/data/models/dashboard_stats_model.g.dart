// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_stats_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardStatsModel _$DashboardStatsModelFromJson(Map<String, dynamic> json) =>
    DashboardStatsModel(
      user: json['user'] as Map<String, dynamic>?,
      enrollmentStats: json['enrollment_stats'] as Map<String, dynamic>?,
      recentEnrollments: json['recent_enrollments'] as List<dynamic>?,
      expiringSoon: json['expiring_soon'] as List<dynamic>?,
      notifications: json['notifications'] as Map<String, dynamic>?,
      recentActivities: (json['recent_activities'] as List<dynamic>?)
          ?.map((e) => ActivityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DashboardStatsModelToJson(
  DashboardStatsModel instance,
) => <String, dynamic>{
  'user': instance.user,
  'enrollment_stats': instance.enrollmentStats,
  'recent_enrollments': instance.recentEnrollments,
  'expiring_soon': instance.expiringSoon,
  'notifications': instance.notifications,
  'recent_activities': instance.recentActivities,
};
