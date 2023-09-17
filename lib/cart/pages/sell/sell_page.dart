import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todavenda/clients/clients.dart';
import 'package:todavenda/clients/widgets/client_selector.dart';
import 'package:todavenda/commons/commons.dart';
import 'package:todavenda/products/products.dart';

import '../../cart.dart';
import '../../widgets/cart_list_tile.dart';

class SellPage extends StatelessWidget {
  const SellPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<CartBloc>(context),
      child: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          switch (state.status) {
            case CartStatus.checkout:
              return context.go('/carrinho/confirmacao');
            case CartStatus.payment:
              return context.go('/carrinho/pagamento');
            case CartStatus.finalizing:
              return context.go('/carrinho/finalizado');
            default:
              null;
          }
        },
        builder: (context, state) {
          return const SellView();
        },
      ),
    );
  }
}

class SellView extends StatefulWidget {
  const SellView({super.key});

  @override
  State<SellView> createState() => _SellViewState();
}

class _SellViewState extends State<SellView> {
  int totalQuantity = 0;
  String formattedTotalPrice = '';
  Client? selectedClient;

  @override
  void initState() {
    context.read<CartBloc>().add(const CartStarted());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: totalQuantity > 0
          ? Badge(
              label: Text(totalQuantity.toString()),
              child: FloatingActionButton(
                onPressed: () =>
                    context.read<CartBloc>().add(const CartCheckouted()),
                child: const Icon(Icons.shopping_cart),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 160,
              child: ClientSelector(
                clientsRepository: context.read<ClientsRepository>(),
                initial: selectedClient,
                onChanged: (client) => context
                    .read<CartBloc>()
                    .add(CartClientChanged(client: client)),
              ),
            ),
            if (totalQuantity > 0)
              Padding(
                padding: const EdgeInsets.only(right: 64),
                child: Text(
                  formattedTotalPrice,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
          ],
        ),
      ),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (context, state) {
          setState(() {
            totalQuantity = state.totalQuantity;
            formattedTotalPrice = state.formattedTotalPrice;
            selectedClient = state.client;
          });
        },
        builder: (context, state) {
          switch (state.status) {
            case CartStatus.failure:
              return ExceptionWidget(exception: state.exception);
            case CartStatus.initial:
              return SellSelectorView(
                items: state.items,
                onAdded: (product) => context
                    .read<CartBloc>()
                    .add(CartItemAdded(product: product)),
                onRemoved: (product) => context
                    .read<CartBloc>()
                    .add(CartItemRemoved(product: product)),
              );
            default:
              return const LoadingWidget();
          }
        },
      ),
    );
  }
}

class SellSelectorView extends StatelessWidget {
  const SellSelectorView({
    super.key,
    required this.items,
    required this.onAdded,
    required this.onRemoved,
  });

  final Map<Product, int> items;
  final void Function(Product product) onAdded;
  final void Function(Product product) onRemoved;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => context.read<CartBloc>().add(const CartStarted()),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: Text(
              'Selecione os items da venda',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            centerTitle: true,
            pinned: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.point_of_sale),
                color: Theme.of(context).colorScheme.primary,
                onPressed: () => context.go('/caixa'),
              ),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              items.entries
                  .toList()
                  .map(
                    (item) => SellListTile(
                      product: item.key,
                      quantity: item.value,
                      onAdded: () => onAdded(item.key),
                      onRemoved: () => onRemoved(item.key),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}
