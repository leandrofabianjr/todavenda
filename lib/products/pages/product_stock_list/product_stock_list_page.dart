import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/products/pages/product_stock_list/bloc/product_stock_list_bloc.dart';
import 'package:todavenda/products/products.dart';

class ProductStockListPage extends StatelessWidget {
  const ProductStockListPage({super.key, required this.productUuid});

  final String productUuid;

  @override
  Widget build(BuildContext context) {
    final productStockRepository =
        context.read<ProductsRepository>().stockRepository(productUuid);
    return BlocProvider(
      create: (context) => ProductStockListBloc(productStockRepository)
        ..add(const ProductStockListStarted()),
      child: const ProductStockListView(),
    );
  }
}

class ProductStockListView extends StatelessWidget {
  const ProductStockListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const ProductStockListAppBar(),
          BlocBuilder<ProductStockListBloc, ProductStockListState>(
            builder: (context, state) {
              if (state is ProductStockListLoading) {
                return const SliverFillRemaining(child: LoadingWidget());
              }

              if (state is ProductStockListLoaded) {
                final productStocks = state.productStocks;

                if (productStocks.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                      child: Text('Não há atualizações de estoque cadastradas'),
                    ),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ProductStockListViewTile(
                      productStocks[index],
                    ),
                    childCount: productStocks.length,
                  ),
                );
              }

              return SliverFillRemaining(
                child: ExceptionWidget(
                  exception:
                      state is ProductStockListException ? state.ex : null,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ProductStockListAppBar extends StatelessWidget {
  const ProductStockListAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      title: Text('Atualizações de estoque'),
      floating: true,
    );
  }
}

class ProductStockListViewTile extends StatelessWidget {
  const ProductStockListViewTile(this.productStock, {super.key});

  final ProductStock productStock;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(productStock.quantity.toString()),
      subtitle: productStock.observation == null
          ? null
          : Text(productStock.observation!),
      trailing: Text(DateTimeFormatter.shortDateTime(productStock.createdAt)),
    );
  }
}
