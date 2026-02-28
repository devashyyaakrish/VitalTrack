import 'package:hive/hive.dart';
import '../../domain/entities/health_entities.dart';
import '../../domain/entities/habit_entity.dart';
import '../../core/constants/app_constants.dart';

part 'health_models.g.dart';

// ─── Water Entry ───────────────────────────────────────────────────────────

@HiveType(typeId: AppConstants.waterEntryTypeId)
class WaterEntryModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final int amountMl;
  @HiveField(3)
  final DateTime timestamp;
  @HiveField(4)
  final String dateKey;

  WaterEntryModel({
    required this.id,
    required this.userId,
    required this.amountMl,
    required this.timestamp,
    required this.dateKey,
  });

  factory WaterEntryModel.fromEntity(WaterEntryEntity e) => WaterEntryModel(
        id: e.id,
        userId: e.userId,
        amountMl: e.amountMl,
        timestamp: e.timestamp,
        dateKey: e.dateKey,
      );

  factory WaterEntryModel.fromMap(Map<String, dynamic> map) => WaterEntryModel(
        id: map['id'],
        userId: map['userId'],
        amountMl: map['amountMl'],
        timestamp: DateTime.parse(map['timestamp']),
        dateKey: map['dateKey'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'amountMl': amountMl,
        'timestamp': timestamp.toIso8601String(),
        'dateKey': dateKey,
      };

  WaterEntryEntity toEntity() => WaterEntryEntity(
        id: id,
        userId: userId,
        amountMl: amountMl,
        timestamp: timestamp,
        dateKey: dateKey,
      );
}

// ─── Step Entry ────────────────────────────────────────────────────────────

@HiveType(typeId: AppConstants.stepEntryTypeId)
class StepEntryModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final int steps;
  @HiveField(3)
  final DateTime timestamp;
  @HiveField(4)
  final String dateKey;

  StepEntryModel({
    required this.id,
    required this.userId,
    required this.steps,
    required this.timestamp,
    required this.dateKey,
  });

  factory StepEntryModel.fromEntity(StepEntryEntity e) => StepEntryModel(
        id: e.id,
        userId: e.userId,
        steps: e.steps,
        timestamp: e.timestamp,
        dateKey: e.dateKey,
      );

  factory StepEntryModel.fromMap(Map<String, dynamic> map) => StepEntryModel(
        id: map['id'],
        userId: map['userId'],
        steps: map['steps'],
        timestamp: DateTime.parse(map['timestamp']),
        dateKey: map['dateKey'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'steps': steps,
        'timestamp': timestamp.toIso8601String(),
        'dateKey': dateKey,
      };

  StepEntryEntity toEntity() => StepEntryEntity(
        id: id,
        userId: userId,
        steps: steps,
        timestamp: timestamp,
        dateKey: dateKey,
      );
}

// ─── Calorie Entry ─────────────────────────────────────────────────────────

@HiveType(typeId: AppConstants.calorieEntryTypeId)
class CalorieEntryModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String mealName;
  @HiveField(3)
  final int calories;
  @HiveField(4)
  final DateTime timestamp;
  @HiveField(5)
  final String dateKey;

  CalorieEntryModel({
    required this.id,
    required this.userId,
    required this.mealName,
    required this.calories,
    required this.timestamp,
    required this.dateKey,
  });

  factory CalorieEntryModel.fromEntity(CalorieEntryEntity e) =>
      CalorieEntryModel(
        id: e.id,
        userId: e.userId,
        mealName: e.mealName,
        calories: e.calories,
        timestamp: e.timestamp,
        dateKey: e.dateKey,
      );

  factory CalorieEntryModel.fromMap(Map<String, dynamic> map) =>
      CalorieEntryModel(
        id: map['id'],
        userId: map['userId'],
        mealName: map['mealName'],
        calories: map['calories'],
        timestamp: DateTime.parse(map['timestamp']),
        dateKey: map['dateKey'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'mealName': mealName,
        'calories': calories,
        'timestamp': timestamp.toIso8601String(),
        'dateKey': dateKey,
      };

  CalorieEntryEntity toEntity() => CalorieEntryEntity(
        id: id,
        userId: userId,
        mealName: mealName,
        calories: calories,
        timestamp: timestamp,
        dateKey: dateKey,
      );
}

// ─── Sleep Entry ───────────────────────────────────────────────────────────

@HiveType(typeId: AppConstants.sleepEntryTypeId)
class SleepEntryModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final DateTime sleepStart;
  @HiveField(3)
  final DateTime sleepEnd;
  @HiveField(4)
  final double durationHours;
  @HiveField(5)
  final String dateKey;

  SleepEntryModel({
    required this.id,
    required this.userId,
    required this.sleepStart,
    required this.sleepEnd,
    required this.durationHours,
    required this.dateKey,
  });

  factory SleepEntryModel.fromEntity(SleepEntryEntity e) => SleepEntryModel(
        id: e.id,
        userId: e.userId,
        sleepStart: e.sleepStart,
        sleepEnd: e.sleepEnd,
        durationHours: e.durationHours,
        dateKey: e.dateKey,
      );

  factory SleepEntryModel.fromMap(Map<String, dynamic> map) => SleepEntryModel(
        id: map['id'],
        userId: map['userId'],
        sleepStart: DateTime.parse(map['sleepStart']),
        sleepEnd: DateTime.parse(map['sleepEnd']),
        durationHours: (map['durationHours'] as num).toDouble(),
        dateKey: map['dateKey'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'sleepStart': sleepStart.toIso8601String(),
        'sleepEnd': sleepEnd.toIso8601String(),
        'durationHours': durationHours,
        'dateKey': dateKey,
      };

  SleepEntryEntity toEntity() => SleepEntryEntity(
        id: id,
        userId: userId,
        sleepStart: sleepStart,
        sleepEnd: sleepEnd,
        durationHours: durationHours,
        dateKey: dateKey,
      );
}

// ─── Habit ─────────────────────────────────────────────────────────────────

@HiveType(typeId: AppConstants.habitTypeId)
class HabitModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String name;
  @HiveField(3)
  final String? description;
  @HiveField(4)
  final String iconEmoji;
  @HiveField(5)
  int currentStreak;
  @HiveField(6)
  int longestStreak;
  @HiveField(7)
  final DateTime createdAt;
  @HiveField(8)
  bool isActive;

  HabitModel({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    required this.iconEmoji,
    required this.currentStreak,
    required this.longestStreak,
    required this.createdAt,
    required this.isActive,
  });

  factory HabitModel.fromEntity(HabitEntity e) => HabitModel(
        id: e.id,
        userId: e.userId,
        name: e.name,
        description: e.description,
        iconEmoji: e.iconEmoji,
        currentStreak: e.currentStreak,
        longestStreak: e.longestStreak,
        createdAt: e.createdAt,
        isActive: e.isActive,
      );

  factory HabitModel.fromMap(Map<String, dynamic> map) => HabitModel(
        id: map['id'],
        userId: map['userId'],
        name: map['name'],
        description: map['description'],
        iconEmoji: map['iconEmoji'] ?? '✅',
        currentStreak: map['currentStreak'] ?? 0,
        longestStreak: map['longestStreak'] ?? 0,
        createdAt: DateTime.parse(map['createdAt']),
        isActive: map['isActive'] ?? true,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'userId': userId,
        'name': name,
        if (description != null) 'description': description,
        'iconEmoji': iconEmoji,
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'createdAt': createdAt.toIso8601String(),
        'isActive': isActive,
      };

  HabitEntity toEntity() => HabitEntity(
        id: id,
        userId: userId,
        name: name,
        description: description,
        iconEmoji: iconEmoji,
        currentStreak: currentStreak,
        longestStreak: longestStreak,
        createdAt: createdAt,
        isActive: isActive,
      );
}

// ─── Habit Log ─────────────────────────────────────────────────────────────

@HiveType(typeId: AppConstants.habitLogTypeId)
class HabitLogModel extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String habitId;
  @HiveField(2)
  final String userId;
  @HiveField(3)
  final String dateKey;
  @HiveField(4)
  bool isCompleted;
  @HiveField(5)
  final DateTime loggedAt;

  HabitLogModel({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.dateKey,
    required this.isCompleted,
    required this.loggedAt,
  });

  factory HabitLogModel.fromEntity(HabitLogEntity e) => HabitLogModel(
        id: e.id,
        habitId: e.habitId,
        userId: e.userId,
        dateKey: e.dateKey,
        isCompleted: e.isCompleted,
        loggedAt: e.loggedAt,
      );

  factory HabitLogModel.fromMap(Map<String, dynamic> map) => HabitLogModel(
        id: map['id'],
        habitId: map['habitId'],
        userId: map['userId'],
        dateKey: map['dateKey'],
        isCompleted: map['isCompleted'] ?? false,
        loggedAt: DateTime.parse(map['loggedAt']),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'habitId': habitId,
        'userId': userId,
        'dateKey': dateKey,
        'isCompleted': isCompleted,
        'loggedAt': loggedAt.toIso8601String(),
      };

  HabitLogEntity toEntity() => HabitLogEntity(
        id: id,
        habitId: habitId,
        userId: userId,
        dateKey: dateKey,
        isCompleted: isCompleted,
        loggedAt: loggedAt,
      );
}
