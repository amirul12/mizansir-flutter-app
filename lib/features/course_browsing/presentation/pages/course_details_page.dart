// File: lib/features/course_browsing/presentation/pages/course_details_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';
import '../widgets/lesson_preview_item.dart';

/// Course Details Page
class CourseDetailsPage extends StatefulWidget {
  final String courseId;

  const CourseDetailsPage({
    super.key,
    required this.courseId,
  });

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  @override
  void initState() {
    super.initState();
    // Load course details and preview lessons
    context.read<CourseBloc>().add(
          LoadCourseDetailsEvent(courseId: widget.courseId),
        );
    context.read<CourseBloc>().add(
          LoadPreviewLessonsEvent(courseId: widget.courseId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CourseBloc, CourseState>(
        builder: (context, state) {
          if (state is CourseLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CourseError) {
            return _buildErrorView(state.message);
          }

          if (state is CourseDetailsLoaded) {
            return _buildCourseDetails(context, state.course);
          }

          // Initial state
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildCourseDetails(BuildContext context, dynamic course) {
    return CustomScrollView(
      slivers: [
        // App bar with thumbnail
        SliverAppBar(
          expandedHeight: 250,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              course.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 4,
                    color: Colors.black45,
                  ),
                ],
              ),
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Thumbnail image
                course.thumbnail != null
                    ? CachedNetworkImage(
                        imageUrl: course.thumbnail!,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(
                            Icons.school,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.school,
                          size: 64,
                          color: Colors.grey,
                        ),
                      ),
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Course content
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category and level badges
                Wrap(
                  spacing: 8,
                  children: [
                    if (course.hasCategory)
                      Chip(
                        label: Text(course.category.name),
                        backgroundColor: course.category.color != null
                            ? Color(int.parse(
                                '0xFF${course.category.color!.substring(1)}'))
                            : null,
                        labelStyle: TextStyle(
                          color: course.category.color != null
                              ? Colors.white
                              : null,
                        ),
                      ),
                    if (course.level != null)
                      Chip(
                        label: Text(course.levelLabel),
                        avatar: const Icon(Icons.stars, size: 18),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                // Price and enrollment info
                Row(
                  children: [
                    // Price
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: course.isFree
                            ? Colors.green.withValues(alpha: 0.1)
                            : Theme.of(context)
                                .primaryColor
                                .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: course.isFree ? Colors.green : Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        course.formattedPrice,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: course.isFree
                                  ? Colors.green
                                  : Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Students count
                    Expanded(
                      child: _buildStatCard(
                        context,
                        icon: Icons.people,
                        label: 'Students',
                        value: '${course.enrolledCount}',
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Lessons count
                    Expanded(
                      child: _buildStatCard(
                        context,
                        icon: Icons.play_circle,
                        label: 'Lessons',
                        value: '${course.totalLessons}',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Rating
                if (course.rating != null)
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 8),
                      Text(
                        course.rating!.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),

                const SizedBox(height: 24),

                // Description
                Text(
                  'About This Course',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  course.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                      ),
                ),

                const SizedBox(height: 24),

                // Duration
                if (course.duration != null)
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Duration: ${course.duration}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),

                const SizedBox(height: 24),

                // Preview lessons section
                _buildPreviewLessonsSection(),

                const SizedBox(height: 24),

                // Enroll button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to enrollment - will implement later
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Enrollment feature coming soon!'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      course.isFree ? 'Start Learning' : 'Enroll Now',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewLessonsSection() {
    return BlocBuilder<CourseBloc, CourseState>(
      buildWhen: (previous, current) =>
          current is PreviewLessonsLoaded || current is CourseLoading,
      builder: (context, state) {
        if (state is CourseLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (state is PreviewLessonsLoaded) {
          if (state.lessons.isEmpty) {
            return const SizedBox();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Preview Lessons',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextBadge(
                    count: state.lessons.length,
                    label: 'free previews',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...state.lessons.map((lesson) {
                return LessonPreviewItem(
                  lesson: lesson,
                  onTap: () {
                    // Play lesson preview - will implement later
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Playing: ${lesson.title}'),
                      ),
                    );
                  },
                );
              }),
            ],
          );
        }

        return const SizedBox();
      },
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
              'Error Loading Course',
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
                context.read<CourseBloc>().add(
                      LoadCourseDetailsEvent(courseId: widget.courseId),
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
}

/// Simple badge widget for lesson count
class TextBadge extends StatelessWidget {
  final int count;
  final String label;

  const TextBadge({
    super.key,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$count $label',
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
