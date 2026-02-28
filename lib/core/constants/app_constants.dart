/// App-wide constants
class AppConstants {
  AppConstants._();

  // Hive Box Names
  static const String userBox = 'user_box';
  static const String waterBox = 'water_box';
  static const String stepsBox = 'steps_box';
  static const String caloriesBox = 'calories_box';
  static const String sleepBox = 'sleep_box';
  static const String habitsBox = 'habits_box';
  static const String habitLogsBox = 'habit_logs_box';
  static const String settingsBox = 'settings_box';

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String waterCollection = 'water_entries';
  static const String stepsCollection = 'step_entries';
  static const String caloriesCollection = 'calorie_entries';
  static const String sleepCollection = 'sleep_entries';
  static const String habitsCollection = 'habits';
  static const String habitLogsCollection = 'habit_logs';

  // Default Daily Goals
  static const int defaultWaterGoalMl = 2000;
  static const int defaultStepsGoal = 10000;
  static const int defaultCaloriesGoal = 2000;
  static const double defaultSleepGoalHours = 8.0;

  // Notification IDs
  static const int waterNotificationId = 100;
  static const int habitNotificationId = 200;

  // SharedPreferences Keys
  static const String themeKey = 'theme_mode';
  static const String unitsKey = 'units';
  static const String waterReminderKey = 'water_reminder';
  static const String habitReminderKey = 'habit_reminder';
  static const String onboardingKey = 'onboarding_done';

  // Hive Type IDs
  static const int userModelTypeId = 0;
  static const int waterEntryTypeId = 1;
  static const int stepEntryTypeId = 2;
  static const int calorieEntryTypeId = 3;
  static const int sleepEntryTypeId = 4;
  static const int habitTypeId = 5;
  static const int habitLogTypeId = 6;

  // Quote refresh interval
  static const Duration quoteDuration = Duration(days: 1);

  // Motivational Quotes
  static const List<String> motivationalQuotes = [
    "Small steps every day lead to big changes.",
    "Your health is an investment, not an expense.",
    "Take care of your body. It's the only place you have to live.",
    "Consistency is the key to achieving and maintaining momentum.",
    "Every workout is progress. Every healthy meal is a victory.",
    "The groundwork for all happiness is good health.",
    "A healthy outside starts from the inside.",
    "Be stronger than your excuses.",
    "Your body can stand almost anything. It's your mind you have to convince.",
    "Don't stop when you're tired. Stop when you're done.",
  ];
}
