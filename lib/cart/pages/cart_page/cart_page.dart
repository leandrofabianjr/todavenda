import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/products/products.dart';

import '../../cart.dart';
import '../../widgets/cart_list_tile.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<CartBloc>(context),
      child: const CartView(),
    );
  }
}

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartBloc, CartState>(
      listener: (context, state) {
        if (state is CartCheckout) {
          context.push('/carrinho/confirmar');
        }
      },
      builder: (context, state) {
        if (state is CartLoading) {
          return const Scaffold(body: LoadingWidget());
        }
        if (state is CartLoaded) {
          return CartSelectorView(
            items: state.items,
            formattedTotalPrice: state.formattedTotalPrice,
            totalQuantity: state.totalQuantity,
            onAdded: (product) =>
                context.read<CartBloc>().add(CartItemAdded(product: product)),
            onRemoved: (product) =>
                context.read<CartBloc>().add(CartItemRemoved(product: product)),
          );
        }

        return Scaffold(
          body: ExceptionWidget(
            exception: state is CartException ? state.ex : null,
          ),
        );
      },
    );
  }
}

class CartSelectorView extends StatelessWidget {
  const CartSelectorView({
    super.key,
    required this.items,
    required this.totalQuantity,
    required this.formattedTotalPrice,
    required this.onAdded,
    required this.onRemoved,
  });

  final Map<Product, int> items;
  final int totalQuantity;
  final String formattedTotalPrice;
  final void Function(Product product) onAdded;
  final void Function(Product product) onRemoved;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: totalQuantity > 0
          ? BottomAppBar(
              height: 54,
              child: Row(
                children: [
                  Text(
                    formattedTotalPrice,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            )
          : null,
      floatingActionButton: totalQuantity > 0
          ? Badge(
              label: Text(totalQuantity.toString()),
              child: FloatingActionButton(
                onPressed: () =>
                    context.read<CartBloc>().add(const CartCheckouted()),
                child: const Icon(Icons.shopping_cart),
              ),
            )
          : null,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      body: RefreshIndicator(
        onRefresh: () async =>
            context.read<CartBloc>().add(const CartStarted()),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: const Text('Toda Venda'),
              pinned: false,
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () => context.push('/produtos'),
                  icon: const Icon(Icons.list),
                ),
              ],
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                items.entries
                    .toList()
                    .map(
                      (item) => CartListTile(
                        product: item.key,
                        quantity: item.value,
                        onAdded: () => onAdded(item.key),
                        onRemoved: () => onRemoved(item.key),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}
