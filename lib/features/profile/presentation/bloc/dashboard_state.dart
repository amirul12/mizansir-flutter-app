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
class DashboardLoading extends DashboardState {}

/// Dashboard loaded state.
class DashboardLoaded extends DashboardState {
  final DashboardStats stats;

  const DashboardLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

/// Activity loaded state.
class ActivityLoaded extends DashboardState {
  final List<Activity> activities;
  final bool hasMore;

  const ActivityLoaded(this.activities, {this.hasMore = false});

  @override
  List<Object?> get props => [activities, hasMore];
}

/// Empty state.
class DashboardEmpty extends DashboardState {
  final String message;

  const DashboardEmpty(this.message);

  @override
  List<Object?> get props => [message];
}

/// Error state.
class DashboardError extends DashboardState {
  final String message;

  const DashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
