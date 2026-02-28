import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/habit_entity.dart';
import '../../domain/repositories/habit_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/date_utils.dart';
import '../models/health_models.dart';

const _uuid = Uuid();

class MockHabitRepository implements HabitRepository {
  final Box<HabitModel> _habitBox;
  final Box<HabitLogModel> _logBox;

  MockHabitRepository({
    required Box<HabitModel> habitBox,
    required Box<HabitLogModel> logBox,
  })  : _habitBox = habitBox,
        _logBox = logBox;

  @override
  Future<Either<Failure, HabitEntity>> createHabit({
    required String userId,
    required String name,
    String? description,
    String iconEmoji = '✅',
  }) async {
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
    return Either.right(model.toEntity());
  }

  @override
  Future<Either<Failure, List<HabitEntity>>> getUserHabits(
      String userId) async {
    final habits = _habitBox.values
        .where((h) => h.userId == userId && h.isActive)
        .map((h) => h.toEntity())
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return Either.right(habits);
  }

  @override
  Future<Either<Failure, HabitEntity>> updateHabit(HabitEntity habit) async {
    final model = HabitModel.fromEntity(habit);
    await _habitBox.put(model.id, model);
    return Either.right(habit);
  }

  @override
  Future<Either<Failure, void>> deleteHabit(String habitId) async {
    final habit = _habitBox.get(habitId);
    if (habit == null) return const Either.right(null);
    habit.isActive = false;
    await _habitBox.put(habitId, habit);
    return const Either.right(null);
  }

  @override
  Future<Either<Failure, HabitLogEntity>> toggleHabitLog({
    required String habitId,
    required String userId,
    required String dateKey,
  }) async {
    // Check if log exists for this day
    final logs = _logBox.values
        .where((l) => l.habitId == habitId && l.dateKey == dateKey)
        .toList();

    final HabitLogModel log;
    if (logs.isEmpty) {
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
      final existing = logs.first;
      existing.isCompleted = !existing.isCompleted;
      await _logBox.put(existing.id, existing);
      log = existing;
    }

    // Update streak
    await _recalculateStreak(habitId, userId);

    return Either.right(log.toEntity());
  }

  @override
  Future<Either<Failure, List<HabitLogEntity>>> getLogsForWeek({
    required String userId,
    required List<String> dateKeys,
  }) async {
    final logs = _logBox.values
        .where((l) => l.userId == userId && dateKeys.contains(l.dateKey))
        .map((l) => l.toEntity())
        .toList();
    return Either.right(logs);
  }

  Future<void> _recalculateStreak(String habitId, String userId) async {
    final habit = _habitBox.get(habitId);
    if (habit == null) return;

    int streak = 0;
    final today = DateTime.now();

    for (int i = 0; i < 365; i++) {
      final day = today.subtract(Duration(days: i));
      final key = AppDateUtils.toDateKey(day);
      final log = _logBox.values
          .where(
              (l) => l.habitId == habitId && l.dateKey == key && l.isCompleted)
          .toList();
      if (log.isEmpty) break;
      streak++;
    }

    habit.currentStreak = streak;
    if (streak > habit.longestStreak) habit.longestStreak = streak;
    await _habitBox.put(habitId, habit);
  }
}
