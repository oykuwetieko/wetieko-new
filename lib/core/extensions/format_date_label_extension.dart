import 'package:intl/intl.dart';

extension FormatDateLabelExtension on DateTime {
  String formatDateLabel() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final msgDate = DateTime(year, month, day);

    final difference = msgDate.difference(today).inDays;

    if (difference == 0) return "Bugün";
    if (difference == -1) return "Dün";
    if (difference == 1) return "Yarın";

    return DateFormat("dd.MM.yyyy").format(this);
  }
}
