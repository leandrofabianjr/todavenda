import 'package:flutter/material.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/commons/widgets/lfj/lfj_bar_chart.dart';
import 'package:todavenda/reports/reports.dart';

class PaymentsBarChart extends StatelessWidget {
  const PaymentsBarChart({
    super.key,
    required this.config,
    this.sessionUuid,
  });

  final String? sessionUuid;
  final ReportConfig config;

  @override
  Widget build(BuildContext context) {
    if (config.data.isEmpty) {
      return const Center(
        child: Text('Não há vendas realizadas no período'),
      );
    }

    final amountByDateTimeBarChartConfig =
        LfjAmountByDateTimeBarChartConfig.fromReportConfig(config);

    return LfjBarChart(data: amountByDateTimeBarChartConfig.barChartDataList);
  }
}

class LfjAmountByDateTimeBarChartConfig extends ReportConfig {
  const LfjAmountByDateTimeBarChartConfig({
    super.type = ReportConfigType.today,
    required super.dateTimeRange,
    required super.data,
  });

  List<LfjBarChartData> get barChartDataList {
    List<LfjBarChartData> chartData = [];

    // Cria a lista dos valores de cada barra
    final values = {
      for (var i = barValueOf(dateTimeRange.start);
          i.isBefore(dateTimeRange.end);
          i = barRange.call(i))
        i: 0.0
    };

    // Soma os valores totais de cada barra
    for (final obj in data) {
      final dateTime = obj.createdAt;
      final barKey = barValueOf(dateTime);
      values[barKey] = values[barKey]! + obj.total;
    }

    // Cria as barras
    for (final value in values.entries) {
      chartData.add(
        LfjBarChartData(
          label: barLabelOf(value.key),
          value: value.value,
          onTouchLabel: onTouchBarLabelOf(value.key),
          formatValue: (value) => CurrencyFormatter().formatPtBr(value),
        ),
      );
    }

    return chartData;
  }

  static LfjAmountByDateTimeBarChartConfig fromReportConfig(
      ReportConfig reportConfig) {
    return LfjAmountByDateTimeBarChartConfig(
      type: reportConfig.type,
      dateTimeRange: reportConfig.dateTimeRange,
      data: reportConfig.data,
    );
  }

  DateTime Function(DateTime) get barRange {
    hourly(DateTime dt) => dt.add(const Duration(hours: 1));
    daily(DateTime dt) => dt.add(const Duration(days: 1));
    monthly(DateTime dt) =>
        dt.add(const Duration(days: 32)).firstInstantOfTheMonth;

    switch (type) {
      case ReportConfigType.today:
        return hourly;
      case ReportConfigType.last7Days:
      case ReportConfigType.last30Days:
      case ReportConfigType.currentMonth:
        return daily;
      case ReportConfigType.monthToMonth:
        return monthly;
      case ReportConfigType.custom:
        final duration = dateTimeRange.duration;
        if (duration < const Duration(days: 1)) return hourly;
        if (duration < const Duration(days: 31)) return daily;
        return monthly;
    }
  }

  String onTouchBarLabelOf(DateTime keyValue) {
    final hourly = 'Entre ${keyValue.hour}h e ${keyValue.hour + 1}h';
    final daily = DateTimeFormatter.shortDate(keyValue);
    final monthly = keyValue.monthName;
    switch (type) {
      case ReportConfigType.today:
        return hourly;
      case ReportConfigType.last7Days:
      case ReportConfigType.last30Days:
      case ReportConfigType.currentMonth:
        return daily;
      case ReportConfigType.monthToMonth:
        return keyValue.monthName;
      case ReportConfigType.custom:
        final duration = dateTimeRange.duration;
        if (duration < const Duration(days: 1)) return hourly;
        if (duration < const Duration(days: 31)) return daily;
        return monthly;
    }
  }

  DateTime barValueOf(DateTime keyValue) {
    switch (type) {
      case ReportConfigType.today:
        return keyValue.firstInstantOfTheHour;
      case ReportConfigType.last7Days:
      case ReportConfigType.last30Days:
      case ReportConfigType.currentMonth:
        return keyValue.firstInstantOfTheDay;
      case ReportConfigType.monthToMonth:
        return keyValue.firstInstantOfTheMonth;
      case ReportConfigType.custom:
        final duration = dateTimeRange.duration;
        if (duration < const Duration(days: 1)) {
          return keyValue.firstInstantOfTheHour;
        }
        if (duration < const Duration(days: 31)) {
          return keyValue.firstInstantOfTheDay;
        }
        return keyValue.firstInstantOfTheMonth;
    }
  }

  /// Cria o label de cada barra
  String barLabelOf(DateTime keyValue) {
    final hourly = '${keyValue.hour}h';
    final daily = DateTimeFormatter.shortDate(keyValue);
    final monthly = keyValue.monthName;
    switch (type) {
      case ReportConfigType.today:
        return hourly;
      case ReportConfigType.last7Days:
      case ReportConfigType.last30Days:
      case ReportConfigType.currentMonth:
        return daily;
      case ReportConfigType.monthToMonth:
        return keyValue.monthName;
      case ReportConfigType.custom:
        final duration = dateTimeRange.duration;
        if (duration < const Duration(days: 1)) return hourly;
        if (duration < const Duration(days: 31)) return daily;
        return monthly;
    }
  }
}
