import 'package:flutter/material.dart';

abstract interface class Modals {
  static Future<void> showLoading(BuildContext context) => showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator.adaptive()),
      );

  static void removeDialog(BuildContext context) => Navigator.of(context).pop();
}
