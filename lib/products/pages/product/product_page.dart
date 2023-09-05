import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          slivers: [
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoaded) {
                  final product = state.product;
                  return SliverAppBar(
                    title: Text(product.description),
                  );
                }
                return const SliverAppBar();
              },
            ),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const SliverFillRemaining(child: LoadingWidget());
                }

                if (state is ProductLoaded) {
                  final product = state.product;

                  return SliverList(
                    delegate: SliverChildListDelegate(
                      [
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
                    ),
                  );
                }

                return SliverFillRemaining(
                  child: ExceptionWidget(
                    exception: state is ProductException ? state.ex : null,
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
