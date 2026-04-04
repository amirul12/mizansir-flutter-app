// File: lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../../features/course_browsing/presentation/pages/courses_page.dart';
import '../../features/course_browsing/presentation/pages/course_details_page.dart';
import '../../features/course_browsing/presentation/pages/course_search_page.dart';
import '../../features/course_browsing/presentation/pages/categories_page.dart';
import '../../features/course_browsing/presentation/bloc/course_bloc.dart';
import '../../features/enrollment/presentation/bloc/enrollment_bloc.dart';
import '../../features/enrollment/presentation/pages/my_courses_page.dart';
import '../../features/enrollment/presentation/pages/lesson_player_page.dart';
import '../../features/enrollment/presentation/pages/course_progress_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/dashboard_page.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/bloc/profile_event.dart';
import '../../features/profile/presentation/bloc/dashboard_bloc.dart';
import '../../features/profile/presentation/bloc/dashboard_event.dart';
import '../di/injection_container.dart' as di;

/// App router configuration
class AppRouter {
  // Private constructor to prevent instantiation
  AppRouter._();

  // Route names (for navigation)
  static const String home = 'home';
  static const String login = 'login';
  static const String register = 'register';
  static const String courses = 'courses';
  static const String courseDetails = 'course_details';
  static const String courseSearch = 'course_search';
  static const String categories = 'categories';
  static const String myCourses = 'my_courses';
  static const String courseProgress = 'course_progress';
  static const String lessonPlayer = 'lesson_player';
  static const String enrollments = 'enrollments';
  static const String profile = 'profile';
  static const String dashboard = 'dashboard';

  // Route paths
  static const String homePath = '/';
  static const String loginPath = '/login';
  static const String registerPath = '/register';
  static const String coursesPath = '/courses';
  static const String courseDetailsPath = '/courses/:id';
  static const String courseSearchPath = '/search';
  static const String categoriesPath = '/categories';
  static const String myCoursesPath = '/my-courses';
  static const String courseProgressPath = '/my-courses/:courseId';
  static const String lessonPlayerPath = '/my-courses/:courseId/lessons';
  static const String lessonPlayerWithPath = '/my-courses/:courseId/lessons/:lessonId';
  static const String enrollmentsPath = '/enrollments';
  static const String profilePath = '/profile';
  static const String dashboardPath = '/dashboard';

  // GoRouter configuration
  static GoRouter get router {
    return GoRouter(
      initialLocation: homePath,
      debugLogDiagnostics: true,
      errorBuilder: (context, state) => _ErrorPage(error: state.error),
      routes: [
        // Home Route - Checks auth and redirects accordingly
        GoRoute(
          path: homePath,
          name: home,
          builder: (context, state) => BlocProvider(
            create: (context) => di.sl<AuthBloc>()..add(GetCurrentUserEvent()),
            child: const _HomePage(),
          ),
        ),

        // Authentication Routes
        GoRoute(
          path: loginPath,
          name: login,
          builder: (context, state) => BlocProvider(
            create: (context) => di.sl<AuthBloc>(),
            child: const LoginPage(),
          ),
        ),
        GoRoute(
          path: registerPath,
          name: register,
          builder: (context, state) => BlocProvider(
            create: (context) => di.sl<AuthBloc>(),
            child: const RegisterPage(),
          ),
        ),

        // Course Routes
        GoRoute(
          path: coursesPath,
          name: courses,
          builder: (context, state) => BlocProvider(
            create: (context) => di.sl<CourseBloc>(),
            child: const CoursesPage(),
          ),
        ),
        GoRoute(
          path: courseDetailsPath,
          name: courseDetails,
          builder: (context, state) {
            final courseId = state.pathParameters['id']!;
            return BlocProvider(
              create: (context) => di.sl<CourseBloc>(),
              child: CourseDetailsPage(courseId: courseId),
            );
          },
        ),
        GoRoute(
          path: courseSearchPath,
          name: courseSearch,
          builder: (context, state) => BlocProvider(
            create: (context) => di.sl<CourseBloc>(),
            child: const CourseSearchPage(),
          ),
        ),
        GoRoute(
          path: categoriesPath,
          name: categories,
          builder: (context, state) => BlocProvider(
            create: (context) => di.sl<CourseBloc>(),
            child: const CategoriesPage(),
          ),
        ),

        // My Courses Route
        GoRoute(
          path: myCoursesPath,
          name: myCourses,
          builder: (context, state) => const _MyCoursesPage(),
        ),

        // Lesson Player Route
        GoRoute(
          path: lessonPlayerPath,
          name: lessonPlayer,
          builder: (context, state) {
            final courseId = state.pathParameters['courseId']!;
            final lessonId = state.pathParameters['lessonId']!;
            return _LessonPlayerPage(
              courseId: courseId,
              lessonId: lessonId,
            );
          },
        ),

        // Enrollments Route
        GoRoute(
          path: enrollmentsPath,
          name: enrollments,
          builder: (context, state) => const _EnrollmentsPage(),
        ),

        // Profile Route
        GoRoute(
          path: profilePath,
          name: profile,
          builder: (context, state) => BlocProvider(
            create: (context) => di.sl<ProfileBloc>()..add(LoadProfileEvent()),
            child: const ProfilePage(),
          ),
        ),

        // Dashboard Route
        GoRoute(
          path: dashboardPath,
          name: dashboard,
          builder: (context, state) => BlocProvider(
            create: (context) => di.sl<DashboardBloc>()..add(LoadDashboardEvent()),
            child: const DashboardPage(),
          ),
        ),
      ],
    );
  }
}

// ========== Placeholder Pages ==========

/// Home Page - Shows login/register if not auth, redirects to courses if auth
class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          // User is logged in, redirect to courses
          context.go('/courses');
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          // Show loading while checking auth
          if (state is AuthLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          // If authenticated, will redirect via listener
          // If not authenticated or error, show login/register screen
          return Scaffold(
            appBar: AppBar(title: const Text('PrivateTutor')),
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.school_outlined,
                        size: 80,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Welcome to PrivateTutor',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Your Online Learning Platform',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Please login or register to continue',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[500],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => context.go('/login'),
                        icon: const Icon(Icons.login),
                        label: const Text('Login'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Register button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => context.go('/register'),
                        icon: const Icon(Icons.person_add),
                        label: const Text('Create Account'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Features preview
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildFeature(
                          Icons.video_library,
                          'Video Courses',
                          Colors.blue,
                        ),
                        _buildFeature(
                          Icons.quiz,
                          'Quizzes',
                          Colors.green,
                        ),
                        _buildFeature(
                          Icons.verified,
                          'Certificates',
                          Colors.orange,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeature(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 32),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

/// My Courses Page Placeholder
class _MyCoursesPage extends StatelessWidget {
  const _MyCoursesPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Courses')),
      body: const Center(
        child: Text('My Courses Page - Coming Soon'),
      ),
    );
  }
}

/// Lesson Player Page Placeholder
class _LessonPlayerPage extends StatelessWidget {
  final String courseId;
  final String lessonId;

  const _LessonPlayerPage({
    required this.courseId,
    required this.lessonId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lesson Player')),
      body: Center(
        child: Text('Lesson: $lessonId - Course: $courseId - Coming Soon'),
      ),
    );
  }
}

/// Enrollments Page Placeholder
class _EnrollmentsPage extends StatelessWidget {
  const _EnrollmentsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enrollments')),
      body: const Center(
        child: Text('Enrollments Page - Coming Soon'),
      ),
    );
  }
}

/// Profile Page Placeholder
class _ProfilePage extends StatelessWidget {
  const _ProfilePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(
        child: Text('Profile Page - Coming Soon'),
      ),
    );
  }
}

/// Dashboard Page Placeholder
class _DashboardPage extends StatelessWidget {
  const _DashboardPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: const Center(
        child: Text('Dashboard Page - Coming Soon'),
      ),
    );
  }
}

/// Error Page
class _ErrorPage extends StatelessWidget {
  final Exception? error;

  const _ErrorPage({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'An error occurred',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(error?.toString() ?? 'Unknown error'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
