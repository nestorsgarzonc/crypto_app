import 'package:crypto_app/core/failure/failure.dart';
import 'package:crypto_app/core/sealed/state_async.dart';
import 'package:crypto_app/features/auth/models/register_model.dart';
import 'package:crypto_app/features/auth/provider/auth_provider.dart';
import 'package:crypto_app/features/auth/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}

class MockUser extends Mock implements User {}

class MockRef extends Mock implements Ref {}

void main() {
  group('AuthNotifier', () {
    late AuthNotifier authNotifier;
    late MockRef mockRef;
    late MockAuthService mockAuthService;

    setUp(() {
      mockRef = MockRef();
      mockAuthService = MockAuthService();
      authNotifier = AuthNotifier(ref: mockRef, service: mockAuthService);
    });

    test('login - should update state with successful login', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password';
      when(() => mockAuthService.login(email, password)).thenAnswer((_) async {});
      // Act
      await authNotifier.login(email, password);
      // Assert
      expect(authNotifier.state.registerState, const StateAsync<void>.data(null));
    });

    test('login - should update state with failure on login error', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password';
      const error = Failure('Login failed');
      when(() => mockAuthService.login(email, password)).thenThrow(error);
      // Act
      await authNotifier.login(email, password);
      // Assert
      expect(authNotifier.state.registerState, StateAsync<void>.failure(Failure(error.toString())));
    });

    test('register - should update state with successful registration', () async {
      // Arrange
      final registerModel = RegisterModel(
        email: 'test@example.com',
        password: 'password',
        name: 'John Doe',
        confirmPassword: 'password',
        birthday: DateTime(1990, 1, 1),
        id: 1,
      );
      when(() => mockAuthService.register(registerModel)).thenAnswer((_) async {});
      // Act
      await authNotifier.register(registerModel);

      // Assert
      expect(authNotifier.state.registerState, const StateAsync<void>.data(null));
    });

    test('register - should update state with failure on registration error', () async {
      // Arrange
      final registerModel = RegisterModel(
        email: 'test@example.com',
        password: 'password',
        name: 'John Doe',
        confirmPassword: 'password',
        birthday: DateTime(1990, 1, 1),
        id: 1,
      );
      final error = Exception('Registration failed');
      when(() => mockAuthService.register(registerModel)).thenThrow(error);
      // Act
      await authNotifier.register(registerModel);
      // Assert
      expect(authNotifier.state.registerState, StateAsync.failure(Failure(error.toString())));
    });

    test('checkAuth - should update state with successful authentication', () async {
      // Arrange
      final user = MockUser(/* user data */);
      when(() => mockAuthService.getAuth()).thenAnswer((_) async => user);
      when(() => mockAuthService.authStateChanges())
          .thenAnswer((_) => Stream<User?>.fromIterable([]));
      // Act
      await authNotifier.checkAuth();

      // Assert
      expect(authNotifier.state.userAuth.value, user);
    });

    test('checkAuth - should update state with failure on authentication error', () async {
      // Arrange
      const error = Failure('Authentication failed');
      when(() => mockAuthService.getAuth()).thenThrow(error);

      // Act
      await authNotifier.checkAuth();

      // Assert
      expect(authNotifier.state.userAuth, StateAsync.failure(Failure(error.toString())));
    });

    test('getUser - should update state with successful user retrieval', () async {
      // Arrange
      final user = UserModel(
        id: 1,
        email: 'some@email.com',
        name: 'John Doe',
        birthday: DateTime(1990, 1, 1),
      );
      when(() => mockAuthService.getUser()).thenAnswer((_) async => user);

      // Act
      await authNotifier.getUser();

      // Assert
      expect(authNotifier.state.userModel, StateAsync.data(user));
    });

    test('getUser - should update state with failure on user retrieval error', () async {
      // Arrange
      const error = Failure('User retrieval failed');
      when(() => mockAuthService.getUser()).thenThrow(error);

      // Act
      await authNotifier.getUser();

      // Assert
      expect(authNotifier.state.userModel, StateAsync.failure(Failure(error.toString())));
    });

    test('updateUser - should update state with successful user update', () async {
      // Arrange
      final updateUser = UpdateUser(
        id: 1,
        email: 'some@email.com',
        name: 'John Doe',
        birthday: DateTime(1990, 1, 1),
        password: 'password',
      );
      when(() => mockAuthService.updateUser(updateUser)).thenAnswer((_) async {});
      when(() => mockAuthService.getUser()).thenAnswer((_) async => updateUser);
      // Act
      await authNotifier.updateUser(updateUser);

      // Assert
      expect(authNotifier.state.updateUser, const StateAsync<void>.data(null));
    });

    test('updateUser - should update state with failure on user update error', () async {
      // Arrange
      final updateUser = UpdateUser(
        id: 1,
        email: 'email@email.com',
        name: 'John Doe',
        birthday: DateTime(1990, 1, 1),
        password: 'password',
      );
      final error = Exception('User update failed');
      when(() => mockAuthService.updateUser(updateUser)).thenThrow(error);

      // Act
      await authNotifier.updateUser(updateUser);

      // Assert
      expect(authNotifier.state.updateUser, StateAsync.failure(Failure(error.toString())));
    });

    test('signOut - should call AuthService signOut method', () {
      // Act
      authNotifier.signOut();

      // Assert
      verify(() => mockAuthService.signOut()).called(1);
    });
  });
}
