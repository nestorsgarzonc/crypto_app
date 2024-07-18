import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto_app/core/sealed/state_async.dart';
import 'package:crypto_app/features/auth/models/register_model.dart';

class AuthState {
  const AuthState({
    required this.userAuth,
    required this.registerState,
    required this.userModel,
    required this.updateUser,
  });

  final StateAsync<User?> userAuth;
  final StateAsync<UserModel> userModel;
  final StateAsync<void> registerState;
  final StateAsync<void> updateUser;

  factory AuthState.initial() {
    return const AuthState(
      userAuth: StateAsync.initial(),
      userModel: StateAsync.initial(),
      registerState: StateAsync.initial(),
      updateUser: StateAsync.initial(),
    );
  }

  AuthState copyWith({
    StateAsync<User?>? userAuth,
    StateAsync<UserModel>? userModel,
    StateAsync<void>? registerState,
    StateAsync<void>? updateUser,
  }) {
    return AuthState(
      userAuth: userAuth ?? this.userAuth,
      userModel: userModel ?? this.userModel,
      registerState: registerState ?? this.registerState,
      updateUser: updateUser ?? this.updateUser,
    );
  }

  @override
  bool operator ==(covariant AuthState other) {
    if (identical(this, other)) return true;
  
    return 
      other.userAuth == userAuth &&
      other.userModel == userModel &&
      other.registerState == registerState &&
      other.updateUser == updateUser;
  }

  @override
  int get hashCode {
    return userAuth.hashCode ^
      userModel.hashCode ^
      registerState.hashCode ^
      updateUser.hashCode;
  }
}
