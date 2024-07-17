import 'package:crypto_app/features/dashboard/models/coins_model.dart';
import 'package:crypto_app/ui/spacings.dart';
import 'package:flutter/material.dart';

class SideCryptoDetail extends StatelessWidget {
  const SideCryptoDetail({super.key, required this.coin});

  final CoinsModel coin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(4),
      constraints: const BoxConstraints(maxHeight: 350, minHeight: 250),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            coin.name,
            style: theme.textTheme.titleLarge?.copyWith(color: Colors.blue[800]),
            textAlign: TextAlign.center,
          ),
          Spacings.v16,
          Image.network(coin.image, width: 80, height: 80, alignment: Alignment.center),
          Spacings.v16,
          TweenAnimationBuilder(
            tween: Tween(begin: 0, end: coin.currentPrice),
            duration: const Duration(milliseconds: 250),
            builder: (_, value, child) =>
                Text('\$${value.toStringAsFixed(2)}', style: theme.textTheme.titleMedium),
          ),
          Spacings.v8,
          Text('Symbol: ${coin.symbol}', style: theme.textTheme.titleMedium),
        ],
      ),
    );
  }
}
