import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/clients/widgets/client_selector.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/companies/companies.dart';

import '../../cart.dart';
import '../../widgets/cart_list_tile.dart';

class CartCheckoutPage extends StatelessWidget {
  const CartCheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<CartBloc>(context)..add(const CartResumed()),
      child: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          switch (state.status) {
            case CartStatus.initial:
              return context.go('/carrinho');
            case CartStatus.payment:
              return context.go('/carrinho/pagamento');
            case CartStatus.finalizing:
              return context.go('/carrinho/finalizado');
            default:
              null;
          }
        },
        builder: (context, state) {
          return const CartCheckoutView();
        },
      ),
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
  Client? selectedClient;

  @override
  Widget build(BuildContext context) {
    final companyUuid = CompanySelectorBloc.getCompanyUuid(context);
    return WillPopScope(
      onWillPop: () async {
        context.read<CartBloc>().add(CartStarted(companyUuid: companyUuid));
        context.go('/carrinho');
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
                child: ClientSelector(
                  clientsRepository: context.read<ClientsRepository>(),
                  initial: selectedClient,
                  onChanged: (client) => context
                      .read<CartBloc>()
                      .add(CartClientAdded(client: client)),
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
            setState(() {
              formattedTotalQuantity = state.formattedTotalQuantity;
              formattedTotalPrice = state.formattedTotalPrice;
              selectedClient = state.client;
            });
          },
          builder: (context, state) {
            switch (state.status) {
              case CartStatus.loading:
                return const LoadingWidget();
              case CartStatus.failure:
                return ExceptionWidget(exception: state.exception);
              default:
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
          },
        ),
      ),
    );
  }
}
