import 'package:crypto_app/core/sealed/state_async.dart';
import 'package:crypto_app/features/dashboard/provider/dashboard_provider.dart';
import 'package:crypto_app/features/dashboard/ui/widgets/crypto_compare_widget.dart';
import 'package:crypto_app/features/dashboard/ui/widgets/side_crypto_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompareTab extends ConsumerStatefulWidget {
  const CompareTab({super.key});

  @override
  ConsumerState<CompareTab> createState() => _CompareTabState();
}

class _CompareTabState extends ConsumerState<CompareTab> {
  List<String> _coins = [];

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => ref.read(dashboardProvider.notifier).getListCoins());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (listCoins, coins) = ref.watch(dashboardProvider.select((e) => (e.listCoins, e.coins)));
    return Column(
      children: [
        SafeArea(child: Text('Compare cryptos', style: theme.textTheme.titleLarge)),
        const SizedBox(width: double.infinity, height: 16),
        if (_coins.isEmpty)
          listCoins.when(
            loading: () => const Center(child: CircularProgressIndicator.adaptive()),
            error: (e) => Center(child: Text(e.toString())),
            data: (coins) =>
                Expanded(child: CryptoCompareWidget(onCompare: _onCompare, coins: coins)),
          )
        else
          coins.when(
            loading: () => const Center(child: CircularProgressIndicator.adaptive()),
            error: (e) => Center(child: Text(e.toString())),
            data: (cryptos) => Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children:
                        cryptos.map((e) => Expanded(child: SideCryptoDetail(coin: e))).toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () => setState(() => _coins = []),
                      child: const Text('Change coins'),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _onCompare(List<String> coins) {
    _coins = coins;
    setState(() {});
    ref.read(dashboardProvider.notifier).fetchCryptos(query: coins);
  }
}
