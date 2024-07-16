import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_app/core/extension_method/string_extension_method.dart';
import 'package:crypto_app/core/failure/api_exception.dart';
import 'package:crypto_app/features/dashboard/provider/shortener_state.dart';
import 'package:crypto_app/features/dashboard/service/shortener_service.dart';

final shortenerUrlProvider =
    StateNotifierProvider<ShortenerUrlNotifier, ShortenerState>(ShortenerUrlNotifier.fromRef);

class ShortenerUrlNotifier extends StateNotifier<ShortenerState> {
  ShortenerUrlNotifier(this.shortenerService) : super(ShortenerState.initial());

  factory ShortenerUrlNotifier.fromRef(Ref ref) {
    return ShortenerUrlNotifier(ref.read(shortenerServiceProvider));
  }

  final ShortenerService shortenerService;

  Future<void> shortUrl(String url) async {
    try {
      state = state.copyWith(isLoading: true);
      url = url.trim();
      if (url.isEmpty) {
        state = state.copyWith(isLoading: false, error: 'URL cannot be empty');
        return;
      }
      if (!url.isUrl()) {
        state = state.copyWith(isLoading: false, error: 'Invalid URL');
        return;
      }
      final uri = Uri.parse(url);
      final res = await shortenerService.shortUrl(uri);
      state = state.copyWith(
        isLoading: false,
        urls: [...state.urls, res],
      );
    } on ApiException catch (e) {
      state = state.copyWith(isLoading: false, error: e.error);
    } catch (_) {
      state = state.copyWith(isLoading: false, error: 'Something went wrong');
    }
  }
}
