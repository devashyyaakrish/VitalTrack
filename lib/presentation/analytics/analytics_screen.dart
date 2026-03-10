import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../core/components/glass_card.dart';
import '../../core/components/animated_loader.dart';
import 'cubit/analytics_cubit.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AnalyticsCubit>().loadAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          AppStrings.analytics,
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
        ),
        actions: [
          BlocBuilder<AnalyticsCubit, AnalyticsState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _PeriodToggle(
                  isWeekly: state.showWeekly,
                  onTap: () => context.read<AnalyticsCubit>().togglePeriod(),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<AnalyticsCubit, AnalyticsState>(
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
          if (state.isLoading) return const Center(child: AnimatedLoader());

          final dates = AppDateUtils.currentWeek()
              .map((d) => AppDateUtils.toDateKey(d))
              .toList();

          return RefreshIndicator(
            onRefresh: () async => context.read<AnalyticsCubit>().loadAnalytics(),
            color: AppColors.primary,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
              children: [
                _ChartCard(
                  title: 'Water Intake',
                  subtitle: 'ml · this week',
                  color: AppColors.waterColor,
                  gradient: AppColors.waterGradient,
                  icon: Icons.water_drop_rounded,
                  child: _buildBarChart(
                      state.weeklyWater, dates, AppColors.waterColor, 2500),
                ),
                const SizedBox(height: 16),
                _ChartCard(
                  title: 'Step Count',
                  subtitle: 'steps · this week',
                  color: AppColors.stepsColor,
                  gradient: AppColors.stepsGradient,
                  icon: Icons.directions_walk_rounded,
                  child: _buildLineChart(
                      state.weeklySteps, dates, AppColors.stepsColor, 12000),
                ),
                const SizedBox(height: 16),
                _ChartCard(
                  title: 'Calories',
                  subtitle: 'kcal · this week',
                  color: AppColors.caloriesColor,
                  gradient: AppColors.caloriesGradient,
                  icon: Icons.local_fire_department_rounded,
                  child: _buildLineChart(
                      state.weeklyCalories, dates, AppColors.caloriesColor, 2500),
                ),
                const SizedBox(height: 16),
                _ChartCard(
                  title: 'Sleep Duration',
                  subtitle: 'hours · this week',
                  color: AppColors.sleepColor,
                  gradient: AppColors.sleepGradient,
                  icon: Icons.bedtime_rounded,
                  child: _buildBarChart(
                    state.weeklySleep.map((k, v) => MapEntry(k, v.toInt())),
                    dates,
                    AppColors.sleepColor,
                    10,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBarChart(
      Map<String, int> data, List<String> dates, Color color, double maxY) {
    if (data.isEmpty) {
      return const Center(
        child: Text('No data yet',
            style: TextStyle(
                fontFamily: 'Inter',
                color: AppColors.textSecondaryDark,
                fontSize: 13)),
      );
    }

    final spots = dates.asMap().entries.map((e) {
      final val = data[e.value] ?? 0;
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: val.toDouble(),
            gradient: LinearGradient(
              colors: [color.withValues(alpha: 0.7), color],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            width: 18,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          )
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY * 1.2,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= dates.length) return const Text('');
                final date = AppDateUtils.currentWeek()[idx];
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    ['M', 'T', 'W', 'T', 'F', 'S', 'S'][date.weekday - 1],
                    style: const TextStyle(
                      color: AppColors.textSecondaryDark,
                      fontSize: 11,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 3,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.white.withValues(alpha: 0.08),
            strokeWidth: 1,
            dashArray: [4, 4],
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: spots,
      ),
    );
  }

  Widget _buildLineChart(
      Map<String, int> data, List<String> dates, Color color, double maxY) {
    if (data.isEmpty) {
      return const Center(
        child: Text('No data yet',
            style: TextStyle(
                fontFamily: 'Inter',
                color: AppColors.textSecondaryDark,
                fontSize: 13)),
      );
    }

    final spots = dates.asMap().entries.map((e) {
      final val = data[e.value] ?? 0;
      return FlSpot(e.key.toDouble(), val.toDouble());
    }).toList();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 6,
        minY: 0,
        lineTouchData: const LineTouchData(enabled: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 3,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.white.withValues(alpha: 0.08),
            strokeWidth: 1,
            dashArray: [4, 4],
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx < 0 || idx >= dates.length) return const Text('');
                final date = AppDateUtils.currentWeek()[idx];
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    ['M', 'T', 'W', 'T', 'F', 'S', 'S'][date.weekday - 1],
                    style: const TextStyle(
                      color: AppColors.textSecondaryDark,
                      fontSize: 11,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            gradient: LinearGradient(colors: [color.withValues(alpha: 0.6), color]),
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                color: AppColors.backgroundDark,
                radius: 4,
                strokeColor: color,
                strokeWidth: 2,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [color.withValues(alpha: 0.2), color.withValues(alpha: 0.0)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodToggle extends StatelessWidget {
  final bool isWeekly;
  final VoidCallback onTap;

  const _PeriodToggle({required this.isWeekly, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.glassWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.date_range_rounded, size: 14, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              isWeekly ? 'This Week' : 'Overview',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final Color color;
  final Gradient gradient;
  final IconData icon;

  const _ChartCard({
    required this.title,
    required this.subtitle,
    required this.child,
    required this.color,
    required this.gradient,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      height: 230,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: Colors.white, size: 14),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(child: child),
        ],
      ),
    );
  }
}
