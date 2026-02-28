import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/health_entities.dart';
import '../../domain/repositories/health_repositories.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/date_utils.dart';
import '../models/health_models.dart';

const _uuid = Uuid();

// ─── Mock Water Repository ──────────────────────────────────────────────────────

class MockWaterRepository implements WaterRepository {
  final Box<WaterEntryModel> _box;
  MockWaterRepository({required Box<WaterEntryModel> box}) : _box = box;

  @override
  Future<Either<Failure, WaterEntryEntity>> addWaterEntry({
    required String userId,
    required int amountMl,
  }) async {
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
    return Either.right(model.toEntity());
  }

  @override
  Future<Either<Failure, List<WaterEntryEntity>>> getTodayEntries(
      String userId) async {
    final today = AppDateUtils.todayKey;
    final entries = _box.values
        .where((e) => e.userId == userId && e.dateKey == today)
        .map((e) => e.toEntity())
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return Either.right(entries);
  }

  @override
  Future<Either<Failure, List<WaterEntryEntity>>> getEntriesByDate({
    required String userId,
    required String dateKey,
  }) async {
    final entries = _box.values
        .where((e) => e.userId == userId && e.dateKey == dateKey)
        .map((e) => e.toEntity())
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return Either.right(entries);
  }

  @override
  Future<Either<Failure, void>> deleteEntry(String entryId) async {
    await _box.delete(entryId);
    return const Either.right(null);
  }

  @override
  Future<Either<Failure, Map<String, int>>> getWeeklyTotals(
      String userId) async {
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
  }
}

// ─── Mock Step Repository ────────────────────────────────────────────────────────

class MockStepRepository implements StepRepository {
  final Box<StepEntryModel> _box;
  MockStepRepository({required Box<StepEntryModel> box}) : _box = box;

  @override
  Future<Either<Failure, StepEntryEntity>> addStepEntry({
    required String userId,
    required int steps,
  }) async {
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
    return Either.right(model.toEntity());
  }

  @override
  Future<Either<Failure, int>> getTodaySteps(String userId) async {
    final today = AppDateUtils.todayKey;
    final total = _box.values
        .where((e) => e.userId == userId && e.dateKey == today)
        .fold<int>(0, (sum, e) => sum + e.steps);
    return Either.right(total);
  }

  @override
  Future<Either<Failure, List<StepEntryEntity>>> getEntriesByDate({
    required String userId,
    required String dateKey,
  }) async {
    final entries = _box.values
        .where((e) => e.userId == userId && e.dateKey == dateKey)
        .map((e) => e.toEntity())
        .toList();
    return Either.right(entries);
  }

  @override
  Future<Either<Failure, Map<String, int>>> getWeeklyTotals(
      String userId) async {
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
  }
}

// ─── Mock Calorie Repository ────────────────────────────────────────────────────

class MockCalorieRepository implements CalorieRepository {
  final Box<CalorieEntryModel> _box;
  MockCalorieRepository({required Box<CalorieEntryModel> box}) : _box = box;

  @override
  Future<Either<Failure, CalorieEntryEntity>> addCalorieEntry({
    required String userId,
    required String mealName,
    required int calories,
  }) async {
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
    return Either.right(model.toEntity());
  }

  @override
  Future<Either<Failure, List<CalorieEntryEntity>>> getTodayEntries(
      String userId) async {
    final today = AppDateUtils.todayKey;
    final entries = _box.values
        .where((e) => e.userId == userId && e.dateKey == today)
        .map((e) => e.toEntity())
        .toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return Either.right(entries);
  }

  @override
  Future<Either<Failure, void>> deleteEntry(String entryId) async {
    await _box.delete(entryId);
    return const Either.right(null);
  }

  @override
  Future<Either<Failure, Map<String, int>>> getWeeklyTotals(
      String userId) async {
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
  }
}

// ─── Mock Sleep Repository ──────────────────────────────────────────────────────

class MockSleepRepository implements SleepRepository {
  final Box<SleepEntryModel> _box;
  MockSleepRepository({required Box<SleepEntryModel> box}) : _box = box;

  @override
  Future<Either<Failure, SleepEntryEntity>> logSleep({
    required String userId,
    required DateTime sleepStart,
    required DateTime sleepEnd,
  }) async {
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
    // Remove existing entry for same day
    final existing =
        _box.values.where((e) => e.userId == userId && e.dateKey == dateKey);
    for (final e in existing) {
      await _box.delete(e.id);
    }
    await _box.put(id, model);
    return Either.right(model.toEntity());
  }

  @override
  Future<Either<Failure, SleepEntryEntity?>> getTodaySleep(
      String userId) async {
    final today = AppDateUtils.todayKey;
    final entries =
        _box.values.where((e) => e.userId == userId && e.dateKey == today);
    if (entries.isEmpty) return const Either.right(null);
    return Either.right(entries.first.toEntity());
  }

  @override
  Future<Either<Failure, Map<String, double>>> getWeeklyHours(
      String userId) async {
    final days = AppDateUtils.lastNDays(7);
    final result = <String, double>{};
    for (final day in days) {
      final key = AppDateUtils.toDateKey(day);
      final entries =
          _box.values.where((e) => e.userId == userId && e.dateKey == key);
      result[key] = entries.isEmpty ? 0.0 : entries.first.durationHours;
    }
    return Either.right(result);
  }
}
