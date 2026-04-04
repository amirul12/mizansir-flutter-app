import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/no_params.dart';
import '../../domain/usecases/get_dashboard_usecase.dart';
import '../../domain/usecases/get_activity_usecase.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';

/// Dashboard BLoC.
///
/// Manages dashboard-related state and operations.
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardUseCase getDashboardUseCase;
  final GetActivityUseCase getActivityUseCase;

  DashboardBloc({
    required this.getDashboardUseCase,
    required this.getActivityUseCase,
  }) : super(DashboardInitial()) {
    on<LoadDashboardEvent>(_onLoadDashboard);
    on<LoadActivityEvent>(_onLoadActivity);
    on<ClearDashboardErrorEvent>(_onClearError);
  }

  Future<void> _onLoadDashboard(
    LoadDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    final result = await getDashboardUseCase(NoParams());

    result.fold(
      (failure) => emit(DashboardError(_getErrorMessage(failure))),
      (stats) => emit(DashboardLoaded(stats)),
    );
  }

  Future<void> _onLoadActivity(
    LoadActivityEvent event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    final result = await getActivityUseCase(
      GetActivityParams(
        page: event.page,
        limit: event.limit,
      ),
    );

    result.fold(
      (failure) => emit(DashboardError(_getErrorMessage(failure))),
      (activities) {
        if (activities.isEmpty) {
          return emit(DashboardEmpty('No activity yet'));
        }
        final hasMore = activities.length >= event.limit;
        emit(ActivityLoaded(activities, hasMore: hasMore));
      },
    );
  }

  Future<void> _onClearError(
    ClearDashboardErrorEvent event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardError) {
      emit(DashboardInitial());
    }
  }

  String _getErrorMessage(dynamic failure) {
    switch (failure.runtimeType.toString()) {
      case 'NetworkFailure':
        return 'Please check your internet connection and try again.';
      case 'UnauthorizedFailure':
        return 'You are not authorized. Please login again.';
      case 'NotFoundFailure':
        return 'Data not found.';
      case 'ServerFailure':
        return 'Server error. Please try again later.';
      default:
        return 'An unexpected error occurred. Please try again.';
    }
  }
}
