import 'package:equatable/equatable.dart';
import 'package:mizansir/features/profile/data/models/activity_model.dart' show ActivityModel;
import 'package:mizansir/features/profile/data/models/dashboard_stats_model.dart';
 
 

/// Abstract base class for all dashboard states.
abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class DashboardInitial extends DashboardState {}

/// Loading state.
class DashboardLoading extends DashboardState {
  final bool isOffline;
  final DashboardStatsModel? existingStats;
  final List<ActivityModel>? existingActivities;

  const DashboardLoading({
    this.isOffline = false,
    this.existingStats,
    this.existingActivities,
  });

  @override
  List<Object?> get props => [isOffline, existingStats, existingActivities];
}

/// Consolidated Dashboard loaded state to hold both stats and activities.
class DashboardLoaded extends DashboardState {
  final DashboardStatsModel? stats;
  final List<ActivityModel>? activities;
  final bool hasMoreActivities;
  final bool isOffline;
  final String? message;

  const DashboardLoaded({
    this.stats,
    this.activities,
    this.hasMoreActivities = false,
    this.isOffline = false,
    this.message,
  });

  DashboardLoaded copyWith({
    DashboardStatsModel? stats,
    List<ActivityModel>? activities,
    bool? hasMoreActivities,
    bool? isOffline,
    String? message,
  }) {
    return DashboardLoaded(
      stats: stats ?? this.stats,
      activities: activities ?? this.activities,
      hasMoreActivities: hasMoreActivities ?? this.hasMoreActivities,
      isOffline: isOffline ?? this.isOffline,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [stats, activities, hasMoreActivities, isOffline, message];
}

/// Error state.
class DashboardError extends DashboardState {
  final String message;
  final DashboardStatsModel? existingStats;
  final List<ActivityModel>? existingActivities;

  const DashboardError(
    this.message, {
    this.existingStats,
    this.existingActivities,
  });

  @override
  List<Object?> get props => [message, existingStats, existingActivities];
}
