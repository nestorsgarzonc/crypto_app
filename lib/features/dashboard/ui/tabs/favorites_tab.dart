import 'package:crypto_app/core/sealed/state_async.dart';
import 'package:crypto_app/features/dashboard/provider/dashboard_provider.dart';
import 'package:crypto_app/features/dashboard/ui/widgets/crypto_favorite_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavoritesTab extends ConsumerWidget {
  const FavoritesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final (coins, fav) = ref.watch(dashboardProvider.select((e) => (e.coins, e.favoriteCoinsList)));
    return Column(
      children: [
        SafeArea(
          bottom: false,
          child: Text('Your favorites cryptos!', style: theme.textTheme.titleLarge),
        ),
        const SizedBox(width: double.infinity, height: 16),
        Expanded(
          child: coins.when(
            error: (e) => Text(e.toString()),
            loading: () => const CircularProgressIndicator.adaptive(),
            data: (_) => ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: fav.length,
              itemBuilder: (context, index) => CryptoItemCard(
                coin: fav[index],
                isFavorite: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
