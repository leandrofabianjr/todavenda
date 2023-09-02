import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/cart/cart.dart';

class CartFinalizingPage extends StatelessWidget {
  const CartFinalizingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<CartBloc>(context)..add(const CartResumed()),
      child: const CartFinalizingView(),
    );
  }
}

class CartFinalizingView extends StatelessWidget {
  const CartFinalizingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            if (state.status != CartStatus.finalizing) {
              context.go('/carrinho');
            }
          },
          builder: (context, state) => const SizedBox(),
        ),
        const Icon(
          Icons.check,
          size: 80,
          color: Colors.green,
        ),
        Text(
          'Venda finalizada',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () => context.read<CartBloc>().add(const CartCleaned()),
          child: const Text('Voltar'),
        ),
      ],
    )));
  }
}
