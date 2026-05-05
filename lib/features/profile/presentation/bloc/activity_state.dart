import 'package:equatable/equatable.dart';
import 'package:mizansir/features/profile/data/models/activity_model.dart' show ActivityModel;

/// Abstract base class for all activity states.
abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object?> get props => [];
}

/// Initial state.
class ActivityInitial extends ActivityState {}

/// Loading state.
class ActivityLoading extends ActivityState {
  final List<ActivityModel>? existingActivities;

  const ActivityLoading({this.existingActivities});

  @override
  List<Object?> get props => [existingActivities];
}

/// Loaded state.
class ActivityLoaded extends ActivityState {
  final List<ActivityModel> activities;
  final bool hasMore;
  final bool isOffline;
  final String? message;

  const ActivityLoaded({
    required this.activities,
    this.hasMore = false,
    this.isOffline = false,
    this.message,
  });

  @override
  List<Object?> get props => [activities, hasMore, isOffline, message];
}

/// Error state.
class ActivityError extends ActivityState {
  final String message;
  final List<ActivityModel>? existingActivities;

  const ActivityError(
    this.message, {
    this.existingActivities,
  });

  @override
  List<Object?> get props => [message, existingActivities];
}
