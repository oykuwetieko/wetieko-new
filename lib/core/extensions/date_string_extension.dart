import 'package:intl/intl.dart';

extension DateFormatting on String {
 
  String toFormattedDate() {
    try {
      final dateTime = DateTime.parse(this);
      return DateFormat('dd/MM/yyyy').format(dateTime);
    } catch (_) {
      return this;
    }
  }
}
