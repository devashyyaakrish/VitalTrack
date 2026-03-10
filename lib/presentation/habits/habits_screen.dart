import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/date_utils.dart';
import '../../core/components/glass_card.dart';
import '../../core/components/glass_button.dart';
import '../../core/components/glass_input_field.dart';
import '../../core/components/animated_loader.dart';
import 'bloc/habit_bloc.dart';
import '../../domain/entities/habit_entity.dart';

class HabitsScreen extends StatefulWidget {
  const HabitsScreen({super.key});

  @override
  State<HabitsScreen> createState() => _HabitsScreenState();
}

class _HabitsScreenState extends State<HabitsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HabitBloc>().add(HabitLoadEvent());
  }

  void _showAddHabitDialog() {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    String selectedEmoji = '✅';
    final emojis = ['✅', '💧', '🏃', '📚', '🧘', '🥗', '💻', '☀️', '🎯', '🎵'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: GlassCard(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'New Habit',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Choose an emoji and give your habit a name',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.textSecondaryDark,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Emoji picker
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: emojis.map((e) {
                      final isSelected = selectedEmoji == e;
                      return GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setDialogState(() => selectedEmoji = e);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.2)
                                : AppColors.glassWhite,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.glassBorder,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Text(e, style: const TextStyle(fontSize: 22)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),

                  GlassInputField(
                    controller: nameCtrl,
                    hintText: 'Habit name (e.g. Drink Water)',
                    prefixIcon: Icons.edit_outlined,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 12),
                  GlassInputField(
                    controller: descCtrl,
                    hintText: 'Description (optional)',
                    prefixIcon: Icons.notes_rounded,
                  ),
                  const SizedBox(height: 22),

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
                          label: 'Create',
                          height: 44,
                          onPressed: () {
                            final name = nameCtrl.text.trim();
                            if (name.isNotEmpty) {
                              context.read<HabitBloc>().add(HabitCreateEvent(
                                    name: name,
                                    description: descCtrl.text.trim(),
                                    iconEmoji: selectedEmoji,
                                  ));
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HabitBloc, HabitState>(
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
        return Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text(
              AppStrings.habitTracker,
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
              ),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: AppColors.habitsGradient,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.habitsColor.withValues(alpha: 0.4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.add_rounded, color: Colors.white, size: 18),
                ),
                onPressed: _showAddHabitDialog,
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: state.isLoading
              ? const Center(child: AnimatedLoader(color: AppColors.habitsColor))
              : state.habits.isEmpty
                  ? _EmptyHabitsState(onAdd: _showAddHabitDialog)
                  : RefreshIndicator(
                      onRefresh: () async =>
                          context.read<HabitBloc>().add(HabitLoadEvent()),
                      color: AppColors.habitsColor,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                        itemCount: state.habits.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final habit = state.habits[index];
                          final todayKey = AppDateUtils.todayKey;
                          final isDone = state.isCompleted(habit.id, todayKey);
                          return _HabitCard(
                            habit: habit,
                            isCompletedToday: isDone,
                            index: index,
                            onToggle: () => context.read<HabitBloc>().add(
                                  HabitToggleLogEvent(
                                      habitId: habit.id, dateKey: todayKey),
                                ),
                            onDelete: () => context.read<HabitBloc>().add(
                                  HabitDeleteEvent(habitId: habit.id),
                                ),
                          );
                        },
                      ),
                    ),
        );
      },
    );
  }
}

class _EmptyHabitsState extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyHabitsState({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: AppColors.habitsGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.habitsColor.withValues(alpha: 0.35),
                    blurRadius: 24,
                  ),
                ],
              ),
              child: const Icon(Icons.check_circle_outline_rounded,
                  color: Colors.white, size: 48),
            ),
            const SizedBox(height: 24),
            const Text(
              'No habits yet',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimaryDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Start building good routines today.\nSmall steps lead to big changes.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: AppColors.textSecondaryDark,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            GlassButton(
              label: 'Create First Habit',
              icon: Icons.add_rounded,
              gradient: AppColors.habitsGradient,
              glowColor: AppColors.habitsColor.withValues(alpha: 0.4),
              onPressed: onAdd,
              width: 220,
            ),
          ],
        ),
      ),
    );
  }
}

class _HabitCard extends StatefulWidget {
  final HabitEntity habit;
  final bool isCompletedToday;
  final int index;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _HabitCard({
    required this.habit,
    required this.isCompletedToday,
    required this.index,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  State<_HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<_HabitCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _slideY;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 350 + widget.index * 60),
    );
    _slideY = Tween<double>(begin: 20, end: 0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _opacity = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: GlassCard(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.delete_outline_rounded,
                  color: AppColors.error, size: 36),
              const SizedBox(height: 12),
              const Text(
                'Delete Habit?',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: AppColors.textPrimaryDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Remove "${widget.habit.name}" entirely?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AppColors.textSecondaryDark,
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
                      label: 'Delete',
                      height: 44,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFDC2626), Color(0xFFF87171)],
                      ),
                      glowColor: AppColors.error.withValues(alpha: 0.4),
                      onPressed: () {
                        widget.onDelete();
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        onTap: widget.onToggle,
        child: Row(
          children: [
            // Emoji bubble
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.isCompletedToday
                    ? AppColors.success.withValues(alpha: 0.2)
                    : AppColors.glassWhite,
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.isCompletedToday
                      ? AppColors.success.withValues(alpha: 0.5)
                      : AppColors.glassBorder,
                ),
              ),
              child: Text(widget.habit.iconEmoji,
                  style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 14),

            // Name + streak
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: widget.isCompletedToday
                          ? AppColors.textSecondaryDark
                          : AppColors.textPrimaryDark,
                      decoration: widget.isCompletedToday
                          ? TextDecoration.lineThrough
                          : null,
                      decorationColor: AppColors.textSecondaryDark,
                    ),
                    child: Text(widget.habit.name),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Text('🔥', style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      Text(
                        '${widget.habit.currentStreak} day streak',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Actions
            GestureDetector(
              onLongPress: _confirmDelete,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: widget.isCompletedToday
                      ? AppColors.success.withValues(alpha: 0.2)
                      : Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.isCompletedToday
                        ? AppColors.success
                        : AppColors.glassBorder,
                    width: widget.isCompletedToday ? 2 : 1,
                  ),
                ),
                child: Icon(
                  widget.isCompletedToday
                      ? Icons.check_rounded
                      : Icons.circle_outlined,
                  color: widget.isCompletedToday
                      ? AppColors.success
                      : AppColors.textSecondaryDark,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
