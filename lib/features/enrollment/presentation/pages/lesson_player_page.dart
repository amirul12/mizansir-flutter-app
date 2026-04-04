// File: lib/features/enrollment/presentation/pages/lesson_player_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../bloc/enrollment_bloc.dart';
import '../bloc/enrollment_event.dart';
import '../bloc/enrollment_state.dart';
import '../../domain/entities/lesson.dart';
import '../widgets/lesson_item.dart';

/// Lesson Player Page - Displays lesson content and video player
class LessonPlayerPage extends StatefulWidget {
  final String courseId;
  final String? lessonId;

  const LessonPlayerPage({
    super.key,
    required this.courseId,
    this.lessonId,
  });

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
    // Load lessons for this course
    context.read<EnrollmentBloc>().add(
          LoadCourseLessonsEvent(courseId: widget.courseId),
        );
  }

  void _selectLesson(Lesson lesson) {
    setState(() {
      _currentLesson = lesson;

      // Initialize YouTube player if lesson has YouTube video
      if (lesson.hasYoutubeVideo) {
        _youtubeController?.dispose();
        _youtubeController = YoutubePlayerController(
          initialVideoId: lesson.youtubeVideoId!,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            enableCaption: true,
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
              watchTimeSeconds: _currentLesson!.duration * 60, // Assuming watched full lesson
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
      ),
      body: BlocListener<EnrollmentBloc, EnrollmentState>(
        listener: (context, state) {
          if (state is LessonCompleted) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Lesson marked as complete!'),
                backgroundColor: Colors.green,
              ),
            );
            // Reload lessons to get updated state
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
                // Select first lesson or specified lesson
                if (widget.lessonId != null) {
                  _currentLesson = _lessons.firstWhere(
                    (l) => l.id == widget.lessonId,
                    orElse: () => _lessons.first,
                  );
                } else {
                  // Find first incomplete lesson, or first lesson
                  _currentLesson = _lessons.firstWhere(
                    (l) => !l.isCompleted,
                    orElse: () => _lessons.first,
                  );
                }
              }
              return _buildContent(context);
            }

            // Initial state
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
        // Video player area
        Expanded(
          flex: 3,
          child: _buildVideoPlayer(context),
        ),

        // Lesson list
        Expanded(
          flex: 2,
          child: _buildLessonsList(context),
        ),
      ],
    );
  }

  Widget _buildVideoPlayer(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          // Video player or content placeholder
          Center(
            child: _currentLesson!.hasYoutubeVideo && _youtubeController != null
                ? YoutubePlayer(
                    controller: _youtubeController!,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.amber,
                    progressColors: const ProgressBarColors(
                      playedColor: Colors.amber,
                      handleColor: Colors.amberAccent,
                    ),
                    onEnded: (_) {
                      // Auto-play next lesson when video ends
                      if (_currentLesson!.progressPercentage == null ||
                          _currentLesson!.progressPercentage! < 100) {
                        _markLessonComplete();
                      }
                    },
                  )
                : _currentLesson!.hasVideo
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_circle_outline,
                            size: 80,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Video Player',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _currentLesson!.videoUrl!,
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.article_outlined,
                            size: 80,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Lesson Content',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
          ),

          // Top controls
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Lesson title overlay
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _currentLesson!.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              children: [
                // Progress bar
                if (_currentLesson!.progressPercentage != null)
                  Column(
                    children: [
                      LinearProgressIndicator(
                        value: _currentLesson!.progressPercentage! / 100,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.green,
                        ),
                        minHeight: 4,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),

                // Control buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Previous lesson
                    IconButton(
                      icon: const Icon(Icons.skip_previous, color: Colors.white),
                      iconSize: 32,
                      onPressed: _playPreviousLesson,
                    ),

                    // Mark complete button
                    if (!_currentLesson!.isCompleted)
                      ElevatedButton.icon(
                        onPressed: _markLessonComplete,
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('Mark Complete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
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

                    // Next lesson
                    IconButton(
                      icon: const Icon(Icons.skip_next, color: Colors.white),
                      iconSize: 32,
                      onPressed: _playNextLesson,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonsList(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Course Lessons',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${_lessons.length} lessons',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),

          // Lessons list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 16),
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
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
