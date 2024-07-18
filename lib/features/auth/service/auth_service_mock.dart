import 'package:crypto_app/features/auth/models/register_model.dart';
import 'package:crypto_app/features/auth/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServiceMock implements AuthService {
  const AuthServiceMock({
    this.getAuthFn,
    this.getUserFn,
    this.loginFn,
    this.registerFn,
    this.signOutFn,
    this.updateUserFn,
  });

  final User? Function()? getAuthFn;
  final UserModel? Function()? getUserFn;
  final void Function()? loginFn;
  final void Function()? registerFn;
  final void Function()? signOutFn;
  final void Function(UpdateUser user)? updateUserFn;

  @override
  Stream<User?> authStateChanges() => const Stream.empty();

  @override
  Future<User?> getAuth() => Future.value(getAuthFn?.call());

  @override
  Future<UserModel> getUser() async {
    return getUserFn?.call() ??
        UserModel(email: 'test@test.com', name: 'John Doe', id: 1, birthday: DateTime.now());
  }

  @override
  Future<void> login(String email, String password) async => loginFn?.call();

  @override
  Future<void> register(RegisterModel model) async => registerFn?.call();

  @override
  Future<void> signOut() async => signOutFn?.call();

  @override
  Future<void> updateUser(UpdateUser user) async => updateUserFn?.call(user);
}
