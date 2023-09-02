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
      value: BlocProvider.of<CartBloc>(context)..add(const CartResumed()),
      child: const CartView(),
    );
  }
}

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  int totalQuantity = 0;
  String formattedTotalPrice = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      bottomNavigationBar: BottomAppBar(
        height: 54,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            totalQuantity > 0
                ? Text(
                    formattedTotalPrice,
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                : const Text('Selecione algum item acima'),
          ],
        ),
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          setState(() {
            totalQuantity = state.totalQuantity;
            formattedTotalPrice = state.formattedTotalPrice;
          });
          if ([
            CartStatus.checkout,
            CartStatus.payment,
          ].contains(state.status)) {
            context.go('/carrinho/confirmacao');
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case CartStatus.loading:
              return const LoadingWidget();
            case CartStatus.failure:
              return ExceptionWidget(exception: state.exception);
            default:
              return CartSelectorView(
                items: state.items,
                onAdded: (product) => context
                    .read<CartBloc>()
                    .add(CartItemAdded(product: product)),
                onRemoved: (product) => context
                    .read<CartBloc>()
                    .add(CartItemRemoved(product: product)),
              );
          }
        },
      ),
    );
  }
}

class CartSelectorView extends StatelessWidget {
  const CartSelectorView({
    super.key,
    required this.items,
    required this.onAdded,
    required this.onRemoved,
  });

  final Map<Product, int> items;
  final void Function(Product product) onAdded;
  final void Function(Product product) onRemoved;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => context.read<CartBloc>().add(const CartStarted()),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              'Selecione os items da venda',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            centerTitle: true,
            pinned: false,
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
    );
  }
}
