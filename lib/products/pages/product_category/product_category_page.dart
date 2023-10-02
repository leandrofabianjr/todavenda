import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/products/pages/product_category/bloc/product_category_bloc.dart';
import 'package:todavenda/products/services/product_categories_repository.dart';

class ProductCategoryPage extends StatelessWidget {
  const ProductCategoryPage({super.key, required this.uuid});

  final String uuid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductCategoryBloc(
        context.read<ProductCategoriesRepository>(),
        uuid: uuid,
      )..add(const ProductCategoryStarted()),
      child: const ProductCategoryView(),
    );
  }
}

class ProductCategoryView extends StatelessWidget {
  const ProductCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: BlocBuilder<ProductCategoryBloc, ProductCategoryState>(
            builder: (context, state) {
              if (state is ProductCategoryReady) {
                return Text(state.productCategory.name);
              }
              return const SizedBox();
            },
          ),
          actions: [
            BlocBuilder<ProductCategoryBloc, ProductCategoryState>(
              builder: (context, state) {
                if (state is ProductCategoryReady) {
                  return IconButton(
                    onPressed: () => context.go(
                        '/cadastros/produtos/categorias/${state.productCategory.uuid}/editar'),
                    icon: const Icon(Icons.edit),
                  );
                }
                return const SizedBox();
              },
            ),
          ]),
      body: BlocBuilder<ProductCategoryBloc, ProductCategoryState>(
        builder: (context, state) {
          if (state is ProductCategoryLoading) {
            return const LoadingWidget();
          }

          if (state is ProductCategoryReady) {
            final productCategory = state.productCategory;

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                if (productCategory.description != null)
                  DescriptionDetail(
                    description: const Text('Descrição'),
                    detail: Text(
                      productCategory.description!,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
              ],
            );
          }

          return ExceptionWidget(
            exception: state is ProductCategoryException ? state.ex : null,
          );
        },
      ),
    );
  }
}
