import 'package:crypto_app/core/failure/failure.dart';
import 'package:crypto_app/core/logger/custom_logger.dart';
import 'package:crypto_app/core/sealed/state_async.dart';
import 'package:crypto_app/features/auth/models/register_model.dart';
import 'package:crypto_app/features/auth/provider/auth_state.dart';
import 'package:crypto_app/features/auth/service/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.fromRef);

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({required this.ref, required this.service}) : super(AuthState.initial());

  factory AuthNotifier.fromRef(Ref ref) => AuthNotifier(
        ref: ref,
        service: ref.read(authService),
      );

  static const logger = Logger(name: 'AuthProvider');

  final Ref ref;
  final AuthService service;

  void login() {
    service.getAuth();
  }

  Future<void> register(RegisterModel register) async {
    try {
      state = state.copyWith(registerState: const StateAsync.initial());
      await service.register(register);
      state = state.copyWith(registerState: const StateAsync.data(null));
    } catch (e, s) {
      logger.error('Error registering user', e, s);
      state = state.copyWith(registerState: StateAsync.failure(Failure(e.toString())));
    }
  }

  void listenAuth() {
    service
        .authStateChanges()
        .listen((user) => state = state.copyWith(userAuth: StateAsync.data(user)));
  }

  Future<void> checkAuth() async {
    try {
      final user = await service.getAuth();
      state = state.copyWith(userAuth: StateAsync.data(user));
    } catch (e) {
      state = state.copyWith(userAuth: StateAsync.failure(Failure(e.toString())));
    }
  }

  Future<void> getUser() async {
    try {
      final user = await service.getUser();
      state = state.copyWith(userModel: StateAsync.data(user));
    } catch (e) {
      state = state.copyWith(userModel: StateAsync.failure(Failure(e.toString())));
    }
  }

  Future<void> updateUser(UpdateUser user) async {
    try {
      state = state.copyWith(updateUser: const StateAsync.loading());
      await service.updateUser(user);
      await getUser();
      state = state.copyWith(updateUser: const StateAsync.data(null));
    } catch (e) {
      state = state.copyWith(updateUser: StateAsync.failure(Failure(e.toString())));
    }
  }
}
