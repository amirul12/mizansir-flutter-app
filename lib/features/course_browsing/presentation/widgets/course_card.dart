// File: lib/features/course_browsing/presentation/widgets/course_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../domain/entities/course.dart';

/// Course Card Widget
class CourseCard extends StatelessWidget {
  final Course course;
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
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            _buildThumbnail(context),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category
                  if (course.hasCategory)
                    _buildCategoryChip(context),

                  const SizedBox(height: 8),

                  // Title
                  Text(
                    course.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Description
                  Text(
                    course.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  // Meta info row
                  _buildMetaInfo(context),

                  const SizedBox(height: 12),

                  // Price and enroll button row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      _buildPrice(context),

                      // Enroll button
                      if (onEnroll != null)
                        ElevatedButton(
                          onPressed: onEnroll,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Enroll'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 180,
          width: double.infinity,
          color: Colors.grey[300],
          child: course.thumbnail != null
              ? CachedNetworkImage(
                  imageUrl: course.thumbnail!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                  ),
                )
              : Center(
                  child: Icon(
                    Icons.school,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                ),
        ),
        // Level badge
        if (course.level != null)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                course.levelLabel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCategoryChip(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: (course.category?.color != null)
            ? Color(int.parse('0xFF${course.category!.color!.substring(1)}'))
            : Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        course.category!.name,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: (course.category?.color != null)
                  ? Colors.white
                  : Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  Widget _buildMetaInfo(BuildContext context) {
    return Row(
      children: [
        // Rating
        if (course.rating != null) ...[
          Icon(
            Icons.star,
            size: 16,
            color: Colors.amber,
          ),
          const SizedBox(width: 4),
          Text(
            course.rating!.toStringAsFixed(1),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(width: 8),
        ],

        // Students count
        Icon(
          Icons.people_outline,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Text(
          '${course.enrolledCount}',
          style: Theme.of(context).textTheme.bodySmall,
        ),

        const Spacer(),

        // Duration
        if (course.duration != null) ...[
          Icon(
            Icons.access_time,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 4),
          Text(
            course.duration!,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }

  Widget _buildPrice(BuildContext context) {
    return Text(
      course.displayPrice,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: course.isFree
                ? Colors.green
                : Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
