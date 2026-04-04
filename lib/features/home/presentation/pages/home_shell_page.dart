import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_event.dart';
import '../../../profile/presentation/bloc/dashboard_bloc.dart';
import '../../../profile/presentation/bloc/dashboard_event.dart';
import '../../../enrollment/presentation/bloc/enrollment_bloc.dart';
import '../../../enrollment/presentation/bloc/enrollment_event.dart';
import '../../../course_browsing/presentation/bloc/course_bloc.dart';
import '../../../course_browsing/presentation/bloc/course_event.dart';
import '../../domain/entities/home_tab.dart';
import '../bloc/home_shell_cubit.dart';
import '../widgets/home_bottom_nav_bar.dart';
import '../widgets/home_drawer.dart';
import 'home_dashboard_page.dart';
import '../../../../core/di/injection_container.dart' as di;

/// Home Shell Page - Main authenticated app container.
///
/// This is the main entry point for authenticated users.
/// Contains bottom navigation, drawer, and manages tab content.
class HomeShellPage extends StatelessWidget {
  const HomeShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => HomeShellCubit(),
        ),
        // Initialize profile and dashboard blocs
        BlocProvider(
          create: (context) => di.sl<ProfileBloc>()
            ..add(LoadProfileEvent()),
        ),
        BlocProvider(
          create: (context) => di.sl<DashboardBloc>()
            ..add(LoadDashboardEvent())
            ..add(LoadActivityEvent()),
        ),
        // Initialize enrollment bloc for my courses
        BlocProvider(
          create: (context) => di.sl<EnrollmentBloc>()
            ..add(LoadMyCoursesEvent()),
        ),
        // Initialize course bloc for featured courses
        BlocProvider(
          create: (context) => di.sl<CourseBloc>()
            ..add(LoadFeaturedCoursesEvent()),
        ),
      ],
      child: const _HomeShellView(),
    );
  }
}

class _HomeShellView extends StatelessWidget {
  const _HomeShellView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeShellCubit, HomeTab>(
      builder: (context, currentTab) {
        return Scaffold(
          appBar: _buildAppBar(context, currentTab),
          drawer: const HomeDrawer(),
          body: _buildBodyForTab(currentTab),
          bottomNavigationBar: HomeBottomNavBar(
            currentTab: currentTab,
            onTabSelected: (tab) {
              context.read<HomeShellCubit>().setTab(tab);
            },
          ),
        );
      },
    );
  }

  /// Build app bar based on current tab.
  PreferredSizeWidget _buildAppBar(BuildContext context, HomeTab tab) {
    return switch (tab) {
      HomeTab.home => AppBar(
        title: const Text('PrivateTutor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Implement notifications
            },
          ),
        ],
      ),
      HomeTab.courses => AppBar(
        title: const Text('Browse Courses'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              context.push('/search');
            },
          ),
        ],
      ),
      HomeTab.myLearning => AppBar(
        title: const Text('My Learning'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // TODO: Refresh courses
            },
          ),
        ],
      ),
      HomeTab.activity => AppBar(
        title: const Text('Activity'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Filter activity
            },
          ),
        ],
      ),
      HomeTab.profile => AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: Navigate to settings
            },
          ),
        ],
      ),
      _ => AppBar(
        title: const Text('PrivateTutor'),
      ),
    };
  }

  /// Build body content based on current tab.
  Widget _buildBodyForTab(HomeTab tab) {
    return switch (tab) {
      HomeTab.home => const _HomeTabPage(),
      HomeTab.courses => const _CoursesTabPage(),
      HomeTab.myLearning => const _MyLearningTabPage(),
      HomeTab.activity => const _ActivityTabPage(),
      HomeTab.profile => const _ProfileTabPage(),
      _ => const _HomeTabPage(),
    };
  }
}

// Tab page widgets - these will lazy load feature pages

class _HomeTabPage extends StatelessWidget {
  const _HomeTabPage();

  @override
  Widget build(BuildContext context) {
    return const HomeDashboardPage();
  }
}

class _CoursesTabPage extends StatelessWidget {
  const _CoursesTabPage();

  @override
  Widget build(BuildContext context) {
    // This will be replaced with actual CoursesPage
    return const Center(
      child: Text('Courses Tab - Will integrate CoursesPage here'),
    );
  }
}

class _MyLearningTabPage extends StatelessWidget {
  const _MyLearningTabPage();

  @override
  Widget build(BuildContext context) {
    // This will be replaced with actual MyCoursesPage
    return const Center(
      child: Text('My Learning Tab - Will integrate MyCoursesPage here'),
    );
  }
}

class _ActivityTabPage extends StatelessWidget {
  const _ActivityTabPage();

  @override
  Widget build(BuildContext context) {
    // This will be replaced with activity feed
    return const Center(
      child: Text('Activity Tab - Will integrate activity feed here'),
    );
  }
}

class _ProfileTabPage extends StatelessWidget {
  const _ProfileTabPage();

  @override
  Widget build(BuildContext context) {
    // This will be replaced with actual ProfilePage
    return const Center(
      child: Text('Profile Tab - Will integrate ProfilePage here'),
    );
  }
}
