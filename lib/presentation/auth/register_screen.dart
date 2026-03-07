import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../core/theme/app_colors.dart';
import '../../core/components/gradient_scaffold.dart';
import '../../core/components/glass_card.dart';
import '../../core/components/glass_button.dart';
import '../../core/components/glass_input_field.dart';
import 'bloc/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(AuthRegisterWithEmailEvent(
            email: _emailCtrl.text.trim(),
            password: _passwordCtrl.text,
            name: _nameCtrl.text.trim(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GradientScaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
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
                    // ── Header ──────────────────────────────────────────
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => context.pop(),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.glassWhite,
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.glassBorder),
                            ),
                            child: const Icon(Icons.arrow_back_ios_new_rounded,
                                size: 16, color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 16),
                        ShaderMask(
                          shaderCallback: (bounds) =>
                              AppColors.primaryGradient.createShader(bounds),
                          child: const Text(
                            'Create Account',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.8,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 52),
                      child: Text(
                        'Join VitalTrack and start your health journey',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // ── Glass Form Card ──────────────────────────────────
                    GlassCard(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GlassInputField(
                            controller: _nameCtrl,
                            hintText: AppStrings.nameLabel,
                            prefixIcon: Icons.person_outline_rounded,
                            keyboardType: TextInputType.name,
                            textInputAction: TextInputAction.next,
                            validator: Validators.validateName,
                          ),
                          const SizedBox(height: 14),

                          GlassInputField(
                            controller: _emailCtrl,
                            hintText: AppStrings.emailLabel,
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: Validators.validateEmail,
                          ),
                          const SizedBox(height: 14),

                          GlassInputField(
                            controller: _passwordCtrl,
                            hintText: AppStrings.passwordLabel,
                            prefixIcon: Icons.lock_outline_rounded,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.next,
                            validator: Validators.validatePassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textSecondaryDark,
                                size: 20,
                              ),
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          const SizedBox(height: 14),

                          GlassInputField(
                            controller: _confirmPasswordCtrl,
                            hintText: AppStrings.confirmPasswordLabel,
                            prefixIcon: Icons.lock_reset_rounded,
                            obscureText: _obscurePassword,
                            textInputAction: TextInputAction.done,
                            validator: (val) => Validators.validateConfirmPassword(
                                val, _passwordCtrl.text),
                            onSubmitted: (_) => _submit(),
                          ),
                          const SizedBox(height: 28),

                          GlassButton(
                            label: AppStrings.signUp,
                            onPressed: isLoading ? null : _submit,
                            isLoading: isLoading,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // ── Login Link ───────────────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.hasAccount,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.pop(),
                          child: const Text(
                            AppStrings.signIn,
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
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
