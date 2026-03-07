import 'package:flutter/material.dart';

/// Useful Flutter/Dart extensions used throughout the app
extension ContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}

extension StringExtensions on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  bool get isValidEmail {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(trim());
  }
}

extension DoubleExtensions on double {
  /// Clamps value between 0.0 and 1.0 (for progress)
  double get asProgress => clamp(0.0, 1.0).toDouble();

  /// Formats double with max 1 decimal place
  String get compact {
    if (this == truncateToDouble()) return toInt().toString();
    return toStringAsFixed(1);
  }
}

extension IntExtensions on int {
  /// Format large numbers with commas
  String get formatted {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
  }
}

extension DateTimeExtensions on DateTime {
  bool isSameDayAs(DateTime other) =>
      year == other.year && month == other.month && day == other.day;

  bool get isToday => isSameDayAs(DateTime.now());
}
