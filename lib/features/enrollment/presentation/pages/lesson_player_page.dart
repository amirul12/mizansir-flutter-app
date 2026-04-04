// File: lib/features/enrollment/presentation/pages/lesson_player_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/enrollment_bloc.dart';
import '../bloc/enrollment_event.dart';
import '../bloc/enrollment_state.dart';
import '../../domain/entities/lesson.dart';

/// Lesson Player Page - Full YouTube player with controls for a single lesson
class LessonPlayerPage extends StatefulWidget {
  final String courseId;
  final String lessonId;

  const LessonPlayerPage({
    super.key,
    required this.courseId,
    required this.lessonId,
  });

  @override
  State<LessonPlayerPage> createState() => _LessonPlayerPageState();
}

class _LessonPlayerPageState extends State<LessonPlayerPage> {
  Lesson? _currentLesson;
  Lesson? _nextLesson;
  Lesson? _previousLesson;
  YoutubePlayerController? _youtubeController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLesson();
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  void _loadLesson() {
    setState(() {
      _isLoading = true;
      _currentLesson = null;
      _youtubeController = null;
    });

    debugPrint('🔵 Loading lesson: courseId=${widget.courseId}, lessonId=${widget.lessonId}');

    context.read<EnrollmentBloc>().add(
      GetLessonDetailsEvent(
        courseId: widget.courseId,
        lessonId: widget.lessonId,
      ),
    );
  }

  void _initializePlayer(Lesson lesson) {
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
  }

  void _playNextLesson() {
    if (_nextLesson != null) {
      context.go('/my-courses/${widget.courseId}/lessons/${_nextLesson!.id}');
    }
  }

  void _playPreviousLesson() {
    if (_previousLesson != null) {
      context.go(
        '/my-courses/${widget.courseId}/lessons/${_previousLesson!.id}',
      );
    } else {
      // Go back to lessons list
      context.go('/my-courses/${widget.courseId}/lessons');
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

  void _goBackToLessons() {
    context.go('/my-courses/${widget.courseId}/lessons');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _goBackToLessons,
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
          }
        },
        child: BlocBuilder<EnrollmentBloc, EnrollmentState>(
          builder: (context, state) {
            debugPrint('🟢 State changed: ${state.runtimeType}');

            // Handle loading states
            if (state is EnrollmentLoading || state is LessonLoading || _isLoading) {
              debugPrint('⏳ Showing loading indicator');
              return const Center(child: CircularProgressIndicator());
            }

            // Handle lesson loaded
            if (state is LessonDetailsLoaded) {
              debugPrint('✅ Lesson details loaded: ${state.lesson.title}');

              // Only update if lesson changed
              if (_currentLesson?.id != state.lesson.id) {
                _currentLesson = state.lesson;
                _nextLesson = state.nextLesson;
                _previousLesson = state.previousLesson;
                _isLoading = false;
                _initializePlayer(_currentLesson!);
                debugPrint('🎬 Player initialized for: ${_currentLesson!.title}');
              }

              return _buildPlayer(context);
            }

            if (state is EnrollmentError) {
              return _buildErrorView(state.message);
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildPlayer(BuildContext context) {
    if (_currentLesson == null) {
      return _buildEmptyView('Lesson not found');
    }

    final authState = context.read<AuthBloc>().state;
    final studentEmail = authState is AuthAuthenticated
        ? authState.user.email
        : 'student@example.com';

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // YouTube Player (Top)
          Container(
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
                      // Student email watermark
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
                : SizedBox(
                    width: double.infinity,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.play_circle_outline,
                              size: 80,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No video available',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),

          // Lesson Details (Below Player)
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lesson title
                Text(
                  _currentLesson!.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                // Module/Description
                if (_currentLesson!.hasDescription) ...[
                  const SizedBox(height: 8),
                  Text(
                    _currentLesson!.description!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],

                const SizedBox(height: 20),

                // Duration and progress
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 20,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _currentLesson!.formattedDuration,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                          ),
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
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
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

                // Navigation buttons
                Row(
                  children: [
                    // Previous lesson button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _previousLesson != null
                            ? () {
                                if (_previousLesson != null) {
                                  context.go(
                                    '/my-courses/${widget.courseId}/lessons/${_previousLesson!.id}',
                                  );
                                }
                              }
                            : null,
                        icon: const Icon(Icons.skip_previous),
                        label: const Text('Previous'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Mark complete button
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

                    // Next lesson button
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _nextLesson != null ? _playNextLesson : null,
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

                // Navigation info
                if (_previousLesson != null || _nextLesson != null) ...[
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    'Navigation',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  if (_previousLesson != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_upward, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Previous: ${_previousLesson!.title}',
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_nextLesson != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.arrow_downward, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Next: ${_nextLesson!.title}',
                              style: Theme.of(context).textTheme.bodyMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),
                ],

                // Back to lessons list button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _goBackToLessons,
                    icon: const Icon(Icons.list),
                    label: const Text('Back to Lessons List'),
                  ),
                ),
              ],
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
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(
              'Error Loading Lesson',
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
              onPressed: () {
                context.go('/my-courses/${widget.courseId}/lessons');
              },
              icon: const Icon(Icons.list),
              label: const Text('Back to Lessons'),
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
