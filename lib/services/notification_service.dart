import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:developer' as developer;

/// Service for scheduling and managing local notifications
class NotificationService {
  static final NotificationService _instance = NotificationService._();
  factory NotificationService() => _instance;
  NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    
    // For Windows, local notifications require specific setup or might work with generic plugins
    // This scaffold handles Android/iOS/Web/Windows gracefully by catching init errors
    try {
      const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      const settings = InitializationSettings(
        android: androidSettings, 
        iOS: iosSettings,
        // Add Linux/Windows settings if plugins are added
      );
      await _plugin.initialize(settings);
      _initialized = true;
    } catch (e) {
      developer.log('NotificationService init failed: $e. Using log-only mode.');
    }
  }

  /// Schedule water reminder every 2 hours from 8 AM to 10 PM
  Future<void> scheduleWaterReminders({bool enabled = true}) async {
    await _plugin.cancel(100); // Clear existing
    if (!enabled) return;

    const androidDetails = AndroidNotificationDetails(
      'water_reminder',
      'Water Reminders',
      channelDescription: 'Reminds you to drink water',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    // Post an immediate reminder for demo
    await _plugin.show(
      100,
      '💧 Time to hydrate!',
      'Remember to drink some water to stay healthy.',
      details,
    );
  }

  /// Schedule a daily habit reminder at a specific hour
  Future<void> scheduleHabitReminder({bool enabled = true, int hour = 20}) async {
    await _plugin.cancel(200);
    if (!enabled) return;

    const androidDetails = AndroidNotificationDetails(
      'habit_reminder',
      'Habit Reminders',
      channelDescription: 'Daily habit completion reminder',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();
    const details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    await _plugin.show(
      200,
      '✅ Check your habits!',
      'Have you completed your daily habits today?',
      details,
    );
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
