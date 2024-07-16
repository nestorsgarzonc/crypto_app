import 'package:crypto_app/features/dashboard/ui/screens/dashboard_screen.dart';
import 'package:go_router/go_router.dart';

abstract interface class DashboardRoutes {
  static final routes = <RouteBase>[
    GoRoute(
      path: DashboardScreen.route,
      name: DashboardScreen.route,
      builder: (context, state) => const DashboardScreen(),
    ),
  ];
}
