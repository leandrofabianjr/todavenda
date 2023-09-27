import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/reports/reports.dart';
import 'package:todavenda/sales/sales.dart';

class TestChartClass {
  final DateTime dateTime;
  final double amount;

  TestChartClass({required this.dateTime, required this.amount});
}

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
    return CurrencyVsDateTimeBarChart<Sale>(
      data: config.data,
      getDateTime: (obj) => obj.createdAt,
      getAmount: (obj) => obj.total,
      emptyDataWidget: const Center(
        child: Text('Não há vendas realizadas no período'),
      ),
      start: config.start,
      end: config.end,
      barDuration: config.barDuration,
      barTitleBuilder: (dateTime, amount, index, lastBarIndex) => index == 0 ||
              index % config.showBarTitleEach == 0 ||
              index == lastBarIndex
          ? Text(
              config.barTitleBuilder(dateTime, amount),
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            )
          : const SizedBox(),
    );
  }
}

class CurrencyVsDateTimeBarChart<T> extends StatefulWidget {
  const CurrencyVsDateTimeBarChart({
    super.key,
    required this.data,
    required this.getDateTime,
    required this.getAmount,
    required this.emptyDataWidget,
    this.showReloadButton = false,
    required this.start,
    required this.end,
    required this.barDuration,
    required this.barTitleBuilder,
  });

  final List<T> data;
  final DateTime Function(T obj) getDateTime;
  final double Function(T obj) getAmount;
  final bool showReloadButton;
  final Widget emptyDataWidget;
  final DateTime start;
  final DateTime end;
  final Duration barDuration;
  final Widget Function(
          DateTime dateTime, double amount, int index, int lastBarIndex)
      barTitleBuilder;

  @override
  State<CurrencyVsDateTimeBarChart<T>> createState() =>
      _CurrencyVsDateTimeBarChartState<T>();
}

class _CurrencyVsDateTimeBarChartState<T>
    extends State<CurrencyVsDateTimeBarChart<T>> {
  late ColorScheme colorScheme;

  Map<DateTime, double> chartData = {};
  double greatestAmount = 0;
  int numBars = 0;

  int touchedIndex = -1;

  Future<Map<DateTime, double>> buildChartData() async {
    if (widget.data.isEmpty) return {};

    final data = widget.data;

    data.sortBy(widget.getDateTime);

    greatestAmount = 0;
    chartData.clear();

    chartData.clear();

    var nextBarDate = widget.start.add(widget.barDuration);
    while (!nextBarDate.isAfter(widget.end)) {
      chartData[nextBarDate] = 0;
      nextBarDate = nextBarDate.add(widget.barDuration);
    }

    final barDurationisFullDays = widget.barDuration.isFullDays;

    final barDates = chartData.keys.toList();

    for (final obj in data) {
      final dateTime = widget.getDateTime(obj);
      final amount = widget.getAmount(obj);

      if (barDurationisFullDays) {
        for (final barDate in barDates.reversed) {
          if (dateTime.isAtSameMomentAs(barDate) || dateTime.isAfter(barDate)) {
            chartData[barDate] = chartData[barDate]! + amount;
            break;
          }
        }
      } else {
        for (final barDate in barDates) {
          if (!dateTime.isAfter(barDate)) {
            chartData[barDate] = chartData[barDate]! + amount;
            break;
          }
        }
      }
    }

    for (var amount in chartData.values) {
      if (amount > greatestAmount) {
        greatestAmount = amount;
      }
    }

    numBars = chartData.length;

    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
    return FutureBuilder(
      future: buildChartData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ExceptionWidget(exception: snapshot.error);
        }

        if (!snapshot.hasData) {
          return const LoadingWidget();
        }

        if (chartData.isEmpty) {
          return widget.emptyDataWidget;
        }

        return BarChart(
          BarChartData(
            barTouchData: barTouchData,
            titlesData: titlesData,
            borderData: FlBorderData(show: false),
            barGroups: chartData.entries
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
            maxY: greatestAmount,
          ),
        );
      },
    );
  }

  BarTouchData get barTouchData => BarTouchData(
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
                  text: DateTimeFormatter.shortDateTime(
                    chartData.entries.elementAt(groupIndex).key,
                  ),
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 10,
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

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, _) {
              final index = value.toInt();
              final data = chartData.entries.elementAt(index);
              return SideTitleWidget(
                axisSide: AxisSide.bottom,
                space: 4,
                child: widget.barTitleBuilder(
                  data.key,
                  data.value,
                  index,
                  numBars - 1,
                ),
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
