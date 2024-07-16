import 'package:crypto_app/features/auth/ui/screens/login_screen.dart';
import 'package:crypto_app/features/auth/ui/screens/register_screen.dart';
import 'package:go_router/go_router.dart';

abstract interface class AuthRoutes {
  static const publicRoutes = {LoginScreen.route, RegisterScreen.route};

  static final routes = <RouteBase>[
    GoRoute(
      path: LoginScreen.route,
      name: LoginScreen.route,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: RegisterScreen.route,
      name: RegisterScreen.route,
      builder: (context, state) => const RegisterScreen(),
    ),
  ];
}
