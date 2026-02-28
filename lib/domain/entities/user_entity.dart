import 'package:equatable/equatable.dart';

/// User domain entity
class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final int? age;
  final String? gender; // 'male', 'female', 'other'
  final double? heightCm;
  final double? weightKg;
  final int waterGoalMl;
  final int stepsGoal;
  final int caloriesGoal;
  final double sleepGoalHours;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.age,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.waterGoalMl = 2000,
    this.stepsGoal = 10000,
    this.caloriesGoal = 2000,
    this.sleepGoalHours = 8.0,
  });

  UserEntity copyWith({
    String? name,
    String? photoUrl,
    int? age,
    String? gender,
    double? heightCm,
    double? weightKg,
    int? waterGoalMl,
    int? stepsGoal,
    int? caloriesGoal,
    double? sleepGoalHours,
  }) {
    return UserEntity(
      id: id,
      email: email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      waterGoalMl: waterGoalMl ?? this.waterGoalMl,
      stepsGoal: stepsGoal ?? this.stepsGoal,
      caloriesGoal: caloriesGoal ?? this.caloriesGoal,
      sleepGoalHours: sleepGoalHours ?? this.sleepGoalHours,
    );
  }

  /// BMI calculation helper
  double? get bmi {
    if (heightCm == null || weightKg == null) return null;
    final hm = heightCm! / 100;
    return weightKg! / (hm * hm);
  }

  String? get bmiCategory {
    final b = bmi;
    if (b == null) return null;
    if (b < 18.5) return 'Underweight';
    if (b < 25.0) return 'Normal';
    if (b < 30.0) return 'Overweight';
    return 'Obese';
  }

  @override
  List<Object?> get props => [id, name, email, photoUrl, age, gender, heightCm, weightKg];
}
