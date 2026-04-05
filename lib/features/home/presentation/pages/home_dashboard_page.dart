import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../profile/presentation/bloc/dashboard_bloc.dart';
import '../../../profile/presentation/bloc/dashboard_state.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_state.dart';
import '../../../profile/domain/entities/activity.dart';
import '../../../enrollment/presentation/bloc/enrollment_bloc.dart';
import '../../../enrollment/presentation/bloc/enrollment_state.dart';
import '../../../course_browsing/presentation/bloc/course_bloc.dart';
import '../../../course_browsing/presentation/bloc/course_state.dart';
import '../bloc/home_shell_cubit.dart';

/// Home Dashboard Page - Rich dashboard content for authenticated users.
class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({super.key});

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
                  backgroundColor: Colors.red,
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
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        ),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Section
            _buildGreetingSection(context),

            const SizedBox(height: 24),

            // Stats Section
            _buildStatsSection(context),

            const SizedBox(height: 24),

            // Continue Learning Section
            _buildContinueLearningSection(context),

            const SizedBox(height: 24),

            // Featured Courses Section
            _buildFeaturedCoursesSection(context),

            const SizedBox(height: 24),

            // Recent Activity Section
            _buildRecentActivitySection(context),
          ],
        ),
      ),
    );
  }

  /// Build greeting section with user name.
  Widget _buildGreetingSection(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) => current is ProfileLoaded,
      builder: (context, state) {
        String userName = 'Student';
        if (state is ProfileLoaded) {
          userName = state.profile.name.split(' ')[0];
        }

        final hour = DateTime.now().hour;
        String greeting = 'Good Morning';
        if (hour >= 12 && hour < 17) {
          greeting = 'Good Afternoon';
        } else if (hour >= 17) {
          greeting = 'Good Evening';
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$greeting, $userName! 👋',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ready to continue learning?',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        );
      },
    );
  }

  /// Build stats cards section.
  Widget _buildStatsSection(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) => current is DashboardLoaded,
      builder: (context, state) {
        if (state is! DashboardLoaded) {
          return const SizedBox();
        }

        final stats = state.stats;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Progress',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    icon: Icons.school,
                    title: 'Enrollments',
                    value: stats.totalEnrollments.toString(),
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    icon: Icons.play_circle,
                    title: 'Active',
                    value: stats.activeEnrollments.toString(),
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    icon: Icons.check_circle,
                    title: 'Lessons',
                    value: stats.completedLessons.toString(),
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Build a single stat card.
  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  /// Build continue learning section.
  Widget _buildContinueLearningSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Continue Learning',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () {
                context.read<HomeShellCubit>().goToMyLearning();
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        BlocBuilder<EnrollmentBloc, EnrollmentState>(
          buildWhen: (previous, current) =>
              current is EnrollmentLoading ||
              current is MyCoursesLoaded ||
              current is EnrollmentError,
          builder: (context, state) {
            if (state is EnrollmentLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state is MyCoursesLoaded && state.courses.isNotEmpty) {
              final courses = state.courses.take(3).toList();

              return Column(
                children: courses.map((course) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildCourseCard(
                      context,
                      course.title,
                      course.progressPercentage,
                    ),
                  );
                }).toList(),
              );
            }

            return _buildEmptyCard(
              context,
              icon: Icons.play_circle_outline,
              title: 'No courses in progress',
              subtitle: 'Browse our course catalog to get started',
              onTap: () {
                context.read<HomeShellCubit>().goToCourses();
              },
            );
          },
        ),
      ],
    );
  }

  /// Build a simple course card for continue learning.
  Widget _buildCourseCard(
    BuildContext context,
    String title,
    double progress, [
    String? instructor,
  ]) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (instructor != null) ...[
            const SizedBox(height: 4),
            Text(
              instructor,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: progress / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress >= 75
                        ? Colors.green
                        : progress >= 50
                            ? Colors.orange
                            : Colors.blue,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${progress.toInt()}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
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
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () {
               // Navigator.pop(context); // Close drawer if open
                context.go('/courses?featured=true');
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        BlocBuilder<CourseBloc, CourseState>(
          buildWhen: (previous, current) =>
              current is CourseLoading ||
              current is FeaturedCoursesLoaded ||
              current is CourseError,
          builder: (context, state) {
            if (state is CourseLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (state is FeaturedCoursesLoaded && state.courses.isNotEmpty) {
              final courses = state.courses.take(3).toList();

              return SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return Container(
                      width: 280,
                      margin: const EdgeInsets.only(right: 12),
                      child: _buildFeaturedCourseCard(
                        context,
                        course.title,
                        course.description ?? '',
                        course.price,
                      ),
                    );
                  },
                ),
              );
            }

            return _buildEmptyCard(
              context,
              icon: Icons.star_outline,
              title: 'No featured courses available',
              subtitle: 'Check back later for new courses',
              onTap: () {},
            );
          },
        ),
      ],
    );
  }

  /// Build a featured course card.
  Widget _buildFeaturedCourseCard(
    BuildContext context,
    String title,
    String description,
    double price,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(Icons.school, size: 36, color: Colors.blue),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            price > 0 ? '\$${price.toInt()}' : 'Free',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
          ),
        ],
      ),
    );
  }

  /// Build recent activity section.
  Widget _buildRecentActivitySection(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) => current is ActivityLoaded,
      builder: (context, state) {
        if (state is! ActivityLoaded || state.activities.isEmpty) {
          return const SizedBox();
        }

        final activities = state.activities.take(5).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activities.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[300],
                  height: 1,
                ),
                itemBuilder: (context, index) {
                  final activity = activities[index];
                  return ListTile(
                    leading: Icon(
                      _getActivityIcon(activity),
                      color: _getActivityColor(activity),
                    ),
                    title: Text(activity.description),
                    subtitle: Text(_formatActivityTime(activity.createdAt)),
                    dense: true,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// Build an empty state card.
  Widget _buildEmptyCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: onTap,
            child: const Text('Explore Courses'),
          ),
        ],
      ),
    );
  }

  /// Get icon for activity type.
  IconData _getActivityIcon(Activity activity) {
    switch (activity.type) {
      case ActivityType.lessonCompleted:
        return Icons.check_circle;
      case ActivityType.enrollmentCreated:
        return Icons.school;
      case ActivityType.courseProgressUpdated:
        return Icons.trending_up;
      case ActivityType.profileUpdated:
        return Icons.edit;
      case ActivityType.passwordChanged:
        return Icons.lock;
      case ActivityType.avatarUpdated:
        return Icons.image;
      case ActivityType.accountDeleted:
        return Icons.delete_forever;
    }
  }

  /// Get color for activity type.
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
        return Colors.red;
      case ActivityType.avatarUpdated:
        return Colors.teal;
      case ActivityType.accountDeleted:
        return Colors.grey;
    }
  }

  /// Format activity time.
  String _formatActivityTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}
