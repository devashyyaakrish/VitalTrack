import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/constants/app_constants.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;
  final Box<UserModel> _userBox;

  AuthRepositoryImpl({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
    required FirebaseFirestore firestore,
    required Box<UserModel> userBox,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn,
        _firestore = firestore,
        _userBox = userBox;

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user!;
      final userModel = await _fetchOrCreateUser(user.uid, user.displayName ?? '', email);
      return Either.right(userModel.toEntity());
    } on FirebaseAuthException catch (e) {
      return Either.left(AuthFailure(message: _mapAuthError(e.code), code: e.code));
    } catch (e) {
      return Either.left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> registerWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.updateDisplayName(name);
      final userModel = UserModel(
        id: credential.user!.uid,
        name: name,
        email: email,
      );
      await _saveUserToFirestoreAndCache(userModel);
      return Either.right(userModel.toEntity());
    } on FirebaseAuthException catch (e) {
      return Either.left(AuthFailure(message: _mapAuthError(e.code), code: e.code));
    } catch (e) {
      return Either.left(UnexpectedFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return const Either.left(AuthFailure(message: 'Google sign-in was cancelled.'));
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user!;
      final userModel = await _fetchOrCreateUser(
        user.uid,
        user.displayName ?? '',
        user.email ?? '',
        photoUrl: user.photoURL,
      );
      return Either.right(userModel.toEntity());
    } catch (e) {
      return Either.left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await Future.wait([_firebaseAuth.signOut(), _googleSignIn.signOut()]);
      await _userBox.clear();
      return const Either.right(null);
    } catch (e) {
      return Either.left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null) return const Either.right(null);

      // Try cache first
      if (_userBox.isNotEmpty) {
        final cached = _userBox.get(firebaseUser.uid);
        if (cached != null) return Either.right(cached.toEntity());
      }

      // Fetch from Firestore
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(firebaseUser.uid)
          .get();

      if (!doc.exists) return const Either.right(null);

      final userModel = UserModel.fromMap(doc.data()!);
      await _userBox.put(userModel.id, userModel);
      return Either.right(userModel.toEntity());
    } catch (e) {
      return Either.left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile(UserEntity user) async {
    try {
      final model = UserModel.fromEntity(user);
      await _saveUserToFirestoreAndCache(model);
      return Either.right(user);
    } catch (e) {
      return Either.left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return const Either.right(null);
      // Delete Firestore data
      await _firestore.collection(AppConstants.usersCollection).doc(user.uid).delete();
      await user.delete();
      await _userBox.clear();
      return const Either.right(null);
    } on FirebaseAuthException catch (e) {
      return Either.left(AuthFailure(message: e.message ?? 'Delete account failed.'));
    }
  }

  // ── Private helpers ──────────────────────────────────────────────────────

  Future<UserModel> _fetchOrCreateUser(
    String uid,
    String name,
    String email, {
    String? photoUrl,
  }) async {
    final doc = await _firestore.collection(AppConstants.usersCollection).doc(uid).get();
    if (doc.exists) {
      final model = UserModel.fromMap(doc.data()!);
      await _userBox.put(model.id, model);
      return model;
    } else {
      final model = UserModel(id: uid, name: name, email: email, photoUrl: photoUrl);
      await _saveUserToFirestoreAndCache(model);
      return model;
    }
  }

  Future<void> _saveUserToFirestoreAndCache(UserModel model) async {
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(model.id)
        .set(model.toMap(), SetOptions(merge: true));
    await _userBox.put(model.id, model);
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with that email.';
      case 'wrong-password':
        return 'Wrong password. Please try again.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return 'Authentication error: $code';
    }
  }
}
