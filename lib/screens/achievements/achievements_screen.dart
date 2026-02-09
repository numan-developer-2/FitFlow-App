import 'package:flutter/material.dart';
import '../../models/achievement.dart';
import '../../services/achievement_service.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  State<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  final AchievementService _achievementService = AchievementService();
  List<Achievement> _achievements = [];
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadAchievements();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadAchievements() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Initialize achievements for new users
      await _achievementService.initializeUserAchievements();

      // Load achievements
      final achievements = await _achievementService.getAchievements();

      setState(() {
        _achievements = achievements;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading achievements: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Filter achievements by type
  List<Achievement> _getFilteredAchievements(AchievementType type) {
    return _achievements.where((a) => a.type == type).toList();
  }

  // Get all unlocked achievements
  List<Achievement> _getUnlockedAchievements() {
    return _achievements.where((a) => a.isUnlocked).toList();
  }

  // Get achievements for a specific tab index
  List<Achievement> _getAchievementsForTab(int index) {
    switch (index) {
      case 0:
        return _achievements;
      case 1:
        return _getUnlockedAchievements();
      case 2:
        return _getFilteredAchievements(AchievementType.workout);
      case 3:
        return _getFilteredAchievements(AchievementType.streak);
      case 4:
        return [
          ..._getFilteredAchievements(AchievementType.milestone),
          ..._getFilteredAchievements(AchievementType.challenge),
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 200,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      'Achievements',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context).colorScheme.primaryContainer,
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -50,
                            bottom: -10,
                            child: Icon(
                              Icons.emoji_events,
                              size: 180,
                              color: Colors.white.withAlpha(25),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _buildAchievementSummary(),
                        const SizedBox(height: 24),
                        TabBar(
                          controller: _tabController,
                          isScrollable: true,
                          tabs: const [
                            Tab(text: 'All'),
                            Tab(text: 'Unlocked'),
                            Tab(text: 'Workouts'),
                            Tab(text: 'Streaks'),
                            Tab(text: 'Milestones'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverFillRemaining(
                  child: TabBarView(
                    controller: _tabController,
                    children: List.generate(5, (index) {
                      final achievements = _getAchievementsForTab(index);
                      return _buildAchievementsGrid(achievements);
                    }),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildAchievementSummary() {
    final unlocked = _getUnlockedAchievements().length;
    final total = _achievements.length;
    final progress = total > 0 ? unlocked / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Achievement Progress',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$unlocked of $total achievements unlocked',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
            backgroundColor:
                Theme.of(context).colorScheme.primary.withAlpha(51),
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementsGrid(List<Achievement> achievements) {
    if (achievements.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emoji_events_outlined,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No achievements in this category yet!',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return _buildAchievementCard(achievement, index);
      },
    );
  }

  Widget _buildAchievementCard(Achievement achievement, int index) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: achievement.isUnlocked
              ? achievement.color
              : Colors.grey.withAlpha(77),
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () => _showAchievementDetails(achievement),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Achievement Icon
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: achievement.isUnlocked
                      ? achievement.color.withAlpha(51)
                      : Colors.grey.withAlpha(25),
                ),
                child: Center(
                  child: Icon(
                    achievement.isUnlocked
                        ? achievement.icon
                        : Icons.lock_outline,
                    size: 40,
                    color: achievement.isUnlocked
                        ? achievement.color
                        : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Achievement Title
              Text(
                achievement.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: achievement.isUnlocked
                      ? Theme.of(context).colorScheme.onSurface
                      : Colors.grey,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Achievement Description
              Text(
                achievement.description,
                style: TextStyle(
                  fontSize: 12,
                  color: achievement.isUnlocked
                      ? Theme.of(context).colorScheme.onSurfaceVariant
                      : Colors.grey.withAlpha(179),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // Points Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: achievement.isUnlocked
                      ? achievement.color.withAlpha(51)
                      : Colors.grey.withAlpha(25),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.star,
                      size: 14,
                      color: achievement.isUnlocked
                          ? achievement.color
                          : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${achievement.pointsValue} pts',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: achievement.isUnlocked
                            ? achievement.color
                            : Colors.grey,
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

  void _showAchievementDetails(Achievement achievement) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: achievement.isUnlocked
                      ? achievement.color.withAlpha(51)
                      : Colors.grey.withAlpha(25),
                ),
                child: Center(
                  child: Icon(
                    achievement.isUnlocked
                        ? achievement.icon
                        : Icons.lock_outline,
                    size: 60,
                    color: achievement.isUnlocked
                        ? achievement.color
                        : Colors.grey,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                achievement.title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: achievement.isUnlocked
                          ? Theme.of(context).colorScheme.onSurface
                          : Colors.grey,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                achievement.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: achievement.isUnlocked
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Colors.grey.withAlpha(179),
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: achievement.isUnlocked
                          ? achievement.color.withAlpha(51)
                          : Colors.grey.withAlpha(25),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.star,
                          size: 18,
                          color: achievement.isUnlocked
                              ? achievement.color
                              : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${achievement.pointsValue} points',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: achievement.isUnlocked
                                ? achievement.color
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: achievement.isUnlocked
                          ? Colors.green.withAlpha(51)
                          : Colors.grey.withAlpha(25),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          achievement.isUnlocked
                              ? Icons.check_circle
                              : Icons.timelapse,
                          size: 18,
                          color: achievement.isUnlocked
                              ? Colors.green
                              : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          achievement.isUnlocked ? 'Unlocked' : 'Locked',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: achievement.isUnlocked
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (achievement.isUnlocked) ...[
                const SizedBox(height: 24),
                Text(
                  'Unlocked on ${_formatDate(achievement.awardedDate)}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'Today';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
