import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/health_entities.dart';
import '../../../domain/repositories/health_repositories.dart';
import '../../../domain/repositories/auth_repository.dart';

// ── Water Cubit ──────────────────────────────────────────────────────────────

class WaterState extends Equatable {
  final bool isLoading;
  final List<WaterEntryEntity> entries;
  final int goalMl;
  final String? error;
  final String? successMessage;

  int get totalMl => entries.fold(0, (sum, e) => sum + e.amountMl);
  double get progress => goalMl > 0 ? (totalMl / goalMl).clamp(0.0, 1.0) : 0.0;

  const WaterState({
    this.isLoading = false,
    this.entries = const [],
    this.goalMl = 2000,
    this.error,
    this.successMessage,
  });

  WaterState copyWith({
    bool? isLoading,
    List<WaterEntryEntity>? entries,
    int? goalMl,
    String? error,
    String? successMessage,
  }) {
    return WaterState(
      isLoading: isLoading ?? this.isLoading,
      entries: entries ?? this.entries,
      goalMl: goalMl ?? this.goalMl,
      error: error,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, entries, goalMl, error, successMessage];
}

class WaterCubit extends Cubit<WaterState> {
  final WaterRepository _waterRepository;
  final AuthRepository _authRepository;

  WaterCubit({
    required WaterRepository waterRepository,
    required AuthRepository authRepository,
  })  : _waterRepository = waterRepository,
        _authRepository = authRepository,
        super(const WaterState());

  Future<void> loadTodayEntries() async {
    emit(state.copyWith(isLoading: true));
    final userResult = await _authRepository.getCurrentUser();
    if (!userResult.isRight || userResult.right == null) return;
    final user = userResult.right!;
    final result = await _waterRepository.getTodayEntries(user.id);
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (entries) => emit(state.copyWith(
        isLoading: false,
        entries: entries,
        goalMl: user.waterGoalMl,
      )),
    );
  }

  Future<void> addWater(int amountMl) async {
    final userResult = await _authRepository.getCurrentUser();
    if (!userResult.isRight || userResult.right == null) return;
    final result = await _waterRepository.addWaterEntry(
      userId: userResult.right!.id,
      amountMl: amountMl,
    );
    result.fold(
      (f) => emit(state.copyWith(error: f.message)),
      (entry) {
        final updated = [...state.entries, entry];
        emit(state.copyWith(
          entries: updated,
          successMessage: '+$amountMl ml added!',
        ));
      },
    );
  }

  Future<void> deleteEntry(String entryId) async {
    await _waterRepository.deleteEntry(entryId);
    final updated = state.entries.where((e) => e.id != entryId).toList();
    emit(state.copyWith(entries: updated));
  }
}

// ── Step Cubit ───────────────────────────────────────────────────────────────

class StepState extends Equatable {
  final bool isLoading;
  final int totalSteps;
  final int goalSteps;
  final String? error;
  final String? successMessage;

  double get progress =>
      goalSteps > 0 ? (totalSteps / goalSteps).clamp(0.0, 1.0) : 0.0;

  const StepState({
    this.isLoading = false,
    this.totalSteps = 0,
    this.goalSteps = 10000,
    this.error,
    this.successMessage,
  });

  StepState copyWith({
    bool? isLoading,
    int? totalSteps,
    int? goalSteps,
    String? error,
    String? successMessage,
  }) {
    return StepState(
      isLoading: isLoading ?? this.isLoading,
      totalSteps: totalSteps ?? this.totalSteps,
      goalSteps: goalSteps ?? this.goalSteps,
      error: error,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, totalSteps, goalSteps, error, successMessage];
}

class StepCubit extends Cubit<StepState> {
  final StepRepository _stepRepository;
  final AuthRepository _authRepository;

  StepCubit({
    required StepRepository stepRepository,
    required AuthRepository authRepository,
  })  : _stepRepository = stepRepository,
        _authRepository = authRepository,
        super(const StepState());

  Future<void> loadTodaySteps() async {
    emit(state.copyWith(isLoading: true));
    final userResult = await _authRepository.getCurrentUser();
    if (!userResult.isRight || userResult.right == null) return;
    final user = userResult.right!;
    final result = await _stepRepository.getTodaySteps(user.id);
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (steps) => emit(state.copyWith(
        isLoading: false,
        totalSteps: steps,
        goalSteps: user.stepsGoal,
      )),
    );
  }

  Future<void> addSteps(int steps) async {
    final userResult = await _authRepository.getCurrentUser();
    if (!userResult.isRight || userResult.right == null) return;
    final result = await _stepRepository.addStepEntry(
      userId: userResult.right!.id,
      steps: steps,
    );
    result.fold(
      (f) => emit(state.copyWith(error: f.message)),
      (_) => emit(state.copyWith(
        totalSteps: state.totalSteps + steps,
        successMessage: '+$steps steps logged!',
      )),
    );
  }
}

// ── Calorie Cubit ─────────────────────────────────────────────────────────────

class CalorieState extends Equatable {
  final bool isLoading;
  final List<CalorieEntryEntity> entries;
  final int goalCalories;
  final String? error;
  final String? successMessage;

  int get totalCalories => entries.fold(0, (sum, e) => sum + e.calories);
  double get progress =>
      goalCalories > 0 ? (totalCalories / goalCalories).clamp(0.0, 1.0) : 0.0;

  const CalorieState({
    this.isLoading = false,
    this.entries = const [],
    this.goalCalories = 2000,
    this.error,
    this.successMessage,
  });

  CalorieState copyWith({
    bool? isLoading,
    List<CalorieEntryEntity>? entries,
    int? goalCalories,
    String? error,
    String? successMessage,
  }) {
    return CalorieState(
      isLoading: isLoading ?? this.isLoading,
      entries: entries ?? this.entries,
      goalCalories: goalCalories ?? this.goalCalories,
      error: error,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, entries, goalCalories, error, successMessage];
}

class CalorieCubit extends Cubit<CalorieState> {
  final CalorieRepository _calorieRepository;
  final AuthRepository _authRepository;

  CalorieCubit({
    required CalorieRepository calorieRepository,
    required AuthRepository authRepository,
  })  : _calorieRepository = calorieRepository,
        _authRepository = authRepository,
        super(const CalorieState());

  Future<void> loadTodayEntries() async {
    emit(state.copyWith(isLoading: true));
    final userResult = await _authRepository.getCurrentUser();
    if (!userResult.isRight || userResult.right == null) return;
    final user = userResult.right!;
    final result = await _calorieRepository.getTodayEntries(user.id);
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (entries) => emit(state.copyWith(
        isLoading: false,
        entries: entries,
        goalCalories: user.caloriesGoal,
      )),
    );
  }

  Future<void> addMeal({required String name, required int calories}) async {
    final userResult = await _authRepository.getCurrentUser();
    if (!userResult.isRight || userResult.right == null) return;
    final result = await _calorieRepository.addCalorieEntry(
      userId: userResult.right!.id,
      mealName: name,
      calories: calories,
    );
    result.fold(
      (f) => emit(state.copyWith(error: f.message)),
      (entry) => emit(state.copyWith(
        entries: [...state.entries, entry],
        successMessage: '${entry.mealName} logged!',
      )),
    );
  }

  Future<void> deleteEntry(String entryId) async {
    await _calorieRepository.deleteEntry(entryId);
    emit(state.copyWith(
        entries: state.entries.where((e) => e.id != entryId).toList()));
  }
}

// ── Sleep Cubit ───────────────────────────────────────────────────────────────

class SleepState extends Equatable {
  final bool isLoading;
  final SleepEntryEntity? todaySleep;
  final double goalHours;
  final String? error;
  final String? successMessage;

  double get progress => goalHours > 0
      ? ((todaySleep?.durationHours ?? 0) / goalHours).clamp(0.0, 1.0)
      : 0.0;

  const SleepState({
    this.isLoading = false,
    this.todaySleep,
    this.goalHours = 8.0,
    this.error,
    this.successMessage,
  });

  SleepState copyWith({
    bool? isLoading,
    SleepEntryEntity? todaySleep,
    bool clearSleep = false,
    double? goalHours,
    String? error,
    String? successMessage,
  }) {
    return SleepState(
      isLoading: isLoading ?? this.isLoading,
      todaySleep: clearSleep ? null : (todaySleep ?? this.todaySleep),
      goalHours: goalHours ?? this.goalHours,
      error: error,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, todaySleep, goalHours, error, successMessage];
}

class SleepCubit extends Cubit<SleepState> {
  final SleepRepository _sleepRepository;
  final AuthRepository _authRepository;

  SleepCubit({
    required SleepRepository sleepRepository,
    required AuthRepository authRepository,
  })  : _sleepRepository = sleepRepository,
        _authRepository = authRepository,
        super(const SleepState());

  Future<void> loadTodaySleep() async {
    emit(state.copyWith(isLoading: true));
    final userResult = await _authRepository.getCurrentUser();
    if (!userResult.isRight || userResult.right == null) return;
    final user = userResult.right!;
    final result = await _sleepRepository.getTodaySleep(user.id);
    result.fold(
      (f) => emit(state.copyWith(isLoading: false, error: f.message)),
      (sleep) => emit(state.copyWith(
        isLoading: false,
        todaySleep: sleep,
        goalHours: user.sleepGoalHours,
      )),
    );
  }

  Future<void> logSleep({
    required DateTime sleepStart,
    required DateTime sleepEnd,
  }) async {
    final userResult = await _authRepository.getCurrentUser();
    if (!userResult.isRight || userResult.right == null) return;
    final result = await _sleepRepository.logSleep(
      userId: userResult.right!.id,
      sleepStart: sleepStart,
      sleepEnd: sleepEnd,
    );
    result.fold(
      (f) => emit(state.copyWith(error: f.message)),
      (sleep) => emit(state.copyWith(
        todaySleep: sleep,
        successMessage:
            'Sleep logged: ${sleep.durationHours.toStringAsFixed(1)} hours',
      )),
    );
  }
}
