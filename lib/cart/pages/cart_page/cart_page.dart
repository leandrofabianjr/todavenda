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
                onPressed: () => context.push('/carrinho/confirmar').then(
                      (_) => context.read<CartBloc>().add(const CartStarted()),
                    ),
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
            Text(
              totalQuantity > 0
                  ? formattedTotalPrice
                  : 'Selecione algum item acima',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          setState(() {
            totalQuantity = state.totalQuantity;
            formattedTotalPrice = state.formattedTotalPrice;
          });
        },
        builder: (context, state) {
          switch (state.status) {
            case CartStatus.loading:
              return const LoadingWidget();
            case CartStatus.failure:
              return ExceptionWidget(exception: state.exception);
            case CartStatus.initial:
              return CartSelectorView(
                items: state.items,
                onAdded: (product) => context
                    .read<CartBloc>()
                    .add(CartItemAdded(product: product)),
                onRemoved: (product) => context
                    .read<CartBloc>()
                    .add(CartItemRemoved(product: product)),
              );
            default:
              return const ExceptionWidget();
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
    );
  }
}
