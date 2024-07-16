import 'package:crypto_app/core/sealed/state_async.dart';
import 'package:crypto_app/features/dashboard/models/coins_model.dart';
import 'package:crypto_app/features/dashboard/models/coins_order.dart';

class DashboardState {
  const DashboardState({
    required this.coins,
    required this.favoriteCoins,
    this.order = CoinsOrder.descendent,
  });

  final StateAsync<List<CoinsModel>> coins;
  final Set<String> favoriteCoins;
  final CoinsOrder order;

  factory DashboardState.initial() {
    return const DashboardState(
      coins: StateAsync.initial(),
      favoriteCoins: {},
    );
  }

  DashboardState copyWith({
    StateAsync<List<CoinsModel>>? coins,
    Set<String>? favoriteCoins,
    CoinsOrder? order,
  }) {
    return DashboardState(
      coins: coins ?? this.coins,
      favoriteCoins: favoriteCoins ?? this.favoriteCoins,
      order: order ?? this.order,
    );
  }

  @override
  bool operator ==(covariant DashboardState other) {
    if (identical(this, other)) return true;
    return other.coins == coins && other.favoriteCoins == favoriteCoins && other.order == order;
  }

  @override
  int get hashCode => coins.hashCode ^ favoriteCoins.hashCode ^ order.hashCode;
}
