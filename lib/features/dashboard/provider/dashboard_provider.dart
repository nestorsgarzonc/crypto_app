import 'package:collection/collection.dart';
import 'package:crypto_app/core/failure/failure.dart';
import 'package:crypto_app/core/logger/custom_logger.dart';
import 'package:crypto_app/core/sealed/state_async.dart';
import 'package:crypto_app/features/dashboard/models/coins_model.dart';
import 'package:crypto_app/features/dashboard/models/coins_order.dart';
import 'package:crypto_app/features/dashboard/provider/dashboard_state.dart';
import 'package:crypto_app/features/dashboard/service/dashboard_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>(DashboardNotifier.fromRef);

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier(this.service) : super(DashboardState.initial());

  factory DashboardNotifier.fromRef(Ref ref) {
    return DashboardNotifier(ref.read(dashboardService));
  }

  final DashboardService service;
  static const _logger = Logger(name: 'DashboardNotifier');

  Future<void> getFavoritesCoins() async {
    final data = await service.getFavoritesCoins();
    state = state.copyWith(favoriteCoins: data);
  }

  void toggleOrder() {
    state = state.copyWith(
        order: state.order == CoinsOrder.descendent ? CoinsOrder.ascendent : CoinsOrder.descendent);
    fetchCryptos();
  }

  Future<void> fetchCryptos({List<String>? query}) async {
    try {
      state = state.copyWith(coins: const StateAsync.loading());
      final data = await service.getCoins(order: state.order, query: query);
      if (query == null) getFavoritesCoins();
      state = state.copyWith(coins: StateAsync.data(data));
    } catch (e) {
      state = state.copyWith(coins: StateAsync.failure(Failure(e.toString())));
    }
  }

  Future<void> fetchFavoritesCryptos({bool setLoading = true}) async {
    try {
      if (setLoading) state = state.copyWith(coins: const StateAsync.loading());
      final favorites = state.favoriteCoins;
      final data = await service.getCoins(order: state.order, query: favorites.toList());
      List<CoinsModel> orders = data;
      if (!setLoading && state.coins.value != null) {
        orders = _calculateVariation(state.coins.value!, orders);
      }
      state = state.copyWith(coins: StateAsync.data(orders));
    } catch (e) {
      state = state.copyWith(coins: StateAsync.failure(Failure(e.toString())));
    }
  }

  List<CoinsModel> _calculateVariation(List<CoinsModel> prev, List<CoinsModel> current) {
    _logger.info('Calculating variation');
    List<CoinsModel> orders = [];
    for (final cur in current) {
      final prevCoin = prev.firstWhereOrNull((e) => e.id == cur.id);
      if (prevCoin == null) continue;
      final variationPer = (cur.currentPrice - prevCoin.currentPrice) / prevCoin.currentPrice * 100;
      orders.add(cur.copyWith(variation: variationPer.toDouble()));
    }
    return orders;
  }

  Future<void> addFavoriteCoin(String coinId) async {
    await service.addFavoriteCoin(coinId);
    await getFavoritesCoins();
  }

  Future<void> deleteFavoriteCoin(String coinId) async {
    await service.deleteFavoriteCoin(coinId);
    await getFavoritesCoins();
  }

  Future<void> getListCoins() async {
    try {
      state = state.copyWith(listCoins: const StateAsync.loading());
      final data = await service.getListCoins();
      state = state.copyWith(listCoins: StateAsync.data(data));
    } catch (e) {
      state = state.copyWith(listCoins: StateAsync.failure(Failure(e.toString())));
    }
  }
}
