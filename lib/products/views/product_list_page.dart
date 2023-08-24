import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todavenda/commons/widgets/exception_widget.dart';
import 'package:todavenda/commons/widgets/loading_widget.dart';
import 'package:todavenda/products/bloc/bloc/product_list_bloc.dart';
import 'package:todavenda/products/models/product.dart';
import 'package:todavenda/products/services/product_repository.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductListBloc(
        productRepository: context.read<ProductRepository>(),
      )..add(ProductListStarted()),
      child: const ProductListView(),
    );
  }
}

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const ProductListAppBar(),
          BlocBuilder<ProductListBloc, ProductListState>(
            builder: (context, state) {
              if (state is ProductListLoading) {
                return const SliverFillRemaining(child: LoadingWidget());
              }

              if (state is ProductListLoaded) {
                state.products.map((p) => ProductListViewTile(p)).toList();

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ProductListViewTile(
                      state.products[index],
                    ),
                    childCount: state.products.length,
                  ),
                );
              }

              return const SliverFillRemaining(child: ExceptionWidget());
            },
          ),
        ],
      ),
    );
  }
}

class ProductListAppBar extends StatelessWidget {
  const ProductListAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      title: Text('Produtos'),
      floating: true,
    );
  }
}

class ProductListViewTile extends StatelessWidget {
  const ProductListViewTile(this.product, {super.key});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.description),
    );
  }
}
