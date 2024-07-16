import 'package:flutter/services.dart';

abstract interface class InputFormatters {
  static final emailFormatter = FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@.]'));
  static final nameFormatter = FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'));
}
