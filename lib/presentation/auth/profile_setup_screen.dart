import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/components/gradient_scaffold.dart';
import '../../core/components/glass_card.dart';
import '../../core/components/glass_button.dart';
import 'bloc/auth_bloc.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  int _age = 25;
  String _gender = 'other';
  double _heightCm = 170.0;
  double _weightKg = 70.0;

  void _submit(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthProfileIncompleteState) {
        final updatedUser = authState.user.copyWith(
          age: _age,
          gender: _gender,
          heightCm: _heightCm,
          weightKg: _weightKg,
        );
        context.read<AuthBloc>().add(AuthUpdateProfileEvent(user: updatedUser));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return GradientScaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoadingState;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // ── Header ─────────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: AppColors.heroGradient,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.35),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.person_add_rounded,
                              size: 40, color: Colors.white),
                          const SizedBox(height: 10),
                          const Text(
                            AppStrings.profileSetup,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Tell us about yourself to personalise your goals',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Form Card ──────────────────────────────────────
                    GlassCard(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Age
                          _SectionLabel(label: AppStrings.ageLabel),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: SliderTheme(
                                  data: SliderThemeData(
                                    activeTrackColor: AppColors.primary,
                                    inactiveTrackColor:
                                        AppColors.primary.withOpacity(0.2),
                                    thumbColor: AppColors.primary,
                                    overlayColor:
                                        AppColors.primary.withOpacity(0.2),
                                  ),
                                  child: Slider(
                                    value: _age.toDouble(),
                                    min: 10,
                                    max: 100,
                                    divisions: 90,
                                    onChanged: (val) =>
                                        setState(() => _age = val.toInt()),
                                  ),
                                ),
                              ),
                              _ValueChip(label: '$_age yrs'),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Gender
                          _SectionLabel(label: AppStrings.genderLabel),
                          const SizedBox(height: 10),
                          Row(
                            children: ['male', 'female', 'other'].map((g) {
                              final isSelected = _gender == g;
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _gender = g),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.symmetric(horizontal: 4),
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary.withOpacity(0.2)
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primary
                                            : AppColors.glassBorder,
                                        width: isSelected ? 1.5 : 1,
                                      ),
                                    ),
                                    child: Text(
                                      g[0].toUpperCase() + g.substring(1),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 13,
                                        fontWeight: isSelected
                                            ? FontWeight.w700
                                            : FontWeight.w400,
                                        color: isSelected
                                            ? AppColors.primary
                                            : textSecondary,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),

                          // Height
                          _SectionLabel(label: AppStrings.heightLabel),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: SliderTheme(
                                  data: SliderThemeData(
                                    activeTrackColor: AppColors.secondary,
                                    inactiveTrackColor:
                                        AppColors.secondary.withOpacity(0.2),
                                    thumbColor: AppColors.secondary,
                                    overlayColor:
                                        AppColors.secondary.withOpacity(0.2),
                                  ),
                                  child: Slider(
                                    value: _heightCm,
                                    min: 100,
                                    max: 250,
                                    divisions: 150,
                                    onChanged: (val) =>
                                        setState(() => _heightCm = val),
                                  ),
                                ),
                              ),
                              _ValueChip(
                                  label: '${_heightCm.toInt()} cm',
                                  color: AppColors.secondary),
                            ],
                          ),
                          const SizedBox(height: 20),

                          // Weight
                          _SectionLabel(label: AppStrings.weightLabel),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: SliderTheme(
                                  data: SliderThemeData(
                                    activeTrackColor: AppColors.accent,
                                    inactiveTrackColor:
                                        AppColors.accent.withOpacity(0.2),
                                    thumbColor: AppColors.accent,
                                    overlayColor:
                                        AppColors.accent.withOpacity(0.2),
                                  ),
                                  child: Slider(
                                    value: _weightKg,
                                    min: 30,
                                    max: 200,
                                    divisions: 170,
                                    onChanged: (val) =>
                                        setState(() => _weightKg = val),
                                  ),
                                ),
                              ),
                              _ValueChip(
                                  label: '${_weightKg.toInt()} kg',
                                  color: AppColors.accent),
                            ],
                          ),
                          const SizedBox(height: 28),

                          GlassButton(
                            label: AppStrings.done,
                            onPressed: isLoading ? null : () => _submit(context),
                            isLoading: isLoading,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      ),
    );
  }
}

class _ValueChip extends StatelessWidget {
  final String label;
  final Color color;
  const _ValueChip({required this.label, this.color = AppColors.primary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
