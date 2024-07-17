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

final _routerNotifier = NotifierProvider(_AppRouter.new);
final routerProvider = Provider(
  (ref) => GoRouter(
    initialLocation: _AppRouter.initial,
    routes: _AppRouter.routes,
    refreshListenable: ref.watch(_routerNotifier.notifier),
    redirect: ref.read(_routerNotifier.notifier).redirect,
  ),
);

class _AppRouter extends Notifier implements Listenable {
  static const initial = SplashScreen.route;
  static const publicRoutes = {
    ...SplashRoutes.publicRoutes,
    ...AuthRoutes.publicRoutes,
  };
  static final routes = <RouteBase>[
    ...SplashRoutes.routes,
    ...AuthRoutes.routes,
    ...DashboardRoutes.routes,
  ];

  static isPublicRoute(String? route) => publicRoutes.contains(route);
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

  String? redirect(BuildContext context, GoRouterState state) {
    final isAuthRoute = isPrivateRoute(state.fullPath);
    if (isAuthRoute && !isAuthenticated) {
      return LoginScreen.route;
    }
    return null;
  }
}
