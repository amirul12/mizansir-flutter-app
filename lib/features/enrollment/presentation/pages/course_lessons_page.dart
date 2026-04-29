// File: lib/features/enrollment/presentation/pages/course_lessons_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mizansir/features/enrollment/data/models/course_lession_model.dart'
    show CourseLessonModel, Lesson;
import '../bloc/enrollment_bloc.dart';
import '../bloc/enrollment_event.dart';
import '../bloc/enrollment_state.dart';
import '../../../../core/theme/app_colors.dart';

/// Course Lessons List Page - Beautiful, modern lessons interface for students.
///
/// Features:
/// - Stunning gradient progress header with circular progress
/// - Motivational progress tracking with stats
/// - Modern lesson cards with thumbnails and metadata
/// - Smooth animations and transitions
/// - Pull-to-refresh functionality
/// - Empty and error states with engaging visuals
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

  void _selectLesson(String lessonId) {
    // Navigate to single lesson player
    context.go('/my-courses/${widget.courseId}/lessons/$lessonId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            context.go('/home');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _loadLessons,
          ),
        ],
      ),
      body: BlocListener<EnrollmentBloc, EnrollmentState>(
        listener: (context, state) {
          if (state is LessonCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Lesson marked as complete! 🎉',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
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
              return _buildLessonsList(state.courseLessons);
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildLessonsList(CourseLessonModel courseLessonModel) {
    final modules = courseLessonModel.modules ?? [];
    final progress = courseLessonModel.progress;

    if (modules.isEmpty) {
      return _buildEmptyView('No lessons found for this course');
    }

    final totalLessons = progress?.totalLessons ?? 0;
    final completedLessons = progress?.completedLessons ?? 0;
    final progressPercent = progress?.progressPercentage?.toInt() ?? 0;
    final remainingLessons = totalLessons - completedLessons;

    // Calculate total duration from all lessons
    num totalTime = 0;
    for (var module in modules) {
      for (var lesson in module.lessons ?? []) {
        totalTime += (lesson?.durationMinutes ?? 0);
      }
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadLessons();
      },
      color: AppColors.primary,
      child: CustomScrollView(
        slivers: [
          // Progress Header
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryLight],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
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
                              'Your Progress',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _getMotivationalMessage(progressPercent),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Circular Progress
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 80,
                            height: 80,
                            child: CircularProgressIndicator(
                              value: progressPercent / 100,
                              strokeWidth: 8,
                              backgroundColor: Colors.white.withValues(
                                alpha: 0.2,
                              ),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            '$progressPercent%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LinearProgressIndicator(
                      value: progressPercent / 100,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                      minHeight: 12,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildProgressStat(
                          Icons.check_circle_outline,
                          '$completedLessons',
                          'Completed',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildProgressStat(
                          Icons.play_circle_outline,
                          '$remainingLessons',
                          'Remaining',
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildProgressStat(
                          Icons.schedule,
                          _formatDuration(totalTime.toInt()),
                          'Total Time',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Lessons List by Module
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, moduleIndex) {
                final module = modules[moduleIndex];
                final lessons = module.lessons ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (module.moduleName != null &&
                        module.moduleName!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Text(
                          module.moduleName!,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                        ),
                      ),
                    ...lessons.map(
                      (lesson) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildLessonCard(lesson),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              }, childCount: modules.length),
            ),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildLessonCard(Lesson lesson) {
    final isCompleted = lesson.isCompleted ?? false;
    final isPreview = lesson.isPreview ?? false;

    return GestureDetector(
      onTap: () => _selectLesson(lesson.id.toString()),
      child: Container(
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
          border: Border.all(
            color: isCompleted
                ? AppColors.success.withValues(alpha: 0.3)
                : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Thumbnail or Icon
            Container(
              width: 80,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: lesson.thumbnail != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        lesson.thumbnail!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            _buildLessonIcon(isCompleted, isPreview),
                      ),
                    )
                  : _buildLessonIcon(isCompleted, isPreview),
            ),
            const SizedBox(width: 16),
            // Lesson Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title ?? 'Untitled Lesson',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (lesson.durationMinutes != null) ...[
                        const Icon(
                          Icons.schedule,
                          size: 14,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${lesson.durationMinutes} min',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                      const SizedBox(width: 12),
                      if (isPreview)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'PREVIEW',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      if (isCompleted)
                        const Icon(
                          Icons.check_circle,
                          size: 16,
                          color: AppColors.success,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Icon(Icons.play_circle_outline, color: AppColors.primary, size: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonIcon(bool isCompleted, bool isPreview) {
    if (isCompleted) {
      return const Icon(Icons.check_circle, color: AppColors.success, size: 32);
    }
    if (isPreview) {
      return const Icon(Icons.visibility, color: AppColors.secondary, size: 32);
    }
    return const Icon(Icons.play_arrow, color: AppColors.primary, size: 32);
  }

  /// Build progress stat widget.
  Widget _buildProgressStat(IconData icon, String value, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 11,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Get motivational message based on progress.
  String _getMotivationalMessage(int progress) {
    if (progress == 0) return "Let's start your learning journey! 🚀";
    if (progress < 25) return "Great start! Keep the momentum going! 💪";
    if (progress < 50) return "You're making excellent progress! 🌟";
    if (progress < 75) return "More than halfway there! Keep it up! 🔥";
    if (progress < 100) return "Almost done! You're doing amazing! 🎯";
    return "Congratulations! Course completed! 🏆";
  }

  /// Format duration in minutes to hours and minutes.
  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0) {
      return '${hours}h ${mins}m';
    }
    return '${mins}m';
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _loadLessons,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.video_library_outlined,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Check back later for new lessons',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
