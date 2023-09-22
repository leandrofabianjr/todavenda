import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todavenda/clients/pages/pages.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/products/products.dart';
import 'package:todavenda/sales/sales.dart';

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
      body: BlocBuilder<SaleBloc, SaleState>(
        builder: (context, state) {
          if (state is SaleLoading) {
            return const LoadingWidget();
          }

          if (state is SaleLoaded) {
            final sale = state.sale;

            final theme = Theme.of(context);

            return ListView(
              children: [
                SectionCardWidget(
                  children: [
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
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    if (sale.client != null)
                      DescriptionDetail(
                        description: const Text('Cliente'),
                        detail: ActionChip(
                          avatar: const Icon(Icons.person),
                          backgroundColor: theme.colorScheme.secondaryContainer,
                          padding: EdgeInsets.zero,
                          label: Text(
                            sale.client!.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSecondaryContainer,
                            ),
                          ),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: ClientPage(uuid: sale.client!.uuid!),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                SaleItemsReport(sale: sale),
                SalePaymentsReport(sale: sale),
                const SizedBox(height: 80.0),
              ],
            );
          }

          return ExceptionWidget(
            exception: state is SaleException ? state.ex : null,
          );
        },
      ),
    );
  }
}

class SalePaymentsReport extends StatelessWidget {
  const SalePaymentsReport({super.key, required this.sale});
  final Sale sale;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionCardWidget(
      children: [
        Text(
          'Pagamentos:',
          style: theme.textTheme.titleMedium,
        ),
        buildReport(theme),
      ],
    );
  }

  Widget buildReport(ThemeData theme) {
    if (sale.payments.isEmpty) {
      return Text(
        'Não há pagamentos na venda',
        style: theme.textTheme.bodyLarge,
        textAlign: TextAlign.center,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DataTable(
          columns: const [
            DataColumn(label: Text('Tipo')),
            DataColumn(label: Text('Valor')),
          ],
          rows: sale.payments
              .map<DataRow>(
                (p) => DataRow(
                  cells: [
                    DataCell(Text(p.paymentType.label)),
                    DataCell(Text(p.formattedValue, textAlign: TextAlign.end)),
                  ],
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        DescriptionDetail(
          description: const Text('Total pago:'),
          detail: Text(
            sale.formattedAmountPaid,
            style: theme.textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}

class SaleItemsReport extends StatelessWidget {
  const SaleItemsReport({super.key, required this.sale});

  final Sale sale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionCardWidget(
      children: [
        Text(
          'Itens:',
          style: theme.textTheme.titleMedium,
        ),
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
                          DataCell(
                            Text(i.product.description),
                            onTap: () => showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                child: ProductPage(
                                  uuid: i.product.uuid!,
                                ),
                              ),
                            ),
                          ),
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
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
      ],
    );
  }
}
