import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart' as fl;
import 'package:flutter/material.dart';
import 'package:todavenda/commons/extensions/double_extension.dart';
import 'package:todavenda/reports/reports.dart';
import 'package:todavenda/sales/sales.dart';

class PaymentsByTypePieChart extends StatelessWidget {
  const PaymentsByTypePieChart({super.key, required this.config});

  final ReportConfig config;

  List<PieChartData> get data {
    Map<PaymentType, double> totalsByPaymentType = Sale.totalsByPaymentType(
      config.data,
    );

    final colors = {
      PaymentType.cash: Colors.green.withValues(alpha: .7),
      PaymentType.pix: Colors.blue.withValues(alpha: .7),
      PaymentType.debit: Colors.yellow.withValues(alpha: .7),
      PaymentType.credit: Colors.red.withValues(alpha: .7),
      PaymentType.onCredit: Colors.purple.withValues(alpha: .7),
    };

    return totalsByPaymentType.entries
        .map(
          (e) => PieChartData(
            label: e.key.label,
            value: e.value,
            color: colors[e.key]!,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return PieChart<Sale>(
      data: data,
      emptyDataWidget: const Center(
        child: Text('Não há vendas realizadas no período'),
      ),
    );
  }
}

class PieChartData {
  PieChartData({required this.label, required this.value, required this.color});

  final String label;
  final double value;
  final Color color;
}

class PieChart<T> extends StatefulWidget {
  const PieChart({
    super.key,
    required this.data,
    required this.emptyDataWidget,
  });

  final List<PieChartData> data;
  final Widget emptyDataWidget;

  @override
  State<PieChart<T>> createState() => _PieChartState<T>();
}

class _PieChartState<T> extends State<PieChart<T>> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return widget.emptyDataWidget;
    }
    return Row(
      children: <Widget>[
        SizedBox(
          width: 170,
          child: fl.PieChart(
            fl.PieChartData(
              pieTouchData: fl.PieTouchData(
                touchCallback: (fl.FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: fl.FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: 0,
              sections: showingSections(),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: widget.data
                .expand(
                  (d) => [
                    Indicator(
                      color: d.color,
                      text: d.label,
                      value: d.value,
                      isSquare: true,
                    ),
                    const SizedBox(height: 4),
                  ],
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  List<fl.PieChartSectionData> showingSections() {
    return widget.data.mapIndexed<fl.PieChartSectionData>((i, d) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 18.0 : 12.0;
      final radius = isTouched ? 90.0 : 80.0;
      return fl.PieChartSectionData(
        color: d.color,
        value: d.value,
        title: '${d.label}\n${isTouched ? d.value.toCurrency() : ''}',
        radius: radius,
        titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
      );
    }).toList();
  }
}

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.value,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final double value;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: [
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
                color: color,
              ),
            ),
            const SizedBox(width: 4),
            Text(text),
          ],
        ),
        Text(value.toCurrency(), style: Theme.of(context).textTheme.titleSmall),
      ],
    );
  }
}
