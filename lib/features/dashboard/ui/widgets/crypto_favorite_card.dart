import 'package:crypto_app/features/dashboard/models/coins_model.dart';
import 'package:crypto_app/features/dashboard/provider/dashboard_provider.dart';
import 'package:crypto_app/ui/spacings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A widget that represents a card displaying information about a cryptocurrency item.
class CryptoItemCard extends ConsumerWidget {
  /// Constructs a [CryptoItemCard].
  ///
  /// The [coin] parameter is required and represents the cryptocurrency item.
  /// The [isFavorite] parameter is required and indicates whether the cryptocurrency item is marked as a favorite.
  const CryptoItemCard({
    super.key,
    required this.coin,
    required this.isFavorite,
  });

  /// The cryptocurrency item.
  final CoinsModel coin;

  /// Indicates whether the cryptocurrency item is marked as a favorite.
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
