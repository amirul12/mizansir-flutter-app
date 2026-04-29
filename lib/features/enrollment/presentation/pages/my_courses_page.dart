// File: lib/features/enrollment/presentation/pages/my_courses_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/enrollment_bloc.dart';
import '../bloc/enrollment_event.dart';
import '../bloc/enrollment_state.dart';
import '../widgets/enrolled_course_card.dart';

/// My Courses Page - Displays enrolled courses
class MyCoursesPage extends StatefulWidget {
  const MyCoursesPage({super.key});

  @override
  State<MyCoursesPage> createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  @override
  void initState() {
    super.initState();
    // Load enrolled courses
    context.read<EnrollmentBloc>().add(const LoadMyCoursesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Courses'),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<EnrollmentBloc>().add(const LoadMyCoursesEvent());
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<EnrollmentBloc, EnrollmentState>(
        builder: (context, state) {
          if (state is EnrollmentLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EnrollmentError) {
            return _buildErrorView(state.message);
          }

          if (state is EnrollmentEmpty) {
            return _buildEmptyView(state.message);
          }

          if (state is MyCoursesLoaded) {
            return _buildCoursesList(state.courses);
          }

          // Initial state - show loading
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildCoursesList(List courses) {
    if (courses.isEmpty) {
      return _buildEmptyView('No enrolled courses yet');
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<EnrollmentBloc>().add(const LoadMyCoursesEvent());
      },
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final course = courses[index];
          // return EnrolledCourseCard(
          //   course: course,
          //   onTap: () {
          //     // Navigate to course details
          //     context.go('/my-courses/${course.id}');
          //   },
          //   onResume: () {
          //     // Navigate to lessons and start playing
          //     _navigateToLesson(context, course.id);
          //   },
          // );
        },
      ),
    );
  }

  Widget _buildErrorView(String message) {
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
              message,
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

  Widget _buildEmptyView(String message) {
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
              message,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Start learning by enrolling in courses',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Navigate to courses page
                context.go('/courses');
              },
              icon: const Icon(Icons.explore),
              label: const Text('Browse Courses'),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToLesson(BuildContext context, String courseId) {
    // Navigate to lessons page
    context.go('/my-courses/$courseId/lessons');
  }
}
