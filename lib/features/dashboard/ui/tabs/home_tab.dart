import 'package:crypto_app/core/sealed/state_async.dart';
import 'package:crypto_app/features/dashboard/models/coins_order.dart';
import 'package:crypto_app/features/dashboard/provider/dashboard_provider.dart';
import 'package:crypto_app/features/dashboard/ui/widgets/crypto_favorite_card.dart';
import 'package:crypto_app/ui/spacings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeTab extends ConsumerStatefulWidget {
  const HomeTab({super.key});

  @override
  ConsumerState<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  final _formKey = GlobalKey<FormState>();
  final _searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => ref.read(dashboardProvider.notifier).fetchCryptos());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dashboardState = ref.watch(dashboardProvider);
    final isDesc = dashboardState.order == CoinsOrder.descendent;
    return Column(
      children: [
        SafeArea(child: Text('Welcome to Crypto App!', style: theme.textTheme.titleLarge)),
        Spacings.v16,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.search,
                    onFieldSubmitted: (value) =>
                        ref.read(dashboardProvider.notifier).fetchCryptos(query: [value]),
                    decoration:
                        const InputDecoration(hintText: 'Search', prefixIcon: Icon(Icons.search)),
                  ),
                ),
                IconButton(
                  onPressed: () => ref.read(dashboardProvider.notifier).toggleOrder(),
                  icon: Icon(isDesc ? Icons.arrow_downward : Icons.arrow_upward),
                ),
              ],
            ),
          ),
        ),
        Spacings.v16,
        dashboardState.coins.when(
          loading: () => const Center(child: CircularProgressIndicator.adaptive()),
          error: (error) => Text(error.toString()),
          data: (data) => Expanded(
            child: ListView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: data.length,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemBuilder: (context, index) {
                final coin = data[index];
                final isFavorite = dashboardState.favoriteCoins.contains(coin.id);
                return CryptoItemCard(coin: coin, isFavorite: isFavorite);
              },
            ),
          ),
        ),
      ],
    );
  }
}
