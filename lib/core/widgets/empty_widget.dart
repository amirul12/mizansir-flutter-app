// File: lib/core/widgets/empty_widget.dart
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Empty state widget
class EmptyWidget extends StatelessWidget {
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;

  const EmptyWidget({
    required this.message,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.inbox,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty courses widget
class EmptyCoursesWidget extends StatelessWidget {
  final VoidCallback? onBrowse;

  const EmptyCoursesWidget({
    this.onBrowse,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyWidget(
      message: 'No courses found',
      icon: Icons.menu_book,
      actionLabel: onBrowse != null ? 'Browse Courses' : null,
      onAction: onBrowse,
    );
  }
}

/// Empty enrollments widget
class EmptyEnrollmentsWidget extends StatelessWidget {
  final VoidCallback? onEnroll;

  const EmptyEnrollmentsWidget({
    this.onEnroll,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return EmptyWidget(
      message: 'You haven\'t enrolled in any courses yet',
      icon: Icons.school,
      actionLabel: onEnroll != null ? 'Browse Courses' : null,
      onAction: onEnroll,
    );
  }
}

/// Empty lessons widget
class EmptyLessonsWidget extends StatelessWidget {
  const EmptyLessonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyWidget(
      message: 'No lessons available',
      icon: Icons.play_circle_outline,
    );
  }
}
