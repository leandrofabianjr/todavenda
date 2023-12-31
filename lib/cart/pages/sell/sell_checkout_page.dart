import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/commons/commons.dart';

import '../../cart.dart';
import '../../widgets/cart_list_tile.dart';

class SellCheckoutPage extends StatelessWidget {
  const SellCheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<CartBloc>(context)..add(const CartResumed()),
      child: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          switch (state.status) {
            case CartStatus.initial:
              return context.go('/vender');
            case CartStatus.payment:
              return context.go('/vender/pagamento');
            case CartStatus.finalizing:
              return context.go('/vender/finalizado');
            default:
              null;
          }
        },
        builder: (context, state) {
          return const SellCheckoutView();
        },
      ),
    );
  }
}

class SellCheckoutView extends StatefulWidget {
  const SellCheckoutView({super.key});

  @override
  State<SellCheckoutView> createState() => _SellCheckoutViewState();
}

class _SellCheckoutViewState extends State<SellCheckoutView> {
  String formattedTotalQuantity = '';
  String formattedTotalPrice = '';
  Client? selectedClient;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<CartBloc>().add(const CartRestarted());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Confirmação de venda'),
        ),
        bottomNavigationBar: BottomAppBar(
          height: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 160,
                child: BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    selectedClient = state.client;
                    if (state.status == CartStatus.checkout) {
                      return ClientSelector(
                        clientsRepository: context.read<ClientsRepository>(),
                        initial: selectedClient,
                        onChanged: (client) => context
                            .read<CartBloc>()
                            .add(CartClientChanged(client: client)),
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
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
            if (state.status == CartStatus.checkout) {
              setState(() {
                formattedTotalQuantity = state.formattedTotalQuantity;
                formattedTotalPrice = state.formattedTotalPrice;
              });
              if (state.items.isEmpty) {
                context.read<CartBloc>().add(const CartRestarted());
              }
            }
          },
          builder: (context, state) {
            switch (state.status) {
              case CartStatus.failure:
                return ExceptionWidget(exception: state.exception);
              case CartStatus.checkout:
                return ListView(
                  children: state.items.entries
                      .toList()
                      .map(
                        (item) => SellListTile(
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
                return const LoadingWidget();
            }
          },
        ),
      ),
    );
  }
}
