import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentation/auth/bloc/auth_bloc.dart';
import '../../presentation/auth/login_screen.dart';
import '../../presentation/auth/register_screen.dart';
import '../../presentation/auth/profile_setup_screen.dart';
import '../../presentation/main/main_screen.dart';
import '../../presentation/dashboard/dashboard_screen.dart';
import '../../presentation/trackers/trackers_screen.dart';
import '../../presentation/habits/habits_screen.dart';
import '../../presentation/analytics/analytics_screen.dart';
import '../../presentation/settings/settings_screen.dart';

class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final shellNavigatorKey = GlobalKey<NavigatorState>();

  // Replaced static router with createRouter factory to ensure it's reactive to AuthBloc state.
  static GoRouter createRouter(AuthBloc authBloc) {
    return GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/login',
      refreshListenable: GoRouterRefreshStream(authBloc.stream),
      redirect: (context, state) {
        final authState = authBloc.state;
        final isLoginOrRegister = state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';

        if (authState is AuthUnauthenticatedState) {
          return isLoginOrRegister ? null : '/login';
        }

        if (authState is AuthProfileIncompleteState) {
          return state.matchedLocation == '/profile_setup'
              ? null
              : '/profile_setup';
        }

        if (authState is AuthAuthenticatedState) {
          if (isLoginOrRegister || state.matchedLocation == '/profile_setup') {
            return '/dashboard';
          }
        }
        return null; // No redirect needed
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterScreen(),
        ),
        GoRoute(
          path: '/profile_setup',
          builder: (context, state) => const ProfileSetupScreen(),
        ),
        ShellRoute(
          navigatorKey: shellNavigatorKey,
          builder: (context, state, child) {
            // Need to determine index based on path for BottomNavBar
            int currentIndex = 0;
            if (state.matchedLocation.startsWith('/trackers')) currentIndex = 1;
            if (state.matchedLocation.startsWith('/habits')) currentIndex = 2;
            if (state.matchedLocation.startsWith('/analytics'))
              currentIndex = 3;
            if (state.matchedLocation.startsWith('/settings')) currentIndex = 4;

            return MainScreen(currentIndex: currentIndex, child: child);
          },
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
            GoRoute(
              path: '/trackers',
              builder: (context, state) => const TrackersScreen(),
            ),
            GoRoute(
              path: '/habits',
              builder: (context, state) => const HabitsScreen(),
            ),
            GoRoute(
              path: '/analytics',
              builder: (context, state) => const AnalyticsScreen(),
            ),
            GoRoute(
              path: '/settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    );
  }
}

/// Helper to bridge Bloc stream to Listenable for GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
