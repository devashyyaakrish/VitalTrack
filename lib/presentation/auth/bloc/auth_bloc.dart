import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/auth_repository.dart';

// ── Events ──────────────────────────────────────────────────────────────────

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthSignInWithEmailEvent extends AuthEvent {
  final String email;
  final String password;
  const AuthSignInWithEmailEvent({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterWithEmailEvent extends AuthEvent {
  final String email;
  final String password;
  final String name;
  const AuthRegisterWithEmailEvent({
    required this.email,
    required this.password,
    required this.name,
  });
  @override
  List<Object?> get props => [email, password, name];
}

class AuthSignInWithGoogleEvent extends AuthEvent {}

class AuthSignOutEvent extends AuthEvent {}

class AuthCheckStatusEvent extends AuthEvent {}

class AuthUpdateProfileEvent extends AuthEvent {
  final UserEntity user;
  const AuthUpdateProfileEvent({required this.user});
  @override
  List<Object?> get props => [user];
}

class AuthDeleteAccountEvent extends AuthEvent {}

// ── States ──────────────────────────────────────────────────────────────────

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthAuthenticatedState extends AuthState {
  final UserEntity user;
  const AuthAuthenticatedState({required this.user});
  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticatedState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;
  const AuthErrorState({required this.message});
  @override
  List<Object?> get props => [message];
}

class AuthProfileIncompleteState extends AuthState {
  final UserEntity user;
  const AuthProfileIncompleteState({required this.user});
  @override
  List<Object?> get props => [user];
}

// ── Bloc ────────────────────────────────────────────────────────────────────

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthInitialState()) {
    on<AuthCheckStatusEvent>(_onCheckStatus);
    on<AuthSignInWithEmailEvent>(_onSignInWithEmail);
    on<AuthRegisterWithEmailEvent>(_onRegisterWithEmail);
    on<AuthSignInWithGoogleEvent>(_onSignInWithGoogle);
    on<AuthSignOutEvent>(_onSignOut);
    on<AuthUpdateProfileEvent>(_onUpdateProfile);
    on<AuthDeleteAccountEvent>(_onDeleteAccount);
  }

  Future<void> _onCheckStatus(
    AuthCheckStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await _authRepository.getCurrentUser();
    result.fold(
      (failure) => emit(AuthUnauthenticatedState()),
      (user) {
        if (user == null) {
          emit(AuthUnauthenticatedState());
        } else if (user.age == null || user.heightCm == null) {
          emit(AuthProfileIncompleteState(user: user));
        } else {
          emit(AuthAuthenticatedState(user: user));
        }
      },
    );
  }

  Future<void> _onSignInWithEmail(
    AuthSignInWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await _authRepository.signInWithEmail(
      email: event.email,
      password: event.password,
    );
    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) {
        if (user.age == null || user.heightCm == null) {
          emit(AuthProfileIncompleteState(user: user));
        } else {
          emit(AuthAuthenticatedState(user: user));
        }
      },
    );
  }

  Future<void> _onRegisterWithEmail(
    AuthRegisterWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await _authRepository.registerWithEmail(
      email: event.email,
      password: event.password,
      name: event.name,
    );
    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) => emit(AuthProfileIncompleteState(user: user)),
    );
  }

  Future<void> _onSignInWithGoogle(
    AuthSignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await _authRepository.signInWithGoogle();
    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) {
        if (user.age == null || user.heightCm == null) {
          emit(AuthProfileIncompleteState(user: user));
        } else {
          emit(AuthAuthenticatedState(user: user));
        }
      },
    );
  }

  Future<void> _onSignOut(
    AuthSignOutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    await _authRepository.signOut();
    emit(AuthUnauthenticatedState());
  }

  Future<void> _onUpdateProfile(
    AuthUpdateProfileEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await _authRepository.updateProfile(event.user);
    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) => emit(AuthAuthenticatedState(user: user)),
    );
  }

  Future<void> _onDeleteAccount(
    AuthDeleteAccountEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    await _authRepository.deleteAccount();
    emit(AuthUnauthenticatedState());
  }
}
