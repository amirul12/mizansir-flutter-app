import 'package:equatable/equatable.dart';

/// Abstract base class for all dashboard events.
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load dashboard data.
class LoadDashboardEvent extends DashboardEvent {}

/// Event to load activity history.
class LoadActivityEvent extends DashboardEvent {
  final int page;
  final int limit;

  const LoadActivityEvent({
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [page, limit];
}

/// Event to clear error state.
class ClearDashboardErrorEvent extends DashboardEvent {}
