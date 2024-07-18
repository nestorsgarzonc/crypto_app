import 'package:crypto_app/app.dart';
import 'package:crypto_app/core/failure/failure.dart';
import 'package:crypto_app/features/auth/service/auth_service.dart';
import 'package:crypto_app/features/auth/service/auth_service_mock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Auth integration test', () {
    testWidgets('Should go to login screen', (tester) async {
      const authMock = AuthServiceMock();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [authService.overrideWithValue(authMock)],
          child: const CryptoApp(),
        ),
      );
      // Splash screen
      expect(find.text('Loading...'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Welcome to Crypto App'), findsOneWidget);
    });

    testWidgets('Should go to register screen', (tester) async {
      const authMock = AuthServiceMock();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [authService.overrideWithValue(authMock)],
          child: const CryptoApp(),
        ),
      );
      // Splash screen
      expect(find.text('Loading...'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Welcome to Crypto App'), findsOneWidget);
      await tester.tap(find.text('Register'));
      await tester.pumpAndSettle();
      expect(find.text('Complete the form below to register'), findsOneWidget);
    });

    testWidgets('Should login successfully', (tester) async {
      const authMock = AuthServiceMock();
      const email = 'some@email.com';
      const password = '11111111';
      await tester.pumpWidget(
        ProviderScope(
          overrides: [authService.overrideWithValue(authMock)],
          child: const CryptoApp(),
        ),
      );
      // Splash screen
      expect(find.text('Loading...'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Welcome to Crypto App'), findsOneWidget);
      await tester.enterText(find.byKey(const Key('emailField')), email);
      await tester.enterText(find.byKey(const Key('passwordField')), password);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();
      expect(find.text('Login successful'), findsOneWidget);
    });

    testWidgets('Should login unsuccessfully', (tester) async {
      const loginFailed = Failure('Login failed');
      final authMock = AuthServiceMock(loginFn: () => throw loginFailed);
      const email = 'some@email.com';
      const password = '11111111';
      await tester.pumpWidget(
        ProviderScope(
          overrides: [authService.overrideWithValue(authMock)],
          child: const CryptoApp(),
        ),
      );
      // Splash screen
      expect(find.text('Loading...'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Welcome to Crypto App'), findsOneWidget);
      await tester.enterText(find.byKey(const Key('emailField')), email);
      await tester.enterText(find.byKey(const Key('passwordField')), password);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();
      expect(find.text(loginFailed.message), findsOneWidget);
    });
  });
}
