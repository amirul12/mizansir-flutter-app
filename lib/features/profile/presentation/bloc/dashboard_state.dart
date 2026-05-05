import 'package:equatable/equatable.dart';
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

  const DashboardLoading({
    this.isOffline = false,
    this.existingStats,
  });

  @override
  List<Object?> get props => [isOffline, existingStats];
}

/// Dashboard loaded state.
class DashboardLoaded extends DashboardState {
  final DashboardStatsModel stats;
  final bool isOffline;
  final String? message;

  const DashboardLoaded({
    required this.stats,
    this.isOffline = false,
    this.message,
  });

  @override
  List<Object?> get props => [stats, isOffline, message];
}

/// Error state.
class DashboardError extends DashboardState {
  final String message;
  final DashboardStatsModel? existingStats;

  const DashboardError(
    this.message, {
    this.existingStats,
  });

  @override
  List<Object?> get props => [message, existingStats];
}
