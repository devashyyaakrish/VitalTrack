import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/extensions.dart';
import 'bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(AuthSignInWithEmailEvent(
            email: _emailCtrl.text.trim(),
            password: _passwordCtrl.text,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: context.theme.colorScheme.error),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoadingState;

          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // App Logo / Title
                      Icon(Icons.health_and_safety, size: 80, color: context.colorScheme.primary),
                      const SizedBox(height: 16),
                      Text(
                        AppStrings.appName,
                        textAlign: TextAlign.center,
                        style: context.textTheme.displayLarge?.copyWith(
                          color: context.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.appTagline,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 48),

                      // Email Field
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: AppStrings.emailLabel,
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: Validators.validateEmail,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 16),

                      // Password Field
                      TextFormField(
                        controller: _passwordCtrl,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: AppStrings.passwordLabel,
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        validator: Validators.validatePassword,
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: 24),

                      // Login Button
                      ElevatedButton(
                        onPressed: isLoading ? null : _submit,
                        child: isLoading
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              )
                            : const Text(AppStrings.signIn),
                      ),
                      const SizedBox(height: 16),

                      // Google Sign In
                      OutlinedButton.icon(
                        onPressed: isLoading
                            ? null
                            : () => context.read<AuthBloc>().add(AuthSignInWithGoogleEvent()),
                        icon: const Icon(Icons.g_mobiledata, size: 28),
                        label: const Text(AppStrings.googleSignIn),
                      ),
                      const SizedBox(height: 32),

                      // Register Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(AppStrings.noAccount, style: context.textTheme.bodyMedium),
                          TextButton(
                            onPressed: () => context.push('/register'),
                            child: const Text(AppStrings.signUp),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
