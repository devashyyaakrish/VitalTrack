import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/extensions.dart';
import '../../core/utils/date_utils.dart';
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
    
    final emojis = ['✅', '💧', '🏃', '📚', '🧘', '🥗', '💻', '☀️'];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('New Habit'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: emojis.map((e) => GestureDetector(
                    onTap: () => setState(() => selectedEmoji = e),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: selectedEmoji == e ? AppColors.progressTrackLight : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(color: selectedEmoji == e ? AppColors.primary : Colors.transparent),
                      ),
                      child: Text(e, style: const TextStyle(fontSize: 24)),
                    ),
                  )).toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Habit Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descCtrl,
                  decoration: const InputDecoration(labelText: 'Description (optional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx), 
              child: const Text('Cancel')
            ),
            ElevatedButton(
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
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.habitTracker),
      ),
      body: BlocConsumer<HabitBloc, HabitState>(
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

          if (state.habits.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text('No habits yet.', style: context.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text('Start building good routines today.', style: context.textTheme.bodyMedium),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _showAddHabitDialog,
                    child: const Text('Create Habit'),
                  ),
                ],
              ),
            );
          }

          final todayKey = AppDateUtils.todayKey;

          return RefreshIndicator(
            onRefresh: () async => context.read<HabitBloc>().add(HabitLoadEvent()),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.habits.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final habit = state.habits[index];
                final isDoneToday = state.isCompleted(habit.id, todayKey);
                
                return _HabitCard(
                  habit: habit,
                  isCompletedToday: isDoneToday,
                  onToggle: () => context.read<HabitBloc>().add(
                        HabitToggleLogEvent(habitId: habit.id, dateKey: todayKey),
                      ),
                  onDelete: () => context.read<HabitBloc>().add(
                        HabitDeleteEvent(habitId: habit.id),
                      ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddHabitDialog,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _HabitCard extends StatelessWidget {
  final HabitEntity habit;
  final bool isCompletedToday;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _HabitCard({
    required this.habit,
    required this.isCompletedToday,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isCompletedToday ? AppColors.success.withOpacity(0.15) : AppColors.inputFillLight,
            shape: BoxShape.circle,
          ),
          child: Text(habit.iconEmoji, style: const TextStyle(fontSize: 24)),
        ),
        title: Text(
          habit.name,
          style: context.textTheme.titleMedium?.copyWith(
            decoration: isCompletedToday ? TextDecoration.lineThrough : null,
            color: isCompletedToday ? Colors.grey : null,
          ),
        ),
        subtitle: Row(
          children: [
            const Icon(Icons.local_fire_department, size: 16, color: Colors.orange),
            const SizedBox(width: 4),
            Text('${habit.currentStreak} day streak', style: context.textTheme.bodySmall),
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            isCompletedToday ? Icons.check_circle : Icons.circle_outlined,
            color: isCompletedToday ? AppColors.success : Colors.grey,
            size: 32,
          ),
          onPressed: onToggle,
        ),
        onLongPress: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Delete Habit?'),
              content: Text('Remove "${habit.name}" entirely?'),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                TextButton(
                  onPressed: () {
                    onDelete();
                    Navigator.pop(ctx);
                  },
                  child: const Text('Delete', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
