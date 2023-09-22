import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:todavenda/commons/commons.dart';

class CurrencyAmountVsDateTimeChart<T> extends StatefulWidget {
  const CurrencyAmountVsDateTimeChart({
    super.key,
    required this.getData,
    required this.getDateTime,
    required this.getAmount,
    this.showReloadButton = false,
    required this.emptyDataWidget,
  });

  final FutureOr<List<T>> Function() getData;
  final DateTime Function(T obj) getDateTime;
  final double Function(T obj) getAmount;
  final bool showReloadButton;
  final Widget emptyDataWidget;

  @override
  State<CurrencyAmountVsDateTimeChart<T>> createState() =>
      _CurrencyAmountVsDateTimeChartState<T>();
}

class _CurrencyAmountVsDateTimeChartState<T>
    extends State<CurrencyAmountVsDateTimeChart<T>> {
  late List<Color> gradientColors;
  late ColorScheme colorScheme;
  late List<T> data;

  double minX = 0;
  double maxX = 0;
  double minY = 0;
  double maxY = 0;

  calculateAxisValues() {
    if (data.isEmpty) return;

    final firstTimeDate = widget.getDateTime(data.first);
    final lastTimeDate = widget.getDateTime(data.last);
    const lowestAmount = 0.0;
    double greatestAmount = 0;

    for (var obj in data) {
      final amount = widget.getAmount(obj);
      if (amount > greatestAmount) {
        greatestAmount = amount;
      }
    }

    minX = firstTimeDate.lastFullHour.millisecondsSinceEpoch.toDouble();
    maxX = lastTimeDate.nextFullHour.millisecondsSinceEpoch.toDouble();
    minY = lowestAmount;
    maxY = (((greatestAmount / 4) * 5) / 10).round() * 10.0;
  }

  updateData() async {
    data = await widget.getData();
    data.sortBy(widget.getDateTime);
    calculateAxisValues();
    return data;
  }

  List<FlSpot> get spots => data
      .map(
        (obj) => FlSpot(
          widget.getDateTime(obj).millisecondsSinceEpoch.toDouble(),
          widget.getAmount(obj),
        ),
      )
      .toList();

  @override
  void initState() {
    updateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
    gradientColors = [
      colorScheme.primary,
      colorScheme.secondary,
    ];

    return FutureBuilder(
      future: updateData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ExceptionWidget(exception: snapshot.error);
        }

        if (!snapshot.hasData) {
          return const LoadingWidget();
        }

        if (data.isEmpty) {
          return widget.emptyDataWidget;
        }

        return Stack(
          children: <Widget>[
            if (widget.showReloadButton)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: IconButton.filledTonal(
                    onPressed: () => setState(() {}),
                    icon: const Icon(Icons.refresh),
                  ),
                ),
              ),
            LineChart(mainData()),
          ],
        );
      },
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final dt = DateTime.fromMillisecondsSinceEpoch(value.toInt());

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        DateTimeFormatter.hourMinute(dt),
        style: TextStyle(color: colorScheme.primary, fontSize: 10),
        textAlign: TextAlign.left,
        softWrap: false,
      ),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    return Text(
      CurrencyFormatter().formatPtBr(value),
      style: TextStyle(color: colorScheme.primary, fontSize: 10),
      textAlign: TextAlign.left,
      softWrap: false,
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: const FlGridData(
        show: false,
        // drawVerticalLine: true,
        // horizontalInterval: 1,
        // verticalInterval: 1,
        // getDrawingHorizontalLine: (value) {
        //   return FlLine(
        //     color: colorScheme.primaryContainer,
        //     strokeWidth: 1,
        //   );
        // },
        // getDrawingVerticalLine: (value) {
        //   return FlLine(
        //     color: colorScheme.primaryContainer,
        //     strokeWidth: 1,
        //   );
        // },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: (maxX - minX) / 3,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: (maxY - minY) / 3,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 40,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: minX,
      maxX: maxX,
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: false,
          color: colorScheme.primary,
          barWidth: 1.5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (
              FlSpot spot,
              double xPercentage,
              LineChartBarData bar,
              int index, {
              double? size,
            }) {
              return FlDotCirclePainter(
                radius: 1.5,
                color: colorScheme.primary,
                strokeColor: colorScheme.primary,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            color: colorScheme.primary.withOpacity(.2),
          ),
        ),
      ],
    );
  }
}
