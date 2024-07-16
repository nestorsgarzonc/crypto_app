import 'package:flutter/material.dart';

abstract interface class Modals {
  static Future<void> showLoading(BuildContext context) => showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

  static void removeDialog(BuildContext context) => Navigator.of(context).pop();
}
