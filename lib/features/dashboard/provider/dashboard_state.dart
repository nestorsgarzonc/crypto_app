import 'package:flutter/foundation.dart';
import 'package:crypto_app/core/sealed/state_async.dart';
import 'package:crypto_app/features/dashboard/models/coins_model.dart';
import 'package:crypto_app/features/dashboard/models/coins_order.dart';

/// Represents the state of the dashboard in the crypto app.
class DashboardState {
  /// Constructs a new instance of [DashboardState].
  const DashboardState({
    required this.coins,
    required this.favoriteCoins,
    required this.listCoins,
    this.order = CoinsOrder.descendent,
  });

  /// The state of the coins.
  final StateAsync<List<CoinsModel>> coins;

  /// The set of favorite coins.
  final Set<String> favoriteCoins;

  /// The order of the coins.
  final CoinsOrder order;

  /// The state of the list of coins.
  final StateAsync<Set<String>> listCoins;

  /// Returns a list of favorite coins.
  List<CoinsModel> get favoriteCoinsList =>
      coins.value?.where((e) => favoriteCoins.contains(e.id)).toList() ?? [];

  /// Constructs an initial instance of [DashboardState].
  factory DashboardState.initial() {
    return const DashboardState(
      coins: StateAsync.initial(),
      favoriteCoins: {},
      listCoins: StateAsync.initial(),
    );
  }

  /// Creates a copy of this [DashboardState] with the given fields replaced with the new values.
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
    return other.coins == coins &&
        setEquals(other.favoriteCoins, favoriteCoins) &&
        other.order == order &&
        other.listCoins == listCoins;
  }

  @override
  int get hashCode {
    return coins.hashCode ^ favoriteCoins.hashCode ^ order.hashCode ^ listCoins.hashCode;
  }
}
