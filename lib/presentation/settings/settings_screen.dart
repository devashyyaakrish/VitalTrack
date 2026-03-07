import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/components/glass_card.dart';
import '../../core/components/glass_button.dart';
import 'cubit/settings_cubit.dart';
import '../auth/bloc/auth_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        final cubit = context.read<SettingsCubit>();

        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text(
              AppStrings.settings,
              style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
            ),
          ),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
            children: [
              // ── Profile Card ─────────────────────────────────────────
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  final user = authState is AuthAuthenticatedState
                      ? authState.user
                      : null;
                  final initial = user?.name.isNotEmpty == true
                      ? user!.name[0].toUpperCase()
                      : '?';

                  return GlassCard(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2563EB),
                        Color(0xFF7C3AED),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 58,
                          height: 58,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.white.withOpacity(0.4)),
                          ),
                          child: Center(
                            child: Text(
                              initial,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?.name ?? 'Loading...',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                user?.email ?? '',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.75),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),

              // ── Preferences ───────────────────────────────────────────
              _SectionHeader(label: 'PREFERENCES'),
              const SizedBox(height: 10),

              GlassCard(
                padding: EdgeInsets.zero,
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  children: [
                    _GlassTile(
                      icon: Icons.dark_mode_rounded,
                      iconColor: AppColors.accent,
                      title: AppStrings.darkMode,
                      trailing: Switch(
                        value: state.isDarkMode,
                        onChanged: (_) => cubit.toggleDarkMode(),
                        activeColor: AppColors.primary,
                      ),
                    ),
                    _Divider(),
                    _GlassTile(
                      icon: Icons.straighten_rounded,
                      iconColor: AppColors.secondary,
                      title: 'Metric Units',
                      subtitle: state.useMetric ? 'kg, cm, ml' : 'lbs, ft, oz',
                      trailing: Switch(
                        value: state.useMetric,
                        onChanged: (_) => cubit.toggleUnits(),
                        activeColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Notifications ─────────────────────────────────────────
              _SectionHeader(label: 'NOTIFICATIONS'),
              const SizedBox(height: 10),

              GlassCard(
                padding: EdgeInsets.zero,
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  children: [
                    _GlassTile(
                      icon: Icons.water_drop_rounded,
                      iconColor: AppColors.waterColor,
                      title: AppStrings.waterReminders,
                      trailing: Switch(
                        value: state.waterReminders,
                        onChanged: (_) => cubit.toggleWaterReminders(),
                        activeColor: AppColors.primary,
                      ),
                    ),
                    _Divider(),
                    _GlassTile(
                      icon: Icons.notifications_active_rounded,
                      iconColor: AppColors.habitsColor,
                      title: AppStrings.habitReminders,
                      trailing: Switch(
                        value: state.habitReminders,
                        onChanged: (_) => cubit.toggleHabitReminders(),
                        activeColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Account ───────────────────────────────────────────────
              _SectionHeader(label: 'ACCOUNT'),
              const SizedBox(height: 10),

              GlassCard(
                padding: EdgeInsets.zero,
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  children: [
                    _GlassTile(
                      icon: Icons.logout_rounded,
                      iconColor: AppColors.warning,
                      title: AppStrings.signOut,
                      titleColor: AppColors.warning,
                      onTap: () async {
                        final confirm = await _showConfirmDialog(
                          context,
                          title: 'Sign Out',
                          message: 'Are you sure you want to sign out?',
                          confirmLabel: 'Sign Out',
                          confirmColor: AppColors.warning,
                        );
                        if (confirm == true) cubit.signOut();
                      },
                    ),
                    _Divider(),
                    _GlassTile(
                      icon: Icons.delete_forever_rounded,
                      iconColor: AppColors.error,
                      title: AppStrings.deleteAccount,
                      titleColor: AppColors.error,
                      onTap: () async {
                        final confirm = await _showConfirmDialog(
                          context,
                          title: 'Delete Account?',
                          message:
                              'This action is permanent and will delete all your data.',
                          confirmLabel: 'Delete',
                          confirmColor: AppColors.error,
                        );
                        if (confirm == true) cubit.deleteAccount();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<bool?> _showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    required String confirmLabel,
    required Color confirmColor,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_rounded, color: confirmColor, size: 36),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimaryDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.textSecondaryDark,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GlassButton.outlined(
                      label: 'Cancel',
                      onPressed: () => Navigator.pop(ctx, false),
                      height: 44,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlassButton(
                      label: confirmLabel,
                      height: 44,
                      gradient: LinearGradient(
                        colors: [
                          confirmColor.withOpacity(0.8),
                          confirmColor,
                        ],
                      ),
                      glowColor: confirmColor.withOpacity(0.3),
                      onPressed: () => Navigator.pop(ctx, true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  const _SectionHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      label,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.4,
        color:
            isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      ),
    );
  }
}

class _GlassTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Color? titleColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _GlassTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.titleColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 18),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: titleColor ??
              (Theme.of(context).brightness == Brightness.dark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight),
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle!,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: AppColors.textSecondaryDark,
              ),
            )
          : null,
      trailing: trailing,
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.glassBorder,
      indent: 54,
      endIndent: 0,
    );
  }
}
