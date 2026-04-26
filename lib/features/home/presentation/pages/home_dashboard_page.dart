import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../profile/data/models/dashboard_stats_model.dart';
import '../../../profile/presentation/bloc/dashboard_bloc.dart';
import '../../../profile/presentation/bloc/dashboard_event.dart';
import '../../../profile/presentation/bloc/dashboard_state.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_state.dart';
import '../../../profile/domain/entities/activity.dart';
 
import '../../../enrollment/presentation/bloc/enrollment_bloc.dart';
import '../../../enrollment/presentation/bloc/enrollment_event.dart';
import '../../../enrollment/presentation/bloc/enrollment_state.dart';
import '../../../course_browsing/presentation/bloc/course_bloc.dart';
import '../../../course_browsing/presentation/bloc/course_event.dart';
import '../../../course_browsing/presentation/bloc/course_state.dart';
import '../../../course_browsing/domain/entities/course.dart';
import '../bloc/home_shell_cubit.dart';
import '../../../../core/theme/app_colors.dart';

/// Home Dashboard Page - Modern, visually rich dashboard for authenticated students.
///
/// Features:
/// - Personalized greeting with time-based messages
/// - Visual stats cards with icons and colors
/// - Continue learning section with progress tracking
/// - Featured courses carousel
/// - Recent activity feed
/// - Quick action buttons
/// - Modern card design with shadows and gradients
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
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<DashboardBloc>().add(LoadDashboardEvent());
          context.read<DashboardBloc>().add(LoadActivityEvent());
          context.read<EnrollmentBloc>().add(const LoadMyCoursesEvent());
          context.read<CourseBloc>().add(const LoadFeaturedCoursesEvent());
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Section with Quick Actions
              _buildGreetingSection(context),

              const SizedBox(height: 24),

              // Stats Section
              _buildStatsSection(context),

              const SizedBox(height: 24),

              // Quick Actions Section
              _buildQuickActionsSection(context),

              const SizedBox(height: 24),

              // Continue Learning Section
              _buildContinueLearningSection(context),

              const SizedBox(height: 24),

              // Featured Courses Section
              _buildFeaturedCoursesSection(context),

              const SizedBox(height: 24),

              // Recent Activity Section
              _buildRecentActivitySection(context),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  /// Build greeting section with user name and motivational message.
  Widget _buildGreetingSection(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      buildWhen: (previous, current) => current is ProfileLoaded,
      builder: (context, state) {
        String userName = 'Student';
        String? avatarUrl;
        if (state is ProfileLoaded) {
          userName = state.profile.name.split(' ')[0];
          avatarUrl = state.profile.avatar;
        }

        final hour = DateTime.now().hour;
        String greeting = 'Good Morning';
        String emoji = '🌅';
        String motivationalMessage = 'Start your day with learning!';

        if (hour >= 12 && hour < 17) {
          greeting = 'Good Afternoon';
          emoji = '☀️';
          motivationalMessage = 'Keep up the great work!';
        } else if (hour >= 17) {
          greeting = 'Good Evening';
          emoji = '🌙';
          motivationalMessage = 'Evening sessions are productive!';
        }

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, AppColors.primaryLight],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$greeting, $userName! $emoji',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      motivationalMessage,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Avatar or placeholder
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: avatarUrl != null && avatarUrl.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.network(
                          avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.person,
                              size: 30,
                              color: AppColors.primary,
                            );
                          },
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 30,
                        color: AppColors.primary,
                      ),
              ),
            ],
          ),
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
        } else if (state is DashboardLoading) {
        
        }

        if (stats == null) {
          return const SizedBox();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Progress',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                _buildWeeklyTrendIndicator(context),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildModernStatCard(
                    context,
                    icon: Icons.school_outlined,
                    title: 'Enrollments',
                    value: stats.enrollmentStats.toString(),
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
                    value: stats.recentEnrollments.toString(),
                    color: AppColors.secondary,
                    gradient: AppColors.secondaryGradient,
                  ),
                ),
                const SizedBox(width: 12),
                // Expanded(
                //   child: _buildModernStatCard(
                //     context,
                //     icon: Icons.check_circle_outline,
                //     title: 'Lessons',
                //     value: stats.completedLessons.toString(),
                //     color: AppColors.accent,
                //     gradient: [AppColors.accent, AppColors.accentLight],
                //   ),
                // ),
              ],
            ),
          ],
        );
      },
    );
  }

  /// Build weekly trend indicator.
  Widget _buildWeeklyTrendIndicator(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.successLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.trending_up, size: 16, color: AppColors.success),
          const SizedBox(width: 4),
          Text(
            'This Week',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            gradient[0].withValues(alpha: 0.15),
            gradient[1].withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
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
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
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
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionButton(
                context,
                icon: Icons.explore_outlined,
                label: 'Browse',
                color: AppColors.primary,
                onTap: () {
                  context.read<HomeShellCubit>().goToCourses();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionButton(
                context,
                icon: Icons.play_arrow_outlined,
                label: 'Continue',
                color: AppColors.secondary,
                onTap: () {
                  context.read<HomeShellCubit>().goToMyLearning();
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionButton(
                context,
                icon: Icons.search_outlined,
                label: 'Search',
                color: AppColors.accent,
                onTap: () {
                  context.push('/search');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Build a quick action button.
  Widget _buildQuickActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build continue learning section with modern cards.
  Widget _buildContinueLearningSection(BuildContext context) {
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
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () {
                context.read<HomeShellCubit>().goToMyLearning();
              },
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: const Text('View All'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
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
                  // Handle both MyCourseEntity and legacy EnrolledCourse
                  final String title;
                  final String description;
                  final double progressPercentage;
                  final int totalLessons;
                  final int completedLessons;
                  final String courseId;
                  final String? nextLessonId;

                  if (course.runtimeType.toString().contains('MyCourseEntity')) {
                    // MyCourseEntity has nested structure
                    final myCourse = course as dynamic;
                    title = myCourse.course.title;
                    description = myCourse.course.description;
                    progressPercentage = myCourse.curriculum.progressPercentage;
                    totalLessons = myCourse.curriculum.totalLessons;
                    completedLessons = myCourse.curriculum.completedLessons;
                    courseId = myCourse.course.id;
                    nextLessonId = myCourse.curriculum.nextLesson?.id;
                  } else {
                    // Legacy EnrolledCourse structure
                    title = course.title ?? 'Untitled Course';
                    description = course.description ?? '';
                    progressPercentage = course.progressPercentage ?? 0.0;
                    totalLessons = course.totalLessons ?? 0;
                    completedLessons = course.completedLessons ?? 0;
                    courseId = course.id;
                    nextLessonId = course.nextLessonId;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildModernCourseCard(
                      context,
                      title,
                      progressPercentage,
                      description,
                      totalLessons,
                      completedLessons,
                      courseId,
                      nextLessonId,
                    ),
                  );
                }).toList(),
              );
            }

            return _buildModernEmptyCard(
              context,
              icon: Icons.play_circle_outline,
              title: 'No courses in progress',
              subtitle: 'Browse our course catalog to get started',
              buttonText: 'Explore Courses',
              onTap: () {
                context.read<HomeShellCubit>().goToCourses();
              },
            );
          },
        ),
      ],
    );
  }

  /// Build a modern course card with enhanced visual design.
  Widget _buildModernCourseCard(
    BuildContext context,
    String title,
    double progress,
    String? description,
    int totalLessons,
    int completedLessons,
    String courseId,
    String? nextLessonId,
  ) {
    final progressColor = _getProgressColor(progress);

    return Container(
      padding: const EdgeInsets.all(16),
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
            if (nextLessonId != null) {
              context.go('/my-courses/$courseId/lessons/$nextLessonId');
            } else {
              context.go('/my-courses/$courseId/lessons');
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        if (description != null && description.isNotEmpty)
                          Text(
                            description,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: progressColor.withValues(alpha: 0.1),
                      border: Border.all(color: progressColor, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        '${progress.toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: progressColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress / 100,
                  backgroundColor: AppColors.progressBackground,
                  valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.play_circle_outline,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$completedLessons of $totalLessons lessons',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: progressColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      progress >= 75
                          ? 'Almost Done!'
                          : progress >= 50
                          ? 'Halfway'
                          : 'In Progress',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: progressColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Get progress color based on percentage.
  Color _getProgressColor(double progress) {
    if (progress >= 75) return AppColors.secondary;
    if (progress >= 50) return AppColors.accent;
    return AppColors.primary;
  }

  /// Build featured courses section with modern cards.
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
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () {
                context.go('/courses?featured=true');
              },
              icon: const Icon(Icons.arrow_forward, size: 18),
              label: const Text('View All'),
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
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
                height: 280,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return Container(
                      width: 280,
                      margin: const EdgeInsets.only(right: 12),
                      child: _buildModernFeaturedCourseCard(
                        context,
                        course,
                      ),
                    );
                  },
                ),
              );
            }

            return _buildModernEmptyCard(
              context,
              icon: Icons.star_outline,
              title: 'No featured courses available',
              subtitle: 'Check back later for new courses',
              buttonText: 'Browse All Courses',
              onTap: () {
                context.read<HomeShellCubit>().goToCourses();
              },
            );
          },
        ),
      ],
    );
  }

  /// Build a modern featured course card with enhanced design.
  Widget _buildModernFeaturedCourseCard(BuildContext context, Course course) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () => context.go('/courses/${course.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Course Thumbnail with overlay
              Stack(
                children: [
                  _buildFeaturedThumbnail(course.thumbnail),
                  // Price/Enrolled Tag
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: course.isEnrolled == true
                            ? AppColors.secondary
                            : AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        course.isEnrolled == true
                            ? 'Enrolled'
                            : course.displayPrice,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Level Badge
                  if (course.level != null)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          course.levelLabel.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category & Rating Row
                    Row(
                      children: [
                        if (course.category != null)
                          Text(
                            course.category!.name.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        const Spacer(),
                        const Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: AppColors.starActive,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          course.rating?.toStringAsFixed(1) ?? 'NR',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Title
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    // Stats Row
                    Row(
                      children: [
                        const Icon(
                          Icons.play_circle_outline_rounded,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${course.totalLessonsCount} Lessons',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.people_outline_rounded,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${course.enrolledCount}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedThumbnail(String? url) {
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.disabledBackground,
      ),
      child:
          url != null && url.isNotEmpty
              ? Image.network(url, fit: BoxFit.cover)
              : const Center(
                child: Icon(
                  Icons.school_outlined,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
    );
  }

  /// Build a modern empty state card.
  Widget _buildModernEmptyCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.disabledBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
          width: 2,
          strokeAlign: BorderSide.strokeAlignInside,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 48, color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: onTap,
            icon: const Icon(Icons.explore_outlined),
            label: Text(buttonText),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Build recent activity section with modern design.
  Widget _buildRecentActivitySection(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      buildWhen: (previous, current) =>
          current is DashboardLoaded || current is DashboardLoading,
      builder: (context, state) {
        List<Activity>? activities;

        if (state is DashboardLoaded) {
          activities = state.activities;
        } else if (state is DashboardLoading) {
        
        }

        if (activities == null || activities.isEmpty) {
          return const SizedBox();
        }

        final recentActivities = activities.take(5).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Activity',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                // TextButton(
                //   onPressed: () {
                //     context.read<HomeShellCubit>().goToActivity();
                //   },
                //   style: TextButton.styleFrom(
                //     foregroundColor: AppColors.primary,
                //   ),
                //   child: const Text('View All'),
                // ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
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
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: recentActivities.length,
                separatorBuilder: (context, index) =>
                    Divider(color: AppColors.border, height: 1),
                itemBuilder: (context, index) {
                  final activity = recentActivities[index];
                  return _buildActivityTile(activity);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// Build a modern activity tile.
  Widget _buildActivityTile(Activity activity) {
    final color = _getActivityColor(activity);
    final icon = _getActivityIcon(activity);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(
        activity.description,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
      ),
      subtitle: Text(
        _formatActivityTime(activity.createdAt),
        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
      ),
      dense: true,
    );
  }

  /// Get icon for activity type.
  IconData _getActivityIcon(Activity activity) {
    switch (activity.type) {
      case ActivityType.lessonCompleted:
        return Icons.check_circle_outline;
      case ActivityType.enrollmentCreated:
        return Icons.school_outlined;
      case ActivityType.courseProgressUpdated:
        return Icons.trending_up;
      case ActivityType.profileUpdated:
        return Icons.edit_outlined;
      case ActivityType.passwordChanged:
        return Icons.lock_outline;
      case ActivityType.avatarUpdated:
        return Icons.image_outlined;
      case ActivityType.accountDeleted:
        return Icons.delete_forever;
    }
  }

  /// Get color for activity type.
  Color _getActivityColor(Activity activity) {
    switch (activity.type) {
      case ActivityType.lessonCompleted:
        return AppColors.success;
      case ActivityType.enrollmentCreated:
        return AppColors.primary;
      case ActivityType.courseProgressUpdated:
        return AppColors.accent;
      case ActivityType.profileUpdated:
        return AppColors.categoryEnglish;
      case ActivityType.passwordChanged:
        return AppColors.error;
      case ActivityType.avatarUpdated:
        return AppColors.categoryChemistry;
      case ActivityType.accountDeleted:
        return AppColors.textTertiary;
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
