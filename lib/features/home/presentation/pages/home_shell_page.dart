import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_event.dart';
import '../../../profile/presentation/bloc/dashboard_bloc.dart';
import '../../../profile/presentation/bloc/dashboard_event.dart';
import '../../../enrollment/presentation/bloc/enrollment_bloc.dart';
import '../../../enrollment/presentation/bloc/enrollment_event.dart';
import '../../../enrollment/presentation/bloc/enrollment_state.dart';
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
    return BlocBuilder<EnrollmentBloc, EnrollmentState>(
      buildWhen: (previous, current) =>
          current is EnrollmentLoading ||
          current is MyCoursesLoaded ||
          current is EnrollmentError ||
          current is EnrollmentEmpty,
      builder: (context, state) {
        // Show loading
        if (state is EnrollmentLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error
        if (state is EnrollmentError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Oops!',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<EnrollmentBloc>().add(const LoadMyCoursesEvent());
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }

        // Show empty
        if (state is EnrollmentEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start learning by enrolling in courses',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[500],
                        ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<HomeShellCubit>().goToCourses();
                    },
                    icon: const Icon(Icons.explore),
                    label: const Text('Browse Courses'),
                  ),
                ],
              ),
            ),
          );
        }

        // Show courses
        if (state is MyCoursesLoaded) {
          if (state.courses.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.school_outlined,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No enrolled courses yet',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start your learning journey today!',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[500],
                          ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<HomeShellCubit>().goToCourses();
                      },
                      icon: const Icon(Icons.explore),
                      label: const Text('Browse Courses'),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<EnrollmentBloc>().add(const LoadMyCoursesEvent());
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.courses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final course = state.courses[index];
                return _buildEnrolledCourseCard(context, course);
              },
            ),
          );
        }

        // Initial state
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildEnrolledCourseCard(BuildContext context, dynamic course) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navigate to course details/lessons
            context.go('/my-courses/${course.id}');
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and status
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _buildStatusChip(course.status),
                              const SizedBox(width: 8),
                              if (course.expiresAt != null)
                                _buildDaysRemainingChip(course.expiresAt!),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Progress circle
                    if (course.progressPercentage != null)
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getProgressColor(course.progressPercentage)
                              .withValues(alpha: 0.1),
                          border: Border.all(
                            color: _getProgressColor(course.progressPercentage),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${course.progressPercentage.toInt()}%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _getProgressColor(course.progressPercentage),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Description
                if (course.description != null && course.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      course.description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                // Stats row
                Row(
                  children: [
                    _buildStat(
                      Icons.play_circle_outline,
                      '${course.totalLessons ?? 0} Lessons',
                      Colors.blue,
                    ),
                    const SizedBox(width: 16),
                    if (course.completedLessons != null)
                      _buildStat(
                        Icons.check_circle_outline,
                        '${course.completedLessons} Completed',
                        Colors.green,
                      ),
                    const SizedBox(width: 16),
                    if (course.totalWatchTimeMinutes != null)
                      _buildStat(
                        Icons.schedule,
                        '${course.totalWatchTimeMinutes} min',
                        Colors.orange,
                      ),
                  ],
                ),

                const SizedBox(height: 12),

                // Action button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.go('/my-courses/${course.id}/lessons');
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Continue Learning'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    String label;

    switch (status.toLowerCase()) {
      case 'approved':
      case 'active':
        color = Colors.green;
        label = 'Active';
        break;
      case 'pending':
        color = Colors.orange;
        label = 'Pending';
        break;
      case 'expired':
        color = Colors.red;
        label = 'Expired';
        break;
      case 'completed':
        color = Colors.blue;
        label = 'Completed';
        break;
      default:
        color = Colors.grey;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildDaysRemainingChip(DateTime expiresAt) {
    final daysRemaining = expiresAt.difference(DateTime.now()).inDays;

    if (daysRemaining <= 0) {
      return const SizedBox.shrink();
    }

    final color = _getDaysRemainingColor(daysRemaining);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        '$daysRemaining days left',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildStat(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Color _getProgressColor(double? progress) {
    if (progress == null) return Colors.grey;
    if (progress >= 75) return Colors.green;
    if (progress >= 50) return Colors.orange;
    return Colors.blue;
  }

  Color _getDaysRemainingColor(int? days) {
    if (days == null) return Colors.grey;
    if (days <= 7) return Colors.red;
    if (days <= 30) return Colors.orange;
    return Colors.green;
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
