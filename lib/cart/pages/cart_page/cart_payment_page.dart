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
    final theme = Theme.of(context);
    double amountPaid;
    return WillPopScope(
      onWillPop: () async {
        context.read<CartBloc>().add(const CartSaleRemoved());
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
            if (state.status == CartStatus.checkout) {
              context.go('/carrinho/confirmacao');
            }
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: theme.colorScheme.error,
                ),
              );
            }
          },
          builder: (context, state) {
            amountPaid = state.sale?.missingAmountPaid ?? 0;
            switch (state.status) {
              case CartStatus.failure:
                return ExceptionWidget(exception: state.exception);
              case CartStatus.payment:
                return ListView(
                  children: [
                    ExpansionTile(
                        initiallyExpanded: state.sale!.isFullyPaid,
                        title: state.sale!.isFullyPaid
                            ? const Text('Venda totalmente paga')
                            : Row(
                                children: [
                                  const Text('Faltam'),
                                  const SizedBox(width: 8),
                                  Text(
                                    state.sale!.formattedMissingAmountPaid
                                        .toString(),
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                            color: theme.colorScheme.error),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text('de'),
                                  const SizedBox(width: 8),
                                  Text(state.sale!.formattedTotal.toString(),
                                      style: theme.textTheme.titleMedium),
                                ],
                              ),
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 8.0,
                            ),
                            child: Text(
                              'Pagamentos realizados',
                              style: theme.textTheme.titleSmall,
                            ),
                          ),
                          ...state.sale!.payments
                              .map(
                                (p) => ListTile(
                                  title: Text(p.type.label),
                                  leading: PaymentTypeIcon(type: p.type),
                                  subtitle: Text(
                                    p.formattedValue,
                                    style: theme.textTheme.titleSmall,
                                  ),
                                  trailing: IconButton(
                                    onPressed: () => context
                                        .read<CartBloc>()
                                        .add(CartPaymentRemoved(payment: p)),
                                    icon: Icon(
                                      Icons.delete,
                                      color: theme.colorScheme.error,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ]),
                    const SizedBox(height: 16),
                    if (state.sale!.isNotFullyPaid)
                      ListTile(
                        title: CurrencyField(
                          decoration:
                              const InputDecoration(labelText: 'Valor a pagar'),
                          initialValue: amountPaid,
                          onChanged: (value) => amountPaid = value,
                        ),
                      ),
                    if (state.sale!.isNotFullyPaid)
                      ...PaymentType.values
                          .map(
                            (type) => ListTile(
                              onTap: () => context.read<CartBloc>().add(
                                  CartPaymentAdded(
                                      type: type, value: amountPaid)),
                              leading: PaymentTypeIcon(type: type),
                              title: Text(type.label),
                            ),
                          )
                          .toList(),
                  ],
                );
              default:
                return const LoadingWidget();
            }
          },
        ),
        floatingActionButton: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state.sale?.isFullyPaid ?? false) {
              return FloatingActionButton(
                onPressed: () =>
                    context.read<CartBloc>().add(const CartPaymentsFinalized()),
                child: const Icon(Icons.check),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class PaymentTypeIcon extends StatelessWidget {
  const PaymentTypeIcon({super.key, required this.type});

  final PaymentType type;

  @override
  Widget build(BuildContext context) {
    return switch (type) {
      PaymentType.cash => const Icon(Icons.money),
      PaymentType.credit => const Icon(Icons.credit_card),
      PaymentType.debit => const Icon(Icons.credit_card),
      PaymentType.pix => const Icon(Icons.pix),
    };
  }
}
