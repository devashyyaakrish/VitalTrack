import 'package:flutter/material.dart';

/// VitalTrack — Premium Apple-inspired Color Palette
/// Deep Navy / Indigo / Glass system with vibrant metric accents
class AppColors {
  AppColors._();

  // ── Primary Brand ──────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF4F8EF7);       // Electric Blue
  static const Color primaryLight = Color(0xFF7EB0FF);
  static const Color primaryDark = Color(0xFF2563EB);
  static const Color secondary = Color(0xFF34D9C3);     // Cyan-Teal
  static const Color secondaryLight = Color(0xFF5EE8D6);
  static const Color secondaryDark = Color(0xFF0EA5A5);
  static const Color accent = Color(0xFF818CF8);        // Indigo accent
  static const Color accentPink = Color(0xFFF472B6);    // Pink accent

  // ── Semantic Colors ────────────────────────────────────────────────────────
  static const Color success = Color(0xFF34D399);
  static const Color warning = Color(0xFFFBBF24);
  static const Color error = Color(0xFFF87171);
  static const Color errorLight = Color(0xFFFF8A8A);
  static const Color info = Color(0xFF60A5FA);

  // ── Dark Theme Backgrounds (Primary Mode) ─────────────────────────────────
  static const Color backgroundDark = Color(0xFF080C20);    // Deep Space
  static const Color backgroundDark2 = Color(0xFF0D1333);   // Midnight Blue
  static const Color surfaceDark = Color(0xFF111827);
  static const Color cardDark = Color(0xFF1A2235);
  static const Color inputFillDark = Color(0xFF1E2A45);
  static const Color borderDark = Color(0xFF2A3A5C);
  static const Color progressTrackDark = Color(0xFF1E2A45);

  // ── Light Theme Backgrounds ───────────────────────────────────────────────
  static const Color backgroundLight = Color(0xFFF0F4FF);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color inputFillLight = Color(0xFFEEF2FF);
  static const Color borderLight = Color(0xFFD6E0FF);
  static const Color shadowLight = Color(0x0A4F8EF7);
  static const Color progressTrackLight = Color(0xFFE0E7FF);

  // ── Text Colors — Dark Theme ───────────────────────────────────────────────
  static const Color textPrimaryDark = Color(0xFFF1F5FF);
  static const Color textSecondaryDark = Color(0xFF9BA8C5);
  static const Color textDisabledDark = Color(0xFF4A5577);

  // ── Text Colors — Light Theme ─────────────────────────────────────────────
  static const Color textPrimaryLight = Color(0xFF0F1729);
  static const Color textSecondaryLight = Color(0xFF5A6589);
  static const Color textDisabledLight = Color(0xFF9BA8C5);

  // ── Glass / Frosted UI Tokens ─────────────────────────────────────────────
  static const Color glassWhite = Color(0x14FFFFFF);      // white 8%
  static const Color glassWhiteMed = Color(0x22FFFFFF);   // white 13%
  static const Color glassBorder = Color(0x28FFFFFF);     // white 16%
  static const Color glowBlue = Color(0x334F8EF7);        // blue glow shadow
  static const Color glowCyan = Color(0x2234D9C3);        // cyan glow shadow

  // ── Metric Accent Colors (vibrant) ────────────────────────────────────────
  static const Color waterColor = Color(0xFF38BDF8);      // Sky Blue
  static const Color stepsColor = Color(0xFF34D9B4);      // Emerald Teal
  static const Color caloriesColor = Color(0xFFFB923C);   // Warm Orange
  static const Color sleepColor = Color(0xFFA78BFA);      // Soft Violet
  static const Color habitsColor = Color(0xFFF472B6);     // Hot Pink

  // ── Gradient Definitions ──────────────────────────────────────────────────
  static const LinearGradient backgroundGradientDark = LinearGradient(
    colors: [Color(0xFF080C20), Color(0xFF0D1333), Color(0xFF111827)],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient backgroundGradientLight = LinearGradient(
    colors: [Color(0xFFEEF2FF), Color(0xFFF5F8FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4F8EF7), Color(0xFF34D9C3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient waterGradient = LinearGradient(
    colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient stepsGradient = LinearGradient(
    colors: [Color(0xFF0D9488), Color(0xFF34D9B4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient caloriesGradient = LinearGradient(
    colors: [Color(0xFFEA580C), Color(0xFFFB923C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sleepGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFFA78BFA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient habitsGradient = LinearGradient(
    colors: [Color(0xFFDB2777), Color(0xFFF472B6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
