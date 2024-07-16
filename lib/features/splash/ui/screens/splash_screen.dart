import 'package:crypto_app/features/auth/provider/auth_provider.dart';
import 'package:crypto_app/features/auth/ui/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  static const route = '/splash';

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => ref.read(authProvider.notifier).checkAuth());
    super.initState();
  }

  void _listener(_, AsyncValue<User?> next) {
    switch (next) {
      case AsyncLoading():
        break;
      case AsyncData<User?>(value: final v):
        if (v != null) {
          GoRouter.of(context).goNamed(LoginScreen.route);
          //TODO: Go to dashboard
          //GoRouter.of(context).goNamed('/dashboard');
        } else {
          GoRouter.of(context).goNamed(LoginScreen.route);
        }
        break;
      case AsyncError _:
        GoRouter.of(context).goNamed(LoginScreen.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<User?>>(authProvider.select((e) => e.user), _listener);
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator.adaptive(),
            SizedBox(height: 20),
            Text('Loading...'),
          ],
        ),
      ),
    );
  }
}
