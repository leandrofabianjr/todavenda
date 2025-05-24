import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LfjBarChartData {
  final double value;
  final String? label;
  final String onTouchLabel;
  final String Function(double value) formatValue;

  LfjBarChartData({
    required this.value,
    this.label,
    required this.onTouchLabel,
    required this.formatValue,
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
  Widget build(BuildContext context) {
    colorScheme = Theme.of(context).colorScheme;
    greatestBarValue = _findGreatestBarValue();
    numBars = widget.data.length;
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
                          ? [colorScheme.primary, colorScheme.primary]
                          : [
                              colorScheme.primary.withValues(alpha: .3),
                              colorScheme.primary.withValues(alpha: .8),
                            ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
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
      getTooltipColor: (BarChartGroupData group) => colorScheme.primary,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 0,
      getTooltipItem:
          (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            if (groupIndex != touchedIndex) {
              return null;
            }
            final data = widget.data.elementAt(groupIndex);
            return BarTooltipItem(
              data.formatValue(data.value),
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
        getTitlesWidget: (value, meta) {
          final index = value.toInt();
          final label = widget.data.elementAt(index).label;
          return SideTitleWidget(
            meta: meta,
            space: 4,
            // Apenas a primeira e a última barra exibem label
            child: label != null && (index == 0 || index == numBars - 1)
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
    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
  );
}
