import 'package:equatable/equatable.dart';

/// Abstract base class for all activity events.
abstract class ActivityEvent extends Equatable {
  const ActivityEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load activity history.
class LoadActivityEvent extends ActivityEvent {
  final int page;
  final int limit;

  const LoadActivityEvent({
    this.page = 1,
    this.limit = 20,
  });

  @override
  List<Object?> get props => [page, limit];
}
