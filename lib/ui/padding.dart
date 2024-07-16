import 'package:flutter/material.dart';

abstract interface class Paddings {
  static EdgeInsets bodySafePadding(BuildContext context) => EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 16,
        right: 16,
      );
}
