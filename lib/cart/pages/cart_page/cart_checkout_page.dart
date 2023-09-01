import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';

import '../../cart.dart';
import '../../widgets/cart_list_tile.dart';

class CartCheckoutPage extends StatelessWidget {
  const CartCheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<CartBloc>(context)..add(const CartCheckouted()),
      child: const CartCheckoutView(),
    );
  }
}

class CartCheckoutView extends StatefulWidget {
  const CartCheckoutView({super.key});

  @override
  State<CartCheckoutView> createState() => _CartCheckoutViewState();
}

class _CartCheckoutViewState extends State<CartCheckoutView> {
  String formattedTotalQuantity = '';
  String formattedTotalPrice = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmação de venda'),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 80,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formattedTotalQuantity,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              formattedTotalPrice,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.read<CartBloc>().add(const CartConfirmed()),
        label: const Text('Confirmar'),
        icon: const Icon(Icons.check),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          setState(() {
            formattedTotalQuantity = state.formattedTotalQuantity;
            formattedTotalPrice = state.formattedTotalPrice;
          });
          if (state.status == CartStatus.finalizing) {
            context.pop();
            context.read<CartBloc>().add(const CartStarted());
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Venda finalizada!'),
              backgroundColor: Colors.green,
            ));
          }
        },
        builder: (context, state) {
          switch (state.status) {
            case CartStatus.loading:
              return const LoadingWidget();
            case CartStatus.failure:
              return ExceptionWidget(exception: state.exception);
            case CartStatus.initial:
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
            default:
              return const ExceptionWidget();
          }
        },
      ),
    );
  }
}
