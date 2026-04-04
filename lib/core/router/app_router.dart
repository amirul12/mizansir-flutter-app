// File: lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';

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
  static const String myCourses = 'my_courses';
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
  static const String myCoursesPath = '/my-courses';
  static const String lessonPlayerPath = '/my-courses/:courseId/lessons/:lessonId';
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
        // Home Route
        GoRoute(
          path: homePath,
          name: home,
          builder: (context, state) => const _HomePage(),
        ),

        // Authentication Routes
        GoRoute(
          path: loginPath,
          name: login,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: registerPath,
          name: register,
          builder: (context, state) => const RegisterPage(),
        ),

        // Course Routes
        GoRoute(
          path: coursesPath,
          name: courses,
          builder: (context, state) => const _CoursesPage(),
        ),
        GoRoute(
          path: courseDetailsPath,
          name: courseDetails,
          builder: (context, state) {
            final courseId = state.pathParameters['id']!;
            return _CourseDetailsPage(courseId: courseId);
          },
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
          builder: (context, state) => const _ProfilePage(),
        ),

        // Dashboard Route
        GoRoute(
          path: dashboardPath,
          name: dashboard,
          builder: (context, state) => const _DashboardPage(),
        ),
      ],
    );
  }
}

// ========== Placeholder Pages ==========

/// Home Page Placeholder
class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PrivateTutor')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to PrivateTutor',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Phase 1 Foundation Complete'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.go('/courses'),
              child: const Text('Browse Courses'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Courses Page Placeholder
class _CoursesPage extends StatelessWidget {
  const _CoursesPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Courses')),
      body: const Center(
        child: Text('Courses Page - Coming Soon'),
      ),
    );
  }
}

/// Course Details Page Placeholder
class _CourseDetailsPage extends StatelessWidget {
  final String courseId;

  const _CourseDetailsPage({required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Details')),
      body: Center(
        child: Text('Course Details: $courseId - Coming Soon'),
      ),
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
