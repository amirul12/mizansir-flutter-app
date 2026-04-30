// File: lib/features/course_browsing/presentation/pages/course_details_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import 'package:mizansir/features/enrollment/data/models/enrollments_create_model.dart'
    show EnrollmentsCreateModel;
import '../bloc/course_bloc.dart';
import '../bloc/course_event.dart';
import '../bloc/course_state.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/di/injection_container.dart';
import '../../../enrollment/presentation/bloc/enrollment_bloc.dart';
import '../../../enrollment/presentation/bloc/enrollment_event.dart';
import '../../../enrollment/presentation/bloc/enrollment_state.dart';

/// Course Details Page - Modern, visually rich course information
class CourseDetailsPage extends StatefulWidget {
  final String courseId;

  const CourseDetailsPage({super.key, required this.courseId});

  @override
  State<CourseDetailsPage> createState() => _CourseDetailsPageState();
}

class _CourseDetailsPageState extends State<CourseDetailsPage> {
  @override
  void initState() {
    super.initState();
    _loadCourseData();
  }

  void _loadCourseData() {
    context.read<CourseBloc>().add(
      LoadCourseDetailsEvent(courseId: widget.courseId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<EnrollmentBloc>(),
      child: PopScope(
        canPop: context.canPop(),
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            // If we can't pop, navigate to courses
            context.go('/home?tab=courses');
          }
        },
        child: Scaffold(
          body: BlocListener<CourseBloc, CourseState>(
            listener: (context, state) {
              if (state is CourseError) {
                final message = state.message.toLowerCase();
                if (message.contains('enrollment') ||
                    message.contains('enroll') ||
                    message.contains('required')) {
                  _showEnrollmentRequiredSnackbar(state.message);
                }
              }
            },
            child: BlocBuilder<CourseBloc, CourseState>(
              builder: (context, state) {
                if (state is CourseLoading) {
                  return _buildLoadingState();
                }

                if (state is CourseError) {
                  final message = state.message.toLowerCase();
                  if (message.contains('enrollment') ||
                      message.contains('enroll') ||
                      message.contains('required')) {
                    return _buildEnrollmentRequiredState(state);
                  }
                  return _buildErrorState(state.message);
                }

                if (state is CourseDetailsLoaded) {
                  return _buildCourseDetails(state.course);
                }

                return _buildLoadingState();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.1),
            Colors.white,
          ],
        ),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline,
                  size: 48,
                  color: Colors.red[400],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Error Loading Course',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _loadCourseData,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home?tab=courses');
                  }
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnrollmentRequiredState(CourseState state) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.lock_outline,
                  size: 56,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Enrollment Required',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  state is CourseError ? state.message : 'Enrollment required',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Enrollment feature coming soon!'),
                      showCloseIcon: true,
                    ),
                  );
                },
                icon: const Icon(Icons.how_to_reg),
                label: const Text('Enroll Now'),
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go('/home?tab=courses');
                  }
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseDetails(dynamic course) {
    return CustomScrollView(
      slivers: [
        // Custom app bar with image
        SliverAppBar(
          expandedHeight: 320,
          pinned: true,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 20),
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/home?tab=courses');
                }
              },
              tooltip: 'Back',
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Share feature coming soon!'),
                      showCloseIcon: true,
                    ),
                  );
                },
                tooltip: 'Share',
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            titlePadding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 60,
            ),
            title: Text(
              course.title ?? 'Course Details',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                shadows: [
                  Shadow(
                    offset: Offset(0, 2),
                    blurRadius: 8,
                    color: Colors.black87,
                  ),
                ],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            background: Stack(
              fit: StackFit.expand,
              children: [_buildCourseImage(course), _buildGradientOverlay()],
            ),
          ),
        ),

        // Main content
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Quick info chips
                _buildQuickInfo(course),

                const SizedBox(height: 24),

                // Price & Enrollment CTA
                _buildPriceSection(course),

                const SizedBox(height: 24),

                // Enroll Button
                _buildEnrollSection(course),

                const SizedBox(height: 24),

                // Course Stats
                _buildStatsSection(course),

                const SizedBox(height: 24),

                // Description
                _buildDescriptionSection(course),

                const SizedBox(height: 24),

                // Curriculum
                if (course.hasCurriculum && course.modules != null)
                  _buildCurriculumSection(course),

                const SizedBox(height: 24),

                // Instructor & Category
                _buildMetaInfoSection(course),

                const SizedBox(height: 100), // Space for bottom CTA
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCourseImage(dynamic course) {
    String? imageUrl = course.thumbnail;
    if (imageUrl != null && !imageUrl.startsWith('http')) {
      final baseUrl = ApiConstants.baseUrl;
      imageUrl = imageUrl.startsWith('/')
          ? '$baseUrl$imageUrl'
          : '$baseUrl/$imageUrl';
    }

    if (imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor.withValues(alpha: 0.3),
                Theme.of(context).primaryColor.withValues(alpha: 0.1),
              ],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
        errorWidget: (context, url, error) => _buildPlaceholder(course),
      );
    }

    return _buildPlaceholder(course);
  }

  Widget _buildPlaceholder(dynamic course) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.school_outlined,
              size: 80,
              color: Colors.white.withValues(alpha: 0.8),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                course.title ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.1),
            Colors.black.withValues(alpha: 0.7),
          ],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }

  Widget _buildQuickInfo(dynamic course) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (course.level != null)
            _buildInfoChip(
              icon: Icons.signal_cellular_alt,
              label: course.levelLabel,
              color: Colors.blue,
            ),
          if (course.hasCategory)
            _buildInfoChip(
              icon: Icons.category,
              label: course.category!.name!,
              color: Colors.purple,
            ),
          if (course.language != null)
            _buildInfoChip(
              icon: Icons.language,
              label: course.language!,
              color: Colors.green,
            ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(dynamic course) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: course.isFree
              ? [
                  Colors.green.withValues(alpha: 0.1),
                  Colors.green.withValues(alpha: 0.05),
                ]
              : [
                  Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  Theme.of(context).primaryColor.withValues(alpha: 0.05),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: course.isFree
              ? Colors.green.withValues(alpha: 0.3)
              : Theme.of(context).primaryColor.withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Course Price',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  course.displayPrice,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: course.isFree
                        ? Colors.green
                        : Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: course.isFree
                  ? Colors.green
                  : Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              course.isFree ? 'FREE' : 'PREMIUM',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(dynamic course) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: Icons.play_circle_outline,
              label: 'Lessons',
              value: '${course.totalLessonsCount}',
              color: Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          if (course.modulesCount != null)
            Expanded(
              child: _buildStatCard(
                icon: Icons.folder_outlined,
                label: 'Modules',
                value: '${course.modulesCount}',
                color: Colors.orange,
              ),
            ),
          if (course.formattedDuration != null) ...[
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.access_time,
                label: 'Duration',
                value: course.formattedDuration!,
                color: Colors.purple,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(dynamic course) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.info_outline,
                  size: 20,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'About This Course',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            course.description ?? '',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurriculumSection(dynamic course) {
    final modules = course.modules ?? [];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.menu_book,
                  size: 20,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Course Curriculum',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: Text(
              '${course.totalLessonsCount} lessons in ${course.totalLessons} modules',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ),
          const SizedBox(height: 16),
          ...modules.asMap().entries.map((entry) {
            final index = entry.key;
            final module = entry.value;
            final lessons = module['lessons'] as List<dynamic>? ?? [];
            return _buildModuleCard(module, lessons, index + 1);
          }),
        ],
      ),
    );
  }

  Widget _buildModuleCard(
    Map<String, dynamic> module,
    List<dynamic> lessons,
    int moduleNumber,
  ) {
    final moduleName =
        module['module_name'] as String? ?? 'Module $moduleNumber';
    final lessonsCount = module['lessons_count'] as int? ?? lessons.length;
    final totalMinutes = module['total_duration_minutes'] as int?;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1), width: 1),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          expansionTileTheme: ExpansionTileThemeData(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.7),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '$moduleNumber',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          title: Text(
            moduleName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Row(
            children: [
              const Icon(
                Icons.play_circle_outline,
                size: 14,
                color: Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                '$lessonsCount lessons',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
              if (totalMinutes != null && totalMinutes > 0) ...[
                const SizedBox(width: 12),
                const Icon(Icons.access_time, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  '${totalMinutes}m',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                ),
              ],
            ],
          ),
          children: [
            if (lessons.isEmpty)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'No lessons in this module',
                  style: TextStyle(color: Colors.grey),
                ),
              )
            else
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Column(
                  children: lessons.map((lesson) {
                    final lessonMap = lesson as Map<String, dynamic>;
                    return _buildLessonItem(lessonMap);
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonItem(Map<String, dynamic> lesson) {
    final title = lesson['title'] as String? ?? 'Untitled Lesson';
    final durationMinutes = lesson['duration_minutes'] as int?;
    final isPreview = lesson['is_preview'] as bool? ?? false;
    final contentType = lesson['content_type'] as String? ?? 'video';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPreview
              ? Colors.green.withValues(alpha: 0.2)
              : Colors.grey.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: contentType == 'video'
                  ? Colors.blue.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              contentType == 'video'
                  ? Icons.play_arrow
                  : Icons.article_outlined,
              color: contentType == 'video' ? Colors.blue : Colors.orange,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                if (durationMinutes != null && durationMinutes > 0) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$durationMinutes min',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (isPreview)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.green.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: const Text(
                'FREE',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMetaInfoSection(dynamic course) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (course.instructor != null) ...[
            _buildMetaItem(
              icon: Icons.person,
              label: 'Instructor',
              value: course.instructor!,
            ),
            const SizedBox(height: 16),
          ],
          if (course.rating != null) ...[
            _buildMetaItem(
              icon: Icons.star,
              label: 'Rating',
              value:
                  '${course.rating!.toStringAsFixed(1)} (${course.reviewCount} reviews)',
              valueColor: Colors.amber,
            ),
            const SizedBox(height: 16),
          ],
          // _buildMetaItem(
          //   icon: Icons.people,
          //   label: 'Students',
          //   value: '${course.enrolledCount} enrolled',
          // ),
        ],
      ),
    );
  }

  Widget _buildMetaItem({
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showEnrollmentRequiredSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Enroll',
          textColor: Colors.white,
          onPressed: () {
            _showEnrollmentDialog();
          },
        ),
        showCloseIcon: true,
      ),
    );
  }

  Widget _buildEnrollSection(dynamic course) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: BlocListener<EnrollmentBloc, EnrollmentState>(
        listener: (context, state) {
          if (state is EnrollmentCreated) {
            _showEnrollmentSuccessDialog(state.enrollmentData);
          } else if (state is AlreadyEnrolled) {
            _showAlreadyEnrolledDialog(state.message);
          } else if (state is EnrollmentError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                showCloseIcon: true,
              ),
            );
          }
        },
        child: FilledButton.icon(
          onPressed: _showEnrollmentDialog,
          icon: const Icon(Icons.how_to_reg),
          label: Text(course.isFree ? 'Enroll for Free' : 'Enroll Now'),
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  void _showEnrollmentDialog() {
    final courseState = context.read<CourseBloc>().state;
    if (courseState is! CourseDetailsLoaded) return;

    final course = courseState.course;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Enroll in Course'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Course: ${course.title ?? 'Untitled'}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Price: ${course.displayPrice}',
              style: TextStyle(
                color: course.isFree
                    ? Colors.green
                    : Theme.of(context).primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (!course.isFree) ...[
              const SizedBox(height: 16),
              const Text('Payment Method:'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: 'bkash',
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'bkash', child: Text('bKash')),
                  DropdownMenuItem(value: 'nagad', child: Text('Nagad')),
                  DropdownMenuItem(value: 'rocket', child: Text('Rocket')),
                  DropdownMenuItem(value: 'bank', child: Text('Bank Transfer')),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Transaction ID (optional)',
                  border: OutlineInputBorder(),
                  helperText: 'Enter your transaction ID after payment',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Payment Notes (optional)',
                  border: OutlineInputBorder(),
                  helperText: 'Your phone number or any notes',
                ),
                maxLines: 2,
              ),
            ] else ...[
              const SizedBox(height: 16),
              const Text('This course is free! No payment required.'),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _submitEnrollment(course.id ?? '', course.isFree);
            },
            child: Text(course.isFree ? 'Enroll Now' : 'Submit Enrollment'),
          ),
        ],
      ),
    );
  }

  void _submitEnrollment(String courseId, bool isFree) {
    context.read<EnrollmentBloc>().add(
      CreateEnrollmentEvent(
        courseId: courseId,
        paymentMethod: isFree ? "bkash" : 'bkash',
        paymentNotes: isFree ? "Sent from app Free" : 'Sent from app',
        transactionId: isFree
            ? 'TXN${DateTime.now().millisecondsSinceEpoch}'
            : 'TXN${DateTime.now().millisecondsSinceEpoch}',
      ),
    );
  }

  void _showEnrollmentSuccessDialog(EnrollmentsCreateModel enrollmentData) {
    final message = 'Enrollment submitted successfully';
    final nextSteps = enrollmentData.nextSteps;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check_circle, size: 48, color: Colors.green),
        ),
        title: const Text('Enrollment Submitted!'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message),
              const SizedBox(height: 16),
              if (nextSteps != null) ...[
                const Text(
                  'Payment Instructions:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (nextSteps.paymentInstructions != null) ...[
                  Text(nextSteps.paymentInstructions!.title ?? ''),
                  const SizedBox(height: 8),
                  ...(nextSteps.paymentInstructions!.steps ?? []).map(
                    (step) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('• '),
                          Expanded(child: Text(step.toString())),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.go('/my-courses');
            },
            child: const Text('View My Courses'),
          ),
        ],
      ),
    );
  }

  void _showAlreadyEnrolledDialog(String message) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.info_outline, size: 48, color: Colors.blue),
        ),
        title: const Text('Already Enrolled'),
        content: Text(message),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.go('/my-courses');
            },
            child: const Text('View My Courses'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
