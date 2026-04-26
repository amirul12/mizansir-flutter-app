import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../enrollment/data/models/my_course_model.dart';
import '../../../enrollment/presentation/bloc/enrollment_bloc.dart';
import '../../../enrollment/presentation/bloc/enrollment_event.dart';
import '../../../enrollment/presentation/bloc/enrollment_state.dart';
import '../bloc/home_shell_cubit.dart';
import '../../../../core/theme/app_colors.dart';

class HomeMyLearningPage extends StatefulWidget {
  const HomeMyLearningPage({super.key});

  @override
  State<HomeMyLearningPage> createState() => _HomeMyLearningPageState();
}

class _HomeMyLearningPageState extends State<HomeMyLearningPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EnrollmentBloc>().add(const LoadMyCoursesEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EnrollmentBloc, EnrollmentState>(
      builder: (context, state) {
        if (state is EnrollmentLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is EnrollmentError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text('Oops!', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(state.message, style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.read<EnrollmentBloc>().add(const LoadMyCoursesEvent()),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is EnrollmentEmpty) {
          return _buildEmptyView(context, state.message);
        }

        if (state is MyCoursesLoaded) {
          if (state.courses.isEmpty) {
            return _buildEmptyView(context, 'No enrolled courses yet');
          }

          return RefreshIndicator(
            onRefresh: () async => context.read<EnrollmentBloc>().add(const LoadMyCoursesEvent()),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.courses.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final course = state.courses[index];
                return _buildEnrolledCourseCard(context, course as MyCourseModel);
              },
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildEmptyView(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.school_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(message, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.grey[600]), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            const Text('Start learning by enrolling in courses', style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.read<HomeShellCubit>().goToCourses(),
              icon: const Icon(Icons.explore),
              label: const Text('Browse Courses'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnrolledCourseCard(BuildContext context, MyCourseModel course) {
    final courseInfo = course.course;
    final curriculum = course.curriculum;
    final progress = curriculum?.progressPercentage!.clamp(0, 100).toDouble() ?? 0.0;
    final progressColor = _getProgressColor(progress);

    void handleNavigation() {
      if (curriculum?.nextLesson != null) {
        context.go('/my-courses/${courseInfo?.id}/lessons/${curriculum?.nextLesson!.id}');
      } else {
        context.go('/my-courses/${courseInfo?.id}/lessons');
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: handleNavigation,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCourseThumbnail(context, courseInfo!.thumbnail),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: Text(courseInfo.title!, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700))),
                              const SizedBox(width: 8),
                              _buildProgressBadge(progressColor, progress),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (courseInfo.description!.isNotEmpty)
                            Text(courseInfo.description!, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8, runSpacing: 8,
                            children: [
                              _buildMiniStat(Icons.play_circle_outline, '${curriculum!.totalLessons} Lessons', Colors.blue),
                              _buildMiniStat(Icons.check_circle_outline, '${curriculum.completedLessons} Done', Colors.green),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildProgressBar(context, progress, progressColor),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.go('/my-courses/${courseInfo.id}/lessons'),
                        child: const Text('View Lessons'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: handleNavigation,
                        child: Text(curriculum.nextLesson != null ? 'Continue' : 'Start'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCourseThumbnail(BuildContext context, String? thumbnail) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: SizedBox(
        width: 80, height: 80,
        child: thumbnail != null && thumbnail.isNotEmpty
            ? CachedNetworkImage(imageUrl: thumbnail, fit: BoxFit.cover)
            :  Container(color: AppColors.primary, child: Icon(Icons.school, color: Colors.white)),
      ),
    );
  }

  Widget _buildProgressBadge(Color color, double progress) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: Text('${progress.toInt()}%', style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildMiniStat(IconData icon, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildProgressBar(BuildContext context, double progress, Color color) {
    return Column(
      children: [
        LinearProgressIndicator(value: progress / 100, minHeight: 8, borderRadius: BorderRadius.circular(4), backgroundColor: Colors.grey.shade200, valueColor: AlwaysStoppedAnimation(color)),
      ],
    );
  }

  Color _getProgressColor(double progress) {
    if (progress >= 75) return Colors.green;
    if (progress >= 50) return Colors.orange;
    return AppColors.primary;
  }
}
