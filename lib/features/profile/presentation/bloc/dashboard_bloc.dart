import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mizansir/features/profile/data/models/dashboard_stats_model.dart' show DashboardStatsModel;
import '../../../../core/usecases/no_params.dart';
import '../../domain/usecases/get_dashboard_usecase.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

/// Dashboard BLoC.
///
/// Manages dashboard-related state and operations.
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardUseCase getDashboardUseCase;

  DashboardBloc({
    required this.getDashboardUseCase,
  }) : super(DashboardInitial()) {
    on<LoadDashboardEvent>(_onLoadDashboard);
    on<ClearDashboardErrorEvent>(_onClearError);
  }

  Future<void> _onLoadDashboard(
    LoadDashboardEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final currentState = state;
    DashboardStatsModel? existingStats;

    if (currentState is DashboardLoaded) {
      existingStats = currentState.stats;
    }

    emit(DashboardLoading(
      isOffline: false,
      existingStats: existingStats,
    ));

    final result = await getDashboardUseCase(NoParams());

    result.fold(
      (failure) => emit(DashboardError(
        failure.message!,
        existingStats: existingStats,
      )),
      (stats) {
        emit(DashboardLoaded(
          stats: stats,
          isOffline: false,
        ));
      },
    );
  }

  Future<void> _onClearError(
    ClearDashboardErrorEvent event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardError) {
      final errorState = state as DashboardError;
      if (errorState.existingStats != null) {
        emit(DashboardLoaded(
          stats: errorState.existingStats!,
          isOffline: true,
        ));
      }
    }
  }

 
}
