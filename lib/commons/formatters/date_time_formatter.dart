import 'package:intl/intl.dart';

class DateTimeFormatter {
  static shortDateTime(DateTime? dt) {
    if (dt == null) return '';

    return DateFormat('dd/MM/yy hh:mm:ss').format(dt);
  }
}
