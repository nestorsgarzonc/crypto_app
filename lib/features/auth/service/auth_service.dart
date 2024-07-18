import 'package:crypto_app/features/auth/models/register_model.dart';
import 'package:crypto_app/features/auth/service/auth_service_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the [AuthService] implementation.
final authService = Provider<AuthService>(AuthServiceImpl.fromRef);

/// Abstract class defining the contract for an authentication service.
abstract class AuthService {
  /// Retrieves the currently authenticated user.
  Future<User?> getAuth();

  /// Stream of authentication state changes.
  Stream<User?> authStateChanges();

  /// Registers a new user.
  Future<void> register(RegisterModel model);

  /// Updates the user's information.
  Future<void> updateUser(UpdateUser user);

  /// Signs out the current user.
  Future<void> signOut();

  /// Logs in a user with the provided email and password.
  Future<void> login(String email, String password);

  /// Retrieves the user's information.
  Future<UserModel> getUser();
}
