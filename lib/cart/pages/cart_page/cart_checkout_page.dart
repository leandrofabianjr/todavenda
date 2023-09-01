import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todavenda/commons/commons.dart';

import '../../cart.dart';
import '../../widgets/cart_list_tile.dart';

class CartCheckoutPage extends StatelessWidget {
  const CartCheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<CartBloc>(context),
      child: const CartCheckoutView(),
    );
  }
}

class CartCheckoutView extends StatelessWidget {
  const CartCheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmação de venda'),
      ),
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartConfirmation) {
            return BottomAppBar(
              height: 54,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    state.formattedTotalQuantity,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    state.formattedTotalPrice,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartConfirmation) {
            return FloatingActionButton.extended(
              onPressed: () {},
              label: const Text('Confirmar'),
              icon: const Icon(Icons.check),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Scaffold(body: LoadingWidget());
          }
          if (state is CartConfirmation || state is CartConfirmation) {
            return ListView(
              children: state.items.entries
                  .toList()
                  .map(
                    (item) => CartListTile(
                      product: item.key,
                      quantity: item.value,
                      onAdded: () => context
                          .read<CartBloc>()
                          .add(CartItemAdded(product: item.key)),
                      onRemoved: () => context
                          .read<CartBloc>()
                          .add(CartItemRemoved(product: item.key)),
                    ),
                  )
                  .toList(),
            );
          }
          return Scaffold(
            body: ExceptionWidget(
              exception: state is CartException ? state.ex : null,
            ),
          );
        },
      ),
    );
  }
}
