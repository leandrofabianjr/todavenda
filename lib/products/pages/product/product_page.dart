import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';

import '../../pages/product/bloc/product_bloc.dart';
import '../../products.dart';
import '../../widgets/widgets.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key, required this.uuid});

  final String uuid;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(
        context.read<ProductsRepository>(),
        uuid: uuid,
      )..add(const ProductStarted()),
      child: const ProductView(),
    );
  }
}

class ProductView extends StatelessWidget {
  const ProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductReady) {
                return Text(state.product.description);
              }
              return const SizedBox();
            },
          ),
          actions: [
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductReady) {
                  return IconButton(
                    onPressed: () => context
                        .go('/cadastros/produtos/${state.product.uuid}/editar'),
                    icon: const Icon(Icons.edit),
                  );
                }
                return const SizedBox();
              },
            ),
          ]),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const LoadingWidget();
          }

          if (state is ProductReady) {
            final product = state.product;

            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                DescriptionDetail(
                  description: const Text('Preço'),
                  detail: Text(
                    product.formattedPrice,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                DescriptionDetail(
                  description: const Text('Categorias'),
                  detail: ProductCategoriesChipList(
                    categories: product.categories,
                  ),
                )
              ],
            );
          }

          return ExceptionWidget(
            exception: state is ProductException ? state.ex : null,
          );
        },
      ),
    );
  }
}
