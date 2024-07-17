import 'package:crypto_app/features/dashboard/models/coins_model.dart';
import 'package:crypto_app/features/dashboard/provider/dashboard_provider.dart';
import 'package:crypto_app/ui/spacings.dart';
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
        trailing: IconButton(
          icon: Icon(
            Icons.star,
            color: isFavorite ? Colors.orangeAccent : null,
          ),
          onPressed: () => isFavorite
              ? ref.read(dashboardProvider.notifier).deleteFavoriteCoin(coin.id)
              : ref.read(dashboardProvider.notifier).addFavoriteCoin(coin.id),
        ),
        subtitle: Row(
          children: [
            Text(
              '\$${coin.currentPrice.toStringAsFixed(1)}',
              style: theme.textTheme.labelLarge,
            ),
            if (coin.variation != null) ...[
              Spacings.w8,
              Icon(
                coin.isPositiveVar ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                color: coin.isPositiveVar ? Colors.green : Colors.red,
              ),
              Text(
                '${coin.variation ?? 0.toStringAsFixed(2)}%',
                style: theme.textTheme.labelLarge!.copyWith(
                  color: coin.isPositiveVar ? Colors.green : Colors.red,
                ),
              ),
            ],
          ],
        ),
        leading: Image.network(coin.image, height: 36),
      ),
    );
  }
}
