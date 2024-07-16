import 'package:flutter/foundation.dart';
import 'package:crypto_app/features/dashboard/models/url_short.dart';

class ShortenerState {
  const ShortenerState({
    required this.isLoading,
    required this.urls,
    this.error,
  });

  factory ShortenerState.initial() {
    return const ShortenerState(
      isLoading: false,
      urls: [],
      error: null,
    );
  }

  final List<UrlShort> urls;
  final bool isLoading;
  final String? error;

  @override
  bool operator ==(covariant ShortenerState other) {
    if (identical(this, other)) return true;
    return listEquals(other.urls, urls) && other.isLoading == isLoading && other.error == error;
  }

  @override
  int get hashCode => urls.hashCode ^ isLoading.hashCode ^ error.hashCode;

  ShortenerState copyWith({
    bool? isLoading,
    String? error,
    List<UrlShort>? urls,
  }) {
    return ShortenerState(
      isLoading: isLoading ?? this.isLoading,
      urls: urls ?? this.urls,
      error: error,
    );
  }
}
