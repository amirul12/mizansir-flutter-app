// File: lib/features/course_browsing/presentation/widgets/lesson_preview_item.dart
import 'package:flutter/material.dart';
import '../../domain/entities/lesson_preview.dart';

/// Lesson Preview Item Widget
class LessonPreviewItem extends StatelessWidget {
  final LessonPreview lesson;
  final VoidCallback? onTap;
  final bool isPlaying;

  const LessonPreviewItem({
    super.key,
    required this.lesson,
    this.onTap,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isPlaying ? 4 : 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isPlaying
            ? BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              )
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Play icon or thumbnail
              _buildPlayIcon(context),

              const SizedBox(width: 16),

              // Lesson info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      lesson.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight:
                                isPlaying ? FontWeight.bold : FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Meta info row
                    Row(
                      children: [
                        // Duration
                        Icon(
                          Icons.access_time,
                          size: 14,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          lesson.formattedDuration,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),

                        const SizedBox(width: 16),

                        // Order/Episode number
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Episode ${lesson.order}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),

                        const Spacer(),

                        // Free badge
                        if (lesson.isFree)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: Colors.green,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              'FREE',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Arrow icon
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayIcon(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: isPlaying
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
        size: 32,
        color: isPlaying
            ? Theme.of(context).primaryColor
            : Colors.grey[600],
      ),
    );
  }
}
