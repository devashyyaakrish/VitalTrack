import 'package:flutter/material.dart';

/// VitalTrack Color Palette — Blue/Green health theme
class AppColors {
  AppColors._();

  // Primary Brand Colors
  static const Color primary = Color(0xFF2D7DD2);      // Blue
  static const Color primaryLight = Color(0xFF5B9BD5);
  static const Color primaryDark = Color(0xFF1A5FA6);
  static const Color secondary = Color(0xFF2DC1A0);    // Teal-Green
  static const Color secondaryLight = Color(0xFF56CEB5);
  static const Color secondaryDark = Color(0xFF1A9B7E);
  static const Color accent = Color(0xFF8EC3F5);       // Soft blue accent

  // Semantic Colors
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFE74C3C);
  static const Color errorLight = Color(0xFFFF6B6B);
  static const Color info = Color(0xFF3498DB);

  // Light Theme Surfaces
  static const Color backgroundLight = Color(0xFFF4F7FC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color inputFillLight = Color(0xFFF0F4FA);
  static const Color borderLight = Color(0xFFE2EAF4);
  static const Color shadowLight = Color(0x0D2D7DD2);
  static const Color progressTrackLight = Color(0xFFE2EAF4);

  // Dark Theme Surfaces
  static const Color backgroundDark = Color(0xFF0F1624);
  static const Color surfaceDark = Color(0xFF1A2540);
  static const Color cardDark = Color(0xFF1E2D4A);
  static const Color inputFillDark = Color(0xFF243050);
  static const Color borderDark = Color(0xFF2E3E60);
  static const Color progressTrackDark = Color(0xFF2E3E60);

  // Text Colors — Light
  static const Color textPrimaryLight = Color(0xFF1A2340);
  static const Color textSecondaryLight = Color(0xFF6B7A9A);
  static const Color textDisabledLight = Color(0xFFADB8CC);

  // Text Colors — Dark
  static const Color textPrimaryDark = Color(0xFFEAF0FF);
  static const Color textSecondaryDark = Color(0xFF8A9BC0);
  static const Color textDisabledDark = Color(0xFF4A5B7A);

  // Metric Colors (for tracker cards)
  static const Color waterColor = Color(0xFF2D9CD4);
  static const Color stepsColor = Color(0xFF2DC1A0);
  static const Color caloriesColor = Color(0xFFE8834A);
  static const Color sleepColor = Color(0xFF8B5CF6);
  static const Color habitsColor = Color(0xFFEC4899);

  // Gradient definitions
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2D7DD2), Color(0xFF2DC1A0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient waterGradient = LinearGradient(
    colors: [Color(0xFF2D9CD4), Color(0xFF5BC8F5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient stepsGradient = LinearGradient(
    colors: [Color(0xFF2DC1A0), Color(0xFF5BDABE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient caloriesGradient = LinearGradient(
    colors: [Color(0xFFE8834A), Color(0xFFF5A878)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sleepGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
