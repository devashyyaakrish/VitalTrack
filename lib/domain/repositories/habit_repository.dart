import '../entities/habit_entity.dart';
import 'auth_repository.dart';
import '../../core/errors/failures.dart';

/// Repository interface for habit tracking
abstract class HabitRepository {
  Future<Either<Failure, HabitEntity>> createHabit({
    required String userId,
    required String name,
    String? description,
    String iconEmoji,
  });

  Future<Either<Failure, List<HabitEntity>>> getUserHabits(String userId);

  Future<Either<Failure, HabitEntity>> updateHabit(HabitEntity habit);

  Future<Either<Failure, void>> deleteHabit(String habitId);

  /// Mark (or unmark) a habit as completed for a given date
  Future<Either<Failure, HabitLogEntity>> toggleHabitLog({
    required String habitId,
    required String userId,
    required String dateKey,
  });

  /// Get all logs for a given week
  Future<Either<Failure, List<HabitLogEntity>>> getLogsForWeek({
    required String userId,
    required List<String> dateKeys,
  });
}
