import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mizansir/features/profile/data/models/activity_model.dart'
    show ActivityModel;
import '../../../profile/data/models/dashboard_stats_model.dart'
    show
        DashboardStatsModel,
        RecentEnrollment,
        EnrollmentStats;
import '../../../profile/presentation/bloc/dashboard_bloc.dart';
import '../../../profile/presentation/bloc/dashboard_event.dart';
import '../../../profile/presentation/bloc/dashboard_state.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_state.dart';

import '../../../enrollment/presentation/bloc/enrollment_bloc.dart';
import '../../../enrollment/presentation/bloc/enrollment_state.dart';
import '../../../course_browsing/presentation/bloc/course_bloc.dart';
import '../../../course_browsing/presentation/bloc/course_state.dart';
import '../bloc/home_shell_cubit.dart';
import '../../../../core/theme/app_colors.dart';

/// Home Dashboard Page - Modern, visually rich dashboard for authenticated students.
///
/// Re-designed to follow the structure of the reference app:
/// - Custom Header Section (replaced AppBar)
/// - Sequential API calling for better performance
/// - Clean, section-based layout
class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key});

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  @override
  void initState() {
    super.initState();
    _loadDataSequentially();
  }

  /// Loads data for the dashboard.
  Future<void> _loadDataSequentially() async {
    if (!mounted) return;

    // Only call Dashboard related APIs
    context.read<DashboardBloc>().add(LoadDashboardEvent());

    // Wait a bit before next call
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;

    context.read<DashboardBloc>().add(LoadActivityEvent());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DashboardBloc, DashboardState>(
          listener: (context, state) {
            if (state is DashboardError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
        ),
        BlocListener<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _loadDataSequentially,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Custom Header (Logo, Search, Profile)
                  _buildHeaderSection(context),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 2. Greeting Section
                        _buildGreetingSection(context),

                        const SizedBox(height: 24),

                        // 3. Stats Section
                        _buildStatsSection(context),

                        const SizedBox(height: 24),

                        // 4. Quick Actions Section
                        _buildQuickActionsSection(context),

                        const SizedBox(height: 24),

                        // 5. Continue Learning Section
                        _buildContinueLearningSection(context),

                        const SizedBox(height: 24),

                        // 6. Featured Courses Section
                        _buildFeaturedCoursesSection(context),

                        const SizedBox(height: 24),

                        // 7. Recent Activity Section
                        _buildRecentActivitySection(context),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build custom header section similar to reference app.
  Widget _buildHeaderSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withValues(alpha: 0.5),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          // Menu Button
          IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 4),
          // Logo
          Image.asset(
            'assets/icons/logo.png',
            height: 36,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.school, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 8),
          const Text(
            'HSC ICT',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const Spacer(),
          // Search Icon
          IconButton(
            onPressed: () => context.push('/search'),
            icon: const Icon(Icons.search, color: AppColors.textSecondary),
          ),
          // Notification Icon
          IconButton(
            onPressed: () {
              // TODO: Navigate to notifications
            },
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textSecondary,
            ),
          ),
          // Mini Profile
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              String? avatarUrl;
              if (state is ProfileLoaded) {
                avatarUrl = state.profile.user?.avatarUrl;
              }
              return Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.1),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: avatarUrl != null && avatarUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Image.network(
                          avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                                Icons.person,
                                size: 20,
                                color: AppColors.primary,
                              ),
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 20,
                        color: AppColors.primary,
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Build greeting section with user name and motivational message.
  Widget _buildGreetingSection(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        String userName = '';
        String? userEmail;

        if (state is DashboardLoaded && state.stats!.user != null) {
          userName = state.stats!.user!.name!;
          userEmail = state.stats!.user!.email;
        }

        final hour = DateTime.now().hour;
        String greeting = 'Good Morning';
        String emoji = '🌅';

        if (hour >= 12 && hour < 17) {
          greeting = 'Good Afternoon';
          emoji = '☀️';
        } else if (hour >= 17) {
          greeting = 'Good Evening';
          emoji = '🌙';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$greeting, $userName! $emoji',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            if (userEmail != null)
              Text(
                userEmail,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              )
            else
              Text(
                'Let\'s continue your learning journey.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        );
      },
    );
  }

  /// Build stats cards section with modern design.
  Widget _buildStatsSection(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) =>
          current is DashboardLoaded || current is DashboardLoading,
      builder: (context, state) {
        DashboardStatsModel? stats;

        if (state is DashboardLoaded) {
          stats = state.stats;
        }

        if (stats == null) {
          return const SizedBox();
        }

        final enrollmentStats = stats.enrollmentStats;

        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildModernStatCard(
                    context,
                    icon: Icons.school_outlined,
                    title: 'Total',
                    value: (enrollmentStats?.total ?? 0).toString(),
                    color: AppColors.primary,
                    gradient: AppColors.primaryGradient,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildModernStatCard(
                    context,
                    icon: Icons.play_circle_outline,
                    title: 'Active',
                    value: (enrollmentStats?.active ?? 0).toString(),
                    color: AppColors.secondary,
                    gradient: AppColors.secondaryGradient,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildModernStatCard(
                    context,
                    icon: Icons.pending_outlined,
                    title: 'Pending',
                    value: (enrollmentStats?.pending ?? 0).toString(),
                    color: Colors.orange,
                    gradient: [Colors.orange.shade400, Colors.orange.shade600],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildModernStatCard(
                    context,
                    icon: Icons.cancel_outlined,
                    title: 'Expired',
                    value: (enrollmentStats?.expired ?? 0).toString(),
                    color: Colors.red,
                    gradient: [Colors.red.shade400, Colors.red.shade600],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Build a modern stat card with gradient and shadow.
  Widget _buildModernStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Build quick actions section.
  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildSmallQuickAction(
              context,
              icon: Icons.explore_outlined,
              label: 'Browse',
              onTap: () => context.read<HomeShellCubit>().goToCourses(),
            ),
            _buildSmallQuickAction(
              context,
              icon: Icons.play_lesson_outlined,
              label: 'Learning',
              onTap: () => context.read<HomeShellCubit>().goToMyLearning(),
            ),
            _buildSmallQuickAction(
              context,
              icon: Icons.person_outline,
              label: 'Profile',
              onTap: () => context.read<HomeShellCubit>().goToProfile(),
            ),
            _buildSmallQuickAction(
              context,
              icon: Icons.settings_outlined,
              label: 'Settings',
              onTap: () {
                // TODO: Settings
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSmallQuickAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Icon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  /// Build continue learning section.
  Widget _buildContinueLearningSection(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        List<RecentEnrollment>? recentEnrollments;

        if (state is DashboardLoaded) {
          recentEnrollments = state.stats?.recentEnrollments;
        }

        // Hide section if no recent enrollments
        if (recentEnrollments == null || recentEnrollments.isEmpty) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Continue Learning',
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => context.read<HomeShellCubit>().goToMyLearning(),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentEnrollments!.take(3).length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final enrollment = recentEnrollments![index];
                return _buildRecentEnrollmentCard(context, enrollment);
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecentEnrollmentCard(BuildContext context, RecentEnrollment enrollment) {
    final isActive = enrollment.isActive ?? false;
    final statusColor = isActive ? AppColors.primary : AppColors.disabled;
    final statusText = isActive ? 'Active' : 'Inactive';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.play_lesson,
                  color: isActive ? AppColors.primary : AppColors.disabled,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      enrollment.courseTitle ?? 'Course',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      statusText,
                      style: TextStyle(
                        fontSize: 12,
                        color: statusColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : AppColors.disabled.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  enrollment.status ?? 'Unknown',
                  style: TextStyle(
                    fontSize: 10,
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (enrollment.expiresAt != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.access_time,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Expires: ${_formatDate(enrollment.expiresAt!)}',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.isNegative) {
      return 'Expired';
    } else if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days left';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks left';
    } else {
      return '${(difference.inDays / 30).floor()} months left';
    }
  }

  /// Build featured courses section.
  Widget _buildFeaturedCoursesSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Featured Courses',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => context.go('/courses'),
              child: const Text('Browse'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        BlocBuilder<CourseBloc, CourseState>(
          builder: (context, state) {
            if (state is CourseLoading) {
              return const SizedBox(
                height: 150,
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (state is FeaturedCoursesLoaded && state.courses.isNotEmpty) {
              return SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.courses.length,
                  itemBuilder: (context, index) {
                    final course = state.courses[index];
                    return _buildCourseStripCard(context, course);
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _buildCourseStripCard(BuildContext context, dynamic course) {
    return GestureDetector(
      onTap: () => context.go('/courses/${course.id}'),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: course.thumbnail != null
                  ? ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                      child: Image.network(
                        course.thumbnail!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.image, color: Colors.white54),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    course.instructor ?? '',
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build recent activity section.
  Widget _buildRecentActivitySection(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        List<ActivityModel>? activities;
        if (state is DashboardLoaded) {
          activities = state.activities;
        }

        if (activities == null || activities.isEmpty) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemCount: activities.take(3).length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final activity = activities![index];
                  return Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_active,
                          size: 16,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          activity.description!,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
