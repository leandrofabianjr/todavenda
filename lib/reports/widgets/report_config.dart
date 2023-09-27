import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/sales/sales.dart';

enum ReportConfigType {
  today,
  last24hours,
  last7Days,
  last30Days,
}

class ReportConfig extends Equatable {
  const ReportConfig({
    this.type = ReportConfigType.today,
    required this.start,
    required this.end,
    required this.barDuration,
    required this.barTitleBuilder,
    required this.showBarTitleEach,
    required this.data,
  });

  final ReportConfigType type;
  final DateTime start;
  final DateTime end;
  final Duration barDuration;
  final String Function(DateTime dateTime, double amount) barTitleBuilder;
  final int showBarTitleEach;
  final List<Sale> data;

  @override
  List<Object?> get props =>
      [start, end, barDuration, barTitleBuilder, showBarTitleEach];

  static Future<ReportConfig> fromType({
    required SalesRepository salesRepository,
    required ReportConfigType reportType,
  }) async {
    DateTime start, end;
    int showBarTitleEach = 1;

    switch (reportType) {
      case ReportConfigType.last7Days:
        end = DateTime.now().lastInstantOfTheDay;
        start = end.subtract(const Duration(days: 7)).firstInstantOfTheDay;
        break;
      case ReportConfigType.last30Days:
        end = DateTime.now().lastInstantOfTheDay;
        start = end.subtract(const Duration(days: 30)).firstInstantOfTheDay;
        showBarTitleEach = 6;
        break;
      case ReportConfigType.today:
        end = DateTime.now().add(const Duration(hours: 1)).lastFullHour;
        start = end.firstInstantOfTheDay;
        showBarTitleEach = 3;
        break;
      case ReportConfigType.last24hours:
        end = DateTime.now();
        start = end.subtract(const Duration(hours: 24));
        showBarTitleEach = 3;
        break;
    }

    final data = await salesRepository.list(createdBetween: [start, end]);
    if (reportType == ReportConfigType.today && data.isNotEmpty) {
      start = data.first.createdAt.firstInstantOfTheHour;
    }

    final period = end.difference(start);
    final barDuration = barDurationFromPeriod(period);
    return ReportConfig(
      data: data,
      type: ReportConfigType.last7Days,
      start: start,
      end: end,
      barDuration: barDuration,
      barTitleBuilder: barTitleBuilderFromDuration(barDuration),
      showBarTitleEach: showBarTitleEach,
    );
  }

  static Duration barDurationFromPeriod(Duration period) {
    if (!period.isGreaterThan(const Duration(hours: 1))) {
      return const Duration(minutes: 5);
    }
    if (!period.isGreaterThan(const Duration(hours: 3))) {
      return const Duration(minutes: 15);
    }
    if (!period.isGreaterThan(const Duration(hours: 6))) {
      return const Duration(minutes: 30);
    }
    if (!period.isGreaterThan(const Duration(hours: 12))) {
      return const Duration(hours: 1);
    }
    if (!period.isGreaterThan(const Duration(hours: 24))) {
      return const Duration(hours: 2);
    }
    if (!period.isGreaterThan(const Duration(days: 7))) {
      return const Duration(days: 1);
    }
    if (!period.isGreaterThan(const Duration(days: 15))) {
      return const Duration(days: 2);
    }
    if (!period.isGreaterThan(const Duration(days: 30))) {
      return const Duration(days: 3);
    }
    if (!period.isGreaterThan(const Duration(days: 90))) {
      return const Duration(days: 7);
    }

    return period.dividedBy(12).floorDays;
  }

  static String Function(DateTime, double) barTitleBuilderFromDuration(
      Duration barDuration) {
    if (barDuration.isLessThan(const Duration(hours: 2))) {
      return (dateTime, amount) =>
          '${dateTime.hour}h${dateTime.minute.withLeftZero()}';
    }
    if (barDuration.isLessThan(const Duration(days: 1))) {
      return (dateTime, amount) =>
          '${dateTime.day.withLeftZero()}/${dateTime.month.withLeftZero()} ${dateTime.hour}h';
    }
    return (dateTime, amount) =>
        '${dateTime.day.withLeftZero()}/${dateTime.month.withLeftZero()}';
  }

  // static ReportConfig basedOnData(List<Sale> salesData,
  //     [DateTime? endDateTime]) {
  //   salesData.sortBy((s) => s.createdAt);

  //   var start = salesData.first.createdAt;
  //   var end = endDateTime ?? salesData.last.createdAt;
  //   var period = end.difference(start);
  //   final barDuration = barDurationFromPeriod(period);

  //   start = start.subtract(barDuration);

  //   if (barDuration.isFullDays) {
  //     start = start.firstInstantOfTheDay;
  //     end = end.lastInstantOfTheDay;
  //   }

  //   final barCount = (period / barDuration).ceil();
  //   final showBarTitleEach = barCount <= 12 ? 1 : (barCount / 5).floor();

  //   return ReportConfig(
  //     start: start,
  //     end: end,
  //     barDuration: barDuration,
  //     barTitleBuilder: barTitleBuilderFromDuration(barDuration),
  //     showBarTitleEach: showBarTitleEach,
  //   );
  // }
}
