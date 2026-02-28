import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/extensions.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.profileSetup),
        automaticallyImplyLeading: false, // Force them to complete setup
      ),
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Tell us a bit about yourself to personalize your health goals.',
                      style: context.textTheme.bodyLarge?.copyWith(
                        color: context.theme.colorScheme.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Age
                    Text(AppStrings.ageLabel, style: context.textTheme.labelLarge),
                    Slider(
                      value: _age.toDouble(),
                      min: 10,
                      max: 100,
                      divisions: 90,
                      label: _age.toString(),
                      onChanged: (val) => setState(() => _age = val.toInt()),
                    ),
                    Center(child: Text('$_age years', style: context.textTheme.bodyMedium)),
                    const SizedBox(height: 24),

                    // Gender
                    Text(AppStrings.genderLabel, style: context.textTheme.labelLarge),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(value: 'male', label: Text('Male')),
                        ButtonSegment(value: 'female', label: Text('Female')),
                        ButtonSegment(value: 'other', label: Text('Other')),
                      ],
                      selected: {_gender},
                      onSelectionChanged: (set) => setState(() => _gender = set.first),
                    ),
                    const SizedBox(height: 24),

                    // Height
                    Text(AppStrings.heightLabel, style: context.textTheme.labelLarge),
                    Slider(
                      value: _heightCm,
                      min: 100,
                      max: 250,
                      divisions: 150,
                      label: _heightCm.toInt().toString(),
                      onChanged: (val) => setState(() => _heightCm = val),
                    ),
                    Center(child: Text('${_heightCm.toInt()} cm', style: context.textTheme.bodyMedium)),
                    const SizedBox(height: 24),

                    // Weight
                    Text(AppStrings.weightLabel, style: context.textTheme.labelLarge),
                    Slider(
                      value: _weightKg,
                      min: 30,
                      max: 200,
                      divisions: 170,
                      label: _weightKg.toInt().toString(),
                      onChanged: (val) => setState(() => _weightKg = val),
                    ),
                    Center(child: Text('${_weightKg.toInt()} kg', style: context.textTheme.bodyMedium)),
                    const SizedBox(height: 48),

                    // Complete Button
                    ElevatedButton(
                      onPressed: isLoading ? null : () => _submit(context),
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text(AppStrings.done),
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
