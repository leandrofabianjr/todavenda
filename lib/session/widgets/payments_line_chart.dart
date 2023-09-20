import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/sales/models/models.dart';
import 'package:todavenda/session/services/payments_repository.dart';

class PaymentsLineChart extends StatefulWidget {
  const PaymentsLineChart({super.key, required this.paymentsRepository});

  final PaymentsRepository paymentsRepository;

  @override
  State<PaymentsLineChart> createState() => _PaymentsLineChartState();
}

class _PaymentsLineChartState extends State<PaymentsLineChart> {
  late List<Color> gradientColors;
  late ColorScheme colorScheme;
  late List<Payment> payments;
  bool loading = true;

  double greatestPayment = 0;

  updateData() async {
    if (!loading) setState(() => loading = true);

    payments = await widget.paymentsRepository.list();
    payments.sortBy((p) => p.createdAt);

    for (var p in payments) {
      if (p.amount > greatestPayment) {
        greatestPayment = p.amount;
      }
    }

    setState(() => loading = false);
  }

  double get minX => payments.first.createdAt.millisecondsSinceEpoch.toDouble();
  double get maxX => payments.last.createdAt.millisecondsSinceEpoch.toDouble();
  double get minY => 0;
  double get maxY => greatestPayment;

  List<FlSpot> get spots => payments
      .map(
        (p) => FlSpot(p.createdAt.millisecondsSinceEpoch.toDouble(), p.amount),
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

    if (loading) {
      return const LoadingWidget();
    }

    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton.filledTonal(
              onPressed: () => updateData(),
              icon: const Icon(Icons.refresh),
            ),
          ),
        ),
        AspectRatio(
          aspectRatio: 1.5,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 24,
              bottom: 12,
            ),
            child: LineChart(mainData()),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(color: colorScheme.primary);

    if (value == maxX || value == minX) {
      final dt = DateTime.fromMillisecondsSinceEpoch(value.toInt());
      final a = DateTimeFormatter.shortDateTime(dt);
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(a, style: style, textAlign: TextAlign.left),
      );
    }

    return const SizedBox();
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    final style = TextStyle(
      color: colorScheme.primary,
    );

    if (value == 0) {
      return Text('R\$ 0', style: style, textAlign: TextAlign.left);
    }
    if (value == greatestPayment) {
      return Text('R\$ $greatestPayment',
          style: style, textAlign: TextAlign.left);
    }
    return const SizedBox();
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
            interval: maxX - minX,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: maxY - minY,
            getTitlesWidget: leftTitleWidgets,
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
          dotData: const FlDotData(
            show: false,
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
