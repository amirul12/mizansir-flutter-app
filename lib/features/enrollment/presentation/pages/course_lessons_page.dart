// File: lib/features/enrollment/presentation/pages/course_lessons_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/enrollment_bloc.dart';
import '../bloc/enrollment_event.dart';
import '../bloc/enrollment_state.dart';
import '../../domain/entities/lesson.dart';
import '../widgets/lesson_item.dart';

/// Course Lessons List Page - Shows all lessons in a course
class CourseLessonsPage extends StatefulWidget {
  final String courseId;

  const CourseLessonsPage({super.key, required this.courseId});

  @override
  State<CourseLessonsPage> createState() => _CourseLessonsPageState();
}

class _CourseLessonsPageState extends State<CourseLessonsPage> {
  @override
  void initState() {
    super.initState();
    _loadLessons();
  }

  void _loadLessons() {
    context.read<EnrollmentBloc>().add(
      LoadCourseLessonsEvent(courseId: widget.courseId),
    );
  }

  void _selectLesson(Lesson lesson) {
    // Navigate to single lesson player
    context.go('/my-courses/${widget.courseId}/lessons/${lesson.id}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Lessons'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // back to home
            context.go('/home');
          },
        ),
      ),
      body: BlocListener<EnrollmentBloc, EnrollmentState>(
        listener: (context, state) {
          if (state is LessonCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Lesson marked as complete!'),
                backgroundColor: Colors.green,
              ),
            );
            _loadLessons();
          }
        },
        child: BlocBuilder<EnrollmentBloc, EnrollmentState>(
          builder: (context, state) {
            if (state is EnrollmentLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is EnrollmentError) {
              return _buildErrorView(state.message);
            }

            if (state is CourseLessonsLoaded) {
              return _buildLessonsList(state.lessons);
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildLessonsList(List<Lesson> lessons) {
    if (lessons.isEmpty) {
      return _buildEmptyView('No lessons found for this course');
    }

    int completedCount = lessons.where((l) => l.isCompleted).length;
    int progressPercent = lessons.isEmpty
        ? 0
        : ((completedCount / lessons.length) * 100).round();

    return Column(
      children: [
        // Progress header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColor.withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Progress',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: progressPercent / 100,
                backgroundColor: Colors.white24,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 8,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '$completedCount of ${lessons.length} lessons completed',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    '$progressPercent%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Lessons list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: lessons.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final lesson = lessons[index];
              return LessonItem(
                lesson: lesson,
                isSelected: false,
                onTap: () => _selectLesson(lesson),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Error Loading Lessons',
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
              onPressed: _loadLessons,
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
              Icons.video_library_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
