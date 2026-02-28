import 'package:intl/intl.dart';

/// Date/time utility helpers
class AppDateUtils {
  AppDateUtils._();

  static final DateFormat _dayFormat = DateFormat('yyyy-MM-dd');
  static final DateFormat _displayDate = DateFormat('EEE, d MMM');
  static final DateFormat _timeFormat = DateFormat('h:mm a');
  static final DateFormat _monthFormat = DateFormat('MMMM yyyy');

  /// Returns a normalized date string 'yyyy-MM-dd' (no time component)
  static String toDateKey(DateTime dt) => _dayFormat.format(dt);

  /// Today's date key
  static String get todayKey => toDateKey(DateTime.now());

  /// Friendly display format like "Thu, 26 Feb"
  static String displayDate(DateTime dt) => _displayDate.format(dt);

  /// Time format: "9:30 AM"
  static String displayTime(DateTime dt) => _timeFormat.format(dt);

  /// Month format: "February 2026"
  static String displayMonth(DateTime dt) => _monthFormat.format(dt);

  /// Calculate duration between two DateTimes in hours (double)
  static double durationInHours(DateTime start, DateTime end) {
    if (end.isBefore(start)) {
      // Handle overnight sleep
      final adjusted = end.add(const Duration(days: 1));
      return adjusted.difference(start).inMinutes / 60.0;
    }
    return end.difference(start).inMinutes / 60.0;
  }

  /// Returns list of last [n] dates (most recent last)
  static List<DateTime> lastNDays(int n) {
    final today = DateTime.now();
    return List.generate(n, (i) => today.subtract(Duration(days: n - 1 - i)));
  }

  /// Returns the 7 days of the current week starting Monday
  static List<DateTime> currentWeek() {
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    return List.generate(7, (i) => monday.add(Duration(days: i)));
  }

  /// Checks if two DateTimes are the same calendar day
  static bool isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  /// Greeting based on current hour
  static String get greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}
