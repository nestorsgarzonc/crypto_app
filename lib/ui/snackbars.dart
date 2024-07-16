import 'package:flutter/material.dart';

abstract interface class Snackbars {
  static void _showBase(BuildContext context, String message, Color? backgroundColor) =>
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          showCloseIcon: true,
          behavior: SnackBarBehavior.floating,
          backgroundColor: backgroundColor,
        ),
      );

  static void showSuccess(BuildContext context, String message) =>
      _showBase(context, message, Colors.green);

  static void showError(BuildContext context, String message) =>
      _showBase(context, message, Colors.red);

  static void showWarning(BuildContext context, String message) =>
      _showBase(context, message, Colors.orange);

  static void showInfo(BuildContext context, String message) =>
      _showBase(context, message, Colors.blue);

  static void showCustom(BuildContext context, String message, Color backgroundColor) =>
      _showBase(context, message, backgroundColor);
}
