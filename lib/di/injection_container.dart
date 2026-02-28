import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/user_model.dart';
import '../data/models/health_models.dart';
import '../data/repositories/mock_auth_repository.dart';
import '../data/repositories/mock_health_repositories.dart';
import '../data/repositories/mock_habit_repository.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/repositories/health_repositories.dart';
import '../domain/repositories/habit_repository.dart';
import '../presentation/auth/bloc/auth_bloc.dart';
import '../presentation/dashboard/cubit/dashboard_cubit.dart';
import '../presentation/water/cubit/water_cubit.dart';
import '../presentation/steps/cubit/step_cubit.dart';
import '../presentation/calories/cubit/calorie_cubit.dart';
import '../presentation/sleep/cubit/sleep_cubit.dart';
import '../presentation/habits/bloc/habit_bloc.dart';
import '../presentation/analytics/cubit/analytics_cubit.dart';
import '../presentation/settings/cubit/settings_cubit.dart';
import '../core/constants/app_constants.dart';
import '../services/notification_service.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  // ── External Services ────────────────────────────────────────────────────
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => GoogleSignIn(scopes: ['email']));
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  final prefs = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(prefs);

  // ── Hive Boxes ───────────────────────────────────────────────────────────
  sl.registerSingleton<Box<UserModel>>(
    Hive.box<UserModel>(AppConstants.userBox),
  );
  sl.registerSingleton<Box<WaterEntryModel>>(
    Hive.box<WaterEntryModel>(AppConstants.waterBox),
  );
  sl.registerSingleton<Box<StepEntryModel>>(
    Hive.box<StepEntryModel>(AppConstants.stepsBox),
  );
  sl.registerSingleton<Box<CalorieEntryModel>>(
    Hive.box<CalorieEntryModel>(AppConstants.caloriesBox),
  );
  sl.registerSingleton<Box<SleepEntryModel>>(
    Hive.box<SleepEntryModel>(AppConstants.sleepBox),
  );
  sl.registerSingleton<Box<HabitModel>>(
    Hive.box<HabitModel>(AppConstants.habitsBox),
  );
  sl.registerSingleton<Box<HabitLogModel>>(
    Hive.box<HabitLogModel>(AppConstants.habitLogsBox),
  );

  // ── Repositories ─────────────────────────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
    () => MockAuthRepository(userBox: sl()),
  );

  sl.registerLazySingleton<WaterRepository>(
    () => MockWaterRepository(box: sl()),
  );
  sl.registerLazySingleton<StepRepository>(
    () => MockStepRepository(box: sl()),
  );
  sl.registerLazySingleton<CalorieRepository>(
    () => MockCalorieRepository(box: sl()),
  );
  sl.registerLazySingleton<SleepRepository>(
    () => MockSleepRepository(box: sl()),
  );
  sl.registerLazySingleton<HabitRepository>(
    () => MockHabitRepository(
      habitBox: sl(),
      logBox: sl(),
    ),
  );

  // ── Services ─────────────────────────────────────────────────────────────
  sl.registerLazySingleton<NotificationService>(() => NotificationService());

  // ── Blocs / Cubits ───────────────────────────────────────────────────────
  sl.registerFactory(() => AuthBloc(authRepository: sl()));
  sl.registerFactory(() => DashboardCubit(
        waterRepository: sl(),
        stepRepository: sl(),
        calorieRepository: sl(),
        sleepRepository: sl(),
        authRepository: sl(),
      ));
  sl.registerFactory(
      () => WaterCubit(waterRepository: sl(), authRepository: sl()));
  sl.registerFactory(
      () => StepCubit(stepRepository: sl(), authRepository: sl()));
  sl.registerFactory(
      () => CalorieCubit(calorieRepository: sl(), authRepository: sl()));
  sl.registerFactory(
      () => SleepCubit(sleepRepository: sl(), authRepository: sl()));
  sl.registerFactory(
      () => HabitBloc(habitRepository: sl(), authRepository: sl()));
  sl.registerFactory(() => AnalyticsCubit(
        waterRepository: sl(),
        stepRepository: sl(),
        calorieRepository: sl(),
        sleepRepository: sl(),
        authRepository: sl(),
      ));
  sl.registerFactory(() => SettingsCubit(prefs: sl(), authRepository: sl()));
}
