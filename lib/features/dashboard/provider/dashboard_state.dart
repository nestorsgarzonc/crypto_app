import 'package:flutter/foundation.dart';
import 'package:crypto_app/core/sealed/state_async.dart';
import 'package:crypto_app/features/dashboard/models/coins_model.dart';
import 'package:crypto_app/features/dashboard/models/coins_order.dart';

class DashboardState {
  const DashboardState({
    required this.coins,
    required this.favoriteCoins,
    required this.listCoins,
    this.order = CoinsOrder.descendent,
  });

  final StateAsync<List<CoinsModel>> coins;
  final Set<String> favoriteCoins;
  final CoinsOrder order;
  final StateAsync<Set<String>> listCoins;

  List<CoinsModel> get favoriteCoinsList =>
      coins.value?.where((e) => favoriteCoins.contains(e.id)).toList() ?? [];

  factory DashboardState.initial() {
    return const DashboardState(
      coins: StateAsync.initial(),
      favoriteCoins: {},
      listCoins: StateAsync.initial(),
    );
  }

  DashboardState copyWith({
    StateAsync<List<CoinsModel>>? coins,
    Set<String>? favoriteCoins,
    CoinsOrder? order,
    StateAsync<Set<String>>? listCoins,
  }) {
    return DashboardState(
      coins: coins ?? this.coins,
      favoriteCoins: favoriteCoins ?? this.favoriteCoins,
      order: order ?? this.order,
      listCoins: listCoins ?? this.listCoins,
    );
  }

  @override
  bool operator ==(covariant DashboardState other) {
    if (identical(this, other)) return true;
    return 
      other.coins == coins &&
      setEquals(other.favoriteCoins, favoriteCoins) &&
      other.order == order &&
      other.listCoins == listCoins;
  }

  @override
  int get hashCode {
    return coins.hashCode ^
      favoriteCoins.hashCode ^
      order.hashCode ^
      listCoins.hashCode;
  }
}
