import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/extensions.dart';
import 'cubit/dashboard_cubit.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DashboardCubit, DashboardState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!), backgroundColor: context.theme.colorScheme.error),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('${AppStrings.todaySummary}, ${state.userName}'),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => context.read<DashboardCubit>().loadDashboard(),
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => context.read<DashboardCubit>().loadDashboard(),
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                // Quote Card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.format_quote, color: Colors.white70, size: 40),
                      const SizedBox(height: 8),
                      Text(
                        state.quote,
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Text('Metrics', style: context.textTheme.titleLarge),
                const SizedBox(height: 12),

                // Grid of metrics
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                  children: [
                    _MetricCard(
                      title: AppStrings.waterTracker,
                      icon: Icons.water_drop,
                      color: AppColors.waterColor,
                      value: '${state.totalWaterMl} / ${state.waterGoalMl}',
                      progress: state.totalWaterMl / state.waterGoalMl,
                      unit: AppStrings.mlUnit,
                    ),
                    _MetricCard(
                      title: AppStrings.stepTracker,
                      icon: Icons.directions_walk,
                      color: AppColors.stepsColor,
                      value: '${state.totalSteps.formatted} / ${state.stepsGoal.formatted}',
                      progress: state.totalSteps / state.stepsGoal,
                      unit: 'steps',
                    ),
                    _MetricCard(
                      title: AppStrings.calorieTracker,
                      icon: Icons.local_dining,
                      color: AppColors.caloriesColor,
                      value: '${state.totalCalories.formatted} / ${state.caloriesGoal.formatted}',
                      progress: state.totalCalories / state.caloriesGoal,
                      unit: 'kcal',
                    ),
                    _MetricCard(
                      title: AppStrings.sleepTracker,
                      icon: Icons.bedtime,
                      color: AppColors.sleepColor,
                      value: '${state.sleepHours.compact} / ${state.sleepGoalHours.compact}',
                      progress: state.sleepHours / state.sleepGoalHours,
                      unit: 'hours',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String value;
  final double progress;
  final String unit;

  const _MetricCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.value,
    required this.progress,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.asProgress;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Text(
                '${(clampedProgress * 100).toInt()}%',
                style: context.textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: context.textTheme.labelLarge),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: value.split(' / ')[0], // Current value
                      style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' / ${value.split(' / ')[1]} $unit', // Goal + unit
                      style: context.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: clampedProgress,
                  backgroundColor: color.withOpacity(0.15),
                  color: color,
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
