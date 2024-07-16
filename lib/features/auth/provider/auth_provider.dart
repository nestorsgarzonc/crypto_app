import 'package:crypto_app/core/failure/failure.dart';
import 'package:crypto_app/core/logger/custom_logger.dart';
import 'package:crypto_app/features/auth/models/register_model.dart';
import 'package:crypto_app/features/auth/provider/auth_state.dart';
import 'package:crypto_app/features/auth/service/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = StateNotifierProvider<AuthProvider, AuthState>(AuthProvider.fromRef);

class AuthProvider extends StateNotifier<AuthState> {
  AuthProvider({required this.ref, required this.service}) : super(AuthState.initial());

  factory AuthProvider.fromRef(Ref ref) => AuthProvider(
        ref: ref,
        service: ref.read(authService),
      );

  static const logger = Logger(name: 'AuthProvider');

  final Ref ref;
  final AuthService service;

  void login() {
    service.checkAuthStatus();
  }

  Future<void> register(RegisterModel register) async {
    try {
      state = state.copyWith(registerState: const RegisterStateLoading());
      await service.register(register);
      state = state.copyWith(registerState: RegisterStateSuccess());
    } catch (e, s) {
      logger.error('Error registering user', e, s);
      state = state.copyWith(registerState: RegisterStateFailure(Failure(e.toString())));
    }
  }

  void listenAuth() {
    service.authStateChanges().listen((user) => state = state.copyWith(user: AsyncData(user)));
  }

  Future<void> checkAuth() async {
    try {
      final user = await service.checkAuthStatus();
      state = state.copyWith(user: AsyncData(user));
    } catch (e, s) {
      state = state.copyWith(user: AsyncError(e, s));
    }
  }
}
