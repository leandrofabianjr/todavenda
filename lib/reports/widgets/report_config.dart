import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/sales/sales.dart';

enum ReportConfigType {
  today,
  last7Days,
  last30Days,
  currentMonth,
  monthToMonth,
  custom,
}

extension ReportConfigTypeX on ReportConfigType {
  String get label => switch (this) {
        ReportConfigType.today => 'Hoje',
        ReportConfigType.last7Days => 'Últimos 7 dias',
        ReportConfigType.last30Days => 'Últimos 30 dias',
        ReportConfigType.currentMonth => 'Mês atual',
        ReportConfigType.monthToMonth => 'Mês a mês',
        ReportConfigType.custom => 'Personalizado',
      };
}

class ReportConfig extends Equatable {
  const ReportConfig({
    this.type = ReportConfigType.today,
    required this.dateTimeRange,
    required this.data,
  });

  final ReportConfigType type;
  final DateTimeRange dateTimeRange;
  final List<Sale> data;

  @override
  List<Object?> get props => [type, dateTimeRange.hashCode, data];

  String get periodFormatted =>
      '${DateTimeFormatter.shortDate(dateTimeRange.start)} - ${DateTimeFormatter.shortDate(dateTimeRange.end)}';

  static Future<ReportConfig> fromType({
    required SalesRepository salesRepository,
    required ReportConfigType reportType,
    DateTimeRange? dateTimeRange,
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
      case ReportConfigType.custom:
        start = dateTimeRange?.start;
        end = dateTimeRange?.end;
        break;
    }

    final data = await salesRepository.list(createdBetween: [start, end]);

    data.sortBy((s) => s.createdAt);

    start = data.firstOrNull?.createdAt ?? DateTime.now();
    end = data.lastOrNull?.createdAt ?? DateTime.now();

    return ReportConfig(
      data: data,
      type: reportType,
      dateTimeRange: DateTimeRange(start: start, end: end),
    );
  }

  ReportConfig copyWith({
    ReportConfigType? type,
    DateTimeRange? dateTimeRange,
    List<Sale>? data,
  }) {
    return ReportConfig(
      type: type ?? this.type,
      dateTimeRange: dateTimeRange ?? this.dateTimeRange,
      data: data ?? this.data,
    );
  }
}
