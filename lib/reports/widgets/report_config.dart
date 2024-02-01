import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/sales/sales.dart';

enum ReportConfigType {
  today,
  last7Days,
  last30Days,
  currentMonth,
  monthToMonth,
}

class ReportConfig extends Equatable {
  const ReportConfig({
    this.type = ReportConfigType.today,
    required this.start,
    required this.end,
    required this.data,
  });

  final ReportConfigType type;
  final DateTime start;
  final DateTime end;
  final List<Sale> data;

  @override
  List<Object?> get props => [start, end];

  static Future<ReportConfig> fromType({
    required SalesRepository salesRepository,
    required ReportConfigType reportType,
  }) async {
    DateTime? start, end;

    switch (reportType) {
      case ReportConfigType.today:
        end = DateTime.now().lastInstantOfTheDay;
        start = end.firstInstantOfTheDay;
        break;
      case ReportConfigType.last7Days:
        end = DateTime.now().lastInstantOfTheDay;
        start = end.subtract(const Duration(days: 7)).firstInstantOfTheDay;
        break;
      case ReportConfigType.last30Days:
        end = DateTime.now().lastInstantOfTheDay;
        start = end.subtract(const Duration(days: 30)).firstInstantOfTheDay;
        break;
      case ReportConfigType.currentMonth:
        end = DateTime.now().lastInstantOfTheMonth;
        start = end.firstInstantOfTheMonth;
        break;
      case ReportConfigType.monthToMonth:
        break;
    }

    final data = await salesRepository.list(createdBetween: [start, end]);

    data.sortBy((s) => s.createdAt);

    if (start == null || end == null) {
      start = data.first.createdAt.firstInstantOfTheMonth;
      end = DateTime.now().lastInstantOfTheMonth;
    }

    return ReportConfig(
      data: data,
      type: reportType,
      start: start,
      end: end,
    );
  }
}
