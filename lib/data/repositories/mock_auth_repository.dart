import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../../core/errors/failures.dart';
import '../models/user_model.dart';

class MockAuthRepository implements AuthRepository {
  final Box<UserModel> _userBox;
  final _uuid = const Uuid();

  MockAuthRepository({required Box<UserModel> userBox}) : _userBox = userBox;

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    // Simulating a network delay
    await Future.delayed(const Duration(milliseconds: 800));

    // In mock mode, we just check if a user with this email exists in our local cache or create one
    final existingUser = _userBox.values.firstWhere(
      (u) => u.email == email,
      orElse: () =>
          UserModel(id: _uuid.v4(), name: email.split('@').first, email: email),
    );

    await _userBox.put(existingUser.id, existingUser);
    return Either.right(existingUser.toEntity());
  }

  @override
  Future<Either<Failure, UserEntity>> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final newUser = UserModel(
      id: _uuid.v4(),
      name: name,
      email: email,
    );

    await _userBox.put(newUser.id, newUser);
    return Either.right(newUser.toEntity());
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    await Future.delayed(const Duration(seconds: 1));
    final mockUser = UserModel(
      id: 'google-mock-id',
      name: 'Mock Google User',
      email: 'mock.google@example.com',
    );
    await _userBox.put(mockUser.id, mockUser);
    return Either.right(mockUser.toEntity());
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    // Just clearing the local "session" (which is just the userBox being empty or not checked)
    // Actually, in a real mock we might want to track a 'currentUserId' in Hive but for now
    // we assume the UI handles the state.
    return const Either.right(null);
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    if (_userBox.isEmpty) return const Either.right(null);
    return Either.right(_userBox.values.first.toEntity());
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(UserEntity user) async {
    final model = UserModel.fromEntity(user);
    await _userBox.put(model.id, model);
    return Either.right(user);
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    await _userBox.clear();
    return const Either.right(null);
  }
}
