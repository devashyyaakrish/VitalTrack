import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/date_utils.dart';
import '../health/health_cubits.dart' as hc;
import '../health/health_cubits.dart' hide StepState;

class TrackersScreen extends StatefulWidget {
  const TrackersScreen({super.key});

  @override
  State<TrackersScreen> createState() => _TrackersScreenState();
}

class _TrackersScreenState extends State<TrackersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    // Load initial data for all tabs
    context.read<WaterCubit>().loadTodayEntries();
    context.read<StepCubit>().loadTodaySteps();
    context.read<CalorieCubit>().loadTodayEntries();
    context.read<SleepCubit>().loadTodaySleep();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Trackers'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: context.theme.colorScheme.primary,
          unselectedLabelColor: context.theme.textTheme.bodySmall?.color,
          indicatorColor: context.theme.colorScheme.primary,
          tabs: const [
            Tab(icon: Icon(Icons.water_drop), text: 'Water'),
            Tab(icon: Icon(Icons.directions_walk), text: 'Steps'),
            Tab(icon: Icon(Icons.local_dining), text: 'Food'),
            Tab(icon: Icon(Icons.bedtime), text: 'Sleep'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _WaterTab(),
          _StepsTab(),
          _CaloriesTab(),
          _SleepTab(),
        ],
      ),
    );
  }
}

// ── Water Tab ─────────────────────────────────────────────────────────────────

class _WaterTab extends StatelessWidget {
  const _WaterTab();

  void _showAddWaterDialog(BuildContext context) {
    int amount = 250;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Water'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$amount ml', style: context.textTheme.displaySmall),
              Slider(
                value: amount.toDouble(),
                min: 50,
                max: 1000,
                divisions: 19,
                label: '$amount ml',
                onChanged: (val) => setState(() => amount = val.toInt()),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                context.read<WaterCubit>().addWater(amount);
                Navigator.pop(ctx);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaterCubit, WaterState>(
      builder: (context, state) {
        if (state.isLoading) return const Center(child: CircularProgressIndicator());

        return Column(
          children: [
            const SizedBox(height: 32),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: CircularProgressIndicator(
                    value: state.progress,
                    strokeWidth: 16,
                    backgroundColor: AppColors.progressTrackLight, // Adapt for dark mode as needed
                    color: AppColors.waterColor,
                  ),
                ),
                Column(
                  children: [
                    const Icon(Icons.water_drop, color: AppColors.waterColor, size: 40),
                    const SizedBox(height: 8),
                    Text('${state.totalMl}', style: context.textTheme.displayMedium),
                    Text('/ ${state.goalMl} ml', style: context.textTheme.bodyMedium),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showAddWaterDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Drink Water'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.waterColor),
            ),
            const Expanded(child: SizedBox()),
          ],
        );
      },
    );
  }
}

// ── Steps Tab ─────────────────────────────────────────────────────────────────

class _StepsTab extends StatelessWidget {
  const _StepsTab();

  void _showAddStepsDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Steps'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Number of steps'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final steps = int.tryParse(ctrl.text) ?? 0;
              if (steps > 0) {
                context.read<StepCubit>().addSteps(steps);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<hc.StepCubit, hc.StepState>(
      builder: (context, state) {
        if (state.isLoading) return const Center(child: CircularProgressIndicator());

        return Column(
          children: [
            const SizedBox(height: 32),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: CircularProgressIndicator(
                    value: state.progress,
                    strokeWidth: 16,
                    backgroundColor: AppColors.progressTrackLight,
                    color: AppColors.stepsColor,
                  ),
                ),
                Column(
                  children: [
                    const Icon(Icons.directions_walk, color: AppColors.stepsColor, size: 40),
                    const SizedBox(height: 8),
                    Text(state.totalSteps.formatted, style: context.textTheme.displayMedium),
                    Text('/ ${state.goalSteps.formatted} steps', style: context.textTheme.bodyMedium),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _showAddStepsDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Manual Entry'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.stepsColor),
            ),
            const Spacer(),
            Text('Auto-sync with Apple Health / Google Fit coming soon.', style: context.textTheme.labelSmall),
            const SizedBox(height: 32),
          ],
        );
      },
    );
  }
}

// ── Calories Tab ──────────────────────────────────────────────────────────────

class _CaloriesTab extends StatelessWidget {
  const _CaloriesTab();

  void _showAddMealDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final calCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Meal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Meal Name (e.g., Avocado Toast)'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: calCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Calories (kcal)'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final cals = int.tryParse(calCtrl.text) ?? 0;
              final name = nameCtrl.text.trim();
              if (cals > 0 && name.isNotEmpty) {
                context.read<CalorieCubit>().addMeal(name: name, calories: cals);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalorieCubit, CalorieState>(
      builder: (context, state) {
        if (state.isLoading) return const Center(child: CircularProgressIndicator());

        return Column(
          children: [
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text('Consumed', style: context.textTheme.labelMedium),
                    Text('${state.totalCalories}', style: context.textTheme.displaySmall?.copyWith(color: AppColors.caloriesColor)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(width: 1, height: 40, color: Colors.grey),
                ),
                Column(
                  children: [
                    Text('Goal', style: context.textTheme.labelMedium),
                    Text('${state.goalCalories}', style: context.textTheme.displaySmall?.copyWith(color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: LinearProgressIndicator(
                value: state.progress,
                minHeight: 12,
                borderRadius: BorderRadius.circular(6),
                color: AppColors.caloriesColor,
                backgroundColor: AppColors.progressTrackLight,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showAddMealDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('Log Meal'),
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.caloriesColor),
            ),
            const SizedBox(height: 24),
            const Divider(),
            Expanded(
              child: state.entries.isEmpty
                  ? Center(child: Text('No meals logged today.', style: context.textTheme.bodyMedium))
                  : ListView.builder(
                      itemCount: state.entries.length,
                      itemBuilder: (context, index) {
                        final entry = state.entries[index];
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: AppColors.inputFillLight,
                            child: Icon(Icons.fastfood, color: AppColors.caloriesColor),
                          ),
                          title: Text(entry.mealName),
                          subtitle: Text(AppDateUtils.displayTime(entry.timestamp)),
                          trailing: Text('${entry.calories} kcal', style: context.textTheme.labelLarge),
                          onLongPress: () => context.read<CalorieCubit>().deleteEntry(entry.id),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

// ── Sleep Tab ─────────────────────────────────────────────────────────────────

class _SleepTab extends StatefulWidget {
  const _SleepTab();
  @override
  State<_SleepTab> createState() => _SleepTabState();
}

class _SleepTabState extends State<_SleepTab> {
  TimeOfDay _bedTime = const TimeOfDay(hour: 22, minute: 30);
  TimeOfDay _wakeTime = const TimeOfDay(hour: 6, minute: 30);

  Future<void> _selectTime(BuildContext context, bool isBedTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isBedTime ? _bedTime : _wakeTime,
    );
    if (picked != null) {
      setState(() {
        if (isBedTime) _bedTime = picked;
        else _wakeTime = picked;
      });
    }
  }

  void _logSleep() {
    final now = DateTime.now();
    // Reconstruct start time (yesterday if PM, today if AM — simplistic logic)
    var start = DateTime(now.year, now.month, now.day, _bedTime.hour, _bedTime.minute);
    if (_bedTime.hour > 12) {
      start = start.subtract(const Duration(days: 1));
    }
    
    var end = DateTime(now.year, now.month, now.day, _wakeTime.hour, _wakeTime.minute);
    
    context.read<SleepCubit>().logSleep(sleepStart: start, sleepEnd: end);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SleepCubit, SleepState>(
      builder: (context, state) {
        if (state.isLoading) return const Center(child: CircularProgressIndicator());

        return Column(
          children: [
            const SizedBox(height: 32),
            Icon(Icons.bedtime, size: 80, color: AppColors.sleepColor),
            const SizedBox(height: 16),
            if (state.todaySleep != null) ...[
              Text(
                '${state.todaySleep!.durationHours.toStringAsFixed(1)} hours',
                style: context.textTheme.displayLarge?.copyWith(color: AppColors.sleepColor),
              ),
              Text('logged today', style: context.textTheme.bodyMedium),
            ] else ...[
              Text('No sleep logged yet', style: context.textTheme.titleLarge),
            ],
            const SizedBox(height: 48),
            
            // Time Pickers
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _TimePickerCard(
                    title: 'Bedtime',
                    time: _bedTime,
                    icon: CupertinoIcons.moon_fill,
                    onTap: () => _selectTime(context, true),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  _TimePickerCard(
                    title: 'Wake up',
                    time: _wakeTime,
                    icon: CupertinoIcons.sun_max_fill,
                    onTap: () => _selectTime(context, false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _logSleep,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.sleepColor),
              child: const Text('Set Sleep Log'),
            ),
          ],
        );
      },
    );
  }
}

class _TimePickerCard extends StatelessWidget {
  final String title;
  final TimeOfDay time;
  final IconData icon;
  final VoidCallback onTap;

  const _TimePickerCard({required this.title, required this.time, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: AppColors.sleepColor),
                const SizedBox(width: 8),
                Text(title, style: context.textTheme.labelMedium),
              ],
            ),
            const SizedBox(height: 8),
            Text(time.format(context), style: context.textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
