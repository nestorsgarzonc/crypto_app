import 'package:crypto_app/features/dashboard/models/coins_model.dart';
import 'package:crypto_app/features/dashboard/models/coins_order.dart';
import 'package:crypto_app/features/dashboard/service/dashboard_service_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the [DashboardService] implementation.
final dashboardService = Provider<DashboardService>((ref) => DashboardServiceImpl.fromRef(ref));

/// Abstract class defining the contract for the Dashboard Service.
abstract class DashboardService {
  /// Retrieves a list of coins based on the specified parameters.
  ///
  /// [order] specifies the order in which the coins should be sorted (default: [CoinsOrder.descendent]).
  /// [page] specifies the page number to retrieve (default: 1).
  /// [query] specifies a list of coin IDs to filter the results (default: null).
  Future<List<CoinsModel>> getCoins(
      {CoinsOrder order = CoinsOrder.descendent, int page = 1, List<String>? query});

  /// Retrieves the set of favorite coins for the user.
  Future<Set<String>> getFavoritesCoins();

  /// Adds a coin to the user's favorite coins.
  ///
  /// [coinId] specifies the ID of the coin to add.
  Future<void> addFavoriteCoin(String coinId);

  /// Deletes a coin from the user's favorite coins.
  ///
  /// [coinId] specifies the ID of the coin to delete.
  Future<void> deleteFavoriteCoin(String coinId);

  /// Retrieves a set of all available coin IDs.
  Future<Set<String>> getListCoins();
}

/// Implementation of the [DashboardService] contract.
