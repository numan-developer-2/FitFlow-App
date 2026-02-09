import 'package:flutter/material.dart';
import '../../config/theme_config.dart';
import 'package:fitflow/models/workout_category.dart';
import 'package:fitflow/screens/workouts/workout_details_screen.dart';

class DiscoverWorkoutsScreen extends StatefulWidget {
  const DiscoverWorkoutsScreen({super.key});

  @override
  State<DiscoverWorkoutsScreen> createState() => _DiscoverWorkoutsScreenState();
}

class _DiscoverWorkoutsScreenState extends State<DiscoverWorkoutsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  List<WorkoutCategory> _allWorkouts = [];
  List<WorkoutCategory> _filteredWorkouts = [];
  bool _isLoading = true;

  final List<String> _difficultyFilters = [
    'All',
    'Beginner',
    'Intermediate',
    'Advanced',
  ];

  @override
  void initState() {
    super.initState();
    _loadWorkouts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadWorkouts() {
    setState(() => _isLoading = true);

    // Get workouts from model
    final workouts = WorkoutCategory.getAllCategories();

    setState(() {
      _allWorkouts = workouts;
      _filteredWorkouts = workouts;
      _isLoading = false;
    });
  }

  void _filterWorkouts(String difficulty) {
    setState(() {
      _selectedFilter = difficulty;

      if (difficulty == 'All') {
        _filteredWorkouts = _allWorkouts;
      } else {
        _filteredWorkouts = _allWorkouts
            .where((workout) =>
                workout.difficulty.toLowerCase() == difficulty.toLowerCase())
            .toList();
      }
    });
  }

  void _searchWorkouts(String query) {
    if (query.isEmpty) {
      _filterWorkouts(_selectedFilter);
      return;
    }

    final searchResults = _allWorkouts.where((workout) {
      final nameMatch =
          workout.name.toLowerCase().contains(query.toLowerCase());
      final descMatch =
          workout.description.toLowerCase().contains(query.toLowerCase());

      return nameMatch || descMatch;
    }).toList();

    setState(() {
      _filteredWorkouts = searchResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Scaffold(
      backgroundColor: ThemeConfig.secondaryColor,
      appBar: AppBar(
        backgroundColor: ThemeConfig.secondaryColor,
        elevation: 0,
        title: Text(
          'Discover Workouts',
          style: TextStyle(
            fontSize: isSmallScreen ? 20 : 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search bar
                    _buildSearchBar(),
                    const SizedBox(height: 16),

                    // Filters
                    _buildFilters(),
                    const SizedBox(height: 16),

                    // Workout list
                    Expanded(
                      child: _filteredWorkouts.isEmpty
                          ? _buildEmptyState()
                          : GridView.builder(
                              padding:
                                  EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: size.width > 600 ? 3 : 2,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 0.75,
                              ),
                              itemCount: _filteredWorkouts.length,
                              itemBuilder: (context, index) {
                                final workout = _filteredWorkouts[index];
                                return _buildWorkoutCard(workout);
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: ThemeConfig.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _searchWorkouts,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'Search workouts...',
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _difficultyFilters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: GestureDetector(
              onTap: () => _filterWorkouts(filter),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? ThemeConfig.primaryColor
                      : ThemeConfig.cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWorkoutCard(WorkoutCategory workout) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutDetailsScreen(
              workoutCategory: workout,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: ThemeConfig.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Workout image
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      workout.color.withValues(alpha: 0.8),
                      workout.color,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Background icon
                    Positioned.fill(
                      child: Icon(
                        workout.icon,
                        size: 60,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    // Difficulty badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          workout.difficulty,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Workout info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      workout.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${workout.duration} min • ${workout.caloriesBurn} cal',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No workouts found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
