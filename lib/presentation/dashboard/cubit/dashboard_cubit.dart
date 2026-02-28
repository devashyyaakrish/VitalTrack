import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/health_entities.dart';
import '../../../domain/repositories/health_repositories.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../core/errors/failures.dart';

// ── State ────────────────────────────────────────────────────────────────────

class DashboardState extends Equatable {
  final bool isLoading;
  final String? error;
  final int totalWaterMl;
  final int waterGoalMl;
  final int totalSteps;
  final int stepsGoal;
  final int totalCalories;
  final int caloriesGoal;
  final double sleepHours;
  final double sleepGoalHours;
  final String userName;
  final String quote;

  const DashboardState({
    this.isLoading = true,
    this.error,
    this.totalWaterMl = 0,
    this.waterGoalMl = 2000,
    this.totalSteps = 0,
    this.stepsGoal = 10000,
    this.totalCalories = 0,
    this.caloriesGoal = 2000,
    this.sleepHours = 0,
    this.sleepGoalHours = 8,
    this.userName = '',
    this.quote = '',
  });

  DashboardState copyWith({
    bool? isLoading,
    String? error,
    int? totalWaterMl,
    int? waterGoalMl,
    int? totalSteps,
    int? stepsGoal,
    int? totalCalories,
    int? caloriesGoal,
    double? sleepHours,
    double? sleepGoalHours,
    String? userName,
    String? quote,
  }) {
    return DashboardState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      totalWaterMl: totalWaterMl ?? this.totalWaterMl,
      waterGoalMl: waterGoalMl ?? this.waterGoalMl,
      totalSteps: totalSteps ?? this.totalSteps,
      stepsGoal: stepsGoal ?? this.stepsGoal,
      totalCalories: totalCalories ?? this.totalCalories,
      caloriesGoal: caloriesGoal ?? this.caloriesGoal,
      sleepHours: sleepHours ?? this.sleepHours,
      sleepGoalHours: sleepGoalHours ?? this.sleepGoalHours,
      userName: userName ?? this.userName,
      quote: quote ?? this.quote,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        totalWaterMl,
        totalSteps,
        totalCalories,
        sleepHours,
        userName,
        quote,
      ];
}

// ── Cubit ────────────────────────────────────────────────────────────────────

class DashboardCubit extends Cubit<DashboardState> {
  final WaterRepository _waterRepository;
  final StepRepository _stepRepository;
  final CalorieRepository _calorieRepository;
  final SleepRepository _sleepRepository;
  final AuthRepository _authRepository;

  DashboardCubit({
    required WaterRepository waterRepository,
    required StepRepository stepRepository,
    required CalorieRepository calorieRepository,
    required SleepRepository sleepRepository,
    required AuthRepository authRepository,
  })  : _waterRepository = waterRepository,
        _stepRepository = stepRepository,
        _calorieRepository = calorieRepository,
        _sleepRepository = sleepRepository,
        _authRepository = authRepository,
        super(const DashboardState());

  Future<void> loadDashboard() async {
    emit(state.copyWith(isLoading: true));
    final userResult = await _authRepository.getCurrentUser();
    final userId = userResult.isRight ? userResult.right?.id ?? '' : '';
    final user = userResult.isRight ? userResult.right : null;

    final results = await Future.wait([
      _waterRepository.getTodayEntries(userId),
      _stepRepository.getTodaySteps(userId),
      _calorieRepository.getTodayEntries(userId),
      _sleepRepository.getTodaySleep(userId),
    ]);

    final waterResult = results[0];
    final stepResult = results[1];
    final calorieResult = results[2];
    final sleepResult = results[3];

    int totalWater =
        (results[0] as Either<Failure, List<WaterEntryEntity>>).fold(
      (_) => 0,
      (entries) => entries.fold(0, (sum, e) => sum + e.amountMl),
    );

    int totalSteps = (results[1] as Either<Failure, int>).fold(
      (_) => 0,
      (steps) => steps,
    );

    int totalCalories =
        (results[2] as Either<Failure, List<CalorieEntryEntity>>).fold(
      (_) => 0,
      (entries) => entries.fold(0, (sum, e) => sum + e.calories),
    );

    double sleepHours = (results[3] as Either<Failure, SleepEntryEntity?>).fold(
      (_) => 0.0,
      (entry) => entry?.durationHours ?? 0.0,
    );

    // Random daily quote
    final quotes = [
      "Small steps every day lead to big changes.",
      "Your health is an investment, not an expense.",
      "Take care of your body. It's the only place you have to live.",
      "Consistency is the key to maintaining momentum.",
      "Every healthy meal is a victory. Keep going!",
    ];
    final quoteIndex = DateTime.now().day % quotes.length;

    emit(state.copyWith(
      isLoading: false,
      totalWaterMl: totalWater,
      waterGoalMl: user?.waterGoalMl ?? 2000,
      totalSteps: totalSteps,
      stepsGoal: user?.stepsGoal ?? 10000,
      totalCalories: totalCalories,
      caloriesGoal: user?.caloriesGoal ?? 2000,
      sleepHours: sleepHours,
      sleepGoalHours: user?.sleepGoalHours ?? 8.0,
      userName: user?.name.split(' ').first ?? '',
      quote: quotes[quoteIndex],
    ));
  }
}

// ignore helper
abstract class _EitherType {}
