import 'package:crypto_app/features/auth/ui/routes.dart';
import 'package:crypto_app/features/dashboard/ui/routes.dart';
import 'package:crypto_app/features/splash/ui/routes.dart';
import 'package:crypto_app/features/splash/ui/screens/splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider(
  (ref) => GoRouter(
    initialLocation: _AppRouter.initial,
    routes: _AppRouter.routes,
  ),
);

abstract interface class _AppRouter {
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

  static isPublicRoute(String route) => publicRoutes.contains(route);
  static isPrivateRoute(String route) => !isPublicRoute(route);
}
