// File: lib/features/enrollment/presentation/pages/lesson_player_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/enrollment_bloc.dart';
import '../bloc/enrollment_event.dart';
import '../bloc/enrollment_state.dart';
import '../../domain/entities/lesson.dart';
import '../widgets/lesson_item.dart';

/// Lesson Player Page - Displays lesson content and video player
class LessonPlayerPage extends StatefulWidget {
  final String courseId;
  final String? lessonId;

  const LessonPlayerPage({super.key, required this.courseId, this.lessonId});

  @override
  State<LessonPlayerPage> createState() => _LessonPlayerPageState();
}

class _LessonPlayerPageState extends State<LessonPlayerPage> {
  Lesson? _currentLesson;
  List<Lesson> _lessons = [];
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  void _loadData() {
    context.read<EnrollmentBloc>().add(
      LoadCourseLessonsEvent(courseId: widget.courseId),
    );
  }

  void _selectLesson(Lesson lesson) {
    setState(() {
      _currentLesson = lesson;

      if (lesson.hasYoutubeVideo) {
        _youtubeController?.dispose();
        _youtubeController = YoutubePlayerController(
          initialVideoId: lesson.youtubeVideoId!,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            enableCaption: true,
            hideControls: false,
            controlsVisibleAtStart: true,
            forceHD: false,
            loop: false,
            isLive: false,
          ),
        );
      } else {
        _youtubeController?.dispose();
        _youtubeController = null;
      }
    });
  }

  void _playNextLesson() {
    if (_currentLesson != null && _lessons.isNotEmpty) {
      final currentIndex = _lessons.indexWhere(
        (l) => l.id == _currentLesson!.id,
      );
      if (currentIndex >= 0 && currentIndex < _lessons.length - 1) {
        _selectLesson(_lessons[currentIndex + 1]);
      }
    }
  }

  void _playPreviousLesson() {
    if (_currentLesson != null && _lessons.isNotEmpty) {
      final currentIndex = _lessons.indexWhere(
        (l) => l.id == _currentLesson!.id,
      );
      if (currentIndex > 0) {
        _selectLesson(_lessons[currentIndex - 1]);
      }
    }
  }

  void _markLessonComplete() {
    if (_currentLesson != null && !_currentLesson!.isCompleted) {
      context.read<EnrollmentBloc>().add(
        MarkLessonCompleteEvent(
          courseId: widget.courseId,
          lessonId: _currentLesson!.id,
          watchTimeSeconds: _currentLesson!.duration * 60,
          progressPercentage: 100,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson Player'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<EnrollmentBloc, EnrollmentState>(
        listener: (context, state) {
          if (state is LessonCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Lesson marked as complete!'),
                backgroundColor: Colors.green,
              ),
            );
            _loadData();
          }
        },
        child: BlocBuilder<EnrollmentBloc, EnrollmentState>(
          builder: (context, state) {
            if (state is EnrollmentLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is EnrollmentError) {
              return _buildErrorView(state.message);
            }

            if (state is CourseLessonsLoaded) {
              _lessons = state.lessons;
              if (_currentLesson == null && _lessons.isNotEmpty) {
                if (widget.lessonId != null) {
                  _currentLesson = _lessons.firstWhere(
                    (l) => l.id == widget.lessonId,
                    orElse: () => _lessons.first,
                  );
                } else {
                  _currentLesson = _lessons.firstWhere(
                    (l) => !l.isCompleted,
                    orElse: () => _lessons.first,
                  );
                }
              }
              return _buildContent(context);
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (_lessons.isEmpty) {
      return _buildEmptyView('No lessons found for this course');
    }

    if (_currentLesson == null) {
      return _buildEmptyView('Lesson not found');
    }

    return Column(
      children: [
        _buildVideoPlayer(context),
        Expanded(child: _buildLessonInfo(context)),
      ],
    );
  }

  Widget _buildVideoPlayer(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final studentEmail = authState is AuthAuthenticated
        ? authState.user.email
        : 'student@example.com';

    return Container(
      color: Colors.black,
      child: _currentLesson!.hasYoutubeVideo && _youtubeController != null
          ? Stack(
              children: [
                Center(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: YoutubePlayer(
                      controller: _youtubeController!,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.amber,
                      progressColors: const ProgressBarColors(
                        playedColor: Colors.amber,
                        handleColor: Colors.amberAccent,
                        backgroundColor: Colors.white24,
                      ),
                      onEnded: (_) {
                        if (_currentLesson!.progressPercentage == null ||
                            _currentLesson!.progressPercentage! < 100) {
                          _markLessonComplete();
                          Future.delayed(const Duration(seconds: 2), () {
                            if (mounted) {
                              _playNextLesson();
                            }
                          });
                        }
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      studentEmail,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            )
          : _currentLesson!.hasVideo
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.play_circle_outline, size: 80, color: Colors.white),
                const SizedBox(height: 16),
                Text(
                  'Video Player',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  _currentLesson!.videoUrl!,
                  style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.article_outlined, size: 80, color: Colors.white),
                const SizedBox(height: 16),
                Text(
                  'Lesson Content',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
    );
  }

  Widget _buildLessonInfo(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _currentLesson!.title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),

            if (_currentLesson!.hasDescription) ...[
              const SizedBox(height: 8),
              Text(
                _currentLesson!.description!,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ],

            const SizedBox(height: 16),

            Row(
              children: [
                Icon(Icons.access_time, size: 20, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  _currentLesson!.formattedDuration,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                if (_currentLesson!.progressPercentage != null)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LinearProgressIndicator(
                          value: _currentLesson!.progressPercentage! / 100,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _currentLesson!.isCompleted
                                ? Colors.green
                                : Colors.amber,
                          ),
                          minHeight: 4,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${_currentLesson!.progressPercentage}% complete',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: _currentLesson!.isCompleted
                                    ? Colors.green
                                    : Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _playPreviousLesson,
                    icon: const Icon(Icons.skip_previous),
                    label: const Text('Previous'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                if (!_currentLesson!.isCompleted)
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      onPressed: _markLessonComplete,
                      icon: const Icon(Icons.check, size: 18),
                      label: const Text('Mark Complete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  )
                else
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, size: 18, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Completed',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _playNextLesson,
                    icon: const Icon(Icons.skip_next),
                    label: const Text('Next'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            Text(
              'Course Lessons',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '${_lessons.length} lessons',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),

            const SizedBox(height: 16),

            Container(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _lessons.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final lesson = _lessons[index];
                  return LessonItem(
                    lesson: lesson,
                    isSelected: _currentLesson?.id == lesson.id,
                    onTap: () => _selectLesson(lesson),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Error Loading Lessons',
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
              Icons.video_library_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
