// file: lib/app/utils/helpers.dart

import 'package:intl/intl.dart';

/// Helper functions for the application
class Helpers {
  /// Format duration in milliseconds to mm:ss format
  static String formatDuration(int milliseconds) {
    final duration = Duration(milliseconds: milliseconds);
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Format duration object to mm:ss format
  static String formatDurationObject(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Format date to readable format
  static String formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Format date time to readable format
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  /// Validate email
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validate password (min 6 characters)
  static bool isValidPassword(String password) {
    return password.length >= 6;
  }

  /// Validate nickname (min 3 characters, alphanumeric)
  static bool isValidNickname(String nickname) {
    if (nickname.length < 3) return false;
    final nicknameRegex = RegExp(r'^[a-zA-Z0-9_]+$');
    return nicknameRegex.hasMatch(nickname);
  }

  /// Calculate latency compensation for WebSocket events
  /// Used to sync playback in Listen Together feature
  static int calculateLatencyMs(String? timestamp) {
    if (timestamp == null) return 0;
    
    try {
      final eventTime = DateTime.parse(timestamp);
      final now = DateTime.now();
      final latency = now.difference(eventTime).inMilliseconds;
      return latency > 0 ? latency : 0;
    } catch (e) {
      return 0;
    }
  }

  /// Format file size
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Truncate text with ellipsis
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Get initials from name
  static String getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
  }

  /// Parse duration from string (e.g., "3:45" to milliseconds)
  static int parseDuration(String duration) {
    try {
      final parts = duration.split(':');
      if (parts.length == 2) {
        final minutes = int.parse(parts[0]);
        final seconds = int.parse(parts[1]);
        return (minutes * 60 + seconds) * 1000;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }
}
