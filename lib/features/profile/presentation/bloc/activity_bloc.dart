import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mizansir/features/profile/data/models/activity_model.dart' show ActivityModel;
import '../../domain/usecases/get_activity_usecase.dart';
import 'activity_event.dart';
import 'activity_state.dart';

/// Activity BLoC.
///
/// Manages activity history state and operations.
class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  final GetActivityUseCase getActivityUseCase;

  ActivityBloc({
    required this.getActivityUseCase,
  }) : super(ActivityInitial()) {
    on<LoadActivityEvent>(_onLoadActivity);
  }

  Future<void> _onLoadActivity(
    LoadActivityEvent event,
    Emitter<ActivityState> emit,
  ) async {
    final currentState = state;
    List<ActivityModel>? existingActivities;

    if (currentState is ActivityLoaded) {
      existingActivities = currentState.activities;
    }

    emit(ActivityLoading(existingActivities: existingActivities));

    final result = await getActivityUseCase(
      GetActivityParams(
        page: event.page,
        limit: event.limit,
      ),
    );

    result.fold(
      (failure) => emit(ActivityError(
        _getErrorMessage(failure),
        existingActivities: existingActivities,
      )),
      (activities) {
        final hasMore = activities.length >= event.limit;
        emit(ActivityLoaded(
          activities: activities,
          hasMore: hasMore,
          isOffline: false,
        ));
      },
    );
  }

  String _getErrorMessage(dynamic failure) {
    switch (failure.runtimeType.toString()) {
      case 'NetworkFailure':
        return 'Please check your internet connection and try again.';
      case 'UnauthorizedFailure':
        return 'You are not authorized. Please login again.';
      case 'NotFoundFailure':
        return 'Activity data not found.';
      case 'ServerFailure':
        return 'Server error. Please try again later.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
