import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/extensions.dart';
import '../../core/components/glass_card.dart';
import '../../core/components/animated_loader.dart';
import 'cubit/dashboard_cubit.dart';
import '../auth/bloc/auth_bloc.dart';

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
            SnackBar(
              content: Text(state.error!),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: AnimatedLoader());
        }

        final isDark = Theme.of(context).brightness == Brightness.dark;

        return RefreshIndicator(
          onRefresh: () => context.read<DashboardCubit>().loadDashboard(),
          color: AppColors.primary,
          backgroundColor:
              isDark ? AppColors.cardDark : AppColors.cardLight,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Hero App Bar ────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: AppColors.heroGradient,
                    ),
                    child: SafeArea(
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 56.0 + 10, 20, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                            BlocBuilder<AuthBloc, AuthState>(
                              builder: (context, authState) {
                                final userName =
                                    authState is AuthAuthenticatedState
                                        ? authState.user.name.split(' ').first
                                        : state.userName;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _greeting(),
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    Text(
                                      userName,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 28,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                        letterSpacing: -0.8,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            // Quote row
                            Row(
                              children: [
                                const Icon(Icons.format_quote_rounded,
                                    color: Colors.white54, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    state.quote,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  collapseMode: CollapseMode.parallax,
                ),
                title: Text(
                  AppStrings.appName,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: IconButton(
                      icon: const Icon(Icons.refresh_rounded,
                          color: Colors.white70, size: 22),
                      onPressed: () =>
                          context.read<DashboardCubit>().loadDashboard(),
                    ),
                  ),
                ],
              ),

              // ── Metrics Section ─────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                sliver: SliverToBoxAdapter(
                  child: Text(
                    "TODAY'S METRICS",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(top: 12)),

              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.9,
                  children: [
                    _AnimatedMetricCard(
                      index: 0,
                      title: AppStrings.waterTracker,
                      gradient: AppColors.waterGradient,
                      icon: Icons.water_drop_rounded,
                      color: AppColors.waterColor,
                      value: '${state.totalWaterMl}',
                      unit: 'ml',
                      goal: '${state.waterGoalMl} ml',
                      progress: state.totalWaterMl / state.waterGoalMl,
                    ),
                    _AnimatedMetricCard(
                      index: 1,
                      title: AppStrings.stepTracker,
                      gradient: AppColors.stepsGradient,
                      icon: Icons.directions_walk_rounded,
                      color: AppColors.stepsColor,
                      value: state.totalSteps.formatted,
                      unit: 'steps',
                      goal: '${state.stepsGoal.formatted}',
                      progress: state.totalSteps / state.stepsGoal,
                    ),
                    _AnimatedMetricCard(
                      index: 2,
                      title: AppStrings.calorieTracker,
                      gradient: AppColors.caloriesGradient,
                      icon: Icons.local_fire_department_rounded,
                      color: AppColors.caloriesColor,
                      value: state.totalCalories.formatted,
                      unit: 'kcal',
                      goal: '${state.caloriesGoal.formatted}',
                      progress: state.totalCalories / state.caloriesGoal,
                    ),
                    _AnimatedMetricCard(
                      index: 3,
                      title: AppStrings.sleepTracker,
                      gradient: AppColors.sleepGradient,
                      icon: Icons.bedtime_rounded,
                      color: AppColors.sleepColor,
                      value: state.sleepHours.compact,
                      unit: 'hours',
                      goal: '${state.sleepGoalHours.compact}',
                      progress: state.sleepHours / state.sleepGoalHours,
                    ),
                  ],
                ),
              ),

              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          ),
        );
      },
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning ☀️';
    if (hour < 17) return 'Good afternoon 🌤';
    return 'Good evening 🌙';
  }
}

class _AnimatedMetricCard extends StatefulWidget {
  final int index;
  final String title;
  final Gradient gradient;
  final IconData icon;
  final Color color;
  final String value;
  final String unit;
  final String goal;
  final double progress;

  const _AnimatedMetricCard({
    required this.index,
    required this.title,
    required this.gradient,
    required this.icon,
    required this.color,
    required this.value,
    required this.unit,
    required this.goal,
    required this.progress,
  });

  @override
  State<_AnimatedMetricCard> createState() => _AnimatedMetricCardState();
}

class _AnimatedMetricCardState extends State<_AnimatedMetricCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideY;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400 + widget.index * 100),
    );
    _slideY = Tween<double>(begin: 30, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _opacity = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Stagger the start
    Future.delayed(Duration(milliseconds: widget.index * 80), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Opacity(
        opacity: _opacity.value,
        child: Transform.translate(
          offset: Offset(0, _slideY.value),
          child: child,
        ),
      ),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and percent
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: widget.gradient,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: widget.color.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(widget.icon, color: Colors.white, size: 18),
                ),
                Text(
                  '${(widget.progress.clamp(0.0, 1.0) * 100).toInt()}%',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: widget.color,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              widget.title,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
            const SizedBox(height: 2),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: widget.value,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.8,
                    color: AppColors.textPrimaryDark,
                    height: 1.0,
                  ),
                ),
                TextSpan(
                  text: ' ${widget.unit}',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: AppColors.textSecondaryDark,
                  ),
                ),
              ]),
            ),
            const SizedBox(height: 10),
            // Progress bar
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: widget.progress.clamp(0.0, 1.0)),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value,
                  backgroundColor: widget.color.withOpacity(0.15),
                  color: widget.color,
                  minHeight: 5,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Goal: ${widget.goal} ${widget.unit}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
