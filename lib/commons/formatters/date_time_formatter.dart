import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  DateTime get lastFullHour => copyWith(
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

  get nextFullHour => lastFullHour.add(const Duration(hours: 1));
}

class DateTimeFormatter {
  static shortDateTime(DateTime? dt) {
    if (dt == null) return '';

    return DateFormat('dd/MM/yy hh:mm:ss').format(dt);
  }

  static hourMinute(DateTime? dt) {
    if (dt == null) return '';

    return DateFormat('hh:mm').format(dt);
  }
}
