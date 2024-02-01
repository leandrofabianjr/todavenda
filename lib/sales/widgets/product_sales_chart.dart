import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/products/products.dart';
import 'package:todavenda/reports/reports.dart';

class ProductSalesChart extends StatelessWidget {
  const ProductSalesChart({
    super.key,
    required this.config,
  });

  final ReportConfig config;

  @override
  Widget build(BuildContext context) {
    return RankingBarChart(
      getData: () async {
        Map<Product, int> ranking = {};

        for (final sale in config.data) {
          for (var item in sale.items) {
            final total = ranking[item.product] ?? 0;
            ranking[item.product] = total + item.quantity;
          }
        }

        final topList = Map.fromEntries(
          ranking.entries.toList()
            ..sort((e1, e2) => e2.value - e1.value)
            ..take(5),
        );

        return topList;
      },
      emptyDataWidget: const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(child: Text('Não há vendas realizadas no período')),
      ),
      getLabel: (obj) => obj.description,
    );
  }
}

class RankingBarChart<T> extends StatefulWidget {
  const RankingBarChart({
    super.key,
    required this.getData,
    required this.getLabel,
    required this.emptyDataWidget,
  });

  final Future<Map<T, int>> Function() getData;
  final String Function(T obj) getLabel;
  final Widget emptyDataWidget;

  @override
  State<RankingBarChart<T>> createState() => _RankingBarChartState();
}

class _RankingBarChartState<T> extends State<RankingBarChart<T>> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.getData(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return ExceptionWidget(exception: snapshot.error);
        }
        if (!snapshot.hasData) {
          return const LoadingWidget();
        }
        final data = snapshot.data!;

        if (data.isEmpty) {
          return widget.emptyDataWidget;
        }

        final colorScheme = Theme.of(context).colorScheme;
        final textTheme = Theme.of(context).textTheme;
        final greatestValue = data.values.first;

        return LayoutBuilder(builder: (context, constraints) {
          final maxBarLength = constraints.maxWidth;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: data.entries
                .expand((e) => [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              widget.getLabel(e.key),
                              style: textTheme.titleMedium,
                            ),
                          ),
                          Text(
                            '${e.value} un',
                            style: textTheme.titleSmall!
                                .copyWith(color: colorScheme.secondary),
                          ),
                        ],
                      ),
                      Container(
                        height: 5,
                        width: maxBarLength * e.value / greatestValue,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary.withOpacity(.5),
                              colorScheme.primary,
                            ],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                    ])
                .toList(),
          );
        });
      },
    );
  }
}
