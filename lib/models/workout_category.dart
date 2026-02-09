import 'package:flutter/material.dart';
import '../utils/asset_resolver.dart';

enum DifficultyLevel { beginner, intermediate, advanced }

class WorkoutCategory {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String? imagePath;
  final String? videoPath;
  final int duration; // in minutes
  final String difficulty;
  final int caloriesBurn;

  WorkoutCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.imagePath,
    this.videoPath,
    required this.duration,
    required this.difficulty,
    required this.caloriesBurn,
  });

  // Helper method to get proper video path
  String? get resolvedVideoPath =>
      videoPath != null ? AssetResolver.resolveVideoPath(videoPath!) : null;

  // Helper method to get proper image path
  String get resolvedImagePath =>
      imagePath ?? AssetResolver.resolveImagePath(name.toLowerCase());

  static List<WorkoutCategory> getAllCategories() {
    return [
      WorkoutCategory(
        id: 'chest',
        name: 'Chest',
        description:
            'Build a strong and defined chest with these effective exercises',
        icon: Icons.fitness_center,
        color: Colors.redAccent,
        imagePath: 'assets/workouts/chest workout pic.jpeg',
        videoPath:
            'assets/Videos/10 Best Effective Exercises To Build A Perfect Chest.mp4',
        duration: 30,
        difficulty: 'Intermediate',
        caloriesBurn: 280,
      ),
      WorkoutCategory(
        id: 'arms',
        name: 'Arms',
        description: 'Sculpt your arms with targeted strength training',
        icon: Icons.sports_gymnastics,
        color: Colors.blueAccent,
        imagePath: 'assets/workouts/Arms workout image.jpeg',
        videoPath:
            'assets/Videos/14 Best Workout To Get Big And Perfect Arms.mp4',
        duration: 25,
        difficulty: 'Beginner',
        caloriesBurn: 220,
      ),
      WorkoutCategory(
        id: 'back',
        name: 'Back',
        description: 'Strengthen your back muscles for better posture',
        icon: Icons.accessibility_new,
        color: Colors.purpleAccent,
        imagePath: 'assets/workouts/back wokrout pic.jpeg',
        videoPath:
            'assets/Videos/6 Exercises To Build Bigger Back - Back Workout.mp4',
        duration: 35,
        difficulty: 'Intermediate',
        caloriesBurn: 320,
      ),
      WorkoutCategory(
        id: 'legs',
        name: 'Legs',
        description:
            'Build powerful legs with comprehensive lower body training',
        icon: Icons.directions_run,
        color: Colors.orangeAccent,
        imagePath: 'assets/workouts/leg workout pic.jpeg',
        videoPath:
            'assets/Videos/7 BEST LEG EXERCISES TO GET WIDE THIGH WORKOUT !🎯.mp4',
        duration: 40,
        difficulty: 'Advanced',
        caloriesBurn: 380,
      ),
      WorkoutCategory(
        id: 'shoulders',
        name: 'Shoulders',
        description: 'Develop strong and defined shoulders',
        icon: Icons.sports_martial_arts,
        color: Colors.greenAccent,
        imagePath: 'assets/workouts/shoulder workouy.jpeg',
        videoPath: 'assets/Videos/9 Exercise For Bigger SHOULDER AND TRAPS.mp4',
        duration: 20,
        difficulty: 'Beginner',
        caloriesBurn: 180,
      ),
      WorkoutCategory(
        id: 'core',
        name: 'Core',
        description: 'Strengthen your core for better stability and posture',
        icon: Icons.fitness_center,
        color: Colors.deepPurpleAccent,
        imagePath: 'assets/workouts/abs wrokout.jpg',
        videoPath:
            'assets/Videos/TRICEPS Exercises WITH DUMBBELLS AT HOME AND GYM.mp4',
        duration: 15,
        difficulty: 'Beginner',
        caloriesBurn: 150,
      ),
    ];
  }

  static WorkoutCategory? getById(String id) {
    try {
      return getAllCategories().firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<WorkoutCategory> getByDifficulty(String difficulty) {
    return getAllCategories()
        .where((category) =>
            category.difficulty.toLowerCase() == difficulty.toLowerCase())
        .toList();
  }

  static List<WorkoutCategory> getByDuration(int maxDuration) {
    return getAllCategories()
        .where((category) => category.duration <= maxDuration)
        .toList();
  }

  static String? getVideoPathFromCategory(String categoryName) {
    final category = getAllCategories().firstWhere(
        (c) => c.name.toLowerCase() == categoryName.toLowerCase(),
        orElse: () => getAllCategories()[0]);

    return category.videoPath;
  }

  static String? sanitizeVideoPath(String? path) {
    if (path == null) return null;
    return path;
  }

  static WorkoutCategory getCategoryByName(String name) {
    try {
      return getAllCategories().firstWhere(
        (category) => category.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      debugPrint('Category not found: $name, using default');
      return getAllCategories()[0];
    }
  }

  bool get hasVideo => videoPath != null && videoPath!.isNotEmpty;

  // Create a default category for fallback when none is found
  static WorkoutCategory createDefaultCategory(
      String categoryType, String title) {
    Color defaultColor = Colors.orangeAccent;
    String defaultDescription =
        'A workout designed to improve your fitness level.';
    IconData defaultIcon = Icons.fitness_center;

    // Attempt to standardize category type for matching
    final String normalizedType = categoryType.toLowerCase().trim();

    // Match common workout types to appropriate colors and icons
    if (normalizedType.contains('chest')) {
      defaultColor = Colors.redAccent;
      defaultIcon = Icons.fitness_center;
      defaultDescription =
          'Build a stronger, more defined chest with these effective exercises.';
    } else if (normalizedType.contains('back')) {
      defaultColor = Colors.purpleAccent;
      defaultIcon = Icons.accessibility_new;
      defaultDescription =
          'Develop a strong, muscular back with these powerful back exercises.';
    } else if (normalizedType.contains('arm')) {
      defaultColor = Colors.blueAccent;
      defaultIcon = Icons.sports_gymnastics;
      defaultDescription =
          'Sculpt impressive arms with these targeted bicep and tricep exercises.';
    } else if (normalizedType.contains('leg')) {
      defaultColor = Colors.orangeAccent;
      defaultIcon = Icons.directions_run;
      defaultDescription =
          'Build powerful legs with these effective lower body exercises.';
    } else if (normalizedType.contains('cardio')) {
      defaultColor = Colors.pinkAccent;
      defaultIcon = Icons.directions_run;
      defaultDescription =
          'Boost your heart rate and burn calories with these effective cardio workouts.';
    } else if (normalizedType.contains('full')) {
      defaultColor = Colors.tealAccent;
      defaultIcon = Icons.accessibility_new;
      defaultDescription =
          'A complete workout targeting all major muscle groups.';
    }

    return WorkoutCategory(
      id: categoryType.toLowerCase(),
      name: title,
      description: defaultDescription,
      icon: defaultIcon,
      color: defaultColor,
      imagePath: AssetResolver.resolveImagePath(categoryType.toLowerCase()),
      videoPath: categoryType.toLowerCase(),
      duration: 30,
      difficulty: 'Intermediate',
      caloriesBurn: 300,
    );
  }
}

class Exercise {
  final String name;
  final int sets;
  final String reps;
  final String? imagePath;
  final String description;
  final String tips;
  final DifficultyLevel difficulty;
  final List<String> targetMuscles;
  final List<String> equipment;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    this.imagePath,
    required this.description,
    required this.tips,
    this.difficulty = DifficultyLevel.intermediate,
    this.targetMuscles = const [],
    this.equipment = const [],
  });
}
