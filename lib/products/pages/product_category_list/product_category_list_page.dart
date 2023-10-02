import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/widgets/exception_widget.dart';
import 'package:todavenda/commons/widgets/loading_widget.dart';
import 'package:todavenda/products/models/product_category.dart';
import 'package:todavenda/products/pages/product_category_list/bloc/product_category_list_bloc.dart';
import 'package:todavenda/products/services/product_categories_repository.dart';

class ProductCategoryListPage extends StatelessWidget {
  const ProductCategoryListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ProductCategoryListBloc(context.read<ProductCategoriesRepository>())
            ..add(const ProductCategoryListStarted()),
      child: const ProductCategoryListView(),
    );
  }
}

class ProductCategoryListView extends StatelessWidget {
  const ProductCategoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const ProductCategoryListAppBar(),
          BlocBuilder<ProductCategoryListBloc, ProductCategoryListState>(
            builder: (context, state) {
              if (state is ProductCategoryListLoading) {
                return const SliverFillRemaining(child: LoadingWidget());
              }

              if (state is ProductCategoryListLoaded) {
                final productCategories = state.productCategories;

                if (productCategories.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(
                        child:
                            Text('Não há categorias de produtos cadastradas')),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => ProductCategoryListViewTile(
                      state.productCategories[index],
                    ),
                    childCount: state.productCategories.length,
                  ),
                );
              }

              return SliverFillRemaining(
                child: ExceptionWidget(
                  exception:
                      state is ProductCategoryListException ? state.ex : null,
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context
            .push('/cadastros/produtos/categorias/cadastrar')
            .then((value) {
          context
              .read<ProductCategoryListBloc>()
              .add(const ProductCategoryListStarted());
        }),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ProductCategoryListAppBar extends StatelessWidget {
  const ProductCategoryListAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      title: Text('Categorias de Produtos'),
      floating: true,
    );
  }
}

class ProductCategoryListViewTile extends StatelessWidget {
  const ProductCategoryListViewTile(this.productCategory, {super.key});

  final ProductCategory productCategory;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(productCategory.name),
      subtitle: productCategory.description != null
          ? Text(productCategory.description!)
          : null,
      onTap: () =>
          context.go('/cadastros/produtos/categorias/${productCategory.uuid}'),
    );
  }
}
