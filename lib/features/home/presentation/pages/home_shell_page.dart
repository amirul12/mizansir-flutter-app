import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_event.dart';
import '../../../profile/presentation/bloc/dashboard_bloc.dart';
import '../../../profile/presentation/bloc/dashboard_event.dart';
import '../../../profile/presentation/bloc/dashboard_state.dart';
import '../../../profile/domain/entities/activity.dart';
import '../../../enrollment/presentation/bloc/enrollment_bloc.dart';
import '../../../enrollment/presentation/bloc/enrollment_event.dart';
import '../../../enrollment/presentation/bloc/enrollment_state.dart';
import '../../../course_browsing/presentation/bloc/course_bloc.dart';
import '../../../course_browsing/presentation/bloc/course_event.dart';
import '../../../course_browsing/presentation/bloc/course_state.dart';
import '../../domain/entities/home_tab.dart';
import '../bloc/home_shell_cubit.dart';
import '../widgets/home_bottom_nav_bar.dart';
import '../widgets/home_drawer.dart';
import 'home_dashboard_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
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
        BlocProvider(create: (context) => HomeShellCubit()),
        // Auth bloc for logout functionality
        BlocProvider(create: (context) => di.sl<AuthBloc>()),
        // Initialize profile and dashboard blocs
        BlocProvider(
          create: (context) => di.sl<ProfileBloc>()..add(LoadProfileEvent()),
        ),
        BlocProvider(
          create: (context) => di.sl<DashboardBloc>()
            ..add(LoadDashboardEvent())
            ..add(LoadActivityEvent()),
        ),
        // Initialize enrollment bloc for my courses
        BlocProvider(
          create: (context) =>
              di.sl<EnrollmentBloc>()..add(LoadMyCoursesEvent()),
        ),
        // Initialize course bloc for featured courses
        BlocProvider(
          create: (context) =>
              di.sl<CourseBloc>()..add(LoadFeaturedCoursesEvent()),
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
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Exit'),
              ),
            ],
          ),
        );

        if (shouldExit ?? false) {
          // If User confirms, close the app using SystemNavigator
          SystemNavigator.pop();
        }
      },
      child: BlocBuilder<HomeShellCubit, HomeTab>(
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
      ),
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
      _ => AppBar(title: const Text('PrivateTutor')),
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
    return BlocBuilder<CourseBloc, CourseState>(
      buildWhen: (previous, current) =>
          current is CourseLoading ||
          current is CoursesLoaded ||
          current is CourseError ||
          current is CourseEmpty,
      builder: (context, state) {
        // Show loading
        if (state is CourseLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show error
        if (state is CourseError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text('Oops!', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    state.message ?? 'Failed to load courses',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<CourseBloc>().add(const LoadCoursesEvent());
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
        if (state is CourseEmpty) {
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
                    'No courses available',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check back later for new courses',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          );
        }

        // Show courses
        if (state is CoursesLoaded) {
          if (state.courses.isEmpty ?? true) {
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
                      'No courses available',
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Check back later for new courses',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              context.read<CourseBloc>().add(const LoadCoursesEvent());
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.courses.length ?? 0,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final course = state.courses[index];
                return _buildCourseCard(context, course);
              },
            ),
          );
        }

        // Initial state
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildCourseCard(BuildContext context, dynamic course) {
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
            context.go('/courses/${course.id}');
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with title and price
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.title ?? 'No Title',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          if (course.enrollmentCount != null)
                            Row(
                              children: [
                                const Icon(
                                  Icons.people_outline,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${course.enrollmentCount} enrolled',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                    // Price badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: course.price == 0 || course.price == "0.00"
                            ? Colors.green.withValues(alpha: 0.1)
                            : Theme.of(
                                context,
                              ).primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: course.price == 0 || course.price == "0.00"
                              ? Colors.green.withValues(alpha: 0.3)
                              : Theme.of(
                                  context,
                                ).primaryColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        course.formattedPrice ?? 'Free',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: course.price == 0 || course.price == "0.00"
                              ? Colors.green
                              : Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description
                if (course.description != null &&
                    course.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      course.description!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                // View details button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.go('/courses/${course.id}');
                    },
                    icon: const Icon(Icons.info_outline),
                    label: const Text('View Details'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
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
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text('Oops!', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      context.read<EnrollmentBloc>().add(
                        const LoadMyCoursesEvent(),
                      );
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
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Start learning by enrolling in courses',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
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
                      style: Theme.of(
                        context,
                      ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start your learning journey today!',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
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
            // Navigate to next lesson if available, otherwise show all lessons
            if (course.nextLessonId != null) {
              context.go(
                '/my-courses/${course.id}/lessons/${course.nextLessonId}',
              );
            } else {
              context.go('/my-courses/${course.id}/lessons');
            }
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
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
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
                          color: _getProgressColor(
                            course.progressPercentage,
                          ).withValues(alpha: 0.1),
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
                              color: _getProgressColor(
                                course.progressPercentage,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Description
                if (course.description != null &&
                    course.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      course.description!,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
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
                      // Navigate to next lesson if available, otherwise show all lessons
                      if (course.nextLessonId != null) {
                        context.go(
                          '/my-courses/${course.id}/lessons/${course.nextLessonId}',
                        );
                      } else {
                        context.go('/my-courses/${course.id}/lessons');
                      }
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
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
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
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        List<Activity>? activities;
        bool isLoading = state is DashboardLoading && state.existingActivities == null;
        
        if (state is DashboardLoaded) {
          activities = state.activities;
        } else if (state is DashboardLoading) {
          activities = state.existingActivities;
        }

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (activities == null || activities.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'No activity yet',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<DashboardBloc>().add(LoadActivityEvent());
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: activities.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final activity = activities![index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getActivityColor(activity).withValues(alpha: 0.1),
                  child: Icon(
                    _getActivityIcon(activity),
                    color: _getActivityColor(activity),
                    size: 20,
                  ),
                ),
                title: Text(
                  activity.description,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(_formatActivityDate(activity.createdAt)),
                trailing: Text(
                  activity.typeLabel,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  IconData _getActivityIcon(Activity activity) {
    switch (activity.type) {
      case ActivityType.lessonCompleted:
        return Icons.check_circle_outline;
      case ActivityType.enrollmentCreated:
        return Icons.school_outlined;
      case ActivityType.courseProgressUpdated:
        return Icons.trending_up;
      case ActivityType.profileUpdated:
        return Icons.person_outline;
      case ActivityType.passwordChanged:
        return Icons.lock_outline;
      case ActivityType.avatarUpdated:
        return Icons.photo_camera_outlined;
      case ActivityType.accountDeleted:
        return Icons.delete_outline;
    }
  }

  Color _getActivityColor(Activity activity) {
    switch (activity.type) {
      case ActivityType.lessonCompleted:
        return Colors.green;
      case ActivityType.enrollmentCreated:
        return Colors.blue;
      case ActivityType.courseProgressUpdated:
        return Colors.orange;
      case ActivityType.profileUpdated:
        return Colors.purple;
      case ActivityType.passwordChanged:
        return Colors.teal;
      case ActivityType.avatarUpdated:
        return Colors.pink;
      case ActivityType.accountDeleted:
        return Colors.red;
    }
  }

  String _formatActivityDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 7) {
      return '${date.day}/${date.month}/${date.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}

class _ProfileTabPage extends StatelessWidget {
  const _ProfileTabPage();

  @override
  Widget build(BuildContext context) {
    return const ProfilePage();
  }
}
