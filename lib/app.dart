import 'package:crypto_app/core/router/router.dart';
import 'package:crypto_app/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CryptoApp extends ConsumerWidget {
  const CryptoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(routerProvider);
    return MaterialApp.router(
      title: 'Crypto App',
      theme: MyTheme.theme,
      routerConfig: router,
    );
  }
}
