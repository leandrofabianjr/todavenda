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

  DateTime get firstInstantOfTheMonth => copyWith(
        day: 1,
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
        microsecond: 0,
      );

  DateTime get lastInstantOfTheMonth => copyWith(month: month + 1, day: 0);

  String get monthName => switch (month) {
        1 => 'Janeiro',
        2 => 'Fevereiro',
        3 => 'Março',
        4 => 'Abril',
        5 => 'Maio',
        6 => 'Junho',
        7 => 'Julho',
        8 => 'Agosto',
        9 => 'Setembro',
        10 => 'Outubro',
        11 => 'Novembro',
        12 => 'Dezembro',
        _ => 'Mês',
      };
}
