import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_app/core/constants/ui_size.dart';
import 'package:crypto_app/features/dashboard/provider/shortener_provider.dart';
import 'package:crypto_app/ui/widgets/shortener_card.dart';

class ShortenerDetailScreen extends ConsumerWidget {
  const ShortenerDetailScreen({super.key});

  static const route = '/detail';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final urls = ref.watch(shortenerUrlProvider.select((v) => v.urls));
    return Scaffold(
      appBar: AppBar(
        title: const Text('My shortened URLs'),
      ),
      body: ListView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: const EdgeInsets.symmetric(horizontal: Sizes.m),
        itemCount: urls.length,
        itemBuilder: (context, index) => ShortenerCard(item: urls[index]),
      ),
    );
  }
}
