import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';

import '../../cart.dart';

class CartPaymentPage extends StatelessWidget {
  const CartPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<CartBloc>(context)..add(const CartResumed()),
      child: const CartPaymentView(),
    );
  }
}

class CartPaymentView extends StatefulWidget {
  const CartPaymentView({super.key});

  @override
  State<CartPaymentView> createState() => _CartPaymentViewState();
}

class _CartPaymentViewState extends State<CartPaymentView> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<CartBloc>().add(const CartCheckouted());
        context.go('/carrinho/confirmar');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pagamento'),
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            switch (state.status) {
              case CartStatus.loading:
                return const LoadingWidget();
              case CartStatus.failure:
                return ExceptionWidget(exception: state.exception);
              case CartStatus.payment:
                return const Text('Pagamento');
              default:
                return const ExceptionWidget();
            }
          },
        ),
      ),
    );
  }
}
