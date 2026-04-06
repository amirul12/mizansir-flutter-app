// File: lib/features/enrollment/presentation/widgets/lesson_item.dart
import 'package:flutter/material.dart';
import '../../domain/entities/lesson.dart';
import '../../../../core/theme/app_colors.dart';

/// Modern Lesson Item Widget - Beautiful card design for lesson list.
///
/// Features:
/// - Gradient card backgrounds for completed lessons
/// - Thumbnail support with placeholder gradients
/// - Progress indicators with smooth animations
/// - Status badges (Completed, In Progress, Not Started)
/// - Duration and video type indicators
/// - Smooth touch feedback and hover states
class LessonItem extends StatelessWidget {
  final Lesson lesson;
  final bool isSelected;
  final VoidCallback? onTap;

  const LessonItem({
    super.key,
    required this.lesson,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Thumbnail or Status Icon
                _buildLeadingWidget(context),
                const SizedBox(width: 16),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Status Badge
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lesson.title,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _buildStatusBadge(),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Description
                      if (lesson.hasDescription && lesson.description != lesson.title)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            lesson.description!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      // Metadata Row
                      Row(
                        children: [
                          // Video Type Indicator
                          if (lesson.hasYoutubeVideo) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.errorLight,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.play_circle_filled,
                                    size: 14,
                                    color: AppColors.error,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Video',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.error,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],

                          // Duration
                          Icon(
                            Icons.schedule,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            lesson.formattedDuration,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                          ),

                          // Progress
                          if (lesson.progressPercentage != null && !lesson.isCompleted) ...[
                            const SizedBox(width: 12),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: lesson.progressPercentage! / 100,
                                  backgroundColor: AppColors.progressBackground,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    lesson.progressPercentage! >= 75
                                        ? AppColors.success
                                        : AppColors.primary,
                                  ),
                                  minHeight: 4,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${lesson.progressPercentage}%',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),

                // Play Button
                if (onTap != null)
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: lesson.isCompleted
                          ? AppColors.success
                          : AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      lesson.isCompleted ? Icons.replay : Icons.play_arrow_rounded,
                      color: lesson.isCompleted ? Colors.white : AppColors.primary,
                      size: 24,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build status badge widget.
  Widget _buildStatusBadge() {
    if (lesson.isCompleted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.successLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              size: 12,
              color: AppColors.success,
            ),
            const SizedBox(width: 4),
            Text(
              'Done',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.success,
              ),
            ),
          ],
        ),
      );
    }

    if (lesson.progressPercentage != null && lesson.progressPercentage! > 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'In Progress',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.textTertiary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'New',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }

  /// Build leading widget with thumbnail or icon.
  Widget _buildLeadingWidget(BuildContext context) {
    if (lesson.isCompleted) {
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.success,
              AppColors.secondaryLight,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.check_rounded,
          color: Colors.white,
          size: 32,
        ),
      );
    }

    if (lesson.hasThumbnail) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          lesson.thumbnailUrl!,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildDefaultThumbnail(context);
          },
        ),
      );
    }

    return _buildDefaultThumbnail(context);
  }

  /// Build default thumbnail with gradient.
  Widget _buildDefaultThumbnail(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.primaryGradient.map((c) => c.withValues(alpha: 0.15)).toList(),
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          '${lesson.order}',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
