// file: lib/app/core/theme/app_text_styles.dart

import 'package:flutter/material.dart';

/// Application text styles
/// Consistent typography for the Spotify-like app
class AppTextStyles {
  // Display styles
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: Color(0xFFFFFFFF),
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Color(0xFFFFFFFF),
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Color(0xFFFFFFFF),
  );

  // Headline styles
  static const TextStyle headlineMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Color(0xFFFFFFFF),
  );

  // Title styles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: Color(0xFFFFFFFF),
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Color(0xFFFFFFFF),
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Color(0xFFB3B3B3),
  );

  // Body styles
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    color: Color(0xFFFFFFFF),
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: Color(0xFFFFFFFF),
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: Color(0xFFB3B3B3),
  );

  // Additional styles for specific use cases
  static const TextStyle secondaryHeadlineSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Color(0xFFB3B3B3),
  );

  static const TextStyle appBarTitle = TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle buttonText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle textButtonText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );
}
