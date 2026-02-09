import 'package:flutter/foundation.dart';

/// Log level enum for different log levels
enum LogLevel {
  debug,
  info,
  warning,
  error,
}

/// A simple logger utility class for the app
class AppLogger {
  static bool _isInitialized = false;
  static LogLevel _logLevel = kDebugMode ? LogLevel.debug : LogLevel.info;

  /// Initialize the logger with a specific log level
  static void initialize({LogLevel level = LogLevel.debug}) {
    _logLevel = level;
    _isInitialized = true;
    _log(LogLevel.info, 'Logger initialized with level: ${level.toString().split('.').last}');
  }

  /// Log a debug message
  static void d(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.debug, message, error: error, stackTrace: stackTrace);
  }

  /// Log an info message
  static void i(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.info, message, error: error, stackTrace: stackTrace);
  }

  /// Log a warning message
  static void w(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.warning, message, error: error, stackTrace: stackTrace);
  }

  /// Log an error message
  static void e(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, error: error, stackTrace: stackTrace);
  }

  /// Log a wtf message
  static void wtf(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, error: error, stackTrace: stackTrace);
  }

  // Internal log method
  static void _log(LogLevel level, String message, 
      {Object? error, StackTrace? stackTrace}) {
    if (!_isInitialized) {
      initialize();
    }

    if (level.index < _logLevel.index) {
      return; // Skip logs below the current log level
    }

    final buffer = StringBuffer();
    buffer.write('${_getLogLevelString(level)}: $message');

    if (error != null) {
      buffer.write('\nError: $error');
    }

    if (stackTrace != null) {
      buffer.write('\nStack trace: $stackTrace');
    }

    // Use debugPrint in debug mode, print in release mode
    if (kDebugMode) {
      debugPrint(buffer.toString());
    } else {
      // In release mode, only log warnings and errors
      if (level.index >= LogLevel.warning.index) {
        print(buffer.toString());
      }
    }
  }

  // Helper method to get log level string
  static String _getLogLevelString(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 'DEBUG';
      case LogLevel.info:
        return 'INFO';
      case LogLevel.warning:
        return 'WARNING';
      case LogLevel.error:
        return 'ERROR';
    }
  }
}

// Global logger instance
final logger = AppLogger();
