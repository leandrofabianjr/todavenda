import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
                        (s) => ExpansionTile(
                          title: Text(s.items.length.toString()),
                        ),
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
