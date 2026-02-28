import 'package:equatable/equatable.dart';

/// Habit domain entity
class HabitEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String? description;
  final String iconEmoji;
  final int currentStreak;
  final int longestStreak;
  final DateTime createdAt;
  final bool isActive;

  const HabitEntity({
    required this.id,
    required this.userId,
    required this.name,
    this.description,
    this.iconEmoji = '✅',
    this.currentStreak = 0,
    this.longestStreak = 0,
    required this.createdAt,
    this.isActive = true,
  });

  HabitEntity copyWith({
    String? name,
    String? description,
    String? iconEmoji,
    int? currentStreak,
    int? longestStreak,
    bool? isActive,
  }) {
    return HabitEntity(
      id: id,
      userId: userId,
      name: name ?? this.name,
      description: description ?? this.description,
      iconEmoji: iconEmoji ?? this.iconEmoji,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      createdAt: createdAt,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  List<Object?> get props => [id, userId, name, currentStreak, longestStreak, isActive];
}

/// Log for a specific day's habit completion
class HabitLogEntity extends Equatable {
  final String id;
  final String habitId;
  final String userId;
  final String dateKey; // 'yyyy-MM-dd'
  final bool isCompleted;
  final DateTime loggedAt;

  const HabitLogEntity({
    required this.id,
    required this.habitId,
    required this.userId,
    required this.dateKey,
    required this.isCompleted,
    required this.loggedAt,
  });

  @override
  List<Object?> get props => [id, habitId, userId, dateKey, isCompleted];
}
