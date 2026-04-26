import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Import Entities
import 'package:mizansir/features/home/domain/entities/home_tab.dart';

// Import Blocs
import 'package:mizansir/features/course_browsing/presentation/bloc/course_bloc.dart';
import 'package:mizansir/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:mizansir/features/profile/presentation/bloc/dashboard_bloc.dart';
import 'package:mizansir/features/enrollment/presentation/bloc/enrollment_bloc.dart';
import 'package:mizansir/features/home/presentation/bloc/home_shell_cubit.dart';
import 'package:mizansir/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mizansir/features/auth/presentation/bloc/auth_event.dart';
import 'package:go_router/go_router.dart';

// Import Local Pages
import 'package:mizansir/features/home/presentation/widgets/home_bottom_nav_bar.dart';
import 'package:mizansir/features/home/presentation/widgets/home_drawer.dart';
import 'package:mizansir/features/home/presentation/pages/home_dashboard_page.dart';
import 'package:mizansir/features/home/presentation/pages/home_courses_page.dart';
import 'package:mizansir/features/home/presentation/pages/home_my_learning_page.dart';
import 'package:mizansir/features/profile/presentation/pages/profile_page.dart';

// DI
import 'package:mizansir/core/di/injection_container.dart' as di;

class HomeShellPage extends StatelessWidget {
  final HomeTab? initialTab;
  const HomeShellPage({super.key, this.initialTab});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeShellCubit(initialTab: initialTab)),
        BlocProvider(create: (context) => di.sl<DashboardBloc>()),
        BlocProvider(create: (context) => di.sl<EnrollmentBloc>()),
        BlocProvider(create: (context) => di.sl<CourseBloc>()),
        BlocProvider(create: (context) => di.sl<ProfileBloc>()),
        BlocProvider(create: (context) => di.sl<AuthBloc>()),
      ],
      child: const _HomeShellView(),
    );
  }
}

class _HomeShellView extends StatefulWidget {
  const _HomeShellView();

  @override
  State<_HomeShellView> createState() => _HomeShellViewState();
}

class _HomeShellViewState extends State<_HomeShellView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showLogoutDialog(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout'),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Stay', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              authBloc.add(LogoutEvent());
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeShellCubit, HomeTab>(
      builder: (context, currentTab) {
        return Scaffold(
          key: _scaffoldKey,
          drawer: HomeDrawer(onLogout: () => _showLogoutDialog(context)),
          appBar: _buildAppBar(context, currentTab),
          body: _buildBodyForTab(currentTab),
          bottomNavigationBar: HomeBottomNavBar(
            currentTab: currentTab,
            onTabSelected: (tab) => context.read<HomeShellCubit>().setTab(tab),
          ),
        );
      },
    );
  }

  PreferredSizeWidget? _buildAppBar(BuildContext context, HomeTab tab) {
    if (tab == HomeTab.home) return null;

    String title = 'Privatetutor';
    if (tab == HomeTab.courses) title = 'Explore Courses';
    if (tab == HomeTab.myLearning) title = 'My Learning';
    if (tab == HomeTab.profile) title = 'Profile';

    return AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded),
        onPressed: () => _scaffoldKey.currentState?.openDrawer(),
      ),
    );
  }

  Widget _buildBodyForTab(HomeTab tab) {
    if (tab == HomeTab.home) return const HomeDashboardPage();
    if (tab == HomeTab.courses) return const HomeCoursesPage();
    if (tab == HomeTab.myLearning) return const HomeMyLearningPage();
    if (tab == HomeTab.profile) return const ProfilePage();
    return const HomeDashboardPage();
  }
}
