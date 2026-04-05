// File: lib/features/enrollment/presentation/pages/student_lesson_player_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/enrollment_bloc.dart';
import '../bloc/enrollment_event.dart';
import '../bloc/enrollment_state.dart';
import '../../domain/entities/lesson.dart';
import '../../../../core/services/screen_security_service.dart';

/// Student Lesson Player - Dedicated YouTube video player for students
class StudentLessonPlayerPage extends StatefulWidget {
  final String courseId;
  final String lessonId;

  const StudentLessonPlayerPage({
    super.key,
    required this.courseId,
    required this.lessonId,
  });

  @override
  State<StudentLessonPlayerPage> createState() => _StudentLessonPlayerPageState();
}

class _StudentLessonPlayerPageState extends State<StudentLessonPlayerPage> {
  Lesson? _currentLesson;
  Lesson? _nextLesson;
  YoutubePlayerController? _youtubeController;
  bool _isPlayerReady = false;
  bool _isFullScreen = false;
  final ScreenSecurityService _screenSecurityService = ScreenSecurityService();

  @override
  void initState() {
    super.initState();
    // Prevent screenshots and screen recording
    _enableScreenSecurity();
    // Set landscape orientation for better video experience
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
    ]);
    _loadLesson();
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    // Disable screen security
    _disableScreenSecurity();
    // Reset orientation
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  /// Enable screen security to prevent screenshots and screen recording
  Future<void> _enableScreenSecurity() async {
    try {
      await _screenSecurityService.enableSecurity();
      debugPrint('✅ Screen security enabled - screenshots and recording prevented');
    } catch (e) {
      debugPrint('⚠️ Failed to enable screen security: $e');
    }
  }

  /// Disable screen security when leaving the page
  Future<void> _disableScreenSecurity() async {
    try {
      await _screenSecurityService.disableSecurity();
      debugPrint('✅ Screen security disabled - screenshots allowed again');
    } catch (e) {
      debugPrint('⚠️ Failed to disable screen security: $e');
    }
  }

  void _loadLesson() {
    debugPrint('🎬 Loading student lesson: ${widget.lessonId}');
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
          forceHD: true, // HD quality for students
          loop: false,
          isLive: false,
        ),
      );

      _youtubeController!.addListener(() {
        if (_youtubeController!.value.isFullScreen != _isFullScreen) {
          setState(() {
            _isFullScreen = _youtubeController!.value.isFullScreen;
          });
        }
      });

      _isPlayerReady = true;
      debugPrint('✅ YouTube player ready: ${lesson.youtubeVideoId}');
    } else {
      _isPlayerReady = false;
    }
  }

  void _playNextLesson() {
    if (_nextLesson != null) {
      context.go(
        '/my-courses/${widget.courseId}/lessons/${_nextLesson!.id}',
      );
    } else {
      // No more lessons, go back to list
      context.go('/my-courses/${widget.courseId}/lessons');
    }
  }

  void _toggleFullscreen() {
    // Navigate back (students can use device native fullscreen)
    context.go('/my-courses/${widget.courseId}/lessons');
  }

  void _markAsWatched() {
    if (_currentLesson != null && !_currentLesson!.isCompleted) {
      context.read<EnrollmentBloc>().add(
            MarkLessonCompleteEvent(
              courseId: widget.courseId,
              lessonId: _currentLesson!.id,
              watchTimeSeconds: _currentLesson!.duration * 60,
              progressPercentage: 100,
            ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lesson marked as complete!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<EnrollmentBloc, EnrollmentState>(
        listener: (context, state) {
          if (state is LessonCompleted) {
            // Show brief completion message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✓ Completed!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
              ),
            );
          }
        },
        child: BlocBuilder<EnrollmentBloc, EnrollmentState>(
          builder: (context, state) {
            if (state is EnrollmentLoading || state is LessonLoading) {
              return _buildLoadingView();
            }

            if (state is LessonDetailsLoaded) {
              if (_currentLesson?.id != state.lesson.id) {
                _currentLesson = state.lesson;
                _nextLesson = state.nextLesson;
                _initializePlayer(_currentLesson!);
              }
              return _buildPlayer(context);
            }

            if (state is EnrollmentError) {
              return _buildErrorView(state.message);
            }

            return _buildLoadingView();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'Loading lesson...',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayer(BuildContext context) {
    if (_currentLesson == null) {
      return _buildErrorView('Lesson not found');
    }

    final authState = context.read<AuthBloc>().state;
    final studentEmail = authState is AuthAuthenticated
        ? authState.user.email
        : 'student@example.com';

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar - Only show when NOT in fullscreen
            if (!_isFullScreen)
              Container(
                color: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    // Back button
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                      onPressed: _toggleFullscreen,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                    ),
                    const SizedBox(width: 8),
                    // Lesson title
                    Expanded(
                      child: Text(
                        _currentLesson!.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Mark complete icon
                    if (!_currentLesson!.isCompleted)
                      IconButton(
                        icon: const Icon(Icons.check_circle_outline, color: Colors.white70, size: 24),
                        onPressed: _markAsWatched,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                        tooltip: 'Mark as watched',
                      )
                    else
                      const Icon(Icons.check_circle, color: Colors.green, size: 24),
                  ],
                ),
              ),

            // YouTube Player (Main Content)
            Expanded(
              child: _currentLesson!.hasYoutubeVideo && _youtubeController != null
                  ? Stack(
                      children: [
                        Center(
                          child: YoutubePlayer(
                            controller: _youtubeController!,
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Colors.red,
                            progressColors: const ProgressBarColors(
                              playedColor: Colors.red,
                              handleColor: Colors.redAccent,
                              backgroundColor: Colors.white24,
                            ),
                            onEnded: (_) {
                              // Auto-mark as complete
                              if (_currentLesson!.progressPercentage == null ||
                                  _currentLesson!.progressPercentage! < 100) {
                                _markAsWatched();
                                // Auto-play next lesson after delay
                                Future.delayed(const Duration(seconds: 3), () {
                                  if (mounted) {
                                    _playNextLesson();
                                  }
                                });
                              }
                            },
                          ),
                        ),

                        // Student watermark (top-right corner) - Only when NOT in fullscreen
                        if (!_isFullScreen)
                          Positioned(
                            top: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    color: Colors.white70,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    studentEmail,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    )
                  : Container(
                      color: Colors.black,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.video_library_outlined,
                              size: 64,
                              color: Colors.white54,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No video available',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton.icon(
                              onPressed: () => context.go('/my-courses/${widget.courseId}/lessons'),
                              icon: const Icon(Icons.list),
                              label: const Text('Back to Lessons'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorView(String message) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error Loading Lesson',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.go('/my-courses/${widget.courseId}/lessons'),
                icon: const Icon(Icons.list),
                label: const Text('Back to Lessons'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
