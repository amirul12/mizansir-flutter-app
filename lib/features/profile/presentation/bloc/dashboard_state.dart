import 'package:equatable/equatable.dart';
import '../../domain/entities/dashboard_stats.dart';
import '../../domain/entities/activity.dart';

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
  final DashboardStats? existingStats;
  final List<Activity>? existingActivities;

  const DashboardLoading({this.existingStats, this.existingActivities});

  @override
  List<Object?> get props => [existingStats, existingActivities];
}

/// Consolidated Dashboard loaded state to hold both stats and activities.
class DashboardLoaded extends DashboardState {
  final DashboardStats? stats;
  final List<Activity>? activities;
  final bool hasMoreActivities;
  final String? message;

  const DashboardLoaded({
    this.stats,
    this.activities,
    this.hasMoreActivities = false,
    this.message,
  });

  DashboardLoaded copyWith({
    DashboardStats? stats,
    List<Activity>? activities,
    bool? hasMoreActivities,
    String? message,
  }) {
    return DashboardLoaded(
      stats: stats ?? this.stats,
      activities: activities ?? this.activities,
      hasMoreActivities: hasMoreActivities ?? this.hasMoreActivities,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [stats, activities, hasMoreActivities, message];
}

/// Error state.
class DashboardError extends DashboardState {
  final String message;
  final DashboardStats? stats;
  final List<Activity>? activities;

  const DashboardError(this.message, {this.stats, this.activities});

  @override
  List<Object?> get props => [message, stats, activities];
}
