import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/products/products.dart';

import 'bloc/cart_bloc.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CartBloc(context.read<ProductRepository>())..add(const CartStarted()),
      child: const CartView(),
    );
  }
}

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoading) {
          return const Scaffold(body: LoadingWidget());
        }
        if (state is CartLoaded) {
          return CartSelectorView(
            items: state.items,
            formattedTotalPrice: state.formattedTotalPrice,
            totalQuantity: state.totalQuantity,
            onAdded: (product) => context.read<CartBloc>().add(
                  CartItemAdded(product: product),
                ),
            onRemoved: (product) => context.read<CartBloc>().add(
                  CartItemRemoved(product: product),
                ),
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
              height: 40,
              child: Row(
                children: [
                  Text(formattedTotalPrice),
                ],
              ),
            )
          : null,
      floatingActionButton: totalQuantity > 0
          ? Badge(
              label: Text(totalQuantity.toString()),
              child: FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.shopping_cart),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndDocked,
      body: RefreshIndicator(
        onRefresh: () async =>
            context.read<CartBloc>().add(const CartStarted()),
        child: CustomScrollView(
          slivers: [
            const SliverAppBar(
              title: Text('Toda Venda'),
              pinned: false,
              centerTitle: true,
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

class CartListTile extends StatelessWidget {
  const CartListTile({
    super.key,
    required this.product,
    required this.quantity,
    required this.onAdded,
    required this.onRemoved,
  });

  final Product product;
  final int quantity;
  final void Function() onAdded;
  final void Function() onRemoved;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        onPressed: quantity > 0 ? onRemoved : null,
        icon: const Icon(Icons.remove),
        color: Colors.red,
      ),
      trailing: IconButton(
        onPressed: onAdded,
        icon: const Icon(Icons.add),
        color: Colors.green,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(product.description)),
          if (quantity > 0) ...[
            const SizedBox(width: 8),
            Text(quantity.toString())
          ],
        ],
      ),
      subtitle: Text(
        product.formattedPrice,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
