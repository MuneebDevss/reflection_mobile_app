import 'package:flutter/material.dart';

/// App-wide color constants
class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primaryPurple = Color(0xFF6C5CE7);
  static const Color primaryDark = Color(0xFF5B4FD6);
  static const Color primaryLight = Color(0xFF7C6FE8);
  static const Color primaryBlue = Color(0xFF3B82F6);

  // Background Colors
  static const Color scaffoldBackground = Color(0xFFF5F7FA);
  static const Color cardBackground = Colors.white;
  static const Color darkBackground = Color(0xFF1A1F3A);
  static const Color darkBackgroundSecondary = Color(0xFF2D3561);

  // Status Colors
  static const Color successGreen = Color(0xFF00D9A5);
  static const Color warningRed = Color(0xFFFF6B6B);
  static const Color warningOrange = Color(0xFFFF9933);
  static const Color errorRed = Color(0xFFFF6B6B);
  static const Color infoBlue = Color(0xFF3B82F6);
  static const Color completedGreen = Color(0xFF00D9A5);

  // Text Colors
  static const Color textPrimary = Color(0xFF1A1F3A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color textWhite = Colors.white;
  static const Color textDark = Color(0xFF1A1F3A);
  static const Color accentYellow = Color(0xFFFFD700);

  // Border Colors
  static const Color borderGray = Color(0xFFE2E8F0);
  static const Color dividerColor = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFE2E8F0);

  // Progress Colors
  static Color progressBarBackground = const Color(0xFFE2E8F0);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF6C5CE7),
    Color(0xFF5B4FD6),
  ];

  static const List<Color> darkGradient = [
    Color(0xFF1A1F3A),
    Color(0xFF2D3561),
  ];

  // Shadow Colors
  static Color shadowLight = Colors.black.withOpacity(0.05);
  static Color shadowMedium = Colors.black.withOpacity(0.1);
  static Color shadowPurple = const Color(0xFF6C5CE7).withOpacity(0.3);

  // Overlay Colors
  static Color overlayLight = Colors.white.withOpacity(0.1);
  static Color overlayMedium = Colors.white.withOpacity(0.2);

  // Helper method to get progress color based on value
  static Color getProgressColor(int progress) {
    if (progress >= 75) {
      return successGreen;
    } else if (progress >= 50) {
      return infoBlue;
    } else if (progress >= 25) {
      return const Color(0xFFFBB040);
    } else {
      return warningRed;
    }
  }

  // Helper method to get status color
  static Color getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'COMPLETED':
        return successGreen;
      case 'PENDING':
        return infoBlue;
      case 'SKIPPED':
        return warningRed;
      default:
        return textSecondary;
    }
  }
}
