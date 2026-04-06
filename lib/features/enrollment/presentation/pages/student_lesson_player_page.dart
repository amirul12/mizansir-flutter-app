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

/// YouTube-style student lesson player page.
///
/// Features:
/// - YouTube video playback with HD quality
/// - Playlist sidebar (right on desktop, bottom on mobile)
/// - Auto-mark lesson as complete when 90% watched
/// - Screen capture prevention for content protection
/// - Student email watermark for security
/// - Auto-play next lesson
/// - Responsive layout (desktop/mobile)
/// - Proper fullscreen landscape mode
/// - Instant lesson switching (like YouTube)
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
  List<Lesson> _allLessons = [];
  YoutubePlayerController? _youtubeController;

  bool _isFullScreen = false;
  bool _isCompletedTriggered = false;
  bool _isPlayerReady = false; // Track if player is ready

  final ScreenSecurityService _screenSecurityService = ScreenSecurityService();
  final ScrollController _playlistController = ScrollController();

  @override
  void initState() {
    super.initState();
    _enableScreenSecurity();
    _loadLesson();
  }

  @override
  void didUpdateWidget(StudentLessonPlayerPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Detect when lessonId changes and reload immediately
    if (oldWidget.lessonId != widget.lessonId) {
      _loadLesson();
    }
  }

  @override
  void dispose() {
    // Remove listener before disposing controller (like official example)
    if (_youtubeController != null) {
      _youtubeController!.removeListener(_playerListener);
      _youtubeController!.dispose();
      _youtubeController = null;
    }
    _playlistController.dispose();
    _disableScreenSecurity();
    _resetOrientation();
    super.dispose();
  }

  Future<void> _enableScreenSecurity() async {
    try {
      await _screenSecurityService.enableSecurity();
    } catch (_) {}
  }

  Future<void> _disableScreenSecurity() async {
    try {
      await _screenSecurityService.disableSecurity();
    } catch (_) {}
  }

  void _resetOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _loadLesson() {
    // Load current lesson details
    context.read<EnrollmentBloc>().add(
          GetLessonDetailsEvent(
            courseId: widget.courseId,
            lessonId: widget.lessonId,
          ),
        );

    // Load all lessons for playlist (only if not already loaded)
    if (_allLessons.isEmpty) {
      context.read<EnrollmentBloc>().add(
            LoadCourseLessonsEvent(courseId: widget.courseId),
          );
    }
  }

  void _initializePlayer(Lesson lesson) {
    if (!lesson.hasYoutubeVideo || lesson.youtubeVideoId == null) {
      return;
    }

    // If controller doesn't exist, create it
    if (_youtubeController == null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: lesson.youtubeVideoId!,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          enableCaption: true,
          hideControls: false,
          controlsVisibleAtStart: true,
          forceHD: true,
          loop: false,
          isLive: false,
          disableDragSeek: false,
        ),
      )..addListener(_playerListener);
      return;
    }

    // If video ID is the same, no need to reload
    if (_youtubeController!.initialVideoId == lesson.youtubeVideoId) {
      _isCompletedTriggered = false;
      return;
    }

    // Load the new video using the same controller (like the official example)
    _isCompletedTriggered = false;
    _youtubeController!.load(lesson.youtubeVideoId!);
  }

  void _playerListener() {
    // Only update state if player is ready and widget is mounted
    // Like the official example: if (_isPlayerReady && mounted && !_controller.value.isFullScreen)
    if (!_isPlayerReady || !mounted || _youtubeController == null) return;

    final controller = _youtubeController!;

    // Track fullscreen state changes
    if (controller.value.isFullScreen != _isFullScreen) {
      if (!mounted) return; // Check again before setState
      setState(() {
        _isFullScreen = controller.value.isFullScreen;
      });

      // Handle orientation changes for fullscreen
      if (controller.value.isFullScreen) {
        // Enter landscape mode
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        // Allow all orientations
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      }
    }

    // Auto mark complete after 90% watched
    final total = controller.metadata.duration.inSeconds;
    final position = controller.value.position.inSeconds;

    if (!_isCompletedTriggered &&
        total > 0 &&
        position > 0 &&
        (position / total) >= 0.90 &&
        _currentLesson != null &&
        !_currentLesson!.isCompleted) {
      _isCompletedTriggered = true;
      _markAsWatched(showMessage: false);
    }
  }

  void _playLesson(Lesson lesson) {
    if (lesson.id == _currentLesson?.id) return;

    // Reset player ready state when loading new video
    _isPlayerReady = false;
    _isCompletedTriggered = false;

    // Instant UI update (like YouTube)
    setState(() {
      _currentLesson = lesson;
    });

    // Initialize player immediately (will reuse controller and load new video)
    _initializePlayer(lesson);

    // Load lesson details from API (robust approach)
    context.read<EnrollmentBloc>().add(
          GetLessonDetailsEvent(
            courseId: widget.courseId,
            lessonId: lesson.id,
          ),
        );

    // Update route
    context.go('/my-courses/${widget.courseId}/lessons/${lesson.id}');

    // Scroll to current lesson in playlist
    final index = _allLessons.indexWhere((l) => l.id == lesson.id);
    if (index >= 0) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_playlistController.hasClients) {
          final offset = index * 120.0; // Approximate item height
          _playlistController.animateTo(
            offset,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  void _playNextLesson() {
    if (_allLessons.isEmpty) return;

    final currentIndex = _allLessons.indexWhere((l) => l.id == _currentLesson?.id);
    if (currentIndex >= 0 && currentIndex < _allLessons.length - 1) {
      _playLesson(_allLessons[currentIndex + 1]);
    }
  }

  void _markAsWatched({bool showMessage = true}) {
    if (_currentLesson == null || _currentLesson!.isCompleted) return;

    // Safely get watch time from controller
    int watchedSeconds;
    try {
      watchedSeconds = _youtubeController?.value.position.inSeconds ??
          (_currentLesson!.duration * 60);
    } catch (_) {
      // If controller is not ready, use lesson duration
      watchedSeconds = _currentLesson!.duration * 60;
    }

    context.read<EnrollmentBloc>().add(
          MarkLessonCompleteEvent(
            courseId: widget.courseId,
            lessonId: _currentLesson!.id,
            watchTimeSeconds: watchedSeconds,
            progressPercentage: 100,
          ),
        );

    if (showMessage && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lesson marked as complete'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  String _formatDurationMinutes(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0) {
      return '${hours}h ${mins}m';
    }
    return '$mins min';
  }

  bool _isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width > 800;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<EnrollmentBloc, EnrollmentState>(
        listener: (context, state) {
          if (state is LessonCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✓ Lesson completed'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 1),
              ),
            );
          }
        },
        child: BlocBuilder<EnrollmentBloc, EnrollmentState>(
          builder: (context, state) {
            // Handle different states without resetting UI
            if (state is LessonDetailsLoaded) {
              // Only update if different lesson
              if (_currentLesson?.id != state.lesson.id) {
                _currentLesson = state.lesson;
                _initializePlayer(_currentLesson!);
              }
            } else if (state is CourseLessonsLoaded) {
              // Update playlist
              _allLessons = state.lessons;
            } else if (state is EnrollmentError) {
              return _buildErrorView(state.message);
            }

            // Show initial loading
            if (_currentLesson == null && state is! EnrollmentError) {
              return _buildLoadingView();
            }

            // Build main player
            return _buildMainPlayer(context);
          },
        ),
      ),
    );
  }

  Widget _buildMainPlayer(BuildContext context) {
    if (_youtubeController == null) {
      return _buildNoVideoView();
    }

    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        if (!mounted) return;
        setState(() {
          _isFullScreen = false;
        });
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      },
      player: YoutubePlayer(
        controller: _youtubeController!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
          backgroundColor: Colors.white24,
          bufferedColor: Colors.white38,
        ),
        topActions: [
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.go('/my-courses/${widget.courseId}/lessons'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _currentLesson?.title ?? 'Loading...',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
        onReady: () {
          // Set player ready when YouTube player is ready (like official example)
          if (mounted) {
            setState(() {
              _isPlayerReady = true;
            });
          }
        },
        onEnded: (_) {
          if (_currentLesson != null && !_currentLesson!.isCompleted) {
            _markAsWatched(showMessage: false);
          }

          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) _playNextLesson();
          });
        },
      ),
      builder: (context, player) {
        if (!mounted) return const SizedBox.shrink();
        return _isDesktop(context)
            ? _buildDesktopLayout(player)
            : _buildMobileLayout(player);
      },
    );
  }

  Widget _buildDesktopLayout(Widget player) {
    return Row(
      children: [
        // Main video area
        Expanded(
          flex: 7,
          child: SingleChildScrollView(
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: player,
                ),
                _buildLessonInfo(),
              ],
            ),
          ),
        ),

        // Playlist sidebar
        Container(
          width: 400,
          color: const Color(0xFF0F0F0F),
          child: Column(
            children: [
              _buildPlaylistHeader(),
              Expanded(
                child: _buildPlaylist(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(Widget player) {
    return SingleChildScrollView(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: player,
          ),
          _buildLessonInfo(),
          _buildPlaylistHeader(),
          SizedBox(
            height: 400,
            child: _buildPlaylist(),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonInfo() {
    if (_currentLesson == null) {
      return const SizedBox.shrink();
    }

    final authState = context.read<AuthBloc>().state;
    final studentEmail = authState is AuthAuthenticated
        ? authState.user.email
        : 'student@example.com';

    return Container(
      width: double.infinity,
      color: const Color(0xFF0F0F0F),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _currentLesson!.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.play_circle_outline,
                  color: Colors.white70, size: 18),
              const SizedBox(width: 6),
              Text(
                _formatDurationMinutes(_currentLesson!.duration),
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(width: 16),
              Icon(
                _currentLesson!.isCompleted
                    ? Icons.check_circle
                    : Icons.pending_outlined,
                color: _currentLesson!.isCompleted ? Colors.green : Colors.orange,
                size: 18,
              ),
              const SizedBox(width: 6),
              Text(
                _currentLesson!.isCompleted ? 'Completed' : 'In progress',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.person_outline,
                        color: Colors.white70, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      studentEmail,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (!_currentLesson!.isCompleted)
                ElevatedButton.icon(
                  onPressed: () => _markAsWatched(),
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Mark Complete'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
            ],
          ),
          if (_currentLesson?.description != null &&
              _currentLesson!.description!.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                _currentLesson!.description!,
                style: const TextStyle(
                  color: Colors.white70,
                  height: 1.5,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlaylistHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white10, width: 1),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.playlist_play, color: Colors.white70, size: 20),
          const SizedBox(width: 8),
          const Text(
            'Course Playlist',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            '${_allLessons.length} lessons',
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaylist() {
    if (_allLessons.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white24),
            SizedBox(height: 16),
            Text(
              'Loading playlist...',
              style: TextStyle(color: Colors.white54),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _playlistController,
      itemCount: _allLessons.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final lesson = _allLessons[index];
        final isCurrentLesson = lesson.id == _currentLesson?.id;

        return _buildPlaylistItem(lesson, isCurrentLesson, index + 1);
      },
    );
  }

  Widget _buildPlaylistItem(Lesson lesson, bool isCurrentLesson, int index) {
    return InkWell(
      onTap: () => _playLesson(lesson),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isCurrentLesson
              ? Colors.white.withOpacity(0.1) // Fixed: use withOpacity
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isCurrentLesson ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Thumbnail or index
            Container(
              width: 120,
              height: 68,
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3), // Fixed: use withOpacity
                borderRadius: BorderRadius.circular(4),
              ),
              child: Stack(
                children: [
                  if (lesson.hasThumbnail)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          lesson.thumbnailUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildDefaultThumbnail(index);
                          },
                        ),
                      ),
                    )
                  else
                    _buildDefaultThumbnail(index),
                  if (isCurrentLesson)
                    Container(
                      color: Colors.black.withOpacity(0.3), // Fixed: use withOpacity
                      child: const Center(
                        child: Icon(Icons.play_circle_outline,
                            color: Colors.white, size: 32),
                      ),
                    ),
                  if (lesson.isCompleted)
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, color: Colors.white,
                            size: 12),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Lesson info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lesson.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isCurrentLesson ? Colors.blue : Colors.white,
                      fontSize: 14,
                      fontWeight:
                          isCurrentLesson ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        _formatDurationMinutes(lesson.duration),
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                      if (lesson.isCompleted) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.check_circle,
                            color: Colors.green, size: 14),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            if (isCurrentLesson)
              const Icon(
                Icons.graphic_eq,
                color: Colors.blue,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultThumbnail(int index) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.red.withOpacity(0.8), // Fixed: use withOpacity
            Colors.red.withOpacity(0.6), // Fixed: use withOpacity
          ],
        ),
      ),
      child: Center(
        child: Text(
          '$index',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 16),
          Text(
            'Loading lesson...',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildNoVideoView() {
    return Container(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.video_library_outlined,
                  size: 64, color: Colors.white54),
              const SizedBox(height: 16),
              const Text(
                'No video available',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () =>
                    context.go('/my-courses/${widget.courseId}/lessons'),
                icon: const Icon(Icons.list),
                label: const Text('Back to lessons'),
              ),
            ],
          ),
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
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Error loading lesson',
              style: TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () =>
                  context.go('/my-courses/${widget.courseId}/lessons'),
              icon: const Icon(Icons.list),
              label: const Text('Back to lessons'),
            ),
          ],
        ),
      ),
    );
  }
}
