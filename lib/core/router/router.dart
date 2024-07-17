import 'package:crypto_app/core/sealed/state_async.dart';
import 'package:crypto_app/features/auth/provider/auth_provider.dart';
import 'package:crypto_app/features/auth/ui/routes.dart';
import 'package:crypto_app/features/auth/ui/screens/login_screen.dart';
import 'package:crypto_app/features/dashboard/ui/routes.dart';
import 'package:crypto_app/features/splash/ui/routes.dart';
import 'package:crypto_app/features/splash/ui/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Provider for the app router.
final _routerNotifier = NotifierProvider(_AppRouter.new);

/// Provider for the app router instance.
final routerProvider = Provider(
  (ref) => GoRouter(
    initialLocation: _AppRouter.initial,
    routes: _AppRouter.routes,
    refreshListenable: ref.watch(_routerNotifier.notifier),
    redirect: ref.read(_routerNotifier.notifier).redirect,
  ),
);

/// The main app router class that extends [Notifier] and implements [Listenable].
class _AppRouter extends Notifier implements Listenable {
  static const initial = SplashScreen.route;

  /// Public routes available in the app.
  static const publicRoutes = {
    ...SplashRoutes.publicRoutes,
    ...AuthRoutes.publicRoutes,
  };

  /// All routes available in the app.
  static final routes = <RouteBase>[
    ...SplashRoutes.routes,
    ...AuthRoutes.routes,
    ...DashboardRoutes.routes,
  ];

  /// Checks if a given route is a public route.
  static isPublicRoute(String? route) => publicRoutes.contains(route);

  /// Checks if a given route is a private route.
  static isPrivateRoute(String? route) => !isPublicRoute(route);

  VoidCallback? _listener;
  bool isAuthenticated = false;

  @override
  void addListener(VoidCallback listener) => _listener = listener;

  @override
  build() {
    ref.listen<StateAsync<User?>>(authProvider.select((e) => e.userAuth), (_, next) {
      isAuthenticated = next is AsyncDone<User?> && next.value != null;
      _listener?.call();
    });
  }

  @override
  void removeListener(VoidCallback listener) => _listener = null;

  /// Redirects to a specific route based on the current state of the app.
  ///
  /// If the current route is a private route and the user is not authenticated,
  /// it redirects to the login screen. Otherwise, it returns null.
  String? redirect(BuildContext context, GoRouterState state) {
    final isAuthRoute = isPrivateRoute(state.fullPath);
    if (isAuthRoute && !isAuthenticated) {
      return LoginScreen.route;
    }
    return null;
  }
}
