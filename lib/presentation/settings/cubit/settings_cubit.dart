import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../core/constants/app_constants.dart';

class SettingsState extends Equatable {
  final bool isDarkMode;
  final bool useMetric;       // true = kg/ml, false = lbs/oz
  final bool waterReminders;
  final bool habitReminders;

  const SettingsState({
    this.isDarkMode = false,
    this.useMetric = true,
    this.waterReminders = true,
    this.habitReminders = true,
  });

  SettingsState copyWith({
    bool? isDarkMode,
    bool? useMetric,
    bool? waterReminders,
    bool? habitReminders,
  }) {
    return SettingsState(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      useMetric: useMetric ?? this.useMetric,
      waterReminders: waterReminders ?? this.waterReminders,
      habitReminders: habitReminders ?? this.habitReminders,
    );
  }

  @override
  List<Object?> get props => [isDarkMode, useMetric, waterReminders, habitReminders];
}

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences _prefs;
  final AuthRepository _authRepository;

  SettingsCubit({required SharedPreferences prefs, required AuthRepository authRepository})
      : _prefs = prefs,
        _authRepository = authRepository,
        super(const SettingsState()) {
    _loadSettings();
  }

  void _loadSettings() {
    emit(SettingsState(
      isDarkMode: _prefs.getBool(AppConstants.themeKey) ?? false,
      useMetric: _prefs.getBool(AppConstants.unitsKey) ?? true,
      waterReminders: _prefs.getBool(AppConstants.waterReminderKey) ?? true,
      habitReminders: _prefs.getBool(AppConstants.habitReminderKey) ?? true,
    ));
  }

  Future<void> toggleDarkMode() async {
    final newValue = !state.isDarkMode;
    await _prefs.setBool(AppConstants.themeKey, newValue);
    emit(state.copyWith(isDarkMode: newValue));
  }

  Future<void> toggleUnits() async {
    final newValue = !state.useMetric;
    await _prefs.setBool(AppConstants.unitsKey, newValue);
    emit(state.copyWith(useMetric: newValue));
  }

  Future<void> toggleWaterReminders() async {
    final newValue = !state.waterReminders;
    await _prefs.setBool(AppConstants.waterReminderKey, newValue);
    emit(state.copyWith(waterReminders: newValue));
  }

  Future<void> toggleHabitReminders() async {
    final newValue = !state.habitReminders;
    await _prefs.setBool(AppConstants.habitReminderKey, newValue);
    emit(state.copyWith(habitReminders: newValue));
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }

  Future<void> deleteAccount() async {
    await _authRepository.deleteAccount();
  }
}
