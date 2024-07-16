import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_app/core/failure/failure.dart';

class AuthState {
  const AuthState({
    required this.user,
    required this.registerState,
  });

  final AsyncValue<User?> user;
  final RegisterState registerState;

  factory AuthState.initial() {
    return const AuthState(
      user: AsyncValue.loading(),
      registerState: RegisterStateInitial(),
    );
  }

  AuthState copyWith({
    AsyncValue<User?>? user,
    RegisterState? registerState,
  }) {
    return AuthState(
      user: user ?? this.user,
      registerState: registerState ?? this.registerState,
    );
  }

  @override
  bool operator ==(covariant AuthState other) {
    if (identical(this, other)) return true;

    return other.user == user && other.registerState == registerState;
  }

  @override
  int get hashCode => user.hashCode ^ registerState.hashCode;
}

sealed class RegisterState {
  const RegisterState();
}

class RegisterStateInitial extends RegisterState {
  const RegisterStateInitial();
}

class RegisterStateLoading extends RegisterState {
  const RegisterStateLoading();
}

class RegisterStateFailure extends RegisterState {
  const RegisterStateFailure(this.failure);

  final Failure failure;

  @override
  bool operator ==(covariant RegisterStateFailure other) {
    if (identical(this, other)) return true;
    return other.failure == failure;
  }

  @override
  int get hashCode => failure.hashCode;
}

class RegisterStateSuccess extends RegisterState {}
