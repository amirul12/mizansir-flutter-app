import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mizansir/features/course_browsing/data/models/course_model.dart';
import '../../../../core/theme/app_colors.dart';

/// Course Card Widget - Modern and informative
class CourseCard extends StatelessWidget {
  final CourseModel course;
  final VoidCallback? onTap;
  final VoidCallback? onEnroll;

  const CourseCard({
    super.key,
    required this.course,
    this.onTap,
    this.onEnroll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Thumbnail Image with Overlay Badges
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: _buildThumbnailImage(context),
                  ),

                  // Category & Level Badges
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (course.category != null &&
                            course.category!.name != null)
                          _buildModernBadge(
                            course.category!.name!,
                            _getCategoryColor(course.category!.name!),
                          ),
                        _buildLevelBadge(course.levelLabel),
                      ],
                    ),
                  ),

                  // Price badge overlay
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        course.displayPrice,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: course.isFree
                              ? AppColors.secondary
                              : AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // 2. Course Info Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Rating & Enrollments Row
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: AppColors.starActive,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          course.rating?.toStringAsFixed(1) ?? '0.0',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${course.reviewCount})',
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.people_outline_rounded,
                          size: 16,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${course.enrolledCount}',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Title
                    Text(
                      course.title ?? 'Untitled Course',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        height: 1.3,
                        fontSize: 18,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Instructor
                    if (course.instructor != null)
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              size: 14,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            course.instructor!,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 16),
                    Divider(color: Colors.grey.shade100, height: 1),
                    const SizedBox(height: 16),

                    // Meta Info: Lessons & Duration
                    Row(
                      children: [
                        _buildMetaItem(
                          Icons.play_circle_fill_rounded,
                          '${course.totalLessonsCount} Lessons',
                          Colors.blue.shade600,
                        ),
                        const SizedBox(width: 16),
                        _buildMetaItem(
                          Icons.schedule_rounded,
                          course.formattedDuration ?? 'N/A',
                          Colors.orange.shade600,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // CTA Button - Primary Action
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: onTap ?? onEnroll,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: course.isEnrolled == true
                              ? AppColors.secondary
                              : AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              course.isEnrolled == true
                                  ? 'Continue Learning'
                                  : 'Enroll Now',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Icon(
                              course.isEnrolled == true
                                  ? Icons.play_circle_fill_rounded
                                  : Icons.arrow_forward_rounded,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnailImage(BuildContext context) {
    if (course.thumbnail != null && course.thumbnail!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: course.thumbnail!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 200,
          color: AppColors.primary.withOpacity(0.05),
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (context, url, error) => _buildPlaceholderThumbnail(),
      );
    }
    return _buildPlaceholderThumbnail();
  }

  Widget _buildPlaceholderThumbnail() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary.withOpacity(0.8), AppColors.primary],
        ),
      ),
      child: const Icon(Icons.school, size: 64, color: Colors.white24),
    );
  }

  Widget _buildModernBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildLevelBadge(String level) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        level.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMetaItem(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'math':
      case 'mathematics':
        return AppColors.categoryMath;
      case 'physics':
        return AppColors.categoryPhysics;
      case 'chemistry':
        return AppColors.categoryChemistry;
      case 'biology':
        return AppColors.categoryBiology;
      case 'english':
        return AppColors.categoryEnglish;
      default:
        return AppColors.primary;
    }
  }
}
