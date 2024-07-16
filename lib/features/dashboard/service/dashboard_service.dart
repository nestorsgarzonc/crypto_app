import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_app/core/external/api_handler.dart';
import 'package:crypto_app/core/external/firebase.dart';
import 'package:crypto_app/core/logger/custom_logger.dart';
import 'package:crypto_app/features/dashboard/models/coins_model.dart';
import 'package:crypto_app/features/dashboard/models/coins_order.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dashboardService = Provider<DashboardService>((ref) => DashboardServiceImpl.fromRef(ref));

abstract class DashboardService {
  Future<List<CoinsModel>> getCoins({CoinsOrder order = CoinsOrder.descendent, int page = 1});
  Future<Set<String>> getFavoritesCoins();
  Future<void> addFavoriteCoin(String coinId);
  Future<void> deleteFavoriteCoin(String coinId);
}

class DashboardServiceImpl implements DashboardService {
  const DashboardServiceImpl({required this.userFavRef, required this.apiHandler});

  factory DashboardServiceImpl.fromRef(Ref ref) {
    return DashboardServiceImpl(
      apiHandler: ref.read(apiHandlerProvider),
      userFavRef: ref.read(userFavRefFirestore),
    );
  }

  static const _logger = Logger(name: 'DashboardServiceImpl');
  final ApiHandler apiHandler;
  final DocumentReference<Set<String>> userFavRef;

  @override
  Future<List<CoinsModel>> getCoins(
      {CoinsOrder order = CoinsOrder.descendent, int page = 1}) async {
    final path =
        '/v3/coins/markets?vs_currency=usd&order=${order.labelBackEnd}&per_page=20&page=$page';
    final res = await apiHandler.get(path);
    _logger.info('getCoins: $res');
    return res.responseList.map((e) => CoinsModel.fromMap(e)).toList();
  }

  @override
  Future<Set<String>> getFavoritesCoins() async {
    try {
      final res = await userFavRef.get();
      return res.data() ?? {};
    } catch (e, s) {
      _logger.error('getFavoritesCoins error', e, s);
      return {};
    }
  }

  @override
  Future<void> addFavoriteCoin(String coinId) async {
    try {
      await userFavRef.update({
        'items': FieldValue.arrayUnion([coinId])
      });
    } catch (e, s) {
      _logger.error('addFavoriteCoin error', e, s);
      await userFavRef.set({coinId});
    }
  }

  @override
  Future<void> deleteFavoriteCoin(String coinId) {
    return userFavRef.update({
      'items': FieldValue.arrayRemove([coinId])
    });
  }
}
