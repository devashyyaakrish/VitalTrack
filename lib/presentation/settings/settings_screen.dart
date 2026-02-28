import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/extensions.dart';
import 'cubit/settings_cubit.dart';
import '../auth/bloc/auth_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.settings),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          final cubit = context.read<SettingsCubit>();

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 16),
            children: [
              // ── Profile Section ──────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('PROFILE', style: context.textTheme.labelMedium?.copyWith(color: Colors.grey)),
              ),
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  final user = authState is AuthAuthenticatedState ? authState.user : null;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: context.theme.colorScheme.primary.withOpacity(0.1),
                      child: Text(
                        user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : '?',
                        style: TextStyle(color: context.theme.colorScheme.primary, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(user?.name ?? 'Loading...'),
                    subtitle: Text(user?.email ?? ''),
                    trailing: TextButton(
                      onPressed: () {
                        // In a full app, this would open a Profile Edit screen
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Edit profile coming soon.')),
                        );
                      },
                      child: const Text('Edit'),
                    ),
                  );
                },
              ),
              const Divider(),

              // ── Preferences Section ─────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('PREFERENCES', style: context.textTheme.labelMedium?.copyWith(color: Colors.grey)),
              ),
              SwitchListTile(
                title: const Text(AppStrings.darkMode),
                secondary: const Icon(Icons.dark_mode_outlined),
                value: state.isDarkMode,
                onChanged: (_) => cubit.toggleDarkMode(),
              ),
              SwitchListTile(
                title: const Text('Metric Units'),
                subtitle: Text(state.useMetric ? 'kg, cm, ml' : 'lbs, ft, oz'),
                secondary: const Icon(Icons.straighten),
                value: state.useMetric,
                onChanged: (_) => cubit.toggleUnits(),
              ),
              const Divider(),

              // ── Notifications Section ───────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('NOTIFICATIONS', style: context.textTheme.labelMedium?.copyWith(color: Colors.grey)),
              ),
              SwitchListTile(
                title: const Text(AppStrings.waterReminders),
                secondary: const Icon(Icons.water_drop_outlined),
                value: state.waterReminders,
                onChanged: (_) => cubit.toggleWaterReminders(),
              ),
              SwitchListTile(
                title: const Text(AppStrings.habitReminders),
                secondary: const Icon(Icons.notifications_active_outlined),
                value: state.habitReminders,
                onChanged: (_) => cubit.toggleHabitReminders(),
              ),
              const Divider(),

              // ── Account Section ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text('ACCOUNT', style: context.textTheme.labelMedium?.copyWith(color: Colors.grey)),
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.orange),
                title: const Text(AppStrings.signOut, style: TextStyle(color: Colors.orange)),
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Sign Out'),
                      content: const Text('Are you sure you want to sign out?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                        TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sign Out')),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    cubit.signOut();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text(AppStrings.deleteAccount, style: TextStyle(color: Colors.red)),
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Delete Account?'),
                      content: const Text('This action is permanent and will delete all your data. Are you sure?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Delete', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true) {
                    cubit.deleteAccount();
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
