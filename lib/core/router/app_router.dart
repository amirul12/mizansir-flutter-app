// File: lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/api_constants.dart';
import '../utils/q_context.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/course_browsing/presentation/pages/courses_page.dart';
import '../../features/course_browsing/presentation/pages/course_details_page.dart';
import '../../features/course_browsing/presentation/pages/course_search_page.dart';
import '../../features/course_browsing/presentation/pages/categories_page.dart';
import '../../features/course_browsing/presentation/bloc/course_bloc.dart';
import '../../features/enrollment/presentation/bloc/enrollment_bloc.dart';
import '../../features/enrollment/presentation/pages/course_lessons_page.dart';
import '../../features/enrollment/presentation/pages/student_lesson_player_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/dashboard_page.dart';
import '../../features/profile/presentation/pages/change_password_page.dart';
import '../../features/profile/presentation/pages/about_mizan_sir_page.dart';
import '../../features/profile/presentation/bloc/profile_bloc.dart';
import '../../features/profile/presentation/bloc/profile_event.dart';
import '../../features/profile/presentation/bloc/dashboard_bloc.dart';
import '../../features/profile/presentation/bloc/dashboard_event.dart';
import '../../features/home/presentation/pages/home_shell_page.dart';
import '../../features/home/domain/entities/home_tab.dart';
import '../presentation/pages/splash_page.dart';
import '../di/injection_container.dart' as di;

/// App router configuration
class AppRouter {
  // Private constructor to prevent instantiation
  AppRouter._();

  // Route names (for navigation)
  static const String splash = 'splash';
  static const String home = 'home';
  static const String appShell = 'app_shell';
  static const String login = 'login';
  static const String register = 'register';
  static const String courses = 'courses';
  static const String courseDetails = 'course_details';
  static const String courseSearch = 'course_search';
  static const String categories = 'categories';
  static const String myCourses = 'my_courses';
  static const String courseProgress = 'course_progress';
  static const String lessonPlayer = 'lesson_player';
  static const String lessonPlayerSpecific = 'lesson_player_specific';
  static const String enrollments = 'enrollments';
  static const String profile = 'profile';
  static const String dashboard = 'dashboard';
  static const String changePassword = 'change_password';
  static const String aboutMizanSir = 'about_mizan_sir';

  // Route paths
  static const String splashPath = '/splash';
  static const String homePath = '/';
  static const String appShellPath = '/home';
  static const String loginPath = '/login';
  static const String registerPath = '/register';
  static const String coursesPath = '/courses';
  static const String courseDetailsPath = '/courses/:id';
  static const String courseSearchPath = '/search';
  static const String categoriesPath = '/categories';
  static const String myCoursesPath = '/my-courses';
  static const String courseProgressPath = '/my-courses/:courseId';
  static const String lessonPlayerPath = '/my-courses/:courseId/lessons';
  static const String lessonPlayerWithPath =
      '/my-courses/:courseId/lessons/:lessonId';
  static const String enrollmentsPath = '/enrollments';
  static const String profilePath = '/profile';
  static const String dashboardPath = '/dashboard';
  static const String changePasswordPath = '/change-password';
  static const String aboutMizanSirPath = '/about-mizan-sir';

  // GoRouter configuration
  static GoRouter get router {
    return GoRouter(
      initialLocation: splashPath,
      debugLogDiagnostics: true,
      navigatorKey: QContext.navigatorKey,
      errorBuilder: (context, state) => _ErrorPage(error: state.error),
      routes: [
        // Splash Route - Initial screen that checks auth status
        GoRoute(
          path: splashPath,
          name: splash,
          builder: (context, state) => BlocProvider(
            create: (context) => di.sl<AuthBloc>(),
            child: const SplashPage(),
          ),
        ),

        // Home Route - Landing page for non-authenticated users
        GoRoute(
          path: homePath,
          name: home,
          builder: (context, state) => BlocProvider(
            create: (context) => di.sl<AuthBloc>(),
            child: const _HomePage(),
          ),
        ),

        // About Mizan Sir Route - Publicly accessible
        GoRoute(
          path: aboutMizanSirPath,
          name: aboutMizanSir,
          builder: (context, state) => const AboutMizanSirPage(),
        ),

        // App Shell Route - Main authenticated experience
        GoRoute(
          path: appShellPath,
          name: appShell,
          builder: (context, state) {
            // Check for tab query parameter
            final tabParam = state.uri.queryParameters['tab'];
            HomeTab? initialTab;

            if (tabParam != null) {
              switch (tabParam.toLowerCase()) {
                case 'home':
                  initialTab = HomeTab.home;
                  break;
                case 'courses':
                  initialTab = HomeTab.courses;
                  break;
                case 'my_learning':
                  initialTab = HomeTab.myLearning;
                  break;
                case 'profile':
                  initialTab = HomeTab.profile;
                  break;
              }
            }

            return HomeShellPage(initialTab: initialTab);
          },
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
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => di.sl<CourseBloc>()),
                BlocProvider(create: (context) => di.sl<EnrollmentBloc>()),
              ],
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

        // Course Lessons List Route
        GoRoute(
          path: lessonPlayerPath,
          name: lessonPlayer,
          builder: (context, state) {
            final courseId = state.pathParameters['courseId']!;
            return BlocProvider(
              create: (context) => di.sl<EnrollmentBloc>(),
              child: CourseLessonsPage(courseId: courseId),
            );
          },
        ),

        // Single Lesson Player Route (Student Player)
        GoRoute(
          path: lessonPlayerWithPath,
          name: lessonPlayerSpecific,
          builder: (context, state) {
            final courseId = state.pathParameters['courseId']!;
            final lessonId = state.pathParameters['lessonId']!;
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => di.sl<AuthBloc>()),
                BlocProvider(create: (context) => di.sl<EnrollmentBloc>()),
              ],
              child: StudentLessonPlayerPage(
                courseId: courseId,
                lessonId: lessonId,
              ),
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
            create: (context) =>
                di.sl<DashboardBloc>()..add(LoadDashboardEvent()),
            child: const DashboardPage(),
          ),
        ),

        // Change Password Route
        GoRoute(
          path: changePasswordPath,
          name: changePassword,
          builder: (context, state) => BlocProvider(
            create: (context) => di.sl<ProfileBloc>(),
            child: const ChangePasswordPage(),
          ),
        ),
      ],
    );
  }
}

// ========== Placeholder Pages ==========

/// Home Page - Landing page for non-authenticated users
class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mizan Sir HSC ICT')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 25,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/icons/logo.png',
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.school_outlined,
                        size: 80,
                        color: Colors.blue,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Welcome Text
              const Text(
                'HSC ICT with Mizan Sir',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Private Batch - Simple Text
              Text(
                'Private Batch',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),

              // Tagline
              Text(
                'Master HSC ICT with Expert Guidance',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),

              // Subtitle
              Text(
                'Your Complete HSC ICT Learning Solution',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),

              // Login button - Highlighted
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => context.go('/login'),
                  icon: const Icon(Icons.login, size: 24),
                  label: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 8,
                    shadowColor: Colors.blue.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Register button - Highlighted
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showRegistrationDialog(context),
                  icon: const Icon(Icons.person_add, size: 24),
                  label: const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    elevation: 8,
                    shadowColor: Colors.green.withValues(alpha: 0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // About Mizan Sir Button
              TextButton.icon(
                onPressed: () => context.go('/about-mizan-sir'),
                icon: const Icon(Icons.person, size: 20),
                label: const Text(
                  'About Mizan Sir',
                  style: TextStyle(fontSize: 16),
                ),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue.shade700,
                ),
              ),

              const SizedBox(height: 24),

              // Features preview
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildFeature(
                    Icons.video_library,
                    'Video Courses',
                    Colors.blue,
                  ),
                  _buildFeature(Icons.quiz, 'Quizzes', Colors.green),
                  _buildFeature(Icons.verified, 'Certificates', Colors.orange),
                ],
              ),
            ],
          ),
        ),
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

  void _showRegistrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.green, size: 28),
            const SizedBox(width: 12),
            const Text(
              'Create Account',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'To create a new account, please visit our website.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blue.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.language, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Website:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    '${ApiConstants.baseUrl.replaceFirst('/api', '')}/register',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Click the button below to open the registration page.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              final Uri url = Uri.parse(
                '${ApiConstants.baseUrl.replaceFirst('/api', '')}/register',
              );
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              }
              if (context.mounted) {
                Navigator.pop(context);
              }
            },
            icon: const Icon(Icons.launch, size: 20),
            label: const Text(
              'Open Website',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
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
      body: const Center(child: Text('My Courses Page - Coming Soon')),
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
      body: const Center(child: Text('Enrollments Page - Coming Soon')),
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
