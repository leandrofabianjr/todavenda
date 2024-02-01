import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:todavenda/commons/commons.dart';
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

    return LfjBarChart(data: buildBarChartDataList(config));
  }

  List<LfjBarChartData> buildBarChartDataList(ReportConfig config) {
    List<LfjBarChartData> chartData = [];

    // Cria a lista dos valores de cada barra
    Map<DateTime, double> values =
        buildBarValuesMap(config.type, config.start, config.end);

    // Soma os valores totais de cada barra
    for (final obj in config.data) {
      final dateTime = obj.createdAt;
      if (dateTime.isAtSameMomentAs(config.start) ||
          (dateTime.isAfter(config.start) && dateTime.isBefore(config.end))) {
        final barKey = _buildBarKeyValue(type: config.type, keyValue: dateTime);
        values[barKey] = values[barKey]! + obj.total;
      }
    }

    // Cria as barras
    for (final value in values.entries) {
      // Apenas a primeira e a última barra exibem label
      final isFirst = values.entries.first.key == value.key;
      final isLast = values.entries.last.key == value.key;
      chartData.add(
        LfjBarChartData(
          label: isFirst
              ? _buildLabel(type: config.type, keyValue: value.key)
              : isLast
                  ? _buildLabel(
                      type: config.type,
                      keyValue: value.key.add(const Duration(hours: 1)),
                    )
                  : null,
          value: value.value,
          onTouchLabel: _buildOnTouchLabel(
            type: config.type,
            keyValue: value.key,
          ),
        ),
      );
    }

    return chartData;
  }

  // Cria uma função que formata o label de cada barra
  String _buildOnTouchLabel({
    required ReportConfigType type,
    required DateTime keyValue,
  }) {
    switch (type) {
      case ReportConfigType.today:
        return '${keyValue.hour}h';
      case ReportConfigType.last7Days:
      case ReportConfigType.last30Days:
      case ReportConfigType.currentMonth:
        return DateTimeFormatter.shortDate(keyValue);
      case ReportConfigType.monthToMonth:
        return keyValue.monthName;
    }
  }

  /// Cria o label de cada barra
  String _buildLabel({
    required ReportConfigType type,
    required DateTime keyValue,
  }) {
    switch (type) {
      case ReportConfigType.today:
        return '${keyValue.hour}h';
      case ReportConfigType.last7Days:
      case ReportConfigType.last30Days:
      case ReportConfigType.currentMonth:
        return DateTimeFormatter.shortDate(keyValue);
      case ReportConfigType.monthToMonth:
        return keyValue.monthName;
    }
  }

  /// Cria um Map para os valores de cada barra de acordo com o horário
  Map<DateTime, double> buildBarValuesMap(
      ReportConfigType type, DateTime start, DateTime end) {
    Map<DateTime, double> values = {};

    switch (type) {
      case ReportConfigType.today:
        values = {
          for (var i = start;
              i.isBefore(end);
              i = i.add(const Duration(hours: 1)))
            i: 0.0
        };
        break;
      case ReportConfigType.last7Days:
      case ReportConfigType.last30Days:
      case ReportConfigType.currentMonth:
        values = {
          for (var i = start;
              i.isBefore(end);
              i = i.add(const Duration(days: 1)))
            i: 0.0
        };
        break;
      case ReportConfigType.monthToMonth:
        values = {
          for (var i = start;
              i.isBefore(end);
              i = i.add(const Duration(days: 33)).firstInstantOfTheMonth)
            i: 0.0
        };
    }
    return values;
  }

  DateTime _buildBarKeyValue({
    required ReportConfigType type,
    required DateTime keyValue,
  }) {
    switch (type) {
      case ReportConfigType.today:
        return keyValue.firstInstantOfTheHour;
      case ReportConfigType.last7Days:
      case ReportConfigType.last30Days:
      case ReportConfigType.currentMonth:
        return keyValue.firstInstantOfTheDay;
      case ReportConfigType.monthToMonth:
        return keyValue.firstInstantOfTheMonth;
    }
  }
}

class LfjBarChartData {
  final double value;
  final String? label;
  final String? onTouchLabel;

  LfjBarChartData({
    required this.value,
    this.label,
    this.onTouchLabel,
  });
}

class LfjBarChart extends StatefulWidget {
  const LfjBarChart({super.key, required this.data});

  final List<LfjBarChartData> data;

  @override
  State<LfjBarChart> createState() => _LfjBarChartState();
}

class _LfjBarChartState extends State<LfjBarChart> {
  late ColorScheme colorScheme;
  late double greatestBarValue;
  late int numBars;
  int touchedIndex = -1;

  double _findGreatestBarValue() {
    double greatest = 0;
    for (var bar in widget.data) {
      if (bar.value > greatest) {
        greatest = bar.value;
      }
    }
    return greatest;
  }

  @override
  void initState() {
    numBars = widget.data.length;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
    greatestBarValue = _findGreatestBarValue();
    return BarChart(
      BarChartData(
        barTouchData: buildBarTouchData(),
        titlesData: buildTitlesData(),
        borderData: FlBorderData(show: false),
        barGroups: widget.data
            .mapIndexed(
              (index, element) => BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: element.value,
                    gradient: LinearGradient(
                      colors: touchedIndex == index
                          ? [
                              colorScheme.primary,
                              colorScheme.primary,
                            ]
                          : [
                              colorScheme.primary.withOpacity(.3),
                              colorScheme.primary.withOpacity(.8),
                            ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  )
                ],
                showingTooltipIndicators: [0],
              ),
            )
            .toList(),
        gridData: const FlGridData(show: false),
        maxY: greatestBarValue,
      ),
    );
  }

  BarTouchData buildBarTouchData() => BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: colorScheme.primary,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 0,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            if (groupIndex != touchedIndex) {
              return null;
            }
            return BarTooltipItem(
              CurrencyFormatter().formatPtBr(rod.toY),
              TextStyle(
                color: colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              children: [
                const TextSpan(text: '\n'),
                TextSpan(
                  text: widget.data.elementAt(groupIndex).onTouchLabel,
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 12,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      );

  FlTitlesData buildTitlesData() => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, _) {
              final index = value.toInt();
              final label = widget.data.elementAt(index).label;
              return SideTitleWidget(
                axisSide: AxisSide.bottom,
                space: 4,
                child: label != null
                    ? Text(
                        label,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      )
                    : const SizedBox(),
              );
            },
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );
}
