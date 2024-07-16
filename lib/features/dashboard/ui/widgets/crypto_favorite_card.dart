import 'package:crypto_app/features/dashboard/models/coins_model.dart';
import 'package:crypto_app/features/dashboard/provider/dashboard_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CryptoItemCard extends ConsumerWidget {
  const CryptoItemCard({
    super.key,
    required this.coin,
    required this.isFavorite,
  });

  final CoinsModel coin;
  final bool isFavorite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        title: Text(coin.name),
        subtitle: Text('${coin.symbol} - ${coin.id}'),
        trailing: Text(
          '\$${coin.currentPrice.toStringAsFixed(1)}',
          style: theme.textTheme.labelLarge,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.star,
            color: isFavorite ? Colors.orangeAccent : null,
          ),
          onPressed: () => isFavorite
              ? ref.read(dashboardProvider.notifier).deleteFavoriteCoin(coin.id)
              : ref.read(dashboardProvider.notifier).addFavoriteCoin(coin.id),
        ),
      ),
    );
  }
}
