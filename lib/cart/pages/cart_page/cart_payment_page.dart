import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/sales/models/models.dart';

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
    double amountPaid;

    return WillPopScope(
      onWillPop: () async {
        context.read<CartBloc>().add(const CartCheckouted());
        context.go('/carrinho/confirmacao');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pagamento'),
        ),
        body: BlocConsumer<CartBloc, CartState>(
          listener: (context, state) {
            if (state.status == CartStatus.finalizing) {
              context.go('/carrinho/finalizado');
            }
          },
          builder: (context, state) {
            amountPaid = state.sale?.missingAmountPaid ?? 0;
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
                          initialValue: amountPaid,
                          onChanged: (value) => amountPaid = value,
                        ),
                        const SizedBox(height: 80),
                        ElevatedButton.icon(
                          onPressed: () => context.read<CartBloc>().add(
                                CartPaid(
                                  type: PaymentType.cash,
                                  value: amountPaid,
                                ),
                              ),
                          icon: const Icon(Icons.money),
                          label: const Text('Dinheiro'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => context.read<CartBloc>().add(
                                CartPaid(
                                  type: PaymentType.credit,
                                  value: amountPaid,
                                ),
                              ),
                          icon: const Icon(Icons.credit_card),
                          label: const Text('Crédito'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => context.read<CartBloc>().add(
                                CartPaid(
                                  type: PaymentType.debit,
                                  value: amountPaid,
                                ),
                              ),
                          icon: const Icon(Icons.credit_card),
                          label: const Text('Débito'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => context.read<CartBloc>().add(
                                CartPaid(
                                  type: PaymentType.pix,
                                  value: amountPaid,
                                ),
                              ),
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
