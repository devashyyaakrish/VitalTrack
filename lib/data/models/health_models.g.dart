// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WaterEntryModelAdapter extends TypeAdapter<WaterEntryModel> {
  @override
  final int typeId = 1;

  @override
  WaterEntryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WaterEntryModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      amountMl: fields[2] as int,
      timestamp: fields[3] as DateTime,
      dateKey: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, WaterEntryModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.amountMl)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.dateKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WaterEntryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StepEntryModelAdapter extends TypeAdapter<StepEntryModel> {
  @override
  final int typeId = 2;

  @override
  StepEntryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StepEntryModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      steps: fields[2] as int,
      timestamp: fields[3] as DateTime,
      dateKey: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StepEntryModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.steps)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.dateKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StepEntryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CalorieEntryModelAdapter extends TypeAdapter<CalorieEntryModel> {
  @override
  final int typeId = 3;

  @override
  CalorieEntryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalorieEntryModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      mealName: fields[2] as String,
      calories: fields[3] as int,
      timestamp: fields[4] as DateTime,
      dateKey: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CalorieEntryModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.mealName)
      ..writeByte(3)
      ..write(obj.calories)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.dateKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalorieEntryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SleepEntryModelAdapter extends TypeAdapter<SleepEntryModel> {
  @override
  final int typeId = 4;

  @override
  SleepEntryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SleepEntryModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      sleepStart: fields[2] as DateTime,
      sleepEnd: fields[3] as DateTime,
      durationHours: fields[4] as double,
      dateKey: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SleepEntryModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.sleepStart)
      ..writeByte(3)
      ..write(obj.sleepEnd)
      ..writeByte(4)
      ..write(obj.durationHours)
      ..writeByte(5)
      ..write(obj.dateKey);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SleepEntryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HabitModelAdapter extends TypeAdapter<HabitModel> {
  @override
  final int typeId = 5;

  @override
  HabitModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitModel(
      id: fields[0] as String,
      userId: fields[1] as String,
      name: fields[2] as String,
      description: fields[3] as String?,
      iconEmoji: fields[4] as String,
      currentStreak: fields[5] as int,
      longestStreak: fields[6] as int,
      createdAt: fields[7] as DateTime,
      isActive: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HabitModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.iconEmoji)
      ..writeByte(5)
      ..write(obj.currentStreak)
      ..writeByte(6)
      ..write(obj.longestStreak)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class HabitLogModelAdapter extends TypeAdapter<HabitLogModel> {
  @override
  final int typeId = 6;

  @override
  HabitLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitLogModel(
      id: fields[0] as String,
      habitId: fields[1] as String,
      userId: fields[2] as String,
      dateKey: fields[3] as String,
      isCompleted: fields[4] as bool,
      loggedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, HabitLogModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.habitId)
      ..writeByte(2)
      ..write(obj.userId)
      ..writeByte(3)
      ..write(obj.dateKey)
      ..writeByte(4)
      ..write(obj.isCompleted)
      ..writeByte(5)
      ..write(obj.loggedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
