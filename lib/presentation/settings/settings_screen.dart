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
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border:
                                Border.all(color: Colors.white.withValues(alpha: 0.4)),
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
                                  color: Colors.white.withValues(alpha: 0.75),
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
              const _SectionHeader(label: 'PREFERENCES'),
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
                        activeThumbColor: AppColors.primary,
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
                        activeThumbColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Notifications ─────────────────────────────────────────
              const _SectionHeader(label: 'NOTIFICATIONS'),
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
                        activeThumbColor: AppColors.primary,
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
                        activeThumbColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Account ───────────────────────────────────────────────
              const _SectionHeader(label: 'ACCOUNT'),
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
                        if (confirm == true) {
                          cubit.signOut();
                        }
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
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: AppColors.textSecondaryDark,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: GlassButton.outlined(
                      label: 'Cancel',
                      onPressed: () => Navigator.pop(context, false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlassButton(
                      label: confirmLabel,
                      gradient: LinearGradient(
                        colors: [
                          confirmColor,
                          confirmColor.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      glowColor: confirmColor.withValues(alpha: 0.3),
                      onPressed: () => Navigator.pop(context, true),
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
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: AppColors.textSecondaryDark,
        ),
      ),
    );
  }
}

class _GlassTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Color? titleColor;
  final VoidCallback? onTap;

  const _GlassTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.titleColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: titleColor ?? AppColors.textPrimaryDark,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 1,
      indent: 64,
      color: AppColors.glassWhite,
    );
  }
}
