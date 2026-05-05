import 'package:equatable/equatable.dart';

/// Abstract base class for all dashboard events.
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load dashboard data.
class LoadDashboardEvent extends DashboardEvent {}

/// Event to clear error state.
class ClearDashboardErrorEvent extends DashboardEvent {}
