import 'package:crypto_app/app.dart';
import 'package:crypto_app/core/failure/failure.dart';
import 'package:crypto_app/features/auth/service/auth_service.dart';
import 'package:crypto_app/features/auth/service/auth_service_mock.dart';
import 'package:crypto_app/features/dashboard/service/dashboard_service.dart';
import 'package:crypto_app/features/dashboard/service/dashboard_service_mock.dart';
import 'package:crypto_app/features/dashboard/ui/widgets/crypto_favorite_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements User {}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Dashboard integration test', () {
    final authMock = AuthServiceMock(getAuthFn: () => MockUser());
    final dashboardMock = DashboardServiceMock();
    testWidgets('Should show the coins successfully', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authService.overrideWithValue(authMock),
            dashboardService.overrideWithValue(dashboardMock),
          ],
          child: const CryptoApp(),
        ),
      );
      // Splash screen
      expect(find.text('Loading...'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Welcome to Crypto App!'), findsOneWidget);
      expect(find.byType(CryptoItemCard), findsNWidgets(2));
    });

    testWidgets('Should show the coins unsuccessfully', (tester) async {
      const failure = Failure('Failed to get coins');
      final dashboardMock = DashboardServiceMock(
        getCoinsFn: (order, page, query) => throw failure,
      );
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authService.overrideWithValue(authMock),
            dashboardService.overrideWithValue(dashboardMock),
          ],
          child: const CryptoApp(),
        ),
      );
      // Splash screen
      expect(find.text('Loading...'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text(failure.message), findsOneWidget);
    });

    testWidgets('Should go to favorites and show them successfully', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authService.overrideWithValue(authMock),
            dashboardService.overrideWithValue(dashboardMock),
          ],
          child: const CryptoApp(),
        ),
      );
      // Splash screen
      expect(find.text('Loading...'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.text('Welcome to Crypto App!'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.favorite));
      await tester.pumpAndSettle();
      expect(find.text('Your favorites cryptos!'), findsOneWidget);
      await tester.pumpAndSettle();
      expect(find.byType(CryptoItemCard), findsNWidgets(1));
    });
  });
}
