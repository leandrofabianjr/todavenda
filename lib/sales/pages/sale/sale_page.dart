import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/products/products.dart';

import '../../services/services.dart';
import 'bloc/sale_bloc.dart';

class SalePage extends StatelessWidget {
  const SalePage({super.key, required this.uuid});

  final String uuid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SaleBloc(
        context.read<SalesRepository>(),
        uuid: uuid,
      )..add(const SaleStarted()),
      child: const SaleView(),
    );
  }
}

class SaleView extends StatelessWidget {
  const SaleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Venda')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          slivers: [
            BlocBuilder<SaleBloc, SaleState>(
              builder: (context, state) {
                if (state is SaleLoading) {
                  return const SliverFillRemaining(child: LoadingWidget());
                }

                if (state is SaleLoaded) {
                  final sale = state.sale;

                  return SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        DescriptionDetail(
                          description: const Text('Realizada em'),
                          detail: Text(
                            sale.formattedCreatedAt,
                          ),
                        ),
                        DescriptionDetail(
                          description: const Text('Valor'),
                          detail: Text(
                            sale.formattedTotal,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        if (sale.client != null)
                          DescriptionDetail(
                            description: const Text('Cliente'),
                            detail: Text(
                              sale.client!.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        const SizedBox(height: 30),
                        sale.quantity > 0
                            ? DataTable(
                                columns: const [
                                  DataColumn(label: Text('Produto')),
                                  DataColumn(label: Text('Quantidade')),
                                  DataColumn(label: Text('Valor')),
                                ],
                                rows: sale.items
                                    .map<DataRow>(
                                      (i) => DataRow(
                                        cells: [
                                          DataCell(Text(i.product.description)),
                                          DataCell(
                                            Text(
                                              i.quantity.toString(),
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                          DataCell(
                                            Text(
                                              i.formattedUnitPrice,
                                              textAlign: TextAlign.end,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                    .toList(),
                              )
                            : Text(
                                'Não há itens na venda',
                                style: Theme.of(context).textTheme.bodyLarge,
                                textAlign: TextAlign.center,
                              ),
                      ],
                    ),
                  );
                }

                return SliverFillRemaining(
                  child: ExceptionWidget(
                    exception: state is SaleException ? state.ex : null,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
