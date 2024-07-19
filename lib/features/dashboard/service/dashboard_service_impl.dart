import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_app/core/external/api_handler.dart';
import 'package:crypto_app/core/external/firebase.dart';
import 'package:crypto_app/core/logger/custom_logger.dart';
import 'package:crypto_app/features/dashboard/models/coins_model.dart';
import 'package:crypto_app/features/dashboard/models/coins_order.dart';
import 'package:crypto_app/features/dashboard/service/dashboard_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardServiceImpl implements DashboardService {
  const DashboardServiceImpl({required this.userFavRef, required this.apiHandler});

  /// Factory method to create a [DashboardServiceImpl] instance from a [Ref].
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
      {CoinsOrder order = CoinsOrder.descendent, int page = 1, List<String>? query}) async {
    String queryStr = '';
    if (query != null && query.isNotEmpty) {
      queryStr = '&ids=${query.join(',')}';
    }
    final path =
        '/v3/coins/markets?vs_currency=usd&order=${order.labelBackEnd}&per_page=40&page=$page$queryStr';
    final res = await apiHandler.get(path);
    _logger.info('getCoins: $res');
    final mapped = res.responseList.map((e) => CoinsModel.fromMap(e)).toList();
    final isAsc = order == CoinsOrder.ascendent;
    mapped.sort((a, b) => isAsc
        ? a.currentPrice.compareTo(b.currentPrice)
        : b.currentPrice.compareTo(a.currentPrice));
    return mapped;
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

  @override
  Future<Set<String>> getListCoins() async {
    const path = '/v3/coins/list';
    final res = await apiHandler.get(path);
    _logger.info('getListCoins: $res');
    return res.responseList.map((e) => e['id'] as String).toSet();
  }
}
