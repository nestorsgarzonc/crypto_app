import 'package:crypto_app/features/dashboard/models/coins_model.dart';
import 'package:crypto_app/features/dashboard/models/coins_order.dart';
import 'package:crypto_app/features/dashboard/service/dashboard_service.dart';

class DashboardServiceMock implements DashboardService {
  DashboardServiceMock({
    this.addFavoriteCoinFn,
    this.deleteFavoriteCoinFn,
    this.getCoinsFn,
    this.getFavoritesCoinsFn,
    this.getListCoinsFn,
  });

  final void Function()? addFavoriteCoinFn;
  final void Function()? deleteFavoriteCoinFn;
  final List<CoinsModel> Function(CoinsOrder order, int page, List<String>? query)? getCoinsFn;
  final Set<String> Function()? getFavoritesCoinsFn;
  final Set<String> Function()? getListCoinsFn;

  @override
  Future<void> addFavoriteCoin(String coinId) async => addFavoriteCoinFn?.call();

  @override
  Future<void> deleteFavoriteCoin(String coinId) async => deleteFavoriteCoinFn?.call();

  @override
  Future<List<CoinsModel>> getCoins(
          {CoinsOrder order = CoinsOrder.descendent, int page = 1, List<String>? query}) async =>
      getCoinsFn?.call(order, page, query) ??
      const [
        CoinsModel(
          id: 'bitcoin',
          symbol: 'btc',
          name: 'Bitcoin',
          image: 'https://assets.coingecko.com/coins/images/1/large/bitcoin.png',
          currentPrice: 1.0,
          marketCap: 1.0,
          marketCapRank: 1,
          priceChange24h: 1.0,
          priceChangePercentage24h: 1.0,
        ),
        CoinsModel(
          id: 'ethereum',
          symbol: 'eth',
          name: 'Ethereum',
          image: 'https://assets.coingecko.com/coins/images/279/large/ethereum.png',
          currentPrice: 1.0,
          marketCap: 1.0,
          marketCapRank: 2,
          priceChange24h: 1.0,
          priceChangePercentage24h: 1.0,
        ),
      ];

  @override
  Future<Set<String>> getFavoritesCoins() async => getFavoritesCoinsFn?.call() ?? {'bitcoin'};

  @override
  Future<Set<String>> getListCoins() async => getListCoinsFn?.call() ?? {'bitcoin', 'ethereum'};
}
