import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crypto_app/features/dashboard/models/url_short.dart';

class ShortenerCard extends StatelessWidget {
  const ShortenerCard({required this.item, super.key});

  final UrlShort item;

  void onCopyToClipBoard(String url, BuildContext context) {
    Clipboard.setData(ClipboardData(text: url));
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Copied to clipboard')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(item.short),
        subtitle: Text('Original: ${item.self}'),
        trailing: IconButton(
          icon: const Icon(Icons.content_copy),
          onPressed: () => onCopyToClipBoard(item.short, context),
        ),
      ),
    );
  }
}
