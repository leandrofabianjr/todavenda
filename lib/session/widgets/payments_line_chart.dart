import 'package:collection/collection.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/sales/models/models.dart';
import 'package:todavenda/session/services/payments_repository.dart';

class PaymentsLineChart extends StatefulWidget {
  const PaymentsLineChart(
      {super.key, required this.paymentsRepository, this.sessionUuid});

  final PaymentsRepository paymentsRepository;
  final String? sessionUuid;

  @override
  State<PaymentsLineChart> createState() => _PaymentsLineChartState();
}

class _PaymentsLineChartState extends State<PaymentsLineChart> {
  late List<Color> gradientColors;
  late ColorScheme colorScheme;
  late List<Payment> payments;
  bool loading = true;

  double minX = 0;
  double maxX = 0;
  double minY = 0;
  double maxY = 0;

  calculateAxisValues() {
    if (payments.isEmpty) return;

    final firstTimeDate = payments.first.createdAt;
    final lastTimeDate = payments.last.createdAt;
    const lowestAmount = 0.0;
    double greatestAmount = 0;

    for (var p in payments) {
      if (p.amount > greatestAmount) {
        greatestAmount = p.amount;
      }
    }

    minX = firstTimeDate.lastFullHour.millisecondsSinceEpoch.toDouble();
    maxX = lastTimeDate.nextFullHour.millisecondsSinceEpoch.toDouble();
    minY = lowestAmount;
    maxY = (((greatestAmount / 4) * 5) / 10).round() * 10.0;
  }

  updateData() async {
    if (!loading) setState(() => loading = true);

    payments = await widget.paymentsRepository.list(
      sessionUuid: widget.sessionUuid,
    );
    payments.sortBy((p) => p.createdAt);

    calculateAxisValues();

    setState(() => loading = false);
  }

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

    if (payments.isEmpty) {
      return const Center(
        child: Text('Ainda não há vendas realizadas nesta sessão'),
      );
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
        SizedBox(
          height: 150,
          child: Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: LineChart(mainData()),
          ),
        ),
      ],
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
