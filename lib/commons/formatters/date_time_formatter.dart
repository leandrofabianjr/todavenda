import 'package:intl/intl.dart';

class DateTimeFormatter {
  static shortDate(DateTime? dt) {
    if (dt == null) return '';

    return DateFormat('dd/MM/yy').format(dt);
  }

  static shortDateTime(DateTime? dt) {
    if (dt == null) return '';

    return DateFormat('dd/MM/yy HH:mm:ss').format(dt);
  }

  static hourMinute(DateTime? dt) {
    if (dt == null) return '';

    return DateFormat('hh:mm').format(dt);
  }
}
