import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/repositories/health_repositories.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../core/errors/failures.dart';

class AnalyticsState extends Equatable {
  final bool isLoading;
  final Map<String, int> weeklyWater; // dateKey -> ml
  final Map<String, int> weeklySteps; // dateKey -> steps
  final Map<String, int> weeklyCalories; // dateKey -> cals
  final Map<String, double> weeklySleep; // dateKey -> hours
  final bool showWeekly;
  final String? error;

  const AnalyticsState({
    this.isLoading = false,
    this.weeklyWater = const {},
    this.weeklySteps = const {},
    this.weeklyCalories = const {},
    this.weeklySleep = const {},
    this.showWeekly = true,
    this.error,
  });

  AnalyticsState copyWith({
    bool? isLoading,
    Map<String, int>? weeklyWater,
    Map<String, int>? weeklySteps,
    Map<String, int>? weeklyCalories,
    Map<String, double>? weeklySleep,
    bool? showWeekly,
    String? error,
  }) {
    return AnalyticsState(
      isLoading: isLoading ?? this.isLoading,
      weeklyWater: weeklyWater ?? this.weeklyWater,
      weeklySteps: weeklySteps ?? this.weeklySteps,
      weeklyCalories: weeklyCalories ?? this.weeklyCalories,
      weeklySleep: weeklySleep ?? this.weeklySleep,
      showWeekly: showWeekly ?? this.showWeekly,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        weeklyWater,
        weeklySteps,
        weeklyCalories,
        weeklySleep,
        showWeekly,
        error
      ];
}

class AnalyticsCubit extends Cubit<AnalyticsState> {
  final WaterRepository _waterRepository;
  final StepRepository _stepRepository;
  final CalorieRepository _calorieRepository;
  final SleepRepository _sleepRepository;
  final AuthRepository _authRepository;

  AnalyticsCubit({
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
        super(const AnalyticsState());

  Future<void> loadAnalytics() async {
    emit(state.copyWith(isLoading: true));
    final userResult = await _authRepository.getCurrentUser();
    if (!userResult.isRight || userResult.right == null) return;
    final userId = userResult.right!.id;

    final results = await Future.wait([
      _waterRepository.getWeeklyTotals(userId),
      _stepRepository.getWeeklyTotals(userId),
      _calorieRepository.getWeeklyTotals(userId),
      _sleepRepository.getWeeklyHours(userId),
    ]);

    emit(state.copyWith(
      isLoading: false,
      weeklyWater: (results[0] as Either<Failure, Map<String, int>>).isRight
          ? (results[0] as Either<Failure, Map<String, int>>).right
          : <String, int>{},
      weeklySteps: (results[1] as Either<Failure, Map<String, int>>).isRight
          ? (results[1] as Either<Failure, Map<String, int>>).right
          : <String, int>{},
      weeklyCalories: (results[2] as Either<Failure, Map<String, int>>).isRight
          ? (results[2] as Either<Failure, Map<String, int>>).right
          : <String, int>{},
      weeklySleep: (results[3] as Either<Failure, Map<String, double>>).isRight
          ? (results[3] as Either<Failure, Map<String, double>>).right
          : <String, double>{},
    ));
  }

  void togglePeriod() {
    emit(state.copyWith(showWeekly: !state.showWeekly));
    loadAnalytics();
  }
}
