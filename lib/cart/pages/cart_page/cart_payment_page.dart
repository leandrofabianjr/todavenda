import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/commons/widgets/currency_field.dart';
import 'package:todavenda/products/products.dart';

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
    double payedValue;

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
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CurrencyField(
                          decoration:
                              const InputDecoration(labelText: 'Valor pago'),
                          initialValue: state.missingPaymentValue,
                          onChanged: (value) => payedValue = value,
                        ),
                        const SizedBox(height: 80),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.money),
                          label: const Text('Dinheiro'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.credit_card),
                          label: const Text('Crédito'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.credit_card),
                          label: const Text('Débito'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.money),
                          label: const Text('PIX'),
                        ),
                      ],
                    ),
                  ),
                );
              default:
                return const ExceptionWidget();
            }
          },
        ),
      ),
    );
  }
}
