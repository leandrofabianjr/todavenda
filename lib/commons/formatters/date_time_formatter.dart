import 'package:intl/intl.dart';

extension DateTimeX on DateTime {
  DateTime get lastFullHour => copyWith(
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

  DateTime get nextFullHour => lastFullHour.add(const Duration(hours: 1));

  DateTime get firstInstantOfTheDay => copyWith(
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

  DateTime get lastInstantOfTheDay => add(const Duration(days: 1))
      .firstInstantOfTheDay
      .subtract(const Duration(microseconds: 1));

  DateTime get firstInstantOfTheHour => copyWith(
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );
}

class DateTimeFormatter {
  static shortDateTime(DateTime? dt) {
    if (dt == null) return '';

    return DateFormat('dd/MM/yy HH:mm:ss').format(dt);
  }

  static hourMinute(DateTime? dt) {
    if (dt == null) return '';

    return DateFormat('hh:mm').format(dt);
  }
}
