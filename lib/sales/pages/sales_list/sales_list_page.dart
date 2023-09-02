import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/sales/pages/sales_list/bloc/sales_list_bloc.dart';
import 'package:todavenda/sales/sales.dart';

class SalesListPage extends StatelessWidget {
  const SalesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SalesListBloc(context.read<SalesRepository>())
        ..add(const SalesListRefreshed()),
      child: const SalesListView(),
    );
  }
}

class SalesListView extends StatelessWidget {
  const SalesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vendas')),
      body: BlocBuilder<SalesListBloc, SalesListState>(
        builder: (context, state) {
          if (state is SalesListLoading) {
            return const LoadingWidget();
          }
          if (state is SalesListLoaded) {
            final sales = state.sales;
            return RefreshIndicator(
              onRefresh: () async => context.read<SalesListBloc>().add(
                    const SalesListRefreshed(),
                  ),
              child: ListView(
                children: [
                  ...sales
                      .map(
                        (sale) => SaleListTile(sale: sale),
                      )
                      .toList(),
                ],
              ),
            );
          }

          return const ExceptionWidget();
        },
      ),
    );
  }
}

class SaleListTile extends StatelessWidget {
  const SaleListTile({
    super.key,
    required this.sale,
  });

  final Sale sale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      trailing: Text(
        sale.formattedTotal,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.secondary,
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            sale.formattedCreatedAt,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          Text(
            sale.summary,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
      onTap: () => context.go('/relatorios/vendas/${sale.uuid}'),
    );
  }
}
