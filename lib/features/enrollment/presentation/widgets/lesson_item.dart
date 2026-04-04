// File: lib/features/enrollment/presentation/widgets/lesson_item.dart
import 'package:flutter/material.dart';
import '../../domain/entities/lesson.dart';

/// Lesson Item Widget
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
        color: isSelected
            ? Theme.of(context).primaryColor.withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: _buildLeadingIcon(context),
        title: Text(
          lesson.title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
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
                if (lesson.progressPercentage != null) ...[
                  const SizedBox(width: 12),
                  Text(
                    '${lesson.progressPercentage}% complete',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: lesson.isCompleted
                              ? Colors.green
                              : Colors.grey[600],
                        ),
                  ),
                ],
              ],
            ),
            if (lesson.isCompleted) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 14,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Completed',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: onTap != null
            ? Icon(
                Icons.play_circle_outline,
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[600],
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildLeadingIcon(BuildContext context) {
    if (lesson.isCompleted) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 24,
        ),
      );
    }

    if (isSelected) {
      return Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.play_arrow,
          color: Colors.white,
          size: 24,
        ),
      );
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '${lesson.order}',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.grey[700],
              fontWeight: FontWeight.bold,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
