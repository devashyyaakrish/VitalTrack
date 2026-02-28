import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/date_utils.dart';
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
      appBar: AppBar(
        title: const Text(AppStrings.analytics),
        actions: [
          BlocBuilder<AnalyticsCubit, AnalyticsState>(
            builder: (context, state) {
              return TextButton.icon(
                onPressed: () => context.read<AnalyticsCubit>().togglePeriod(),
                icon: const Icon(Icons.date_range),
                label: Text(state.showWeekly ? 'This Week' : 'Overview'),
              );
            },
          )
        ],
      ),
      body: BlocConsumer<AnalyticsCubit, AnalyticsState>(
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

          final dates = AppDateUtils.currentWeek().map((d) => AppDateUtils.toDateKey(d)).toList();

          return RefreshIndicator(
            onRefresh: () async => context.read<AnalyticsCubit>().loadAnalytics(),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _ChartCard(
                  title: 'Water Intake (ml)',
                  color: AppColors.waterColor,
                  child: _buildBarChart(state.weeklyWater, dates, AppColors.waterColor, 2000),
                ),
                const SizedBox(height: 16),
                _ChartCard(
                  title: 'Steps',
                  color: AppColors.stepsColor,
                  child: _buildLineChart(state.weeklySteps, dates, AppColors.stepsColor, 10000),
                ),
                const SizedBox(height: 16),
                _ChartCard(
                  title: 'Calories (kcal)',
                  color: AppColors.caloriesColor,
                  child: _buildLineChart(state.weeklyCalories, dates, AppColors.caloriesColor, 2000),
                ),
                const SizedBox(height: 16),
                _ChartCard(
                  title: 'Sleep (hours)',
                  color: AppColors.sleepColor,
                  child: _buildBarChart(
                    state.weeklySleep.map((k, v) => MapEntry(k, v.toInt())), // Rough cast for uniform chart func
                    dates,
                    AppColors.sleepColor,
                    8,
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBarChart(Map<String, int> data, List<String> dates, Color color, double maxY) {
    if (data.isEmpty) return const Center(child: Text('No data'));

    final spots = dates.asMap().entries.map((e) {
      final val = data[e.value] ?? 0;
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: val.toDouble(),
            color: color,
            width: 16,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          )
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: AppDateUtils.currentWeek().isNotEmpty ? maxY * 1.5 : maxY, // Dynamic scaling placeholder
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < 0 || value.toInt() >= dates.length) return const Text('');
                final date = AppDateUtils.currentWeek()[value.toInt()];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    ['M', 'T', 'W', 'T', 'F', 'S', 'S'][date.weekday - 1],
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
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
          horizontalInterval: maxY / 2,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.2),
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: spots,
      ),
    );
  }

  Widget _buildLineChart(Map<String, int> data, List<String> dates, Color color, double maxY) {
    if (data.isEmpty) return const Center(child: Text('No data'));

    final spots = dates.asMap().entries.map((e) {
      final val = data[e.value] ?? 0;
      return FlSpot(e.key.toDouble(), val.toDouble());
    }).toList();

    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 6,
        minY: 0,
        // maxY: maxY * 1.5,
        lineTouchData: const LineTouchData(enabled: false),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 2,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.2),
            strokeWidth: 1,
            dashArray: [5, 5],
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < 0 || value.toInt() >= dates.length) return const Text('');
                final date = AppDateUtils.currentWeek()[value.toInt()];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    ['M', 'T', 'W', 'T', 'F', 'S', 'S'][date.weekday - 1],
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
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
            color: color,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                color: context.theme.cardColor,
                radius: 4,
                strokeColor: color,
                strokeWidth: 2,
              ),
            ),
            belowBarData: BarAreaData(
              show: true,
              color: color.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final Widget child;
  final Color color;

  const _ChartCard({required this.title, required this.child, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 250,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(title, style: context.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(child: child),
          ],
        ));
  }
}
