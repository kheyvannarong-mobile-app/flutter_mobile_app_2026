import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Theme: Light Frosted Glassmorphism 3D Botanical
  static const Color background = Color(0xFFE8F1EB); // Soft Misty Botanical Pale Green
  static const Color backgroundLight = Color(0xFFF2F7F4);
  static const Color backgroundEnd = Color(0xFFD6E6DC);

  // Frosted Glass Card Backgrounds
  static const Color glassSurface = Color(0x99FFFFFF); // 60% translucent white
  static const Color glassSurfaceLight = Color(0xBFFFFFFF); // 75% translucent white
  static const Color glassSurfaceStrong = Color(0xDDFFFFFF); // 87% translucent white
  static const Color glassBorder = Color(0xCCFFFFFF); // 80% white crisp border

  // Fallback Surface
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0x73FFFFFF); // 45% white pill input

  // Botanical Sage Green Accents (Matching new 3D reference image)
  static const Color primary = Color(0xFF4A7C59); // Rich Botanical Sage Green
  static const Color primaryDark = Color(0xFF2E583A);
  static const Color primaryLight = Color(0xFF6B9F7A);
  static const Color accent = Color(0xFF5B8E65); // Active Pill Green

  // Status & Badges
  static const Color badgeGreenBg = Color(0xFFDCEFE2);
  static const Color badgeGreenText = Color(0xFF256436);
  static const Color badgeAmberBg = Color(0xFFFEF3C7);
  static const Color badgeAmberText = Color(0xFF92400E);

  // Secondary Accents
  static const Color secondary = Color(0xFFD97736); // Warm terracotta
  static const Color success = Color(0xFF388E3C);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFF57C00);

  // Text Colors (High contrast and organic)
  static const Color textPrimary = Color(0xFF163323); // Deep Forest Slate / Dark Text
  static const Color textSecondary = Color(0xFF4D6E5A); // Medium Sage Green
  static const Color textMuted = Color(0xFF7E9A8A); // Subtle Hint Green
  static const Color textDark = Color(0xFF163323);

  // Border & Shadows
  static const Color border = Color(0x40FFFFFF);
  static const Color borderSubtle = Color(0x80FFFFFF);
  static const Color divider = Color(0x1F2E583A);
  static const Color shadowColor = Color(0x141E3D28);
}
