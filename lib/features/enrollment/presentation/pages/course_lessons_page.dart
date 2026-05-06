// File: lib/features/enrollment/presentation/pages/course_lessons_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mizansir/features/enrollment/data/models/course_lession_model.dart'
    show CourseLessonModel, Lesson, Course, Enrollment, Navigation;
import '../bloc/enrollment_bloc.dart';
import '../bloc/enrollment_event.dart';
import '../bloc/enrollment_state.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => context.go('/home'),
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: _loadLessons,
            ),
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
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 3,
                ),
              );
            }

            if (state is EnrollmentError) {
              return _buildErrorView(state.message);
            }

            if (state is CourseLessonsLoaded) {
              return _buildLessonsList(state.courseLessons);
            }

            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 3,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLessonsList(CourseLessonModel courseLessonModel) {
    final course = courseLessonModel.course;
    final enrollment = courseLessonModel.enrollment;
    final modules = courseLessonModel.modules ?? [];
    final progress = courseLessonModel.progress;
    final navigation = courseLessonModel.navigation;

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
          // Course Header
          if (course != null)
            SliverToBoxAdapter(child: _buildCourseHeader(course, enrollment)),

          // Progress Header
          SliverToBoxAdapter(
            child: _buildProgressHeader(
              progressPercent,
              completedLessons,
              remainingLessons,
              totalTime.toInt(),
            ),
          ),

          // Navigation Controls (if available)
          if (navigation != null)
            SliverToBoxAdapter(child: _buildNavigationControls(navigation)),

          // Lessons List by Module
          if (modules.isEmpty)
            SliverFillRemaining(
              child: _buildEmptyView('No lessons found for this course'),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, moduleIndex) {
                  final module = modules[moduleIndex];
                  final lessons = module.lessons ?? [];

                  if (lessons.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (module.moduleName != null &&
                          module.moduleName!.isNotEmpty)
                        _buildModuleHeader(module.moduleName!, lessons.length),
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

  /// Build course header with title, thumbnail, and enrollment info.
  Widget _buildCourseHeader(Course course, Enrollment? enrollment) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Course Thumbnail
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.1),
                  AppColors.secondary.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: course.thumbnail != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      course.thumbnail!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Icon(
                        Icons.school_rounded,
                        color: AppColors.primary,
                        size: 36,
                      ),
                    ),
                  )
                : Icon(
                    Icons.school_rounded,
                    color: AppColors.primary,
                    size: 36,
                  ),
          ),
          const SizedBox(width: 14),
          // Course Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  course.title ?? 'Course',
                  style: AppTextStyles.h5.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                if (enrollment != null)
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildEnrollmentChip(
                        enrollment.status ?? 'Unknown',
                        enrollment.isActive ?? false,
                      ),
                      if (enrollment.expiresAt != null)
                        _buildExpiryChip(enrollment.expiresAt!),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build progress header with circular progress and stats.
  Widget _buildProgressHeader(
    int progressPercent,
    int completedLessons,
    int remainingLessons,
    int totalTime,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.primaryGradient,
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
                      style: AppTextStyles.h5.copyWith(
                        color: AppColors.textWhite,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _getMotivationalMessage(progressPercent),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textWhite.withValues(alpha: 0.9),
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
                    width: 72,
                    height: 72,
                    child: CircularProgressIndicator(
                      value: progressPercent / 100,
                      strokeWidth: 7,
                      backgroundColor: AppColors.textWhite.withValues(
                        alpha: 0.2,
                      ),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.textWhite,
                      ),
                    ),
                  ),
                  Text(
                    '$progressPercent%',
                    style: AppTextStyles.h5.copyWith(
                      color: AppColors.textWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progressPercent / 100,
              backgroundColor: AppColors.textWhite.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.textWhite,
              ),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 16),
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
                  _formatDuration(totalTime),
                  'Total Time',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build module header with name and lesson count.
  Widget _buildModuleHeader(String moduleName, int lessonCount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.folder_open_rounded, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              moduleName,
              style: AppTextStyles.h6.copyWith(color: AppColors.primary),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$lessonCount',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textWhite,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Build navigation controls for previous/next lesson.
  Widget _buildNavigationControls(Navigation navigation) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        children: [
          if (navigation.previousLesson != null)
            Expanded(
              child: _buildNavigationButton(
                Icons.arrow_back_ios_rounded,
                navigation.previousLesson!.title ?? 'Previous Lesson',
                () => _selectLesson(navigation.previousLesson!.id.toString()),
                isNext: false,
              ),
            ),
          if (navigation.previousLesson != null &&
              navigation.nextLesson != null)
            const SizedBox(width: 12),
          if (navigation.nextLesson != null)
            Expanded(
              child: _buildNavigationButton(
                Icons.arrow_forward_ios_rounded,
                navigation.nextLesson!.title ?? 'Next Lesson',
                () => _selectLesson(navigation.nextLesson!.id.toString()),
                isNext: true,
              ),
            ),
        ],
      ),
    );
  }

  /// Build navigation button.
  Widget _buildNavigationButton(
    IconData icon,
    String title,
    VoidCallback onTap, {
    required bool isNext,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border, width: 1),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (!isNext) ...[
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Previous', style: AppTextStyles.overline),
                    Text(
                      title,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ] else ...[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Next', style: AppTextStyles.overline),
                    Text(
                      title,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(icon, color: AppColors.primary, size: 20),
            ],
          ],
        ),
      ),
    );
  }

  /// Build enrollment status chip.
  Widget _buildEnrollmentChip(String status, bool isActive) {
    final color = isActive ? AppColors.success : AppColors.warning;
    final backgroundColor = isActive
        ? AppColors.successLight
        : AppColors.warningLight;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isActive ? Icons.check_circle : Icons.info_outline,
            color: color,
            size: 14,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              status.toUpperCase(),
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  /// Build expiry date chip.
  Widget _buildExpiryChip(DateTime expiresAt) {
    final now = DateTime.now();
    final daysUntilExpiry = expiresAt.difference(now).inDays;
    final isExpiringSoon = daysUntilExpiry <= 7 && daysUntilExpiry >= 0;
    final isExpired = daysUntilExpiry < 0;

    final color = isExpired
        ? AppColors.error
        : isExpiringSoon
        ? AppColors.warning
        : AppColors.textSecondary;
    final backgroundColor = isExpired
        ? AppColors.errorLight
        : isExpiringSoon
        ? AppColors.warningLight
        : AppColors.disabledBackground;

    final String expiryText;
    if (isExpired) {
      expiryText = 'Expired';
    } else if (isExpiringSoon) {
      expiryText = 'Expires in $daysUntilExpiry days';
    } else if (daysUntilExpiry < 30) {
      expiryText = 'Expires ${DateFormat('MMM d').format(expiresAt)}';
    } else {
      expiryText = 'Expires ${DateFormat('MMM d, y').format(expiresAt)}';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isExpired ? Icons.cancel : Icons.schedule,
            color: color,
            size: 14,
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              expiryText,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
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
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(
            color: isCompleted
                ? AppColors.success.withValues(alpha: 0.3)
                : Colors.transparent,
            width: isCompleted ? 2 : 0,
          ),
        ),
        child: Row(
          children: [
            // Thumbnail or Icon
            Container(
              width: 90,
              height: 64,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.primary.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  if (lesson.thumbnail != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        lesson.thumbnail!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) => Center(
                          child: _buildLessonIcon(isCompleted, isPreview),
                        ),
                      ),
                    )
                  else
                    Center(child: _buildLessonIcon(isCompleted, isPreview)),
                  // Duration Badge
                  if (lesson.durationMinutes != null)
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.videoOverlay,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          _formatDuration(lesson.durationMinutes!),
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textWhite,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 14),
            // Lesson Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title ?? 'Untitled Lesson',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (lesson.description != null && lesson.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      lesson.description!,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      if (isPreview)
                        _buildStatusChip(
                          'PREVIEW',
                          AppColors.secondary,
                          AppColors.secondaryLight,
                          Icons.visibility,
                        ),
                      if (isCompleted) ...[
                        _buildStatusChip(
                          'COMPLETED',
                          AppColors.success,
                          AppColors.successLight,
                          Icons.check_circle,
                        ),
                        if (lesson.completedAt != null)
                          Text(
                            DateFormat('MMM d').format(lesson.completedAt!),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textTertiary,
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: AppColors.primary,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build status chip (preview/completed).
  Widget _buildStatusChip(
    String label,
    Color color,
    Color backgroundColor,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 10),
          const SizedBox(width: 3),
          Text(
            label,
            style: AppTextStyles.overline.copyWith(
              color: color,
              fontSize: 8,
              letterSpacing: 0.5,
            ),
          ),
        ],
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
    return const Icon(
      Icons.play_arrow_rounded,
      color: AppColors.primary,
      size: 32,
    );
  }

  /// Build progress stat widget.
  Widget _buildProgressStat(IconData icon, String value, String label) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.textWhite.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.textWhite, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textWhite.withValues(alpha: 0.8),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
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
            Text('Info', style: AppTextStyles.h4, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
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
                foregroundColor: AppColors.textWhite,
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
            Text(message, style: AppTextStyles.h4, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            Text(
              'Check back later for new lessons',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
