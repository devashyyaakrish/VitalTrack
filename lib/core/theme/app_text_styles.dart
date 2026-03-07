import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // ── Display / Hero ─────────────────────────────────────────────────────────
  static const TextStyle displayHero = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.2,
    fontFamily: 'Inter',
  );

  // ── Headings ───────────────────────────────────────────────────────────────
  static const TextStyle headingLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.8,
    fontFamily: 'Inter',
  );

  static const TextStyle headingMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    fontFamily: 'Inter',
  );

  static const TextStyle headingSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.3,
    fontFamily: 'Inter',
  );

  // ── Body ───────────────────────────────────────────────────────────────────
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    fontFamily: 'Inter',
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.15,
    fontFamily: 'Inter',
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    fontFamily: 'Inter',
  );

  // ── Labels ─────────────────────────────────────────────────────────────────
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    fontFamily: 'Inter',
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.4,
    fontFamily: 'Inter',
  );

  // ── Button ─────────────────────────────────────────────────────────────────
  static const TextStyle buttonText = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
    fontFamily: 'Inter',
  );

  // ── Metric Display ─────────────────────────────────────────────────────────
  static const TextStyle metricValue = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w800,
    letterSpacing: -1.5,
    fontFamily: 'Inter',
  );

  static const TextStyle metricUnit = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.3,
    fontFamily: 'Inter',
  );

  // ── Caption ────────────────────────────────────────────────────────────────
  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    fontFamily: 'Inter',
  );

  // ── Section Header (all-caps) ──────────────────────────────────────────────
  static const TextStyle sectionHeader = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    fontFamily: 'Inter',
  );

  // ── Theme Text Themes ──────────────────────────────────────────────────────
  static TextTheme get lightTextTheme => TextTheme(
        displayLarge: headingLarge.copyWith(color: AppColors.textPrimaryLight),
        displayMedium: headingMedium.copyWith(color: AppColors.textPrimaryLight),
        displaySmall: headingSmall.copyWith(color: AppColors.textPrimaryLight),
        headlineMedium: headingMedium.copyWith(color: AppColors.textPrimaryLight),
        titleLarge: headingSmall.copyWith(color: AppColors.textPrimaryLight),
        titleMedium: labelLarge.copyWith(color: AppColors.textPrimaryLight),
        bodyLarge: bodyLarge.copyWith(color: AppColors.textPrimaryLight),
        bodyMedium: bodyMedium.copyWith(color: AppColors.textPrimaryLight),
        bodySmall: bodySmall.copyWith(color: AppColors.textSecondaryLight),
        labelLarge: labelLarge.copyWith(color: AppColors.textPrimaryLight),
        labelMedium: labelMedium.copyWith(color: AppColors.textSecondaryLight),
        labelSmall: caption.copyWith(color: AppColors.textSecondaryLight),
      );

  static TextTheme get darkTextTheme => TextTheme(
        displayLarge: headingLarge.copyWith(color: AppColors.textPrimaryDark),
        displayMedium: headingMedium.copyWith(color: AppColors.textPrimaryDark),
        displaySmall: headingSmall.copyWith(color: AppColors.textPrimaryDark),
        headlineMedium: headingMedium.copyWith(color: AppColors.textPrimaryDark),
        titleLarge: headingSmall.copyWith(color: AppColors.textPrimaryDark),
        titleMedium: labelLarge.copyWith(color: AppColors.textPrimaryDark),
        bodyLarge: bodyLarge.copyWith(color: AppColors.textPrimaryDark),
        bodyMedium: bodyMedium.copyWith(color: AppColors.textPrimaryDark),
        bodySmall: bodySmall.copyWith(color: AppColors.textSecondaryDark),
        labelLarge: labelLarge.copyWith(color: AppColors.textPrimaryDark),
        labelMedium: labelMedium.copyWith(color: AppColors.textSecondaryDark),
        labelSmall: caption.copyWith(color: AppColors.textSecondaryDark),
      );
}
