import 'package:crypto_app/features/splash/ui/screens/splash_screen.dart';
import 'package:go_router/go_router.dart';

abstract interface class SplashRoutes {
  static const publicRoutes = {SplashScreen.route};

  static final routes = <RouteBase>[
    GoRoute(
      path: SplashScreen.route,
      name: SplashScreen.route,
      builder: (context, state) => const SplashScreen(),
    ),
  ];
}
