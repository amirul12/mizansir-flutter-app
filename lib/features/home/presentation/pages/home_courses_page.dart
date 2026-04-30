import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mizansir/features/course_browsing/data/models/course_list_response.dart';
import 'package:mizansir/features/course_browsing/presentation/bloc/course_bloc.dart';
import 'package:mizansir/features/course_browsing/presentation/bloc/course_event.dart';
import 'package:mizansir/features/course_browsing/presentation/bloc/course_state.dart';
import 'package:mizansir/core/theme/app_colors.dart';

class HomeCoursesPage extends StatefulWidget {
  const HomeCoursesPage({super.key});

  @override
  State<HomeCoursesPage> createState() => _HomeCoursesPageState();
}

class _HomeCoursesPageState extends State<HomeCoursesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseBloc>().add(const LoadCoursesEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseBloc, CourseState>(
      buildWhen: (previous, current) =>
          current is CourseLoading ||
          current is CoursesLoaded ||
          current is CourseError ||
          current is CourseEmpty ||
          current is FeaturedCoursesLoaded,
      builder: (context, state) {
        if (state is CourseLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is CourseError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  const Text(
                    'Oops!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(state.message, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.read<CourseBloc>().add(
                      const LoadCoursesEvent(),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is CourseEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.school_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No courses available',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final courses = state is CoursesLoaded
            ? state.courses
            : state is FeaturedCoursesLoaded
            ? state.courses
            : null;

        if (courses != null && courses.items!.isNotEmpty) {
          return RefreshIndicator(
            onRefresh: () async =>
                context.read<CourseBloc>().add(const LoadCoursesEvent()),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: courses.items!.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) =>
                  _buildCourseCard(context, courses.items![index]),
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildCourseCard(BuildContext context, Item course) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          onTap: () => context.go('/courses/${course.id}'),
          borderRadius: BorderRadius.circular(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    child: _buildThumbnailImage(context, course),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    right: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (course.category != null)
                          _buildModernBadge(
                            course.category!.name!,
                            AppColors.primary,
                          ),
                        _buildBadge(
                          course.level!.toUpperCase(),
                          Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.title!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 18,
                          color: AppColors.starActive,
                        ),
                        const SizedBox(width: 4),

                        Text(
                          '(${course.reviewCount})',
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          course.formattedPrice!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => context.go('/courses/${course.id}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: course.isEnrolled == true
                              ? AppColors.secondary
                              : AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          course.isEnrolled == true
                              ? 'Continue Learning'
                              : 'Enroll Now',
                          style: const TextStyle(fontWeight: FontWeight.bold),
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

  Widget _buildThumbnailImage(BuildContext context, dynamic course) {
    if (course.thumbnail != null && course.thumbnail!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: course.thumbnail!,
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            Container(height: 180, color: Colors.grey.shade100),
        errorWidget: (context, url, error) => Container(
          height: 180,
          color: Colors.grey.shade200,
          child: const Icon(Icons.broken_image),
        ),
      );
    }
    return Container(
      height: 180,
      color: AppColors.primary,
      child: const Icon(Icons.school, color: Colors.white, size: 48),
    );
  }

  Widget _buildModernBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
