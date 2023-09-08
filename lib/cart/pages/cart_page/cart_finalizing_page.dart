import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/cart/cart.dart';
import 'package:todavenda/companies/companies.dart';

class CartFinalizingPage extends StatelessWidget {
  const CartFinalizingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<CartBloc>(context)..add(const CartCleaned()),
      child: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          switch (state.status) {
            case CartStatus.checkout:
              return context.go('/carrinho/confirmacao');
            case CartStatus.payment:
              return context.go('/carrinho/pagamento');
            default:
              null;
          }
        },
        builder: (context, state) {
          return const CartFinalizingView();
        },
      ),
    );
  }
}

class CartFinalizingView extends StatelessWidget {
  const CartFinalizingView({super.key});

  @override
  Widget build(BuildContext context) {
    final companyUuid = CompanySelectorBloc.getCompanyUuid(context);
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
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
          onPressed: () {
            context.read<CartBloc>().add(CartStarted(companyUuid: companyUuid));
            context.go('/carrinho');
          },
          child: const Text('Iniciar nova venda'),
        ),
      ],
    )));
  }
}
