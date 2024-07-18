import 'package:crypto_app/core/failure/failure.dart';
import 'package:crypto_app/features/auth/models/register_model.dart';
import 'package:crypto_app/features/auth/service/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockRef extends Mock implements Ref {}

class MockUser extends Mock implements User {}

void main() {
  group('Auth service testing - getAuth', () {
    test('Should get successfully the User', () async {
      final user = MockUser();
      final auth = MockFirebaseAuth();
      when(() => auth.currentUser).thenReturn(user);
      final authServiceImpl = AuthServiceImpl(MockRef(), auth: auth);
      final res = await authServiceImpl.getAuth();
      expect(res, user);
    });

    test('Should not get successfully the User', () async {
      const user = null;
      final auth = MockFirebaseAuth();
      when(() => auth.currentUser).thenReturn(user);
      final authServiceImpl = AuthServiceImpl(MockRef(), auth: auth);
      final res = await authServiceImpl.getAuth();
      expect(res, user);
      expect(res, isNull);
    });
  });

  group('Auth service testing - authStateChanges', () {
    test('Should listen the changes of the stream', () async {
      final user = MockUser();
      final auth = MockFirebaseAuth();
      final events = [user, null, user, user];
      final stream = Stream<User?>.fromIterable(events);
      when(() => auth.authStateChanges()).thenAnswer((_) => stream);
      final authServiceImpl = AuthServiceImpl(MockRef(), auth: auth);
      final res = authServiceImpl.authStateChanges();
      await expectLater(res, emitsInOrder(events));
    });
  });

  group('Auth service testing - register', () {
    final model = RegisterModel(
      email: 'someemail@gmail.com',
      password: 'password',
      name: 'some name',
      confirmPassword: 'password',
      birthday: DateTime.now(),
      id: 1,
    );
    test('Should raise a FirebaseAuthException when is trying to register', () async {
      final auth = MockFirebaseAuth();
      final ref = MockRef();
      final authServiceImpl = AuthServiceImpl(ref, auth: auth);
      when(() => auth.createUserWithEmailAndPassword(email: model.email, password: model.password))
          .thenThrow(FirebaseAuthException(code: 'email-already-in-use', message: 'error'));
      expect(() => authServiceImpl.register(model), throwsA(isA<Failure>()));
    });
  });
}
