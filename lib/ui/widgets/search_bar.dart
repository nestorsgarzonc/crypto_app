import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:crypto_app/core/constants/ui_size.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    required this.onSendMessage,
    required this.focusNode,
    required this.textController,
    required this.error,
    required this.isLoading,
    super.key,
  });

  final VoidCallback onSendMessage;
  final FocusNode focusNode;
  final TextEditingController textController;
  final String? error;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: Sizes.m),
        Expanded(
          child: TextField(
            onSubmitted: (_) => onSendMessage(),
            focusNode: focusNode,
            controller: textController,
            enabled: !isLoading,
            keyboardType: TextInputType.url,
            inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
            decoration: InputDecoration(
              hintText: 'https://example.com',
              errorText: error,
              labelText: 'Enter URL',
            ),
          ),
        ),
        const SizedBox(width: Sizes.m),
        ElevatedButton(
          onPressed: isLoading ? () {} : onSendMessage,
          child: isLoading
              ? const SizedBox.square(dimension: Sizes.l, child: CircularProgressIndicator())
              : const Icon(Icons.send),
        ),
        const SizedBox(width: Sizes.m),
      ],
    );
  }
}
