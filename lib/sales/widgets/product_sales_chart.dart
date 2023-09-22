import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/products/products.dart';
import 'package:todavenda/sales/sales.dart';

class ProductSalesChart extends StatelessWidget {
  const ProductSalesChart({
    super.key,
    required this.salesRepository,
  });

  final SalesRepository salesRepository;

  @override
  Widget build(BuildContext context) {
    return RankingBarChart(
      getData: () async {
        final sales = await salesRepository.list();
        Map<Product, int> ranking = {};

        for (final sale in sales) {
          for (var item in sale.items) {
            final total = ranking[item.product] ?? 0;
            ranking[item.product] = total + item.quantity;
          }
        }

        return ranking;
      },
      emptyDataWidget: const Text('Não há vendas realizadas'),
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

  final FutureOr<Map<T, int>> Function() getData;
  final String Function(T obj) getLabel;
  final Widget emptyDataWidget;

  @override
  State<RankingBarChart<T>> createState() => _RankingBarChartState();
}

class _RankingBarChartState<T> extends State<RankingBarChart<T>> {
  Future<Map<T, int>> updateData() async {
    final data = await widget.getData();

    final sortedData = Map.fromEntries(
      data.entries.toList()..sort((e1, e2) => e2.value - e1.value),
    );
    return sortedData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: updateData(),
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
                          Text(
                            widget.getLabel(e.key),
                            style: textTheme.titleMedium,
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
