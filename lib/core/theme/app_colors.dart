// File: lib/core/theme/app_colors.dart
import 'package:flutter/material.dart';

/// App color palette
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // Primary Colors
  static const Color primary = Color(0xFF2563EB); // Blue
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFF3B82F6);

  // Secondary Colors
  static const Color secondary = Color(0xFF10B981); // Green
  static const Color secondaryDark = Color(0xFF059669);
  static const Color secondaryLight = Color(0xFF34D399);

  // Accent Colors
  static const Color accent = Color(0xFFF59E0B); // Amber
  static const Color accentDark = Color(0xFFD97706);
  static const Color accentLight = Color(0xFFFBBF24);

  // Background Colors
  static const Color background = Color(0xFFFAFAFA);
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E1E);

  // Text Colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textWhite = Color(0xFFFFFFFF);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFFD1FAE5);
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFDBEAFE);

  // Border Colors
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF374151);

  // Disabled Colors
  static const Color disabled = Color(0xFFD1D5DB);
  static const Color disabledBackground = Color(0xFFF3F4F6);

  // Shadow Colors
  static const Color shadow = Color(0x1A000000);
  static const Color shadowLight = Color(0x0D000000);

  // Gradient Colors
  static const List<Color> primaryGradient = [
    Color(0xFF2563EB),
    Color(0xFF3B82F6),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFF10B981),
    Color(0xFF34D399),
  ];

  // Course Category Colors
  static const Color categoryMath = Color(0xFF3B82F6);
  static const Color categoryPhysics = Color(0xFF10B981);
  static const Color categoryChemistry = Color(0xFFF59E0B);
  static const Color categoryBiology = Color(0xFFEF4444);
  static const Color categoryEnglish = Color(0xFF8B5CF6);
  static const Color categoryOther = Color(0xFF6B7280);

  // Progress Colors
  static const Color progressBackground = Color(0xFFE5E7EB);
  static const Color progressFill = Color(0xFF10B981);

  // Video Player Colors
  static const Color videoBackground = Color(0xFF000000);
  static const Color videoOverlay = Color(0x80000000);

  // Rating Colors
  static const Color starActive = Color(0xFFFBBF24);
  static const Color starInactive = Color(0xFFD1D5DB);
}
