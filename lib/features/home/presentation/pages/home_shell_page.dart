import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../profile/presentation/bloc/profile_bloc.dart';
import '../../../profile/presentation/bloc/profile_event.dart';
import '../../../profile/presentation/bloc/dashboard_bloc.dart';
import '../../../profile/presentation/bloc/dashboard_event.dart';
import '../../../enrollment/presentation/bloc/enrollment_bloc.dart';
import '../../../enrollment/presentation/bloc/enrollment_event.dart';
import '../../../enrollment/presentation/bloc/enrollment_state.dart';
import '../../../enrollment/domain/entities/my_course_entity.dart';
import '../../../course_browsing/presentation/bloc/course_bloc.dart';
import '../../../course_browsing/presentation/bloc/course_event.dart';
import '../../../course_browsing/presentation/bloc/course_state.dart';
import '../../../course_browsing/domain/entities/course.dart';
import '../../domain/entities/home_tab.dart';
import '../bloc/home_shell_cubit.dart';
import '../widgets/home_bottom_nav_bar.dart';
import '../widgets/home_drawer.dart';
import 'home_dashboard_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../../core/di/injection_container.dart' as di;
import '../../../../core/theme/app_colors.dart';

/// Home Shell Page - Main authenticated app container.
///
/// This is the main entry point for authenticated users.
/// Contains bottom navigation, drawer, and manages tab content.
class HomeShellPage extends StatelessWidget {
  final HomeTab? initialTab;

  const HomeShellPage({super.key, this.initialTab});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Home shell cubit for tab management
        BlocProvider(create: (context) => HomeShellCubit()),
        // Auth bloc for logout functionality
        BlocProvider(create: (context) => di.sl<AuthBloc>()),
        // Initialize profile and dashboard blocs
        BlocProvider(
          create: (context) => di.sl<ProfileBloc>()..add(LoadProfileEvent()),
        ),
        BlocProvider(
          create: (context) =>
              di.sl<DashboardBloc>()..add(LoadDashboardEvent()),
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
      child: initialTab != null
          ? _HomeShellViewWithInitialTab(initialTab: initialTab!)
          : const _HomeShellView(),
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
        title: const Text('HSC ICT'),
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
      _ => AppBar(title: const Text('HSC ICT')),
    };
  }

  /// Build body content based on current tab.
  Widget _buildBodyForTab(HomeTab tab) {
    return switch (tab) {
      HomeTab.home => const _HomeTabPage(),
      HomeTab.courses => const _CoursesTabPage(),
      HomeTab.myLearning => const _MyLearningTabPage(),
      HomeTab.profile => const _ProfileTabPage(),
      _ => const _HomeTabPage(),
    };
  }
}

class _HomeShellViewWithInitialTab extends StatefulWidget {
  final HomeTab initialTab;

  const _HomeShellViewWithInitialTab({required this.initialTab});

  @override
  State<_HomeShellViewWithInitialTab> createState() =>
      _HomeShellViewWithInitialTabState();
}

class _HomeShellViewWithInitialTabState
    extends State<_HomeShellViewWithInitialTab> {
  @override
  void initState() {
    super.initState();
    // Set the initial tab when the widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeShellCubit>().setTab(widget.initialTab);
    });
  }

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
        title: const Text('HSC ICT'),
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
      _ => AppBar(title: const Text('HSC ICT')),
    };
  }

  /// Build body content based on current tab.
  Widget _buildBodyForTab(HomeTab tab) {
    return switch (tab) {
      HomeTab.home => const _HomeTabPage(),
      HomeTab.courses => const _CoursesTabPage(),
      HomeTab.myLearning => const _MyLearningTabPage(),
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
          current is FeaturedCoursesLoaded ||
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

        // Show courses (handle both CoursesLoaded and FeaturedCoursesLoaded)
        final courses = state is CoursesLoaded
            ? state.courses
            : state is FeaturedCoursesLoaded
            ? state.courses
            : null;

        if (courses != null && courses.isNotEmpty) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<CourseBloc>().add(const LoadCoursesEvent());
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: courses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final course = courses[index];
                return _buildCourseCard(context, course);
              },
            ),
          );
        }

        // Show empty state when courses list is null or empty
        if (courses == null || courses.isEmpty) {
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

        // Initial state
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildCourseCard(BuildContext context, Course course) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () {
            context.go('/courses/${course.id}');
          },
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Thumbnail Image with Overlay Badges
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: Hero(
                      tag: 'course_image_${course.id}',
                      child: _buildThumbnailImage(context, course),
                    ),
                  ),

                  // Category & Level Badges
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (course.category != null)
                          _buildModernBadge(
                            course.category!.name,
                            _getCategoryColor(course.category!.name),
                          ),
                        _buildLevelBadge(course.levelLabel),
                      ],
                    ),
                  ),

                  // Price badge overlay
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        course.displayPrice,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: course.isFree
                              ? AppColors.secondary
                              : AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // 2. Course Info Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rating Row
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: AppColors.starActive,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          course.rating?.toStringAsFixed(1) ?? '0.0',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${course.reviewCount} reviews)',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.people_outline_rounded,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${course.enrolledCount} students',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Title
                    Text(
                      course.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1.3,
                        fontSize: 18,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Instructor
                    if (course.instructor != null)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            course.instructor!,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 16),
                    Divider(color: Colors.grey.shade100, height: 1),
                    const SizedBox(height: 16),

                    // Meta Info: Lessons & Duration
                    Row(
                      children: [
                        _buildMetaItem(
                          Icons.play_circle_fill_rounded,
                          '${course.totalLessonsCount} Lessons',
                          Colors.blue.shade600,
                        ),
                        const SizedBox(width: 16),
                        _buildMetaItem(
                          Icons.schedule_rounded,
                          course.formattedDuration ?? 'N/A',
                          Colors.orange.shade600,
                        ),
                        const Spacer(),
                        // Language info if available
                        if (course.language != null)
                          Text(
                            course.language!,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // CTA Button - Primary Action
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          context.go('/courses/${course.id}');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: course.isEnrolled == true
                              ? AppColors.secondary
                              : AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              course.isEnrolled == true
                                  ? 'Continue Learning'
                                  : 'Enroll Now',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              course.isEnrolled == true
                                  ? Icons.play_circle_fill_rounded
                                  : Icons.arrow_forward_rounded,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
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

  Widget _buildThumbnailImage(BuildContext context, Course course) {
    if (course.thumbnail != null && course.thumbnail!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: course.thumbnail!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder:
            (context, url) => Container(
              height: 200,
              color: AppColors.primary.withOpacity(0.05),
              child: const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        errorWidget: (context, url, error) => _buildPlaceholderThumbnail(),
      );
    }
    return _buildPlaceholderThumbnail();
  }

  Widget _buildPlaceholderThumbnail() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.8),
            AppColors.primary,
          ],
        ),
      ),
      child: const Icon(Icons.school, size: 64, color: Colors.white24),
    );
  }

  Widget _buildModernBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildLevelBadge(String level) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        level.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMetaItem(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'math':
      case 'mathematics':
        return AppColors.categoryMath;
      case 'physics':
        return AppColors.categoryPhysics;
      case 'chemistry':
        return AppColors.categoryChemistry;
      case 'biology':
        return AppColors.categoryBiology;
      case 'english':
        return AppColors.categoryEnglish;
      default:
        return AppColors.primary;
    }
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
                return _buildEnrolledCourseCard(
                  context,
                  course as MyCourseEntity,
                );
              },
            ),
          );
        }

        // Initial state
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildEnrolledCourseCard(BuildContext context, MyCourseEntity course) {
    final courseInfo = course.course;
    final curriculum = course.curriculum;
    final enrollment = course.enrollment;

    final progress = curriculum.progressPercentage.clamp(0, 100).toDouble();
    final progressColor = _getProgressColor(progress);

    void handleNavigation() {
      if (curriculum.nextLesson != null) {
        context.go(
          '/my-courses/${courseInfo.id}/lessons/${curriculum.nextLesson!.id}',
        );
      } else {
        context.go('/my-courses/${courseInfo.id}/lessons');
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: handleNavigation,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCourseThumbnail(context, courseInfo.thumbnail),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  courseInfo.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        height: 1.3,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              _buildProgressBadge(progressColor, progress),
                            ],
                          ),

                          const SizedBox(height: 8),

                          if (courseInfo.description.isNotEmpty)
                            Text(
                              courseInfo.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Colors.grey.shade600,
                                    height: 1.4,
                                  ),
                            ),

                          const SizedBox(height: 12),

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildMiniInfoChip(
                                icon: Icons.play_circle_outline,
                                label: '${curriculum.totalLessons} Lessons',
                                color: Colors.blue,
                              ),
                              _buildMiniInfoChip(
                                icon: Icons.check_circle_outline,
                                label:
                                    '${curriculum.completedLessons} Completed',
                                color: Colors.green,
                              ),
                              _buildMiniInfoChip(
                                icon: Icons.schedule_outlined,
                                label: courseInfo.formattedDuration,
                                color: Colors.orange,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your progress',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                        ),
                        Text(
                          '${progress.toInt()}%',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: progressColor,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: progress / 100,
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progressColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          context.go('/my-courses/${courseInfo.id}/lessons');
                        },
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(46),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          side: BorderSide(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.2),
                          ),
                        ),
                        child: const Text('View Lessons'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: handleNavigation,
                        icon: const Icon(Icons.play_arrow_rounded, size: 18),
                        label: Text(
                          curriculum.nextLesson != null
                              ? 'Continue'
                              : 'Start Now',
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(46),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseThumbnail(BuildContext context, String? thumbnail) {
    final primaryColor = Theme.of(context).primaryColor;

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        width: 92,
        height: 92,
        child: thumbnail != null && thumbnail.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: thumbnail,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        primaryColor.withOpacity(0.35),
                        primaryColor.withOpacity(0.15),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) =>
                    _buildThumbnailFallback(primaryColor),
              )
            : _buildThumbnailFallback(primaryColor),
      ),
    );
  }

  Widget _buildThumbnailFallback(Color primaryColor) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primaryColor, primaryColor.withOpacity(0.7)],
        ),
      ),
      child: const Center(
        child: Icon(Icons.school_rounded, size: 34, color: Colors.white),
      ),
    );
  }

  Widget _buildProgressBadge(Color color, double progress) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withOpacity(0.20)),
      ),
      child: Text(
        '${progress.toInt()}%',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _buildMiniInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildEnrolledCourseCard(BuildContext context, MyCourseEntity course) {
    // Extract data from entity
    final courseInfo = course.course;
    final curriculum = course.curriculum;
    final enrollment = course.enrollment;

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
            if (curriculum.nextLesson != null) {
              context.go(
                '/my-courses/${courseInfo.id}/lessons/${curriculum.nextLesson!.id}',
              );
            } else {
              context.go('/my-courses/${courseInfo.id}/lessons');
            }
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Thumbnail on the left (avatar size)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        width: 80,
                        height: 80,
                        child:
                            courseInfo.thumbnail != null &&
                                courseInfo.thumbnail!.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: courseInfo.thumbnail!,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Theme.of(
                                          context,
                                        ).primaryColor.withValues(alpha: 0.3),
                                        Theme.of(
                                          context,
                                        ).primaryColor.withValues(alpha: 0.1),
                                      ],
                                    ),
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Theme.of(context).primaryColor,
                                        Theme.of(
                                          context,
                                        ).primaryColor.withValues(alpha: 0.7),
                                      ],
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.school,
                                    size: 32,
                                    color: Colors.white70,
                                  ),
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Theme.of(context).primaryColor,
                                      Theme.of(
                                        context,
                                      ).primaryColor.withValues(alpha: 0.7),
                                    ],
                                  ),
                                ),
                                child: const Icon(
                                  Icons.school,
                                  size: 32,
                                  color: Colors.white70,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Content on the right
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title row with progress
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  courseInfo.title,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              // Progress badge
                              if (curriculum.progressPercentage > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getProgressColor(
                                      curriculum.progressPercentage,
                                    ).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _getProgressColor(
                                        curriculum.progressPercentage,
                                      ).withValues(alpha: 0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    '${curriculum.progressPercentage.toInt()}%',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: _getProgressColor(
                                        curriculum.progressPercentage,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Status and expiry row
                          // Row(
                          //   children: [
                          //     _buildStatusChip(enrollment.status),
                          //     const SizedBox(width: 8),
                          //     _buildDaysRemainingChip(enrollment.expiresAt),
                          //   ],
                          // ),

                          // Description
                          if (courseInfo.description.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              courseInfo.description,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey[600]),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],

                          const SizedBox(height: 12),

                          // Full width stats section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _buildFullWidthStat(
                                  Icons.play_circle_outline,
                                  '${curriculum.totalLessons} Lessons',
                                  Colors.blue,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildFullWidthStat(
                                  Icons.check_circle_outline,
                                  '${curriculum.completedLessons} Completed',
                                  Colors.green,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildFullWidthStat(
                                  Icons.schedule,
                                  courseInfo.formattedDuration,
                                  Colors.orange,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Continue button
                          SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // Navigate to next lesson if available, otherwise show all lessons
                                if (curriculum.nextLesson != null) {
                                  context.go(
                                    '/my-courses/${courseInfo.id}/lessons/${curriculum.nextLesson!.id}',
                                  );
                                } else {
                                  context.go(
                                    '/my-courses/${courseInfo.id}/lessons',
                                  );
                                }
                              },
                              icon: const Icon(Icons.play_arrow, size: 18),
                              label: const Text('Continue Learning'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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

  Widget _buildFullWidthStat(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
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

class _ProfileTabPage extends StatelessWidget {
  const _ProfileTabPage();

  @override
  Widget build(BuildContext context) {
    return const ProfilePage();
  }
}
