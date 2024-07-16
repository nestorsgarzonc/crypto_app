import 'package:intl/intl.dart';

extension DateExt on DateTime {
  String toFormattedString() {
    return DateFormat('dd/MM/yyyy').format(this);
  }
}