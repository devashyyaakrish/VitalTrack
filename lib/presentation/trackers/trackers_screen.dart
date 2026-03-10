import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/date_utils.dart';
import '../../core/components/glass_card.dart';
import '../../core/components/glass_button.dart';
import '../../core/components/metric_ring.dart';
import '../../core/components/animated_loader.dart';
import '../health/health_cubits.dart' as hc;
import '../health/health_cubits.dart' hide StepState;

class TrackersScreen extends StatefulWidget {
  const TrackersScreen({super.key});

  @override
  State<TrackersScreen> createState() => _TrackersScreenState();
}

class _TrackersScreenState extends State<TrackersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Health Trackers',
          style: TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.backgroundDark2,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            decoration: BoxDecoration(
              color: AppColors.glassWhite,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.glassBorder),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: false,
              indicatorSize: TabBarIndicatorSize.tab,
              labelPadding: EdgeInsets.zero,
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textSecondaryDark,
              indicator: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              dividerColor: Colors.transparent,
              labelStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
              ),
              tabs: const [
                Tab(text: '💧 Water'),
                Tab(text: '🏃 Steps'),
                Tab(text: '🍎 Food'),
                Tab(text: '🌙 Sleep'),
              ],
            ),
          ),
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

// ── Water Tab ──────────────────────────────────────────────────────────────────

class _WaterTab extends StatelessWidget {
  const _WaterTab();

  void _showAddWaterDialog(BuildContext context) {
    int amount = 250;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          backgroundColor: Colors.transparent,
          child: GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.water_drop_rounded,
                    color: AppColors.waterColor, size: 36),
                const SizedBox(height: 8),
                const Text(
                  'How much did you drink?',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryDark,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  '$amount ml',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: AppColors.waterColor,
                    letterSpacing: -1,
                  ),
                ),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: AppColors.waterColor,
                    inactiveTrackColor: AppColors.waterColor.withOpacity(0.2),
                    thumbColor: AppColors.waterColor,
                    overlayColor: AppColors.waterColor.withOpacity(0.2),
                  ),
                  child: Slider(
                    value: amount.toDouble(),
                    min: 50,
                    max: 1000,
                    divisions: 19,
                    onChanged: (val) => setState(() => amount = val.toInt()),
                  ),
                ),
                const SizedBox(height: 8),
                // Quick picks
                Wrap(
                  spacing: 8,
                  children: [150, 200, 250, 350, 500].map((ml) {
                    return GestureDetector(
                      onTap: () => setState(() => amount = ml),
                      child: Chip(
                        label: Text('$ml ml'),
                        backgroundColor: amount == ml
                            ? AppColors.waterColor.withOpacity(0.3)
                            : AppColors.glassWhite,
                        labelStyle: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: amount == ml
                              ? AppColors.waterColor
                              : AppColors.textSecondaryDark,
                          fontWeight: FontWeight.w600,
                        ),
                        side: BorderSide(
                          color: amount == ml
                              ? AppColors.waterColor
                              : AppColors.glassBorder,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: GlassButton.outlined(
                        label: 'Cancel',
                        onPressed: () => Navigator.pop(ctx),
                        height: 44,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GlassButton(
                        label: 'Add',
                        onPressed: () {
                          context.read<WaterCubit>().addWater(amount);
                          Navigator.pop(ctx);
                        },
                        height: 44,
                        gradient: AppColors.waterGradient,
                        glowColor: AppColors.waterColor.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WaterCubit, WaterState>(
      builder: (context, state) {
        if (state.isLoading) return const Center(child: AnimatedLoader(color: AppColors.waterColor));
        return _TrackerTabLayout(
          ring: MetricRing(
            progress: state.progress,
            value: '${state.totalMl}',
            unit: 'ml',
            icon: Icons.water_drop_rounded,
            gradient: AppColors.waterGradient,
          ),
          actionButton: GlassButton(
            label: 'Add Water',
            icon: Icons.add_rounded,
            gradient: AppColors.waterGradient,
            glowColor: AppColors.waterColor.withOpacity(0.4),
            onPressed: () => _showAddWaterDialog(context),
            width: 200,
          ),
          goalText: 'Goal: ${state.goalMl} ml',
        );
      },
    );
  }
}

// ── Steps Tab ──────────────────────────────────────────────────────────────────

class _StepsTab extends StatelessWidget {
  const _StepsTab();

  void _showAddStepsDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.directions_walk_rounded,
                  color: AppColors.stepsColor, size: 36),
              const SizedBox(height: 8),
              const Text(
                'Log Steps',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryDark,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: ctrl,
                keyboardType: TextInputType.number,
                autofocus: true,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppColors.stepsColor,
                ),
                decoration: InputDecoration(
                  hintText: '0',
                  hintStyle: TextStyle(
                    color: AppColors.stepsColor.withOpacity(0.3),
                    fontFamily: 'Inter',
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                  border: InputBorder.none,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GlassButton.outlined(
                      label: 'Cancel',
                      onPressed: () => Navigator.pop(ctx),
                      height: 44,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlassButton(
                      label: 'Log',
                      gradient: AppColors.stepsGradient,
                      glowColor: AppColors.stepsColor.withOpacity(0.4),
                      height: 44,
                      onPressed: () {
                        final steps = int.tryParse(ctrl.text) ?? 0;
                        if (steps > 0) context.read<StepCubit>().addSteps(steps);
                        Navigator.pop(ctx);
                      },
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<hc.StepCubit, hc.StepState>(
      builder: (context, state) {
        if (state.isLoading) return const Center(child: AnimatedLoader(color: AppColors.stepsColor));
        return _TrackerTabLayout(
          ring: MetricRing(
            progress: state.progress,
            value: state.totalSteps.formatted,
            unit: 'steps',
            icon: Icons.directions_walk_rounded,
            gradient: AppColors.stepsGradient,
          ),
          actionButton: GlassButton(
            label: 'Log Steps',
            icon: Icons.add_rounded,
            gradient: AppColors.stepsGradient,
            glowColor: AppColors.stepsColor.withOpacity(0.4),
            onPressed: () => _showAddStepsDialog(context),
            width: 200,
          ),
          goalText: 'Goal: ${state.goalSteps.formatted} steps',
        );
      },
    );
  }
}

// ── Calories Tab ───────────────────────────────────────────────────────────────

class _CaloriesTab extends StatelessWidget {
  const _CaloriesTab();

  void _showAddMealDialog(BuildContext context) {
    final nameCtrl = TextEditingController();
    final calCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.restaurant_rounded,
                  color: AppColors.caloriesColor, size: 36),
              const SizedBox(height: 8),
              const Text(
                'Log Meal',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryDark,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                style: const TextStyle(fontFamily: 'Inter', color: AppColors.textPrimaryDark),
                decoration: InputDecoration(
                  hintText: 'Meal name (e.g. Avocado Toast)',
                  hintStyle: TextStyle(color: AppColors.textSecondaryDark, fontFamily: 'Inter', fontSize: 13),
                  filled: true,
                  fillColor: AppColors.glassWhite,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.glassBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.glassBorder),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: calCtrl,
                keyboardType: TextInputType.number,
                style: const TextStyle(fontFamily: 'Inter', color: AppColors.caloriesColor, fontSize: 18, fontWeight: FontWeight.w700),
                decoration: InputDecoration(
                  hintText: 'Calories (kcal)',
                  hintStyle: TextStyle(color: AppColors.caloriesColor.withOpacity(0.4), fontFamily: 'Inter', fontSize: 13),
                  filled: true,
                  fillColor: AppColors.caloriesColor.withOpacity(0.08),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.glassBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.caloriesColor.withOpacity(0.3)),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GlassButton.outlined(
                      label: 'Cancel',
                      onPressed: () => Navigator.pop(ctx),
                      height: 44,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GlassButton(
                      label: 'Add',
                      gradient: AppColors.caloriesGradient,
                      glowColor: AppColors.caloriesColor.withOpacity(0.4),
                      height: 44,
                      onPressed: () {
                        final cals = int.tryParse(calCtrl.text) ?? 0;
                        final name = nameCtrl.text.trim();
                        if (cals > 0 && name.isNotEmpty) {
                          context.read<CalorieCubit>().addMeal(name: name, calories: cals);
                        }
                        Navigator.pop(ctx);
                      },
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<CalorieCubit, CalorieState>(
      builder: (context, state) {
        if (state.isLoading) return const Center(child: AnimatedLoader(color: AppColors.caloriesColor));

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                child: Column(
                  children: [
                    // Summary Ring
                    MetricRing(
                      progress: state.progress,
                      value: '${state.totalCalories}',
                      unit: 'kcal',
                      icon: Icons.local_fire_department_rounded,
                      gradient: AppColors.caloriesGradient,
                      size: 175,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Goal: ${state.goalCalories} kcal',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GlassButton(
                      label: 'Log Meal',
                      icon: Icons.add_rounded,
                      gradient: AppColors.caloriesGradient,
                      glowColor: AppColors.caloriesColor.withOpacity(0.4),
                      onPressed: () => _showAddMealDialog(context),
                      width: 200,
                    ),
                    const SizedBox(height: 24),
                    if (state.entries.isNotEmpty)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "TODAY'S MEALS",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            if (state.entries.isEmpty)
              const SliverToBoxAdapter(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: Text(
                      'No meals logged today',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: AppColors.textSecondaryDark,
                      ),
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final entry = state.entries[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: GlassCard(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  gradient: AppColors.caloriesGradient,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.fastfood_rounded,
                                    color: Colors.white, size: 16),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(entry.mealName,
                                        style: const TextStyle(
                                          fontFamily: 'Inter',
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimaryDark,
                                        )),
                                    Text(
                                      AppDateUtils.displayTime(entry.timestamp),
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 11,
                                        color: AppColors.textSecondaryDark,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${entry.calories} kcal',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.caloriesColor,
                                ),
                              ),
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: () =>
                                    context.read<CalorieCubit>().deleteEntry(entry.id),
                                child: const Icon(Icons.close_rounded,
                                    size: 16, color: AppColors.textSecondaryDark),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: state.entries.length,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// ── Sleep Tab ──────────────────────────────────────────────────────────────────

class _SleepTab extends StatefulWidget {
  const _SleepTab();
  @override
  State<_SleepTab> createState() => _SleepTabState();
}

class _SleepTabState extends State<_SleepTab> {
  TimeOfDay _bedTime = const TimeOfDay(hour: 22, minute: 30);
  TimeOfDay _wakeTime = const TimeOfDay(hour: 6, minute: 30);

  Future<void> _selectTime(BuildContext context, bool isBedTime) async {
    final picked = await showTimePicker(
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
    var start = DateTime(now.year, now.month, now.day, _bedTime.hour, _bedTime.minute);
    if (_bedTime.hour > 12) start = start.subtract(const Duration(days: 1));
    final end = DateTime(now.year, now.month, now.day, _wakeTime.hour, _wakeTime.minute);
    context.read<SleepCubit>().logSleep(sleepStart: start, sleepEnd: end);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SleepCubit, SleepState>(
      builder: (context, state) {
        if (state.isLoading) return const Center(child: AnimatedLoader(color: AppColors.sleepColor));

        final durationH = state.todaySleep?.durationHours ?? 0.0;
        final goalH = 8.0;
        final progress = (durationH / goalH).clamp(0.0, 1.0);

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 100),
          child: Column(
            children: [
              MetricRing(
                progress: progress,
                value: state.todaySleep != null
                    ? durationH.toStringAsFixed(1)
                    : '0',
                unit: 'hours',
                icon: Icons.bedtime_rounded,
                gradient: AppColors.sleepGradient,
                size: 175,
              ),
              const SizedBox(height: 8),
              Text(
                state.todaySleep != null ? 'Logged today' : 'No sleep logged yet',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.textSecondaryDark,
                ),
              ),
              const SizedBox(height: 28),

              // Time pickers
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SET SLEEP SCHEDULE',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: AppColors.textSecondaryDark,
                        )),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _TimePickerTile(
                            title: 'Bedtime',
                            time: _bedTime,
                            icon: CupertinoIcons.moon_fill,
                            color: AppColors.sleepColor,
                            onTap: () => _selectTime(context, true),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Icon(Icons.arrow_forward_rounded,
                              size: 16, color: AppColors.textSecondaryDark),
                        ),
                        Expanded(
                          child: _TimePickerTile(
                            title: 'Wake up',
                            time: _wakeTime,
                            icon: CupertinoIcons.sun_max_fill,
                            color: AppColors.accent,
                            onTap: () => _selectTime(context, false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    GlassButton(
                      label: 'Save Sleep Log',
                      gradient: AppColors.sleepGradient,
                      glowColor: AppColors.sleepColor.withOpacity(0.4),
                      onPressed: _logSleep,
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
}

class _TimePickerTile extends StatelessWidget {
  final String title;
  final TimeOfDay time;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _TimePickerTile({
    required this.title,
    required this.time,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: AppColors.textSecondaryDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time.format(context),
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Shared Layout ──────────────────────────────────────────────────────────────

class _TrackerTabLayout extends StatelessWidget {
  final Widget ring;
  final Widget actionButton;
  final String goalText;

  const _TrackerTabLayout({
    required this.ring,
    required this.actionButton,
    required this.goalText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ring,
            const SizedBox(height: 12),
            Text(
              goalText,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: AppColors.textSecondaryDark,
              ),
            ),
            const SizedBox(height: 28),
            actionButton,
          ],
        ),
      ),
    );
  }
}
