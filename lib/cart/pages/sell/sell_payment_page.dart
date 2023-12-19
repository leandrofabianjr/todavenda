import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/sales/models/models.dart';

import '../../cart.dart';

class SellPaymentPage extends StatelessWidget {
  const SellPaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<CartBloc>(context)..add(const CartResumed()),
      child: const SellPaymentView(),
    );
  }
}

class SellPaymentView extends StatefulWidget {
  const SellPaymentView({super.key});

  @override
  State<SellPaymentView> createState() => _SellPaymentViewState();
}

class _SellPaymentViewState extends State<SellPaymentView> {
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
              context.go('/vender/finalizado');
            }
            if (state.status == CartStatus.checkout) {
              context.go('/vender/confirmacao');
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
                                  title: Text(p.paymentType.label),
                                  leading: p.paymentType.icon,
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
                          .where((type) {
                            if (type == PaymentType.onCredit
                                // && state.client == null && // TODO reabilitar venda fiada
                                ) {
                              // Se não foi selecionado cliente, não pode pagar fiado
                              return false;
                            }
                            return true;
                          })
                          .map(
                            (type) => ListTile(
                              onTap: () => onPaymentSelected(
                                context,
                                type,
                                amountPaid,
                                state.sale!.uuid!,
                              ),
                              leading: type.icon,
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

  void onPaymentSelected(
    BuildContext context,
    PaymentType type,
    double amountPaid,
    String saleUuid,
  ) async {
    if (type == PaymentType.pix) {
      return Navigator.of(context)
          .push<bool?>(
        MaterialPageRoute(
          builder: (context) => PixPaymentPage(
            amount: amountPaid,
            saleUuid: saleUuid,
          ),
        ),
      )
          .then(
        (success) {
          if (success != null && success) {
            return context
                .read<CartBloc>()
                .add(CartPaymentAdded(type: type, value: amountPaid));
          }
        },
      );
    }
    return context
        .read<CartBloc>()
        .add(CartPaymentAdded(type: type, value: amountPaid));
  }
}
