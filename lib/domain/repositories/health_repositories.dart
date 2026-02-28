import '../entities/health_entities.dart';
import 'auth_repository.dart';
import '../../core/errors/failures.dart';

/// Repository interface for water tracking
abstract class WaterRepository {
  Future<Either<Failure, WaterEntryEntity>> addWaterEntry({
    required String userId,
    required int amountMl,
  });

  Future<Either<Failure, List<WaterEntryEntity>>> getTodayEntries(String userId);

  Future<Either<Failure, List<WaterEntryEntity>>> getEntriesByDate({
    required String userId,
    required String dateKey,
  });

  Future<Either<Failure, void>> deleteEntry(String entryId);

  Future<Either<Failure, Map<String, int>>> getWeeklyTotals(String userId);
}

/// Repository interface for step tracking
abstract class StepRepository {
  Future<Either<Failure, StepEntryEntity>> addStepEntry({
    required String userId,
    required int steps,
  });

  Future<Either<Failure, int>> getTodaySteps(String userId);

  Future<Either<Failure, List<StepEntryEntity>>> getEntriesByDate({
    required String userId,
    required String dateKey,
  });

  Future<Either<Failure, Map<String, int>>> getWeeklyTotals(String userId);
}

/// Repository interface for calorie tracking
abstract class CalorieRepository {
  Future<Either<Failure, CalorieEntryEntity>> addCalorieEntry({
    required String userId,
    required String mealName,
    required int calories,
  });

  Future<Either<Failure, List<CalorieEntryEntity>>> getTodayEntries(String userId);

  Future<Either<Failure, void>> deleteEntry(String entryId);

  Future<Either<Failure, Map<String, int>>> getWeeklyTotals(String userId);
}

/// Repository interface for sleep tracking
abstract class SleepRepository {
  Future<Either<Failure, SleepEntryEntity>> logSleep({
    required String userId,
    required DateTime sleepStart,
    required DateTime sleepEnd,
  });

  Future<Either<Failure, SleepEntryEntity?>> getTodaySleep(String userId);

  Future<Either<Failure, Map<String, double>>> getWeeklyHours(String userId);
}
