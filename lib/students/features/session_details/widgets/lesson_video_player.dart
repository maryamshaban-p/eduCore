import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:edulink_app/students/features/session/data/session_repo.dart';

class LessonVideoPlayer extends StatefulWidget {
  final String videoUrl;
  final int sessionId;

  const LessonVideoPlayer({
    super.key,
    required this.videoUrl,
    required this.sessionId,
  });

  @override
  State<LessonVideoPlayer> createState() => _LessonVideoPlayerState();
}

class _LessonVideoPlayerState extends State<LessonVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _isViewRecorded = false;

  // ✅ Add these for progress tracking
  Timer? _progressTimer;
  final SessionRepository _sessionRepo = SessionRepository();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) setState(() => _isInitialized = true);
        // ✅ RECORD VIEW once when initialized
        if (!_isViewRecorded) {
          _recordView();
        }
      }).catchError((_) {
        if (mounted) setState(() => _hasError = true);
      });
  }

  // ✅ ADD THIS METHOD: Record view when video initializes
  Future<void> _recordView() async {
    try {
      final response = await _sessionRepo.recordView(widget.sessionId);
      debugPrint(
        'View recorded: ${response.views}/${response.maxViews} views',
      );
      setState(() => _isViewRecorded = true);

      // Show snackbar if max views reached
      if (response.views >= response.maxViews && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Max views reached for this lesson'),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error recording view: $e');
      // Don't show error to user for view recording
    }
  }

  // ✅ ADD THIS METHOD: Start progress tracking
  void _startProgressTracking() {
    _progressTimer = Timer.periodic(Duration(seconds: 10), (_) async {
      if (_controller.value.isInitialized && _controller.value.isPlaying) {
        try {
          final position = _controller.value.position;
          final duration = _controller.value.duration;

          if (duration.inMilliseconds > 0) {
            double progressPercent =
                (position.inMilliseconds / duration.inMilliseconds) * 100;

            // ✅ UPDATE PROGRESS
            await _sessionRepo.updateLessonProgress(
              widget.sessionId,
              progressPercent,
            );

            debugPrint(
              'Progress updated: ${progressPercent.toStringAsFixed(1)}%',
            );
          }
        } catch (e) {
          debugPrint('Error updating progress: $e');
        }
      }
    });
  }

  // ✅ ADD THIS METHOD: Update final progress on dispose
  Future<void> _saveFinalProgress() async {
    try {
      if (_controller.value.isInitialized) {
        final position = _controller.value.position;
        final duration = _controller.value.duration;

        if (duration.inMilliseconds > 0) {
          double progressPercent =
              (position.inMilliseconds / duration.inMilliseconds) * 100;

          await _sessionRepo.updateLessonProgress(
            widget.sessionId,
            progressPercent,
          );

          debugPrint(
            'Final progress saved: ${progressPercent.toStringAsFixed(1)}%',
          );
        }
      }
    } catch (e) {
      debugPrint('Error saving final progress: $e');
    }
  }

  @override
  void dispose() {
    // ✅ Save final progress before disposing
    _saveFinalProgress();

    // ✅ Cancel timer
    _progressTimer?.cancel();

    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        // ✅ Save progress when paused
        _saveFinalProgress();
      } else {
        _controller.play();
        // ✅ Start progress tracking when playing
        if (_progressTimer == null) {
          _startProgressTracking();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    if (_hasError) {
      return Container(
        width: double.infinity,
        height: screenHeight * 0.25,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
        ),
        child: const Center(
          child: Text('Could not load video', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    if (!_isInitialized) {
      return Container(
        width: double.infinity,
        height: screenHeight * 0.25,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(screenWidth * 0.04),
      child: AspectRatio(
        aspectRatio: _controller.value.aspectRatio == 0 ? 16 / 9 : _controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VideoPlayer(_controller),
            GestureDetector(
              onTap: _togglePlay,
              child: AnimatedOpacity(
                opacity: _controller.value.isPlaying ? 0.0 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Container(
                  color: Colors.black.withOpacity(0.25),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: screenWidth * 0.1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                colors: const VideoProgressColors(
                  playedColor: Color(0xFF055092),
                  bufferedColor: Colors.white54,
                  backgroundColor: Colors.white24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}