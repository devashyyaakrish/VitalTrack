import '../entities/user_entity.dart';
import '../../core/errors/failures.dart';

/// Abstract repository for authentication operations
abstract class AuthRepository {
  /// Sign in with email and password
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Register with email and password
  Future<Either<Failure, UserEntity>> registerWithEmail({
    required String email,
    required String password,
    required String name,
  });

  /// Sign in with Google
  Future<Either<Failure, UserEntity>> signInWithGoogle();

  /// Sign out the current user
  Future<Either<Failure, void>> signOut();

  /// Get the currently signed-in user (returns null if not signed in)
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Update user profile data
  Future<Either<Failure, UserEntity>> updateProfile(UserEntity user);

  /// Delete the current account permanently
  Future<Either<Failure, void>> deleteAccount();
}

/// Simple Either type
class Either<L, R> {
  final L? _left;
  final R? _right;
  final bool _isRight;

  const Either.left(L value)
      : _left = value,
        _right = null,
        _isRight = false;

  const Either.right(R value)
      : _left = null,
        _right = value,
        _isRight = true;

  bool get isLeft => !_isRight;
  bool get isRight => _isRight;

  L get left {
    assert(!_isRight, 'Tried to get left value of a Right.');
    return _left as L;
  }

  R get right {
    assert(_isRight, 'Tried to get right value of a Left.');
    return _right as R;
  }

  T fold<T>(T Function(L) onLeft, T Function(R) onRight) {
    if (_isRight) return onRight(_right as R);
    return onLeft(_left as L);
  }
}
