import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_app/core/external/api_handler.dart';
import 'package:crypto_app/features/dashboard/models/url_short.dart';

final shortenerServiceProvider = Provider<ShortenerService>(ShortenerServiceImpl.fromRef);

abstract class ShortenerService {
  Future<UrlShort> shortUrl(Uri url);
}

class ShortenerServiceImpl implements ShortenerService {
  const ShortenerServiceImpl({required this.apiHandler});

  final ApiHandler apiHandler;

  factory ShortenerServiceImpl.fromRef(Ref ref) {
    return ShortenerServiceImpl(apiHandler: ref.read(apiHandlerProvider));
  }

  @override
  Future<UrlShort> shortUrl(Uri url) async {
    const path = '/alias';
    final res = await apiHandler.post(path, {'url': url.toString()});
    return UrlShort.fromJson(res.responseMap);
  }
}
