import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';

import './bloc/product_list_bloc.dart';
import '../../models/product.dart';
import '../../services/products_repository.dart';
import '../../widgets/widgets.dart';
import 'product_list_filter.dart';

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductListBloc(context.read<ProductsRepository>())
        ..add(const ProductListStarted()),
      child: const ProductListView(),
    );
  }
}

class ProductListView extends StatelessWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ProductListAppBar(),
      body: CustomScrollView(
        slivers: [
          BlocBuilder<ProductListBloc, ProductListState>(
            builder: (context, state) {
              if (state is ProductListLoading) {
                return const SliverFillRemaining(child: LoadingWidget());
              }

              if (state is ProductListLoaded) {
                final products = state.products;

                if (products.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('Não há produtos cadastrados')),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ProductListViewTile(
                      state.products[index],
                    ),
                    childCount: state.products.length,
                  ),
                );
              }

              return SliverFillRemaining(
                child: ExceptionWidget(
                  exception: state is ProductListException ? state.ex : null,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            context.push('/cadastros/produtos/cadastrar').then((value) {
          context.read<ProductListBloc>().add(const ProductListStarted());
        }),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProductListAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ProductListAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListBloc, ProductListState>(
      builder: (context, state) {
        if (state is ProductListLoaded) {
          final filter = state.filter;
          return AppBarWithSearchView(
            onSearchChanged: (term) {
              filter.searchTerm = term;
              context
                  .read<ProductListBloc>()
                  .add(ProductListStarted(filter: filter));
            },
            initialSearchTerm: filter.searchTerm,
            title: const Text('Produtos'),
            actions: [
              IconButton(
                onPressed: () {
                  ProductListFilterDialog.of(context, state.filter).then(
                    (filter) {
                      if (filter != null) {
                        context
                            .read<ProductListBloc>()
                            .add(ProductListStarted(filter: filter));
                      }
                    },
                  );
                },
                icon: const Icon(Icons.filter_list),
              ),
            ],
          );
        }
        return const SizedBox();
      },
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
      subtitle: ProductCategoriesChipList(categories: product.categories),
      trailing: Column(
        children: [
          Text(
            product.formattedPrice,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          if (product.hasStockControl)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.inventory, size: 16),
                const SizedBox(width: 8),
                Text(
                  '${product.currentStock}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
        ],
      ),
      onTap: () => context.go('/cadastros/produtos/${product.uuid}'),
    );
  }
}
