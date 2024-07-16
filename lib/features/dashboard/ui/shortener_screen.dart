import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:crypto_app/core/constants/ui_size.dart';
import 'package:crypto_app/features/dashboard/provider/shortener_provider.dart';
import 'package:crypto_app/features/dashboard/ui/shortener_detail_screen.dart';
import 'package:crypto_app/ui/widgets/search_bar.dart';
import 'package:crypto_app/ui/widgets/shortener_card.dart';

class UrlShortenerScreen extends ConsumerStatefulWidget {
  const UrlShortenerScreen({super.key});

  static const route = '/';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ShortenerUrlScreenState();
}

class _ShortenerUrlScreenState extends ConsumerState<UrlShortenerScreen> {
  final focusNode = FocusNode();
  final textController = TextEditingController();

  void onSendMessage() {
    final text = textController.text;
    if (focusNode.hasFocus) focusNode.unfocus();
    textController.clear();
    ref.read(shortenerUrlProvider.notifier).shortUrl(text);
  }

  @override
  void dispose() {
    focusNode.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(shortenerUrlProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('URL shortener...')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Sizes.m),
          SearchBar(
            onSendMessage: onSendMessage,
            focusNode: focusNode,
            textController: textController,
            error: state.error,
            isLoading: state.isLoading,
          ),
          Padding(
            padding: const EdgeInsets.all(Sizes.m),
            child: Text(
              'Recently shortened URLs',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (state.urls.isNotEmpty) ShortenerCard(item: state.urls.last),
          if (state.urls.length > 1)
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed(ShortenerDetailScreen.route),
              child: const Text('Visit last'),
            ),
        ],
      ),
    );
  }
}
