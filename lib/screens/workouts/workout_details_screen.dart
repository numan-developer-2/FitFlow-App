import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../../models/workout_category.dart';
import 'workout_video_screen.dart';
import '../../services/achievement_service.dart';
import '../../screens/achievements/achievements_screen.dart';

class WorkoutDetailsScreen extends StatefulWidget {
  final WorkoutCategory workoutCategory;

  const WorkoutDetailsScreen({
    super.key,
    required this.workoutCategory,
  });

  @override
  State<WorkoutDetailsScreen> createState() => _WorkoutDetailsScreenState();
}

class _WorkoutDetailsScreenState extends State<WorkoutDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isLoading = true;
  bool _isPlayingVideo = false;
  bool _isVideoInitialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    if (widget.workoutCategory.videoPath != null) {
      try {
        _videoPlayerController =
            VideoPlayerController.asset(widget.workoutCategory.videoPath!);
        await _videoPlayerController!.initialize();
        setState(() {
          _isVideoInitialized = true;
        });
      } catch (e) {
        debugPrint('Error initializing video: $e');
        // Fall back to default video
        try {
          _videoPlayerController = VideoPlayerController.asset(
              'assets/Videos/10 Best Effective Exercises To Build A Perfect Chest.mp4');
          await _videoPlayerController!.initialize();
          setState(() {
            _isVideoInitialized = true;
          });
        } catch (e) {
          debugPrint('Error initializing default video: $e');
          setState(() {
            _isVideoInitialized = false;
          });
        }
      }
    }
  }

  // Record completed workout
  Future<void> _markWorkoutComplete() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Record workout completion in the achievement service
      final achievementService = AchievementService();
      await achievementService.recordWorkoutCompletion(widget.workoutCategory);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              const Text('Workout completed!'),
              const Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AchievementsScreen(),
                    ),
                  );
                },
                child: const Text('VIEW ACHIEVEMENTS'),
              ),
            ],
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      debugPrint('Error recording workout completion: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to record workout completion.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _videoPlayerController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  void _toggleVideo() {
    setState(() {
      _isPlayingVideo = !_isPlayingVideo;
      if (_isPlayingVideo) {
        _videoPlayerController?.play();
      } else {
        _videoPlayerController?.pause();
      }
    });
  }

  // Get color based on difficulty level
  Color _getDifficultyColor(BuildContext context) {
    final theme = Theme.of(context);

    switch (widget.workoutCategory.difficulty.toLowerCase()) {
      case 'beginner':
        return Colors.green;
      case 'intermediate':
        return Colors.orange;
      case 'advanced':
        return Colors.red;
      default:
        return theme.colorScheme.primary;
    }
  }

  void _navigateToWorkoutVideoScreen() {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WorkoutVideoScreen(
            title: widget.workoutCategory.name,
            videoPath: widget.workoutCategory.videoPath ?? 'default_workout',
            category: widget.workoutCategory.name.toLowerCase(),
          ),
        ),
      );
    } catch (e) {
      // Show a helpful error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
              'Error loading workout video. Please try another workout.'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () {},
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            floating: false,
            backgroundColor: widget.workoutCategory.color,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.workoutCategory.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Background gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.workoutCategory.color.withValues(alpha: 0.8),
                          widget.workoutCategory.color,
                        ],
                      ),
                    ),
                  ),
                  // Background icon
                  Positioned(
                    right: -50,
                    bottom: -50,
                    child: Icon(
                      widget.workoutCategory.icon,
                      size: 200,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  // Share functionality
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Difficulty and duration info
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(context),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.workoutCategory.difficulty,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.timer, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.workoutCategory.duration} min',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.local_fire_department,
                          size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.workoutCategory.caloriesBurn} cal',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    widget.workoutCategory.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Video preview
                  if (widget.workoutCategory.hasVideo)
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black,
                      ),
                      child: Stack(
                        children: [
                          if (_isVideoInitialized &&
                              _videoPlayerController != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: VideoPlayer(_videoPlayerController!),
                            )
                          else
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.grey[800],
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          // Play button overlay
                          if (_isVideoInitialized)
                            Center(
                              child: GestureDetector(
                                onTap: _toggleVideo,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _isPlayingVideo
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 24),

                  // Start workout button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          _isLoading ? null : _navigateToWorkoutVideoScreen,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.workoutCategory.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Start Workout',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Complete workout button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _markWorkoutComplete,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: widget.workoutCategory.color,
                        side: BorderSide(color: widget.workoutCategory.color),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Mark as Complete',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
