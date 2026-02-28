import 'package:equatable/equatable.dart';

/// Water intake entry entity
class WaterEntryEntity extends Equatable {
  final String id;
  final String userId;
  final int amountMl;
  final DateTime timestamp;
  final String dateKey; // 'yyyy-MM-dd'

  const WaterEntryEntity({
    required this.id,
    required this.userId,
    required this.amountMl,
    required this.timestamp,
    required this.dateKey,
  });

  @override
  List<Object?> get props => [id, userId, amountMl, timestamp, dateKey];
}

/// Step entry entity
class StepEntryEntity extends Equatable {
  final String id;
  final String userId;
  final int steps;
  final DateTime timestamp;
  final String dateKey;

  const StepEntryEntity({
    required this.id,
    required this.userId,
    required this.steps,
    required this.timestamp,
    required this.dateKey,
  });

  @override
  List<Object?> get props => [id, userId, steps, timestamp, dateKey];
}

/// Calorie entry entity (a single meal)
class CalorieEntryEntity extends Equatable {
  final String id;
  final String userId;
  final String mealName;
  final int calories;
  final DateTime timestamp;
  final String dateKey;

  const CalorieEntryEntity({
    required this.id,
    required this.userId,
    required this.mealName,
    required this.calories,
    required this.timestamp,
    required this.dateKey,
  });

  @override
  List<Object?> get props => [id, userId, mealName, calories, timestamp, dateKey];
}

/// Sleep entry entity
class SleepEntryEntity extends Equatable {
  final String id;
  final String userId;
  final DateTime sleepStart;
  final DateTime sleepEnd;
  final double durationHours;
  final String dateKey; // The date the user woke up

  const SleepEntryEntity({
    required this.id,
    required this.userId,
    required this.sleepStart,
    required this.sleepEnd,
    required this.durationHours,
    required this.dateKey,
  });

  @override
  List<Object?> get props => [id, userId, sleepStart, sleepEnd, durationHours, dateKey];
}
