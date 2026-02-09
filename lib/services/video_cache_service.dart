import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../utils/logger.dart';

class VideoCacheService {
  static final VideoCacheService _instance = VideoCacheService._internal();
  factory VideoCacheService() => _instance;
  VideoCacheService._internal();

  static const String _cacheDirName = 'video_cache';
  static const int _maxCacheSize = 500 * 1024 * 1024; // 500MB

  final Map<String, String> _cachedVideos = {};
  bool _isInitialized = false;

  // Singleton instance getter
  static VideoCacheService get instance => _instance;

  /// Gets the cached path for a video, downloading it if necessary
  Future<String> getVideoPath(String videoPath) async {
    if (kIsWeb) return videoPath; // No caching on web

    // If it's a local asset, return as is
    if (videoPath.startsWith('assets/')) {
      return videoPath;
    }

    // Check if video is already in memory cache
    if (_cachedVideos.containsKey(videoPath)) {
      final cachedFile = File(_cachedVideos[videoPath]!);
      if (await cachedFile.exists()) {
        AppLogger.d('Using cached video from memory: $videoPath');
        return _cachedVideos[videoPath]!;
      } else {
        _cachedVideos.remove(videoPath);
      }
    }

    // If it's a network URL, cache it
    if (videoPath.startsWith('http')) {
      try {
        final cacheDir = await _getCacheDirectory();
        final fileName = '${_generateCacheKey(videoPath)}.mp4';
        final cachedPath = '${cacheDir.path}/$fileName';

        // Check if file exists in cache
        final cachedFile = File(cachedPath);
        if (await cachedFile.exists()) {
          _cachedVideos[videoPath] = cachedPath;
          AppLogger.d('Using cached video from disk: $videoPath');
          return cachedPath;
        }

        // Download and cache the video
        AppLogger.i('Caching video: $videoPath');
        final response = await http.get(Uri.parse(videoPath));
        if (response.statusCode == 200) {
          await cachedFile.writeAsBytes(response.bodyBytes);
          _cachedVideos[videoPath] = cachedPath;
          AppLogger.i('Successfully cached video: $videoPath');

          // Clean up old cache if needed
          await _cleanupCacheIfNeeded();

          return cachedPath;
        } else {
          AppLogger.e('Failed to download video: ${response.statusCode}');
        }
      } catch (e, stackTrace) {
        AppLogger.e('Error caching video: $videoPath',
            error: e, stackTrace: stackTrace);
      }
    }

    return videoPath; // Fallback to original path
  }

  /// Preloads a list of video URLs in the background
  static Future<void> preloadWorkoutVideos({List<String>? videoUrls}) async {
    if (kIsWeb) return; // No caching on web

    try {
      final service = VideoCacheService();
      final urls = videoUrls ??
          [
            // Add default workout videos to preload
            'https://example.com/workouts/warmup.mp4',
            'https://example.com/workouts/cooldown.mp4',
          ];

      // Preload videos in parallel but limit concurrency
      await Future.wait(
        urls.map((url) => service.getVideoPath(url)),
      );

      AppLogger.i('Preloaded ${urls.length} workout videos');
    } catch (e, stackTrace) {
      AppLogger.e('Error preloading videos', error: e, stackTrace: stackTrace);
    }
  }

  /// Gets the cache directory, creating it if it doesn't exist
  Future<Directory> _getCacheDirectory() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final cacheDir = Directory('${appDocDir.path}/$_cacheDirName');
      AppLogger.d('Cache directory path: ${cacheDir.path}');
      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
      }
      return cacheDir;
    } catch (e, stackTrace) {
      AppLogger.e('Failed to get cache directory',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Initialize the cache service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      AppLogger.i('Initializing VideoCacheService...');
      await _initializeCacheDirectory();
      await _cleanupCacheIfNeeded();
      _isInitialized = true;
      AppLogger.i('VideoCacheService initialized');
    } catch (e, stackTrace) {
      AppLogger.e('Failed to initialize VideoCacheService',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Initializes the cache directory
  Future<void> _initializeCacheDirectory() async {
    try {
      final cacheDir = await _getCacheDirectory();
      if (!await cacheDir.exists()) {
        await cacheDir.create(recursive: true);
      }
    } catch (e, stackTrace) {
      AppLogger.e('Failed to initialize cache directory',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Clears all cached videos
  Future<void> clearAllCachedVideos() async {
    _cachedVideos.clear();

    try {
      final cacheDir = await _getCacheDirectory();
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
        await cacheDir.create(recursive: true);
        AppLogger.i('Video cache cleared');
      }
    } catch (e, stackTrace) {
      AppLogger.e('Error clearing video cache',
          error: e, stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Gets the total size of the cache in bytes
  Future<int> getCacheSize() async {
    try {
      final directory = await _getCacheDirectory();
      if (!await directory.exists()) return 0;

      int totalSize = 0;
      final files = directory.list(recursive: true);

      await for (final entity in files) {
        if (entity is File) {
          final stat = await entity.stat();
          totalSize += stat.size;
        }
      }

      return totalSize;
    } catch (e, stackTrace) {
      AppLogger.e('Error getting cache size', error: e, stackTrace: stackTrace);
      return 0;
    }
  }

  /// Generates a cache key from a URL
  String _generateCacheKey(String url) {
    return 'cached_${url.hashCode}';
  }

  /// Cleans up old cache files if cache size exceeds the limit
  Future<void> _cleanupCacheIfNeeded() async {
    try {
      final cacheDir = await _getCacheDirectory();
      final List<FileSystemEntity> files = await cacheDir.list().toList();

      // Sort files by last modified date (oldest first)
      files.sort(
          (a, b) => a.statSync().modified.compareTo(b.statSync().modified));

      // Calculate total size
      int totalSize =
          files.fold(0, (sum, file) => sum + (file.statSync().size));

      // Remove oldest files until we're under the limit
      int index = 0;
      while (totalSize > _maxCacheSize && index < files.length) {
        final file = files[index];
        final fileSize = file.statSync().size;
        await file.delete();
        totalSize -= fileSize;
        index++;

        // Remove from memory cache
        final cachedEntry = _cachedVideos.entries.firstWhere(
          (entry) => entry.value == file.path,
          orElse: () => const MapEntry('', ''),
        );
        if (cachedEntry.key.isNotEmpty) {
          _cachedVideos.remove(cachedEntry.key);
        }
      }

      AppLogger.i(
          'Cache cleanup completed. Current cache size: ${totalSize ~/ (1024 * 1024)}MB');
    } catch (e, stackTrace) {
      AppLogger.e('Error during cache cleanup',
          error: e, stackTrace: stackTrace);
    }
  }

  /// Clears all cached videos
  Future<void> clearCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      await cacheDir.delete(recursive: true);
      _cachedVideos.clear();
    } catch (e) {
      debugPrint('Error clearing video cache: $e');
    }
  }

  /// Preloads a list of video paths
  Future<void> preloadVideos(List<String> videoPaths) async {
    if (kIsWeb) return; // No preloading on web

    for (final path in videoPaths) {
      try {
        await getVideoPath(path);
      } catch (e, stackTrace) {
        AppLogger.e('Error preloading video $path',
            error: e, stackTrace: stackTrace);
      }
    }
  }
}
