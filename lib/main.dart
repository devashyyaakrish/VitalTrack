import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/constants/app_constants.dart';
import 'core/constants/app_strings.dart';
import 'data/models/user_model.dart';
import 'data/models/health_models.dart';
import 'di/injection_container.dart' as di;

import 'presentation/auth/bloc/auth_bloc.dart';
import 'presentation/dashboard/cubit/dashboard_cubit.dart';
import 'presentation/water/cubit/water_cubit.dart';
import 'presentation/steps/cubit/step_cubit.dart';
import 'presentation/calories/cubit/calorie_cubit.dart';
import 'presentation/sleep/cubit/sleep_cubit.dart';
import 'presentation/habits/bloc/habit_bloc.dart';
import 'presentation/analytics/cubit/analytics_cubit.dart';
import 'presentation/settings/cubit/settings_cubit.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (Using placeholder firebase_options.dart)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase placeholder initialization triggered an error: $e');
  }

  // Initialize Hive and Register Adapters
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(WaterEntryModelAdapter());
  Hive.registerAdapter(StepEntryModelAdapter());
  Hive.registerAdapter(CalorieEntryModelAdapter());
  Hive.registerAdapter(SleepEntryModelAdapter());
  Hive.registerAdapter(HabitModelAdapter());
  Hive.registerAdapter(HabitLogModelAdapter());

  // Open Hive Boxes
  await Hive.openBox<UserModel>(AppConstants.userBox);
  await Hive.openBox<WaterEntryModel>(AppConstants.waterBox);
  await Hive.openBox<StepEntryModel>(AppConstants.stepsBox);
  await Hive.openBox<CalorieEntryModel>(AppConstants.caloriesBox);
  await Hive.openBox<SleepEntryModel>(AppConstants.sleepBox);
  await Hive.openBox<HabitModel>(AppConstants.habitsBox);
  await Hive.openBox<HabitLogModel>(AppConstants.habitLogsBox);

  // Setup Dependency Injection
  await di.setupDependencies();

  runApp(const VitalTrackApp());
}

class VitalTrackApp extends StatelessWidget {
  const VitalTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      // Initialize all domain blocs at the root so they live alongside the app lifecycle
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()..add(AuthCheckStatusEvent())),
        BlocProvider(create: (_) => di.sl<DashboardCubit>()),
        BlocProvider(create: (_) => di.sl<WaterCubit>()),
        BlocProvider(create: (_) => di.sl<StepCubit>()),
        BlocProvider(create: (_) => di.sl<CalorieCubit>()),
        BlocProvider(create: (_) => di.sl<SleepCubit>()),
        BlocProvider(create: (_) => di.sl<HabitBloc>()),
        BlocProvider(create: (_) => di.sl<AnalyticsCubit>()),
        BlocProvider(create: (_) => di.sl<SettingsCubit>()),
      ],
      // We wrap MaterialApp with a Builder to access the populated AuthBloc & SettingsCubit
      child: Builder(
        builder: (context) {
          final authBloc = context.read<AuthBloc>();
          final settingsState = context.watch<SettingsCubit>().state;
          
          final router = AppRouter.createRouter(authBloc);

          return MaterialApp.router(
            title: AppStrings.appName,
            theme: AppTheme.darkTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.dark,
            routerConfig: router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
