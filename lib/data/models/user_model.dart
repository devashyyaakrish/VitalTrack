import 'package:hive/hive.dart';
import '../../domain/entities/user_entity.dart';
import '../../core/constants/app_constants.dart';

part 'user_model.g.dart';

@HiveType(typeId: AppConstants.userModelTypeId)
class UserModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? photoUrl;

  @HiveField(4)
  final int? age;

  @HiveField(5)
  final String? gender;

  @HiveField(6)
  final double? heightCm;

  @HiveField(7)
  final double? weightKg;

  @HiveField(8)
  final int waterGoalMl;

  @HiveField(9)
  final int stepsGoal;

  @HiveField(10)
  final int caloriesGoal;

  @HiveField(11)
  final double sleepGoalHours;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.age,
    this.gender,
    this.heightCm,
    this.weightKg,
    this.waterGoalMl = AppConstants.defaultWaterGoalMl,
    this.stepsGoal = AppConstants.defaultStepsGoal,
    this.caloriesGoal = AppConstants.defaultCaloriesGoal,
    this.sleepGoalHours = AppConstants.defaultSleepGoalHours,
  });

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        id: entity.id,
        name: entity.name,
        email: entity.email,
        photoUrl: entity.photoUrl,
        age: entity.age,
        gender: entity.gender,
        heightCm: entity.heightCm,
        weightKg: entity.weightKg,
        waterGoalMl: entity.waterGoalMl,
        stepsGoal: entity.stepsGoal,
        caloriesGoal: entity.caloriesGoal,
        sleepGoalHours: entity.sleepGoalHours,
      );

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id'] as String,
        name: map['name'] as String,
        email: map['email'] as String,
        photoUrl: map['photoUrl'] as String?,
        age: map['age'] as int?,
        gender: map['gender'] as String?,
        heightCm: (map['heightCm'] as num?)?.toDouble(),
        weightKg: (map['weightKg'] as num?)?.toDouble(),
        waterGoalMl: (map['waterGoalMl'] as int?) ?? AppConstants.defaultWaterGoalMl,
        stepsGoal: (map['stepsGoal'] as int?) ?? AppConstants.defaultStepsGoal,
        caloriesGoal: (map['caloriesGoal'] as int?) ?? AppConstants.defaultCaloriesGoal,
        sleepGoalHours:
            (map['sleepGoalHours'] as num?)?.toDouble() ?? AppConstants.defaultSleepGoalHours,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        if (photoUrl != null) 'photoUrl': photoUrl,
        if (age != null) 'age': age,
        if (gender != null) 'gender': gender,
        if (heightCm != null) 'heightCm': heightCm,
        if (weightKg != null) 'weightKg': weightKg,
        'waterGoalMl': waterGoalMl,
        'stepsGoal': stepsGoal,
        'caloriesGoal': caloriesGoal,
        'sleepGoalHours': sleepGoalHours,
      };

  UserEntity toEntity() => UserEntity(
        id: id,
        name: name,
        email: email,
        photoUrl: photoUrl,
        age: age,
        gender: gender,
        heightCm: heightCm,
        weightKg: weightKg,
        waterGoalMl: waterGoalMl,
        stepsGoal: stepsGoal,
        caloriesGoal: caloriesGoal,
        sleepGoalHours: sleepGoalHours,
      );
}
