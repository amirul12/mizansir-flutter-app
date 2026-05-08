import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:mizansir/features/profile/data/models/dashboard_stats_model.dart' show DashboardStatsModel;
import '../../../../core/usecases/no_params.dart';
import '../../domain/usecases/get_dashboard_usecase.dart';

import 'dashboard_event.dart';
import 'dashboard_state.dart';

/// Dashboard BLoC with persistence.
///
/// Manages dashboard-related state and operations.
class DashboardBloc extends HydratedBloc<DashboardEvent, DashboardState> {
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

  @override
  DashboardState? fromJson(Map<String, dynamic> json) {
    try {
      final stateType = json['stateType'] as String?;

      if (stateType == 'DashboardLoaded') {
        final statsJson = json['stats'] as Map<String, dynamic>?;
        if (statsJson != null) {
          return DashboardLoaded(
            stats: DashboardStatsModel.fromJson(statsJson),
            isOffline: json['isOffline'] as bool? ?? true,
            message: json['message'] as String?,
          );
        }
      }
    } catch (_) {}

    return null;
  }

  @override
  Map<String, dynamic>? toJson(DashboardState state) {
    if (state is DashboardLoaded) {
      return {
        'stateType': 'DashboardLoaded',
        'stats': state.stats.toJson(),
        'isOffline': state.isOffline,
        if (state.message != null) 'message': state.message,
      };
    }

    return null;
  }
}
