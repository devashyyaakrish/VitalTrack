import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/health_entities.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/repositories/health_repositories.dart';
import '../../domain/repositories/habit_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_utils.dart';
import '../models/health_models.dart';

const _uuid = Uuid();

// ─── Water Repository ──────────────────────────────────────────────────────

class WaterRepositoryImpl implements WaterRepository {
  final FirebaseFirestore _firestore;
  final Box<WaterEntryModel> _box;

  WaterRepositoryImpl({required FirebaseFirestore firestore, required Box<WaterEntryModel> box})
      : _firestore = firestore,
        _box = box;

  @override
  Future<Either<Failure, WaterEntryEntity>> addWaterEntry({
    required String userId,
    required int amountMl,
  }) async {
    try {
      final now = DateTime.now();
      final id = _uuid.v4();
      final model = WaterEntryModel(
        id: id,
        userId: userId,
        amountMl: amountMl,
        timestamp: now,
        dateKey: AppDateUtils.toDateKey(now),
      );
      await _box.put(id, model);
      _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.waterCollection)
          .doc(id)
          .set(model.toMap())
          .catchError((_) {});
      return Either.right(model.toEntity());
    } catch (e) {
      return Either.left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WaterEntryEntity>>> getTodayEntries(String userId) async {
    try {
      final today = AppDateUtils.todayKey;
      final entries = _box.values
          .where((e) => e.userId == userId && e.dateKey == today)
          .map((e) => e.toEntity())
          .toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return Either.right(entries);
    } catch (e) {
      return Either.left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WaterEntryEntity>>> getEntriesByDate({
    required String userId,
    required String dateKey,
  }) async {
    try {
      final entries = _box.values
          .where((e) => e.userId == userId && e.dateKey == dateKey)
          .map((e) => e.toEntity())
          .toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return Either.right(entries);
    } catch (e) {
      return Either.left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEntry(String entryId) async {
    try {
      final entry = _box.get(entryId);
      if (entry == null) return const Either.right(null);
      await _box.delete(entryId);
      _firestore
          .collection(AppConstants.usersCollection)
          .doc(entry.userId)
          .collection(AppConstants.waterCollection)
          .doc(entryId)
          .delete()
          .catchError((_) {});
      return const Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getWeeklyTotals(String userId) async {
    try {
      final days = AppDateUtils.lastNDays(7);
      final result = <String, int>{};
      for (final day in days) {
        final key = AppDateUtils.toDateKey(day);
        final total = _box.values
            .where((e) => e.userId == userId && e.dateKey == key)
            .fold<int>(0, (sum, e) => sum + e.amountMl);
        result[key] = total;
      }
      return Either.right(result);
    } catch (e) {
      return Either.left(CacheFailure(message: e.toString()));
    }
  }
}

// ─── Step Repository ────────────────────────────────────────────────────────

class StepRepositoryImpl implements StepRepository {
  final FirebaseFirestore _firestore;
  final Box<StepEntryModel> _box;

  StepRepositoryImpl({required FirebaseFirestore firestore, required Box<StepEntryModel> box})
      : _firestore = firestore,
        _box = box;

  @override
  Future<Either<Failure, StepEntryEntity>> addStepEntry({
    required String userId,
    required int steps,
  }) async {
    try {
      final now = DateTime.now();
      final id = _uuid.v4();
      final model = StepEntryModel(
        id: id,
        userId: userId,
        steps: steps,
        timestamp: now,
        dateKey: AppDateUtils.toDateKey(now),
      );
      await _box.put(id, model);
      _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.stepsCollection)
          .doc(id)
          .set(model.toMap())
          .catchError((_) {});
      return Either.right(model.toEntity());
    } catch (e) {
      return Either.left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, int>> getTodaySteps(String userId) async {
    try {
      final today = AppDateUtils.todayKey;
      final total = _box.values
          .where((e) => e.userId == userId && e.dateKey == today)
          .fold<int>(0, (sum, e) => sum + e.steps);
      return Either.right(total);
    } catch (e) {
      return Either.left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StepEntryEntity>>> getEntriesByDate({
    required String userId,
    required String dateKey,
  }) async {
    try {
      final entries = _box.values
          .where((e) => e.userId == userId && e.dateKey == dateKey)
          .map((e) => e.toEntity())
          .toList();
      return Either.right(entries);
    } catch (e) {
      return Either.left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getWeeklyTotals(String userId) async {
    try {
      final days = AppDateUtils.lastNDays(7);
      final result = <String, int>{};
      for (final day in days) {
        final key = AppDateUtils.toDateKey(day);
        final total = _box.values
            .where((e) => e.userId == userId && e.dateKey == key)
            .fold<int>(0, (sum, e) => sum + e.steps);
        result[key] = total;
      }
      return Either.right(result);
    } catch (e) {
      return Either.left(CacheFailure(message: e.toString()));
    }
  }
}

// ─── Calorie Repository ────────────────────────────────────────────────────

class CalorieRepositoryImpl implements CalorieRepository {
  final FirebaseFirestore _firestore;
  final Box<CalorieEntryModel> _box;

  CalorieRepositoryImpl({
    required FirebaseFirestore firestore,
    required Box<CalorieEntryModel> box,
  })  : _firestore = firestore,
        _box = box;

  @override
  Future<Either<Failure, CalorieEntryEntity>> addCalorieEntry({
    required String userId,
    required String mealName,
    required int calories,
  }) async {
    try {
      final now = DateTime.now();
      final id = _uuid.v4();
      final model = CalorieEntryModel(
        id: id,
        userId: userId,
        mealName: mealName,
        calories: calories,
        timestamp: now,
        dateKey: AppDateUtils.toDateKey(now),
      );
      await _box.put(id, model);
      _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.caloriesCollection)
          .doc(id)
          .set(model.toMap())
          .catchError((_) {});
      return Either.right(model.toEntity());
    } catch (e) {
      return Either.left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CalorieEntryEntity>>> getTodayEntries(String userId) async {
    try {
      final today = AppDateUtils.todayKey;
      final entries = _box.values
          .where((e) => e.userId == userId && e.dateKey == today)
          .map((e) => e.toEntity())
          .toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return Either.right(entries);
    } catch (e) {
      return Either.left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEntry(String entryId) async {
    try {
      final entry = _box.get(entryId);
      if (entry == null) return const Either.right(null);
      await _box.delete(entryId);
      _firestore
          .collection(AppConstants.usersCollection)
          .doc(entry.userId)
          .collection(AppConstants.caloriesCollection)
          .doc(entryId)
          .delete()
          .catchError((_) {});
      return const Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, int>>> getWeeklyTotals(String userId) async {
    try {
      final days = AppDateUtils.lastNDays(7);
      final result = <String, int>{};
      for (final day in days) {
        final key = AppDateUtils.toDateKey(day);
        final total = _box.values
            .where((e) => e.userId == userId && e.dateKey == key)
            .fold<int>(0, (sum, e) => sum + e.calories);
        result[key] = total;
      }
      return Either.right(result);
    } catch (e) {
      return Either.left(CacheFailure(message: e.toString()));
    }
  }
}

// ─── Sleep Repository ──────────────────────────────────────────────────────

class SleepRepositoryImpl implements SleepRepository {
  final FirebaseFirestore _firestore;
  final Box<SleepEntryModel> _box;

  SleepRepositoryImpl({
    required FirebaseFirestore firestore,
    required Box<SleepEntryModel> box,
  })  : _firestore = firestore,
        _box = box;

  @override
  Future<Either<Failure, SleepEntryEntity>> logSleep({
    required String userId,
    required DateTime sleepStart,
    required DateTime sleepEnd,
  }) async {
    try {
      final id = _uuid.v4();
      final duration = AppDateUtils.durationInHours(sleepStart, sleepEnd);
      final dateKey = AppDateUtils.toDateKey(sleepEnd);
      final model = SleepEntryModel(
        id: id,
        userId: userId,
        sleepStart: sleepStart,
        sleepEnd: sleepEnd,
        durationHours: duration,
        dateKey: dateKey,
      );
      // Remove existing entry for same day (overwrite)
      final existing = _box.values.where((e) => e.userId == userId && e.dateKey == dateKey);
      for (final e in existing) {
        await _box.delete(e.id);
      }
      await _box.put(id, model);
      _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.sleepCollection)
          .doc(id)
          .set(model.toMap())
          .catchError((_) {});
      return Either.right(model.toEntity());
    } catch (e) {
      return Either.left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, SleepEntryEntity?>> getTodaySleep(String userId) async {
    try {
      final today = AppDateUtils.todayKey;
      final entries = _box.values.where((e) => e.userId == userId && e.dateKey == today);
      if (entries.isEmpty) return const Either.right(null);
      return Either.right(entries.first.toEntity());
    } catch (e) {
      return Either.left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, double>>> getWeeklyHours(String userId) async {
    try {
      final days = AppDateUtils.lastNDays(7);
      final result = <String, double>{};
      for (final day in days) {
        final key = AppDateUtils.toDateKey(day);
        final entries = _box.values.where((e) => e.userId == userId && e.dateKey == key);
        result[key] = entries.isEmpty ? 0.0 : entries.first.durationHours;
      }
      return Either.right(result);
    } catch (e) {
      return Either.left(CacheFailure(message: e.toString()));
    }
  }
}

// ─── Habit Repository ────────────────────────────────────────────────────────

class HabitRepositoryImpl implements HabitRepository {
  final FirebaseFirestore _firestore;
  final Box<HabitModel> _habitBox;
  final Box<HabitLogModel> _logBox;

  HabitRepositoryImpl({
    required FirebaseFirestore firestore,
    required Box<HabitModel> habitBox,
    required Box<HabitLogModel> logBox,
  })  : _firestore = firestore,
        _habitBox = habitBox,
        _logBox = logBox;

  @override
  Future<Either<Failure, HabitEntity>> createHabit({
    required String userId,
    required String name,
    String? description,
    String iconEmoji = '✅',
  }) async {
    try {
      final id = _uuid.v4();
      final model = HabitModel(
        id: id,
        userId: userId,
        name: name,
        description: description,
        iconEmoji: iconEmoji,
        currentStreak: 0,
        longestStreak: 0,
        createdAt: DateTime.now(),
        isActive: true,
      );
      await _habitBox.put(id, model);
      _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.habitsCollection)
          .doc(id)
          .set(model.toMap())
          .catchError((_) {});
      return Either.right(model.toEntity());
    } catch (e) {
      return Either.left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HabitEntity>>> getUserHabits(String userId) async {
    try {
      final habits = _habitBox.values
          .where((h) => h.userId == userId && h.isActive)
          .map((h) => h.toEntity())
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Either.right(habits);
    } catch (e) {
      return Either.left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, HabitEntity>> updateHabit(HabitEntity habit) async {
    try {
      final model = HabitModel.fromEntity(habit);
      await _habitBox.put(model.id, model);
      _firestore
          .collection(AppConstants.usersCollection)
          .doc(habit.userId)
          .collection(AppConstants.habitsCollection)
          .doc(habit.id)
          .update(model.toMap())
          .catchError((_) {});
      return Either.right(habit);
    } catch (e) {
      return Either.left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteHabit(String habitId) async {
    try {
      final habit = _habitBox.get(habitId);
      if (habit == null) return const Either.right(null);
      habit.isActive = false;
      await _habitBox.put(habitId, habit);
      _firestore
          .collection(AppConstants.usersCollection)
          .doc(habit.userId)
          .collection(AppConstants.habitsCollection)
          .doc(habitId)
          .update({'isActive': false})
          .catchError((_) {});
      return const Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, HabitLogEntity>> toggleHabitLog({
    required String habitId,
    required String userId,
    required String dateKey,
  }) async {
    try {
      // Check if log exists for this day
      final existing = _logBox.values.firstWhere(
        (l) => l.habitId == habitId && l.dateKey == dateKey,
        orElse: () => HabitLogModel(
          id: '',
          habitId: habitId,
          userId: userId,
          dateKey: dateKey,
          isCompleted: false,
          loggedAt: DateTime.now(),
        ),
      );

      final HabitLogModel log;
      if (existing.id.isEmpty) {
        // Create new log
        final id = _uuid.v4();
        log = HabitLogModel(
          id: id,
          habitId: habitId,
          userId: userId,
          dateKey: dateKey,
          isCompleted: true,
          loggedAt: DateTime.now(),
        );
        await _logBox.put(id, log);
      } else {
        // Toggle existing
        existing.isCompleted = !existing.isCompleted;
        await _logBox.put(existing.id, existing);
        log = existing;
      }

      // Update streak
      await _recalculateStreak(habitId, userId);

      // Sync to Firestore
      _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .collection(AppConstants.habitLogsCollection)
          .doc(log.id)
          .set(log.toMap())
          .catchError((_) {});

      return Either.right(log.toEntity());
    } catch (e) {
      return Either.left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HabitLogEntity>>> getLogsForWeek({
    required String userId,
    required List<String> dateKeys,
  }) async {
    try {
      final logs = _logBox.values
          .where((l) => l.userId == userId && dateKeys.contains(l.dateKey))
          .map((l) => l.toEntity())
          .toList();
      return Either.right(logs);
    } catch (e) {
      return Either.left(CacheFailure(message: e.toString()));
    }
  }

  /// Recalculates the current streak for a habit based on consecutive completed days
  Future<void> _recalculateStreak(String habitId, String userId) async {
    final habit = _habitBox.get(habitId);
    if (habit == null) return;

    int streak = 0;
    final today = DateTime.now();

    for (int i = 0; i < 365; i++) {
      final day = today.subtract(Duration(days: i));
      final key = AppDateUtils.toDateKey(day);
      final log = _logBox.values
          .where((l) => l.habitId == habitId && l.dateKey == key && l.isCompleted)
          .toList();
      if (log.isEmpty) break;
      streak++;
    }

    habit.currentStreak = streak;
    if (streak > habit.longestStreak) habit.longestStreak = streak;
    await _habitBox.put(habitId, habit);
  }
}
