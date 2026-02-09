import 'package:flutter/material.dart';
import 'package:fitflow/models/social_activity.dart';
import 'package:provider/provider.dart';
import 'package:fitflow/providers/user_provider.dart';
import 'package:intl/intl.dart';

class ActivityCard extends StatefulWidget {
  final SocialActivity activity;
  final VoidCallback onLike;
  final Function(String) onComment;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.onLike,
    required this.onComment,
  });

  @override
  State<ActivityCard> createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> {
  bool _showComments = false;
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;
    final isLiked =
        currentUser != null && widget.activity.likes.contains(currentUser.uid);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shadowColor: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context)
              .colorScheme
              .outlineVariant
              .withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info and timestamp
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage:
                      NetworkImage(widget.activity.userProfileImage),
                  onBackgroundImageError: (exception, stackTrace) {
                    // Handle image loading error
                  },
                  child: widget.activity.userProfileImage.isEmpty
                      ? Text(
                          widget.activity.userName.isNotEmpty
                              ? widget.activity.userName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.activity.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _formatTimestamp(widget.activity.timestamp),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Activity content
            Text(
              widget.activity.activityDescription,
              style: const TextStyle(fontSize: 14),
            ),

            // Activity-specific content
            _buildActivityContent(),

            const SizedBox(height: 16),

            // Like and comment buttons
            Row(
              children: [
                _buildActionButton(
                  icon: isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : null,
                  text: widget.activity.likes.isEmpty
                      ? 'Like'
                      : widget.activity.likes.length.toString(),
                  onTap: widget.onLike,
                ),
                _buildActionButton(
                  icon: Icons.comment,
                  text: widget.activity.comments.isEmpty
                      ? 'Comment'
                      : widget.activity.comments.length.toString(),
                  onTap: () {
                    setState(() {
                      _showComments = !_showComments;
                    });
                  },
                ),
                const Spacer(),
                _buildActionButton(
                  icon: Icons.share,
                  text: 'Share',
                  onTap: () {
                    // TODO: Implement sharing
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sharing coming soon!')));
                  },
                ),
              ],
            ),

            // Comments section
            if (_showComments) ...[
              const Divider(height: 24),

              // Existing comments
              ...widget.activity.comments.map((comment) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage:
                              NetworkImage(comment.userProfileImage),
                          onBackgroundImageError: (exception, stackTrace) {
                            // Handle image loading error
                          },
                          child: comment.userProfileImage.isEmpty
                              ? Text(
                                  comment.userName.isNotEmpty
                                      ? comment.userName[0].toUpperCase()
                                      : 'U',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    comment.userName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _formatTimestamp(comment.timestamp),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(comment.content),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),

              // New comment input
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.2),
                    child: currentUser != null &&
                            currentUser.name != null &&
                            currentUser.name!.isNotEmpty
                        ? Text(currentUser.name![0],
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ))
                        : const Icon(Icons.person_outline, size: 14),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(
                        hintText: 'Write a comment...',
                        border: InputBorder.none,
                      ),
                      minLines: 1,
                      maxLines: 3,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      if (_commentController.text.trim().isNotEmpty) {
                        widget.onComment(_commentController.text.trim());
                        _commentController.clear();
                      }
                    },
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 4),
            Text(text),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // User info row
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(widget.activity.userProfileImage),
              onBackgroundImageError: (exception, stackTrace) {
                // Handle image loading error
              },
              child: widget.activity.userProfileImage.isEmpty
                  ? Text(
                      widget.activity.userName.isNotEmpty
                          ? widget.activity.userName[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.activity.userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    _formatTimestamp(widget.activity.timestamp),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Activity description
        Text(
          widget.activity.activityDescription,
          style: const TextStyle(fontSize: 14),
        ),
        const SizedBox(height: 12),

        // Activity-specific content
        _buildActivitySpecificContent(),
        const SizedBox(height: 12),

        // Action buttons
        Row(
          children: [
            _buildActionButton(
              icon: widget.activity.likes.contains('currentUserId')
                  ? Icons.favorite
                  : Icons.favorite_border,
              text: '${widget.activity.likes.length}',
              onTap: widget.onLike,
              color: widget.activity.likes.contains('currentUserId')
                  ? Colors.red
                  : null,
            ),
            const SizedBox(width: 16),
            _buildActionButton(
              icon: Icons.comment,
              text: '${widget.activity.comments.length}',
              onTap: () => _onCommentPressed(),
            ),
            const SizedBox(width: 16),
            _buildActionButton(
              icon: Icons.share,
              text: 'Share',
              onTap: () => _onSharePressed(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActivitySpecificContent() {
    switch (widget.activity.activityType) {
      case 'workout_completed':
        return _buildWorkoutContent();
      case 'achievement_unlocked':
        return _buildAchievementContent();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildWorkoutContent() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.fitness_center,
            color: Colors.blue,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Workout Completed',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
                  ),
                ),
                if (widget.activity.workoutDuration != null)
                  Text(
                    'Duration: ${widget.activity.workoutDuration} minutes',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                if (widget.activity.caloriesBurned != null)
                  Text(
                    'Calories: ${widget.activity.caloriesBurned} cal',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementContent() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.emoji_events,
            color: Colors.amber[700],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Achievement Unlocked!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.amber[700],
                  ),
                ),
                Text(
                  widget.activity.activityDescription,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentsSection() {
    if (widget.activity.comments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(),
        ...widget.activity.comments
            .map((comment) => _buildCommentItem(comment)),
      ],
    );
  }

  Widget _buildCommentItem(ActivityComment comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(comment.userProfileImage),
            onBackgroundImageError: (exception, stackTrace) {
              // Handle image loading error
            },
            child: comment.userProfileImage.isEmpty
                ? Text(
                    comment.userName.isNotEmpty
                        ? comment.userName[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.userName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatTimestamp(comment.timestamp),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  comment.content,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return DateFormat.yMMMd().add_jm().format(timestamp);
  }

  void _onCommentPressed() {
    // Implementation of _onCommentPressed
  }

  void _onSharePressed() {
    // Implementation of _onSharePressed
  }
}
