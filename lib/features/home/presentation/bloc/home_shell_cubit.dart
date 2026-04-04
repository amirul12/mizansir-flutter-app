import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/home_tab.dart';

/// Home shell cubit for managing tab navigation.
class HomeShellCubit extends Cubit<HomeTab> {
  HomeShellCubit() : super(HomeTab.home);

  /// Change the current tab.
  void setTab(HomeTab tab) {
    if (state != tab) {
      emit(tab);
    }
  }

  /// Navigate to home tab.
  void goToHome() => setTab(HomeTab.home);

  /// Navigate to courses tab.
  void goToCourses() => setTab(HomeTab.courses);

  /// Navigate to my learning tab.
  void goToMyLearning() => setTab(HomeTab.myLearning);

  /// Navigate to activity tab.
  void goToActivity() => setTab(HomeTab.activity);

  /// Navigate to profile tab.
  void goToProfile() => setTab(HomeTab.profile);
}
