// File: lib/features/enrollment/presentation/pages/course_progress_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/enrollment_bloc.dart';
import '../bloc/enrollment_event.dart';
import '../bloc/enrollment_state.dart';
import '../../domain/entities/enrolled_course.dart';
import '../../domain/entities/course_progress.dart';

/// Course Progress Page - Shows detailed progress for an enrolled course
class CourseProgressPage extends StatefulWidget {
  final String courseId;

  const CourseProgressPage({
    super.key,
    required this.courseId,
  });

  @override
  State<CourseProgressPage> createState() => _CourseProgressPageState();
}

class _CourseProgressPageState extends State<CourseProgressPage> {
  EnrolledCourse? _course;
  CourseProgress? _progress;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Load course details and progress
    context.read<EnrollmentBloc>().add(
          LoadEnrolledCourseDetailsEvent(courseId: widget.courseId),
        );
    context.read<EnrollmentBloc>().add(
          LoadCourseProgressEvent(courseId: widget.courseId),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Progress'),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<EnrollmentBloc, EnrollmentState>(
        builder: (context, state) {
          if (state is EnrollmentLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EnrollmentError) {
            return _buildErrorView(state.message);
          }

          if (state is EnrolledCourseDetailsLoaded) {
            _course = state.course;
            return _buildContent(context);
          }

          if (state is CourseProgressLoaded) {
            _progress = state.progress;
            if (_course != null) {
              return _buildContent(context);
            }
          }

          // Initial state
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: _course != null && _course!.isActive
          ? FloatingActionButton.extended(
              onPressed: () {
                context.go('/my-courses/${widget.courseId}/lessons');
              },
              icon: const Icon(Icons.play_arrow),
              label: const Text('Continue Learning'),
            )
          : null,
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_course == null) {
      return _buildEmptyView('Course not found');
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Course header
          _buildCourseHeader(context),

          const SizedBox(height: 24),

          // Progress overview
          _buildProgressOverview(context),

          const SizedBox(height: 24),

          // Enrollment details
          if (_course!.enrollment != null) ...[
            _buildEnrollmentDetails(context),
            const SizedBox(height: 24),
          ],

          // Lessons progress
          if (_progress != null) _buildLessonsProgress(context),

          const SizedBox(height: 80), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildCourseHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status badge
        _buildStatusBadge(context),
        const SizedBox(height: 12),

        // Title
        Text(
          _course!.title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),

        const SizedBox(height: 8),

        // Description
        Text(
          _course!.description,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),

        const SizedBox(height: 16),

        // Thumbnail
        if (_course!.thumbnail != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              _course!.thumbnail!,
              width: double.infinity,
              height: 180,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported, size: 48),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color color;
    String label;

    switch (_course!.status) {
      case 'active':
        color = Colors.green;
        label = 'Active';
        break;
      case 'completed':
        color = Colors.blue;
        label = 'Completed';
        break;
      case 'expired':
        color = Colors.red;
        label = 'Expired';
        break;
      case 'pending':
        color = Colors.orange;
        label = 'Pending';
        break;
      default:
        color = Colors.grey;
        label = _course!.status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildProgressOverview(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress Overview',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Progress bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_course!.completedLessons} of ${_course!.totalLessons} lessons completed',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      '${_course!.progressPercentage.toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: _course!.isCompleted
                                ? Colors.green
                                : Theme.of(context).primaryColor,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: _course!.progressPercentage / 100,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _course!.isCompleted
                        ? Colors.green
                        : Theme.of(context).primaryColor,
                  ),
                  minHeight: 8,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Stats row
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    context,
                    icon: Icons.play_circle,
                    label: 'Completed',
                    value: '${_course!.completedLessons}/${_course!.totalLessons}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    context,
                    icon: Icons.access_time,
                    label: 'Watch Time',
                    value: _course!.formattedWatchTime,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
          Icon(icon, color: Theme.of(context).primaryColor),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentDetails(BuildContext context) {
    final enrollment = _course!.enrollment!;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enrollment Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Enrollment date
            _buildDetailRow(
              context,
              icon: Icons.event,
              label: 'Enrolled',
              value: '${enrollment.enrolledAt.day}/${enrollment.enrolledAt.month}/${enrollment.enrolledAt.year}',
            ),

            const SizedBox(height: 12),

            // Expiry date
            if (_course!.expiresAt != null)
              _buildDetailRow(
                context,
                icon: Icons.access_time,
                label: 'Expires',
                value: '${_course!.expiresAt!.day}/${_course!.expiresAt!.month}/${_course!.expiresAt!.year}',
              ),

            // Payment status
            _buildDetailRow(
              context,
              icon: Icons.payment,
              label: 'Payment Status',
              value: enrollment.statusLabel,
            ),

            if (enrollment.amount != null) ...[
              const SizedBox(height: 12),
              _buildDetailRow(
                context,
                icon: Icons.attach_money,
                label: 'Amount',
                value: '\$${enrollment.amount!.toStringAsFixed(2)}',
              ),
            ],

            if (enrollment.paymentMethod != null) ...[
              const SizedBox(height: 12),
              _buildDetailRow(
                context,
                icon: Icons.credit_card,
                label: 'Payment Method',
                value: enrollment.paymentMethod!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }

  Widget _buildLessonsProgress(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lessons Progress',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),

            // Lesson progress items
            ...(_progress!.lessonProgress.map((lessonProgress) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildLessonProgressItem(context, lessonProgress),
              );
            }).toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonProgressItem(
    BuildContext context,
    lessonProgress,
  ) {
    final isCompleted = lessonProgress.isCompleted;
    final progress = lessonProgress.progressPercentage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 20,
                  color: isCompleted ? Colors.green : Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Text(
                  'Lesson ${lessonProgress.lessonId}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                      ),
                ),
              ],
            ),
            Text(
              '$progress%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isCompleted ? Colors.green : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress / 100,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(
            isCompleted ? Colors.green : Theme.of(context).primaryColor,
          ),
          minHeight: 4,
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
              onPressed: _loadData,
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
              Icons.school_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
