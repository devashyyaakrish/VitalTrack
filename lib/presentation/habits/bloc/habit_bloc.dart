import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/habit_entity.dart';
import '../../../domain/repositories/habit_repository.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../core/utils/date_utils.dart';

// ── Events ────────────────────────────────────────────────────────────────────

abstract class HabitEvent extends Equatable {
  const HabitEvent();
  @override
  List<Object?> get props => [];
}

class HabitLoadEvent extends HabitEvent {}

class HabitCreateEvent extends HabitEvent {
  final String name;
  final String? description;
  final String iconEmoji;
  const HabitCreateEvent(
      {required this.name, this.description, this.iconEmoji = '✅'});
  @override
  List<Object?> get props => [name, description, iconEmoji];
}

class HabitToggleLogEvent extends HabitEvent {
  final String habitId;
  final String dateKey;
  const HabitToggleLogEvent({required this.habitId, required this.dateKey});
  @override
  List<Object?> get props => [habitId, dateKey];
}

class HabitDeleteEvent extends HabitEvent {
  final String habitId;
  const HabitDeleteEvent({required this.habitId});
  @override
  List<Object?> get props => [habitId];
}

// ── State ─────────────────────────────────────────────────────────────────────

class HabitState extends Equatable {
  final bool isLoading;
  final List<HabitEntity> habits;
  final List<HabitLogEntity> weekLogs;
  final List<String> weekDateKeys;
  final String? error;
  final String? successMessage;

  const HabitState({
    this.isLoading = false,
    this.habits = const [],
    this.weekLogs = const [],
    this.weekDateKeys = const [],
    this.error,
    this.successMessage,
  });

  /// Whether a habit is completed for a given date key
  bool isCompleted(String habitId, String dateKey) => weekLogs.any(
      (l) => l.habitId == habitId && l.dateKey == dateKey && l.isCompleted);

  HabitState copyWith({
    bool? isLoading,
    List<HabitEntity>? habits,
    List<HabitLogEntity>? weekLogs,
    List<String>? weekDateKeys,
    String? error,
    String? successMessage,
  }) {
    return HabitState(
      isLoading: isLoading ?? this.isLoading,
      habits: habits ?? this.habits,
      weekLogs: weekLogs ?? this.weekLogs,
      weekDateKeys: weekDateKeys ?? this.weekDateKeys,
      error: error,
      successMessage: successMessage,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, habits, weekLogs, weekDateKeys, error, successMessage];
}

// ── Bloc ─────────────────────────────────────────────────────────────────────

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final HabitRepository _habitRepository;
  final AuthRepository _authRepository;

  HabitBloc({
    required HabitRepository habitRepository,
    required AuthRepository authRepository,
  })  : _habitRepository = habitRepository,
        _authRepository = authRepository,
        super(const HabitState()) {
    on<HabitLoadEvent>(_onLoad);
    on<HabitCreateEvent>(_onCreate);
    on<HabitToggleLogEvent>(_onToggleLog);
    on<HabitDeleteEvent>(_onDelete);
  }

  String? _userId;

  Future<String?> _getOrFetchUserId() async {
    if (_userId != null) return _userId;
    final result = await _authRepository.getCurrentUser();
    if (result.isRight && result.right != null) {
      _userId = result.right!.id;
    }
    return _userId;
  }

  Future<void> _onLoad(HabitLoadEvent event, Emitter<HabitState> emit) async {
    emit(state.copyWith(isLoading: true));
    final userId = await _getOrFetchUserId();
    if (userId == null) return;

    final weekDays = AppDateUtils.currentWeek();
    final weekKeys = weekDays.map(AppDateUtils.toDateKey).toList();

    final habitsResult = await _habitRepository.getUserHabits(userId);
    final logsResult = await _habitRepository.getLogsForWeek(
      userId: userId,
      dateKeys: weekKeys,
    );

    final habits = habitsResult.isRight ? habitsResult.right : <HabitEntity>[];
    final logs = logsResult.isRight ? logsResult.right : <HabitLogEntity>[];

    emit(state.copyWith(
      isLoading: false,
      habits: habits,
      weekLogs: logs,
      weekDateKeys: weekKeys,
    ));
  }

  Future<void> _onCreate(
      HabitCreateEvent event, Emitter<HabitState> emit) async {
    final userId = await _getOrFetchUserId();
    if (userId == null) return;
    final result = await _habitRepository.createHabit(
      userId: userId,
      name: event.name,
      description: event.description,
      iconEmoji: event.iconEmoji,
    );
    result.fold(
      (f) => emit(state.copyWith(error: f.message)),
      (habit) => emit(state.copyWith(
        habits: [...state.habits, habit],
        successMessage: '"${habit.name}" habit created!',
      )),
    );
  }

  Future<void> _onToggleLog(
      HabitToggleLogEvent event, Emitter<HabitState> emit) async {
    final userId = await _getOrFetchUserId();
    if (userId == null) return;
    final result = await _habitRepository.toggleHabitLog(
      habitId: event.habitId,
      userId: userId,
      dateKey: event.dateKey,
    );
    result.fold(
      (f) => emit(state.copyWith(error: f.message)),
      (log) {
        // Update logs list
        final updatedLogs = state.weekLogs
            .where(
              (l) =>
                  !(l.habitId == event.habitId && l.dateKey == event.dateKey),
            )
            .toList()
          ..add(log);
        emit(state.copyWith(weekLogs: updatedLogs));
      },
    );
  }

  Future<void> _onDelete(
      HabitDeleteEvent event, Emitter<HabitState> emit) async {
    await _habitRepository.deleteHabit(event.habitId);
    emit(state.copyWith(
      habits: state.habits.where((h) => h.id != event.habitId).toList(),
    ));
  }
}
