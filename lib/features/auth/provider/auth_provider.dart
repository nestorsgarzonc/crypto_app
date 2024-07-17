import 'package:crypto_app/core/failure/failure.dart';
import 'package:crypto_app/core/logger/custom_logger.dart';
import 'package:crypto_app/core/sealed/state_async.dart';
import 'package:crypto_app/features/auth/models/register_model.dart';
import 'package:crypto_app/features/auth/provider/auth_state.dart';
import 'package:crypto_app/features/auth/service/auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
/// Provider for managing authentication state and actions.
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.fromRef);

/// Notifier class for managing authentication state and actions.
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({required this.ref, required this.service}) : super(AuthState.initial());

  /// Factory constructor for creating an [AuthNotifier] instance from a [Ref].
  factory AuthNotifier.fromRef(Ref ref) => AuthNotifier(
        ref: ref,
        service: ref.read(authService),
      );

  static const logger = Logger(name: 'AuthProvider');

  final Ref ref;
  final AuthService service;

  /// Logs in a user with the provided email and password.
  Future<void> login(String email, String password) async {
    try {
      state = state.copyWith(registerState: const StateAsync.loading());
      await service.login(email, password);
      state = state.copyWith(registerState: const StateAsync.data(null));
    } catch (e, s) {
      logger.error('Error registering user', e, s);
      state = state.copyWith(registerState: StateAsync.failure(Failure(e.toString())));
    }
  }

  /// Registers a new user with the provided registration data.
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

  /// Listens for changes in the authentication state.
  void listenAuth() {
    service.authStateChanges().listen((user) {
      state = state.copyWith(userAuth: StateAsync.data(user));
    });
  }

  /// Checks the current authentication state and updates the state accordingly.
  Future<void> checkAuth() async {
    try {
      final user = await service.getAuth();
      listenAuth();
      state = state.copyWith(userAuth: StateAsync.data(user));
    } catch (e) {
      state = state.copyWith(userAuth: StateAsync.failure(Failure(e.toString())));
    }
  }

  /// Retrieves the user data.
  Future<void> getUser() async {
    try {
      final user = await service.getUser();
      state = state.copyWith(userModel: StateAsync.data(user));
    } catch (e) {
      state = state.copyWith(userModel: StateAsync.failure(Failure(e.toString())));
    }
  }

  /// Updates the user data with the provided data.
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

  /// Signs out the current user.
  void signOut() => service.signOut();
}
