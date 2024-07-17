import 'package:crypto_app/ui/spacings.dart';
import 'package:flutter/material.dart';

class CryptoCompareWidget extends StatefulWidget {
  const CryptoCompareWidget({super.key, required this.onCompare, required this.coins});

  final ValueChanged<List<String>> onCompare;
  final Set<String> coins;

  @override
  State<CryptoCompareWidget> createState() => _CryptoCompareWidgetState();
}

class _CryptoCompareWidgetState extends State<CryptoCompareWidget> {
  TextEditingController _coinAController = TextEditingController();
  TextEditingController _coinBController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Select two cryptos to compare', style: theme.textTheme.titleMedium),
          Spacings.v16,
          Autocomplete(
            optionsBuilder: (text) => widget.coins.where((e) => e.contains(text.text)).toList(),
            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
              _coinAController = textEditingController;
              return TextFormField(
                controller: textEditingController,
                focusNode: focusNode,
                decoration: const InputDecoration(labelText: 'Crypto A'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (v) => widget.coins.contains(v) ? null : 'Invalid coin',
              );
            },
          ),
          Spacings.v16,
          Autocomplete(
            optionsBuilder: (text) => widget.coins.where((e) => e.contains(text.text)).toList(),
            fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
              _coinBController = textEditingController;
              return TextFormField(
                controller: textEditingController,
                focusNode: focusNode,
                decoration: const InputDecoration(labelText: 'Crypto B'),
                validator: (v) => widget.coins.contains(v) ? null : 'Invalid coin',
              );
            },
          ),
          Spacings.v16,
          ElevatedButton(
            onPressed: _onCompare,
            child: const Text('Compare'),
          ),
        ],
      ),
    );
  }

  void _onCompare() {
    if (!_formKey.currentState!.validate()) return;
    widget.onCompare([_coinAController.text, _coinBController.text]);
  }
}
